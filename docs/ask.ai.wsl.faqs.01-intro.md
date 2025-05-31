## 问题解释
当你在 Windows 系统中配置了 `localhost` 代理（如 `http://127.0.0.1:7890`），而 WSL 处于 NAT 模式时，WSL 子系统无法直接访问 Windows 上的 `localhost` 代理。这是因为在 NAT 模式下，WSL 有自己独立的网络命名空间，`localhost` 在 WSL 中指的是 WSL 自身，而不是 Windows 主机。所以会出现 “检测到 localhost 代理配置，但未镜像到 WSL。NAT 模式下的 WSL 不支持 localhost 代理” 的提示。

## 修复方法

### 方法一：使用 Windows 主机的 IP 地址配置代理
在 WSL 中，可以通过 `hostname -I` 命令获取 Windows 主机的 IP 地址，然后使用该 IP 地址配置代理。

在 WSL 中执行以下命令来临时配置代理：
```bash
# 获取 Windows 主机的 IP 地址
host_ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export http_proxy="http://$host_ip:7890"
export https_proxy="http://$host_ip:7890"
```

若要永久配置代理，可以将上述命令添加到 `~/.bashrc` 或 `~/.zshrc` 文件中：
```bash
echo "host_ip=\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2}')" >> ~/.bashrc
echo "export http_proxy=\"http://\$host_ip:7890\"" >> ~/.bashrc
echo "export https_proxy=\"http://s\$host_ip:7890\"" >> ~/.bashrc
source ~/.bashrc
```

### 方法二：使用桥接网络模式
将 WSL 2 的网络模式切换为桥接模式，这样 WSL 就和 Windows 主机处于同一网络中，可以直接访问 Windows 主机的 `localhost` 代理。

在 Windows 的 PowerShell 中执行以下命令修改 `.wslconfig` 文件：
```powershell
$txt="
[wsl2]
networkingMode=bridged
vmSwitch=WslBridge
dhcp=false
ipv6=true
"
set-content -path $HOME/.wslconfig -value $txt
```

然后在 WSL 中配置静态 IP 地址和网关，确保网络连接正常。
