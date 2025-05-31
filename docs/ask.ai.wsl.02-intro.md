在 Windows 上使用 WSL 2 安装 Alpine Linux 的完整步骤如下：

 1. 启用 WSL 功能
以管理员身份打开 PowerShell 并运行：
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

 2. 启用虚拟机平台
继续在 PowerShell 中运行：
```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
完成后重启计算机。

 3. 设置 WSL 2 为默认版本
重启后执行：
```powershell
wsl --set-default-version 2
```

 4. 安装 Alpine Linux
有两种安装方式：

 方式一：通过 Microsoft Store 安装
1. 打开 Microsoft Store
2. 搜索 "Alpine WSL" 并安装

 方式二：手动安装（推荐）
1. 下载最新 Alpine WSL 镜像：
```powershell
# Invoke-WebRequest -Uri "https://github.com/yuk7/AlpineWSL/releases/latest/download/Alpine.zip" -OutFile "Alpine.zip"

# $url="https://github.com/yuk7/AlpineWSL/releases/latest/download/Alpine.zip"
$url="https://github.com/yuk7/AlpineWSL/releases/download/3.18.3-0/Alpine.zip"
cmd.exe /c idman /n /d $url /p I:/10_wsl2/mirror/

```
2. 解压到指定目录：
```powershell
$WSL_DISTRO="alpine-3.18";
# Expand-Archive -Path "Alpine.zip" -DestinationPath "d:\book\wsl2\alpine"

# list files and unpack
# 7z l "I:/10_wsl2/mirror/Alpine.zip"
# 7z x "I:/10_wsl2/mirror/Alpine.zip"  -o"I:/10_wsl2/mirror"
7z x "I:/10_wsl2/mirror/Alpine.zip"  -o"I:/10_wsl2/mirror/$WSL_DISTRO";

# delete unpacked files
# sh -c "rm -f I:/10_wsl2/mirror/rootfs.tar.gz";sh -c "rm -f I:/10_wsl2/mirror/Alpine.exe";
# sh -c "rm -rf I:/10_wsl2/mirror/$WSL_DISTRO";


```
3. 运行安装：
```powershell
# cd d:\book\wsl2\alpine
# .\Alpine.exe



# set vars for installing
$TODYFOMAT=sh -c 'date +"%Y%m%d';$WSL_DISTRO="alpine-3.18";"$TODYFOMAT";"$WSL_DISTRO";

# install from xx.tar.gz downlowed from github ? do
wsl --import "${WSL_DISTRO}" I:/10_wsl2/machine/${WSL_DISTRO}-${TODYFOMAT} I:/10_wsl2/mirror/${WSL_DISTRO}/rootfs.tar.gz --version 2


# up and login wsl
wsl -d "${WSL_DISTRO}"

# shutdown wsl

wsl -d "${WSL_DISTRO}" --shutdown

# list
wsl -l -v

# get redheat release ? do
cat /etc/redhat-release

# set default distro
# wsl --setdefault "${WSL_DISTRO}"

```

 5. 初始化 Alpine
首次运行会提示：
1. 创建新用户（建议使用非root账户）
2. 设置密码
3. 更新软件包：
```bash
apk update && apk upgrade
```

 6. 验证安装
```bash
cat /etc/os-release
```


## 使用国内网络 apk
```bash
# 让 alpine 可以使用国内网络 apk 如阿里云 ，编写sed bash脚本，执行后重启wsl
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# sed -i 's/mirrors.aliyun.com/dl-cdn.alpinelinux.org/g' /etc/apk/repositories

# exit wsl
exit;

# reboot wsl
wsl --shutdown;wsl;

```

## 使用上海时间
```bash
#!/bin/bash

apk add --no-cache tzdata

# 创建时区目录（如果不存在）
mkdir -p /usr/share/zoneinfo/Asia

# 设置上海时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 同步硬件时钟
hwclock --systohc

# 验证时间设置
echo "当前系统时间:"
date
echo "当前硬件时钟时间:"
hwclock -r

# 安装并配置chrony时间同步服务
apk add --no-cache chrony
rc-service chronyd start
rc-update add chronyd

# 配置chrony使用阿里云NTP服务器
sed -i 's/^pool.*/server ntp.aliyun.com iburst/' /etc/chrony/chrony.conf

# 重启chrony服务
rc-service chronyd restart

# alpine_set_shanghai_time.sh
```