# WSL2 Scripts 项目介绍

## 项目意义
本项目旨在提供一系列脚本，帮助用户在 Windows 环境下更方便地配置和使用 WSL2（Windows Subsystem for Linux）。通过这些脚本，用户可以轻松完成 WSL2 虚拟机平台启用、WSL 版本设置、Linux 发行版的下载与安装、网络配置以及 Docker 环境搭建等操作，大大简化了 WSL2 的使用流程。

## 启用 WSL 的虚拟机平台功能
以管理员身份运行 PowerShell，执行以下命令：
```powershell
.\wsl2\scripts\00-enable-wsl-vmp.ps1
```

## 设置 WSL 版本并列出当前安装的系统
```powershell
.\wsl2\scripts\01-set-wsl-version-and-list.ps1
```

## 下载|解压|安装操作系统

该脚本用于下载和解压CentOS相关文件，输入参数3时下载，输入4时解压，输入5时删除，输入6时安装，接受url和workspace作为参数。

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

## 在 Windows 中为 WSL 设置 NAT 网络 （让WSL使用NAT网络）
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
sh ./wsl2/scripts/04-check-wsl-ip-and-ping.sh
``` -->

## 在 Windows 中检查 WSL IP 并进行网络测试
```powershell
# wsl sh /mnt/d/book/wsl2/scripts/04-check-wsl-ip-and-ping.sh

# wsl pwd
wsl sh ./wsl2/scripts/04-check-wsl-ip-and-ping.sh
```


## 在 Windows 中设置 Alpine 的 APK 源
```bash
# 查看可用源列表
wsl sh ./wsl2/scripts/05-alpine-set-apk-repo.sh list

wsl sh ./wsl2/scripts/05-alpine-set-apk-repo.sh current

# 使用阿里云源
wsl sh ./wsl2/scripts/05-alpine-set-apk-repo.sh aliyun

# 使用自定义源
wsl sh ./wsl2/scripts/05-alpine-set-apk-repo.sh --set http://your-mirror.com/alpine/v3.18/main
```


## 在 Windows 中设置 Alpine 的时区为上海
```bash
wsl sh ./wsl2/scripts/05-alpine-set-timezone.sh Asia/Shanghai
```


## 在 Windows 中安装 Docker 到 Alpine
```bash
wsl sh ./wsl2/scripts/06-alpine-install-docker.sh

# wsl docker --version;
# wsl docker info
# wsl ip addr
```

## 在 Windows 中配置 Alpine 的 Docker 守护进程
```bash
# down
wsl sh ./wsl2/scripts/08-alpine-stop-dockerd.sh

# up
wsl sh ./wsl2/scripts/07-alpine-configure-dockerd.sh

# wsl docker info
# ping -c 3 www.baidu.com
# ping -c 3 registry-1.docker.io

```

## 在 Windows 中从 Docker Hub 拉取 Alpine 镜像

```powershell
# in a word:
wsl docker run --rm --name alpine alpine:latest /bin/sh -c "echo 'Hello, Alpine!'"
# wsl docker image ls 



# or:

# install docker cilent of window in window with scoop
# ...
# scoop install docker

# list | create | use docker contect
docker context ls 
# docker context create wsl --docker "host=unix:///var/run/docker.sock"
# docker context create wsl --docker "host=tcp://127.0.0.1:2375"
# docker context create wsl --docker "host=tcp://127.0.0.1:2375" --description "Current DOCKER_HOST based configuration"
$env:DOCKER_HOST=""
docker context use wsl 

# check connecting from client (win) to server (wsl)
# ...
docker info

# pull alpine and run it to say hello
docker pull alpine:latest
docker run --rm --name alpine alpine:latest /bin/sh -c "echo 'Hello, Alpine!'"
docker image ls 

```


## get resolv.conf of wsl in win
```bash
# wsl cat /etc/resolv.conf;
```


## 为 WSL 准备桥接网络
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
#  add
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 1
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 2
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 3

# del
# .\wsl2\scripts\09-setup-wsl-bridge.ps1 -netAdapterName "WLAN-WiFi" -switchName "WslBridge" -Action 4

get-content "$env:USERPROFILE\.wslconfig"
```


## 在 Window 中让 WSL 使用桥接网络
```powershell
wsl ./wsl2/scripts/10-alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1;
wsl --shutdown;sh -c "sleep 3";

wsl ./wsl2/scripts/04-check-wsl-ip-and-ping.sh

# 将脚本安装到alpine bin，并让alpine启动时执行 10-alpine_configure_bridged_network.sh 192.168.0.106/24 192.168.0.1 192.168.0.1;
```

<!-- ## 将脚本安装到 Alpine 的 bin 目录并在启动时自动运行 -->

<!-- ## 清理 WSL 桥接网络 -->
