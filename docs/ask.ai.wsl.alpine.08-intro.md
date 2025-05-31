## Alpine 不支持 systemd 的 socket 激活

### 错误信息
```bash
❌ Docker Start fail (Please check /var/log/dockerd.log)
time="2025-05-30T19:31:47.796903692+08:00" level=info msg="Starting up"
failed to load listeners: no sockets found via socket activation: make sure the service was started by systemd
```

### 问题分析


从错误信息看，Docker 启动时尝试通过 systemd 的 socket 激活机制但失败了（Alpine 默认使用 OpenRC 而不是 systemd）。以下是修复方案：

```bash:
# ... 前面代码保持不变 ...

# 修改启动命令，移除fd://只使用tcp
DOCKERD_CMD="dockerd --host=tcp://0.0.0.0:2375 --config-file=/etc/docker/daemon.yaml --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

# ... 后续代码保持不变 ...
```

关键修改点：
1. 移除了 `--host=fd://` 参数（Alpine 不支持 systemd 的 socket 激活）
2. 保留 TCP 监听用于远程管理

这样修改后 Docker 会直接监听 TCP 端口而不会尝试使用 systemd 的 socket 激活机制。如果仍需本地连接，可以使用：
```bash
docker -H tcp://127.0.0.1:2375 ps
```


- 

## Docker 监听安全配置方案

### 错误信息
```bash
❌ Docker Start fail (Please check /var/log/dockerd.log)
time="2025-05-30T19:36:08.804654145+08:00" level=info msg="Starting up"
time="2025-05-30T19:36:08.804959152+08:00" level=warning msg="Binding to IP address without --tlsverify is insecure and gives root access on this machine to everyone who has access to your network." host="tcp://0.0.0.0:2375"
time="2025-05-30T19:36:08.804971523+08:00" level=warning msg="Binding to an IP address, even on localhost, can also give access to scripts run in a browser. Be safe out there!" host="tcp://0.0.0.0:2375"
time="2025-05-30T19:36:09.805193014+08:00" level=warning msg="Binding to an IP address without --tlsverify is deprecated. Startup is intentionally being slowed down to show this message" host="tcp://0.0.0.0:2375"
time="2025-05-30T19:36:09.805258559+08:00" level=warning msg="Please consider generating tls certificates with client validation to prevent exposing unauthenticated root access to your network" host="tcp://0.0.0.0:2375"
time="2025-05-30T19:36:09.805268552+08:00" level=warning msg="You can override this by explicitly specifying '--tls=false' or '--tlsverify=false'" host="tcp://0.0.0.0:2375"
time="2025-05-30T19:36:09.805274159+08:00" level=warning msg="Support for listening on TCP without authentication or explicit intent to run without authentication will be removed in the next release" host="tcp://0.0.0.0:2375"
```

### 问题分析
从错误日志来看，Docker 警告直接监听 TCP 端口不安全。以下是修改后的安全配置方案：

```bash
# ... 前面代码保持不变 ...

# 修改为仅本地监听的安全配置
DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

# 或者完全禁用TCP（仅使用Unix socket）
# DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

# ... 后面代码保持不变 ...
```

关键修改点：
1. 将 `0.0.0.0` 改为 `127.0.0.1` 仅监听本地
2. 添加了 TLS 认证参数（需要提前生成证书）
3. 或者完全禁用 TCP 仅使用 Unix socket

建议选择以下任一方案：
1. 使用 Unix socket（最安全）
2. 本地TCP + TLS 认证
3. 添加 `--tls=false` 明确禁用TLS（不推荐）

## docker 安全问题警告
### 警告信息
```bash
WARNING: API is accessible on http://127.0.0.1:2375 without encryption.
         Access to the remote API is equivalent to root access on the host. Refer
         to the 'Docker daemon attack surface' section in the documentation for
         more information: https://docs.docker.com/go/attack-surface/
WARNING: No swap limit support
```

### 问题分析
从警告信息来看，Docker 服务存在两个安全问题需要处理：

1. **未加密的API访问**：Docker API 通过未加密的 HTTP 暴露在 127.0.0.1:2375
2. **缺少swap限制支持**：无法限制容器的swap内存使用

以下是修复这两个问题的修改方案：

```bash:d:\book\wsl2\scripts\07-alpine-configure-dockerd.sh
# ... 前面代码保持不变 ...

# 修改为安全配置
DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

# 添加swap限制支持（需在Windows端配置）
echo "[wsl2]" > ~/.wslconfig
echo "kernelCommandLine = cgroup_enable=memory swapaccount=1" >> ~/.wslconfig

# ... 后面代码保持不变 ...
```

主要修改点：
1. 移除了TCP监听端口，仅保留Unix socket
2. 添加了TLS认证相关参数（需提前生成证书）
3. 添加了WSL2的swap限制支持配置

需要提前执行的操作：
```bash
# 生成TLS证书
mkdir -p /etc/docker/ssl
cd /etc/docker/ssl
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=$(hostname)" -sha256 -new -key server-key.pem -out server.csr
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem
```

## wsl 是否需要设置swap limit
在 WSL 2 环境下，默认情况下确实需要手动设置 swap limit 支持。以下是具体分析和配置方法：

### 为什么需要设置？
1. **WSL 2 限制**：WSL 2 默认内核未启用 cgroup swap 限制功能
2. **Docker 警告**：会出现 `WARNING: No swap limit support` 警告
3. **功能影响**：无法通过 `--memory-swap` 参数限制容器swap使用

### 配置方法
修改 Windows 用户目录下的 `.wslconfig` 文件：

```bash
# ... 前面代码保持不变 ...

# 添加swap限制支持（在WSL配置中）
echo "[wsl2]" > /mnt/c/Users/$USER/.wslconfig
echo "kernelCommandLine = cgroup_enable=memory swapaccount=1" >> /mnt/c/Users/$USER/.wslconfig

# ... 后面代码保持不变 ...
```

### 验证方法
重启 WSL 后检查：
```bash
wsl --shutdown
wsl -d alpine
cat /proc/cmdline | grep swapaccount  # 应显示包含swapaccount=1
docker info | grep -i swap  # 警告应消失
```

### 注意事项
1. 需要**管理员权限**修改系统文件
2. 配置后必须完全重启 WSL (`wsl --shutdown`)
3. 仅对 WSL 2 有效，WSL 1 不需要此配置

建议将此配置添加到你的 WSL 初始化脚本中，确保每次环境重建时自动生效。