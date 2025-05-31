
- - 搭建环境。win -> wsl (alpine) 使用桥接网络，wsl使用静态地址192.168.0.106。win的ip为192.168.0.107。

以下是搭建 Windows 与 WSL (Alpine) 桥接网络环境的完整步骤：

### 1. 创建桥接网络配置文件
在 Windows 用户目录创建 `.wslconfig` 文件：

```powershell
$wslConfigContent = @"
[wsl2]
networkingMode=bridged
vmSwitch=WSLBridge
dhcp=false
ipv6=true
"@
Set-Content -Path "$HOME\.wslconfig" -Value $wslConfigContent

# sh -c "cat ~/.wslconfig"
```

### 2. 创建 Hyper-V 虚拟交换机
以管理员身份运行 PowerShell：

```powershell
# 默认参数运行
.\setup_wsl2_bridged_vm_switch.ps1

# Get-NetAdapter
# 指定网卡名称
.\setup_wsl2_bridged_vm_switch.ps1 -NetAdapterName "WLAN-WiFi"

# 指定交换机名称
.\setup_wsl2_bridged_vm_switch.ps1 -SwitchName "WslBridge"

# 指定网卡名称和交换机名称
.\setup_wsl2_bridged_vm_switch.ps1 -NetAdapterName "WLAN-WiFi" -SwitchName "WslBridge"

```

- manage network adapters:
```powershell
# 查看网卡名称
Get-NetAdapter | Select-Object Name, Status, InterfaceDescription, InterfaceAlias, MacAddress

# 只列出已启用的网卡
Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object Name

# 修改网卡名称
# Rename-NetAdapter -Name "WLAN 2" -NewName "WLAN-Wifi"
Rename-NetAdapter -Name "WLAN-Wifi" -NewName "WLAN-WiFi"
```

- manage virtual switches:
```powershell
# 查看虚拟交换机
Get-VMSwitch | Select-Object Name, SwitchType, AllowManagementOS, NetAdapterInterfaceDescription, NetAdapterName, NetAdapter

# 列出所有虚拟交换机
Get-VMSwitch | Select-Object Name, SwitchType, AllowManagementOS, NetAdapterInterfaceDescription, NetAdapterName, NetAdapter

# 列出所有虚拟交换机
Get-VMSwitch | Select-Object Name, SwitchType, AllowManagementOS, NetAdapterInterfaceDescription, NetAdapterName, NetAdapter | Format-Table -AutoSize

# 列出所有虚拟交换机
Get-VMSwitch | Select-Object Name, SwitchType, AllowManagementOS, NetAdapterInterfaceDescription, NetAdapterName, NetAdapter | Format-Table -AutoSize | Out-String -Stream | clip
```


### 3. 配置 Alpine 静态 IP
在 Alpine WSL 中创建网络配置文件：

```bash
# 授予执行权限
chmod +x alpine_configure_bridged_network.sh
# 运行脚本
./alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1

# wsl ./wsl2/alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1
```

### 4. 重启 WSL 使配置生效
```powershell
# exit;
wsl --shutdown;wsl;
```

### 5. 验证网络配置
在 Alpine 中执行：

```bash
# 检查IP地址
ip addr show eth0

# 测试与Windows主机的连通性
ping -c 2 192.168.0.107

# 测试外网连接
ping -c 2 www.baidu.com
```

### 6. 可选：设置主机名解析
在 Windows 的 hosts 文件中添加：

```powershell
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.0.106 alpine-wsl"
```

在 Alpine 的 hosts 文件中添加：

```bash
echo "192.168.0.107 windows-host" >> /etc/hosts
```

这样配置后，你的 Alpine WSL 将通过桥接模式获得静态 IP 192.168.0.106，Windows 主机 IP 为 192.168.0.107，两者可以直接互相访问。