# WSL2 Scripts 介绍和使用示例

## 00-enable-wsl-vmp.ps1
```powershell
# 以管理员身份运行PowerShell
# 执行以下命令以启用WSL的虚拟机平台功能
.\wsl2\scripts\00-enable-wsl-vmp.ps1
```

## 01-set-wsl-version-and-list.ps1
```powershell
# 设置WSL版本并列出相关信息
.\wsl2\scripts\01-set-wsl-version-and-list.ps1
```

## 02-download-unpack-centos.ps1
该脚本用于下载和解压CentOS相关文件，输入参数3时下载，输入4时解压，输入5时删除，输入6时安装，接受url和workspace作为参数。
### 使用示例
```powershell
$url="https://github.com/mishamosher/CentOS-WSL/releases/download/7.9-2211/CentOS7.zip"
$url="https://ghfast.top/https://github.com/mishamosher/CentOS-WSL/releases/download/9-stream-20230626/CentOS9-stream.zip"
$url="https://github.com/yuk7/AlpineWSL/releases/download/3.18.3-0/Alpine.zip";$WSL_DISTRO="alpine-3.18";$TODYFOMAT="20250530";
$workspace="I:/10_wsl2"

# 下载
.\wsl2\scripts\02-download-unpack-centos.ps1 -Url $url -Workspace $workspace -Action 3
# 解压
.\wsl2\scripts\02-download-unpack-centos.ps1 -Url $url -Workspace $workspace -Action 4
# 删除解压文件
.\wsl2\scripts\02-download-unpack-centos.ps1 -Url $url -Workspace $workspace -Action 5

# install distro to be some machine
.\wsl2\scripts\02-download-unpack-centos.ps1 -Url $url -Workspace $workspace -Action 6 -WSL_DISTRO "$WSL_DISTRO" -TODYFOMAT "$TODYFOMAT"

# set default machine
.\wsl2\scripts\02-download-unpack-centos.ps1 -Url $url -Workspace $workspace -Action 7 -WSL_DISTRO "$WSL_DISTRO" 

# del machine distro
.\wsl2\scripts\02-download-unpack-centos.ps1 -Url $url -Workspace $workspace -Action 8 -WSL_DISTRO "$WSL_DISTRO"

# wsl -l -v;
# wsl --setdefault alpine-3.18;
```

## in win set nat network for wsl
```powershell
# set
.\wsl2\scripts\03-set-wsl-nat-config.ps1

# get
get-content $HOME/.wslconfig;

```

<!-- ## login default distion wsl bash
```bash
wsl -l -v;
wsl --setdefault alpine-3.18;
wsl;
``` -->

<!-- ## get wsl ip and ping network in wsl
```bash
sh ./scripts/04-check-wsl-ip-and-ping.sh
``` -->

## check wsl ip and ping network of wsl in win
```powershell
# wsl sh /mnt/d/book/wsl2/scripts/04-check-wsl-ip-and-ping.sh

# wsl pwd
wsl sh ./scripts/04-check-wsl-ip-and-ping.sh
```


## alpine set apk repo source in win
```bash
# 查看可用源列表
wsl sh ./scripts/05-alpine-set-apk-repo.sh list

wsl sh ./scripts/05-alpine-set-apk-repo.sh current

# 使用阿里云源
wsl sh ./scripts/05-alpine-set-apk-repo.sh aliyun

# 使用自定义源
wsl sh ./scripts/05-alpine-set-apk-repo.sh --set http://your-mirror.com/alpine/v3.18/main
```


## alpine use shanghai timezone in win
```bash
wsl sh ./scripts/05-alpine-set-timezone.sh Asia/Shanghai
```


## alpine install docker in win
```bash
wsl sh ./scripts/06-alpine-install-docker.sh

# wsl docker --version;
# wsl docker info
# wsl ip addr
```

## alpine configure dockerd in win
```bash
wsl sh ./scripts/08-alpine-stop-dockerd.sh

wsl sh ./scripts/07-alpine-configure-dockerd.sh
# wsl docker info

ping -c 3 www.baidu.com
ping -c 3 registry-1.docker.io

```

## pull alpine image from docker hub in win

```powershell
docker context ls 
# docker context create wsl --docker "host=unix:///var/run/docker.sock"
# docker context create wsl --docker "host=tcp://127.0.0.1:2375"
# docker context create wsl --docker "host=tcp://127.0.0.1:2375" --description "Current DOCKER_HOST based configuration"
$env:DOCKER_HOST=""
docker context use wsl 
docker info

docker pull alpine:latest
docker run --rm --name alpine alpine:latest /bin/sh -c "echo 'Hello, Alpine!'"
docker image ls 


```

## ping network in wsl with different nameserver
```bash
echo "
nameserver 8.8.8.8
nameserver 8.8.4.4
" > /etc/resolv.conf;
cat /etc/resolv.conf;
ping -c 3 registry-1.docker.io

echo "
nameserver 223.5.5.5
nameserver 223.6.6.6
"> /etc/resolv.conf;
cat /etc/resolv.conf;
ping -c 3 www.baidu.com

echo "
nameserver 223.6.6.6
nameserver 8.8.4.4
"> /etc/resolv.conf;
cat /etc/resolv.conf;
ping -c 3 www.baidu.com
```


## prepare bridge network for wsl
```powershell
# exit wsl;
# ...
# exit

# shutdown wsl
# ...
# wsl --shutdown;sh -c "sleep 3";
# wsl -l -v;

# list your network adapter
# ...
# Get-NetAdapter | Where-Object { $_.Name -like "vEthernet*" } | Format-Table Name,InterfaceDescription,Status


# use with default network adapter name and switch name
# .\wsl2\scripts\09-setup-wsl-bridge.ps1

 .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge"
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 1
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 2
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 3
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 4

get-content "$env:USERPROFILE\.wslconfig"
```

## 删除冗余的网卡或交换机
```powershell
# 1. 列出所有虚拟交换机
Get-VMSwitch | Format-Table Name,SwitchType,NetAdapterInterfaceDescription

# 2. 删除指定的虚拟交换机（替换Name为要删除的交换机名）
# Remove-VMSwitch -Name "WSL (Hyper-V)" -Force
# Remove-VMSwitch -Name "WSL (*)" -Force

# 3. 列出所有网络适配器
Get-NetAdapter | Where-Object { $_.Name -like "vEthernet*" } | Format-Table Name,InterfaceDescription,Status

# 4. 删除指定的网络适配器（替换Name为要删除的适配器名）
Remove-NetAdapter -Name "vEthernet (WSL (Hyper-V))" -Confirm:$false

.\wsl2\scripts\09-del-unused-switch.ps1  -switchName "WSL (*)"
```

## tell wsl use bridge network
```powershell
wsl ./scripts/10-alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1;
wsl --shutdown;sh -c "sleep 3";

wsl ./scripts/04-check-wsl-ip-and-ping.sh

# 将脚本安装到alpine bin，并让alpine启动时执行 10-alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1;
```

## install bash script to Alpine 's bin diretory and autorun when boot
```bash
# disable setup_wsl_network_script then install bash script

# setup_wsl_network_script "$gateway" "$bridgenet" "$wslIp"

```
1. **复制脚本到 Alpine 的 bin 目录**
    在 WSL 环境下执行以下命令：
    ```bash
    wsl cp /mnt/d/book/wsl2/scripts/10-alpine_configure_bridged_network.sh /usr/local/bin/
    wsl chmod +x /usr/local/bin/10-alpine_configure_bridged_network.sh
    ```
2. **让 Alpine 启动时执行脚本**
    编辑 `/etc/rc.local` 文件（如果文件不存在则创建），添加以下内容：
    ```bash
    wsl sh -c 'echo "/usr/local/bin/10-alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1" >> /etc/rc.local'
    wsl chmod +x /etc/rc.local
    ```
3. **验证配置**
    重启 WSL 使配置生效：
    ```powershell
    wsl --shutdown
    ```
    等待一段时间后再次启动 WSL，脚本应该会在启动时自动执行。

## clean bridge network for wsl
