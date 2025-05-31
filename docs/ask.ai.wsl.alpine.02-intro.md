## 在Windows中让WSL(Alpine)执行脚本

在Windows中让WSL(Alpine)执行脚本有以下几种方法：

### 方法1：直接通过wsl命令执行
```powershell
# 直接执行脚本（需要脚本在Alpine的文件系统中）
wsl -d Alpine ./alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1
```

### 方法2：先进入Alpine再执行
```powershell
# 先进入Alpine环境
wsl -d Alpine
# 然后在Alpine中执行
./alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1
```

### 方法3：从Windows传递脚本到Alpine后执行
```powershell
# 将脚本从Windows复制到Alpine
wsl -d Alpine mkdir -p ~/scripts
wsl -d Alpine cp /mnt/c/path/to/your/script/alpine_configure_bridged_network.sh ~/scripts/

# 然后在Alpine中执行
wsl -d Alpine ~/scripts/alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1
```

### 方法4：使用wsl --exec直接执行
```powershell
wsl --exec -d Alpine /bin/sh -c "~/alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1"
```

建议使用方法1最为简洁高效，可以直接在Windows的PowerShell中运行而不需要进入Alpine终端。