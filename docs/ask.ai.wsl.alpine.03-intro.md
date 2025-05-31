以下是 Alpine Linux 网络管理的常用命令和配置方法：

### 1. 基本网络命令
```bash
# 查看所有网络接口
ip link show

# 查看IP地址配置
ip addr show

# 查看路由表
ip route show

# 测试网络连通性
ping -c 4 8.8.8.8
```

### 2. 网络接口管理
```bash
# 启用网络接口
ip link set eth0 up

# 禁用网络接口
ip link set eth0 down

# 添加IP地址
ip addr add 192.168.0.106/24 dev eth0

# 删除IP地址
ip addr del 192.168.0.106/24 dev eth0
```

### 3. 路由管理
```bash
# 添加默认网关
ip route add default via 192.168.0.1

# 添加静态路由
ip route add 192.168.1.0/24 via 192.168.0.1

# 删除路由
ip route del default via 192.168.0.1
```

### 4. 持久化网络配置
Alpine 使用 `/etc/network/interfaces` 文件进行持久化配置：

```bash:/etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.168.0.106
    netmask 255.255.255.0
    gateway 192.168.0.1
    dns-nameservers 192.168.0.1
```

### 5. DNS配置
```bash
# 临时修改DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# 防止resolv.conf被覆盖
chattr +i /etc/resolv.conf
```

### 6. 网络服务管理
```bash
# 重启网络服务
rc-service networking restart

# 查看网络服务状态
rc-service networking status
```

### 7. 网络工具安装
```bash
# 安装完整网络工具包
apk add iproute2 net-tools

# 安装ping工具
apk add iputils
```

这些命令和配置方法可以帮助您有效管理 Alpine Linux 的网络设置。