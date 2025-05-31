## download centos distro from github and install

```powershell

# download from github
# 346MB
$url="https://github.com/mishamosher/CentOS-WSL/releases/download/7.9-2211/CentOS7.zip"
$url="https://ghfast.top/https://github.com/mishamosher/CentOS-WSL/releases/download/9-stream-20230626/CentOS9-stream.zip"
cmd.exe /c idman /n /d $url /p I:/10_wsl2/mirror/


# list files and unpack
# get name from url and use it as distro name
$name=$url.split("/")[-1];
$name;

$WSL_DISTRO=$url.split("/")[-1].split(".")[0];
$WSL_DISTRO=$WSL_DISTRO.split("-")[0];
$WSL_DISTRO

# list files and unpack
# 7z l "I:/10_wsl2/mirror/$name"
# 7z x "I:/10_wsl2/mirror/$name"  -o"I:/10_wsl2/mirror"
7z x "I:/10_wsl2/mirror/$name"  -o"I:/10_wsl2/mirror/$WSL_DISTRO";

# delete unpacked files
# sh -c "rm -f I:/10_wsl2/mirror/rootfs.tar.gz";sh -c "rm -f I:/10_wsl2/mirror/Alpine.exe";
# sh -c "rm -rf I:/10_wsl2/mirror/$WSL_DISTRO";

# get today date
$TODYFOMAT=sh -c 'date +"%Y%m%d';
"$TODYFOMAT";
"$WSL_DISTRO";

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

# update installed packages? do:
yum -y update
# Cannot find a valid baseurl for repo: base/7/x86_64
# ping -c 4 www.baidu.com
# ping -c 4 127.0.0.1
# ping -c 4 192.168.5.9
# sudo systemctl restart network

# install gcc,gcc+,wget ? do
yum -y install gcc gcc-c++ make wget

#
yum -y install tar

yum -y install net-tools
```

[download centos from github](https://github.com/wsldl-pg/CentWSL/releases/tag/8.1.1911.1)

[download centos from github](https://github.com/CentOS/sig-cloud-instance-images/tree/CentOS-8-x86_64/docker)

[wsl install centos](https://www.cnblogs.com/lghgo/p/16003505.html)