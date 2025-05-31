## 创建桥接网络配置

主要功能说明：
1. 自动检测并创建外部虚拟交换机
2. 配置.wslconfig使用桥接模式
3. 禁用DHCP以便手动配置静态IP

使用示例：
```powershell
.\wsl2\scripts\09-setup-wsl-bridge.ps1
```

注意事项：
1. 需要以管理员权限运行
2. 配置后需手动在WSL中设置静态IP
3. 建议在~/.profile中添加网络配置脚本