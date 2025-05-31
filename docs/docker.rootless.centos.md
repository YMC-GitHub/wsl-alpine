## Using Docker Rootless Mode to Run Docker Services

- [Using Docker Rootless Mode to Run Docker Services](https://zhuanlan.zhihu.com/p/607655187)

## change root password

```sh
# login wsl
# wsl

# add user
useradd rootless
sysctl user.max_user_namespaces=28633

# cat user
# cat /etc/subuid
# rootless:100000:65536
# cat /etc/subgid


# change root password
o="password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=";
n="password requisite pam_cracklib.so try_first_pass retry=3 type= minlen=8";
# sed  "s/$o/$n/" /etc/pam.d/system-auth
sed -i "s/$o/$n/" /etc/pam.d/system-auth
passwd

# su rootless

# Download rootless script from official and run it
# curl -fsSL https://get.docker.com/rootless | sh
curl -o rootless-docker.sh -fsSL https://get.docker.com/rootless;chmod +x ./rootless-docker.sh;./rootless-docker.sh;



```

## centos - yum use aliyun source

```bash
chmod +x /mnt/d/book/wsl2/centos.yum.aliyun.sh;/mnt/d/book/wsl2/centos.yum.aliyun.sh;
# yum repolist;yum search nginx;
```

## FinalShell connects to the Ubuntu subsystem

```bash
file="centos.ssh.finalshell.on";
chmod +x /mnt/d/book/wsl2/${file}.sh;
/mnt/d/book/wsl2/${file}.sh;

```

## alpine - install apktool in docker - debug

```bash
# enter bash in os apline ? do
# docker run -it --rm --name alpine alpine /bin/sh

# info alpine pwd ?do
# docker run -it --rm alpine pwd

# mount current dir and ls files in alpine ? do
# docker run --rm -v `pwd`:/app alpine ls /app

# 1
docker run -it --rm --name jdkalpine -v `pwd`:/app -w /app openjdk:8-alpine /bin/sh

# 2
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
apk add --no-cache curl bash
cd /usr/local/bin
GH_PROXY_URL="www.ghproxy.cn/";APKTOOL_VERSION="2.4.0";
curl -sLO ${GH_PROXY_URL}https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && chmod +x apktool
curl -sL -o apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${APKTOOL_VERSION}.jar && chmod +x apktool.jar
# https://cdn.gitmirror.com/bb/iBotPeaches/apktool/v${APKTOOL_VERSION}.jar

# [refre theanam/docker-apktool dockerfile](https://github.com/theanam/docker-apktool)

```

## build apktool in dockerfile

```bash
# info Dockerfile
cat /mnt/d/book/docker-hub/apktool.jdk8.alpine/Dockerfile | grep -Ev "^ *#" | sed "/^ *$/d"

cat /mnt/d/book/docker-hub/apktool.jdk8.alpine/Dockerfile | grep -E "^ *# feat" | sed "/^ *$/d"


# image.build
GH_PROXY_URL="www.ghproxy.cn/";APKTOOL_VERSION="2.4.0";
# GH_PROXY_URL="www.ghproxy.cn/";APKTOOL_VERSION="2.10.0";

docker build --build-arg BUILD_VERSION=$APKTOOL_VERSION --build-arg GH_PROXY_URL="$GH_PROXY_URL" -t zero/apktool:latest /mnt/d/book/docker-hub/apktool.jdk8.alpine

# image.check.java
docker run -it --rm --name apktool zero/apktool java -version

docker run -it --rm --name apktool zero/apktool apktool --version

docker run -it --rm --name apktool zero/apktool /bin/sh

```

## Android apk decompile, modify, repackage, sign

```bash
# [米人源码](https://www.mir6.com/)
# [mhzx-mb setup](https://www.bilibili.com/video/BV1QG6UY8EfN)
# [mhzx-mb fyymw](https://www.fyymw.com/game_source_code/7979.html)

# get apktool version
docker run -it --rm --name apktool zero/apktool apktool --version

cd /mnt/m/ecloud_download
docker run --rm -v `pwd`:/app zero/apktool apktool d mhzx12_192.168.5.9.apk


# human-task:
cd /mnt/m/ecloud_download
docker run -it --rm --name apktool -v `pwd`:/app zero/apktool /bin/sh
# decode xx.apk file
apkname="mhzx12_192.168.5.9";
apktool d ${apkname}.apk
# ...

oldip="192.168.5.9";newip="192.168.0.105";

# get ip and port about local email checking
cat ${apkname}/smali/com/zulong/sdk/constant/HttpConstant.smali | grep -Eo http://.* | sed 's/"//g' | head -n 1


# put ip
sed -i "s/$oldip/$newip/g" ${apkname}/smali/com/zulong/sdk/constant/HttpConstant.smali
# use88 port
sed -iE "s/$newip:86/$newip:88/g" $apkname/smali/com/zulong/sdk/constant/HttpConstant.smali



# get ip about server ?
# cat ${apkname}/assets/config/all_platform_config.xml
# put ip
sed -i "s/$oldip/$newip/g" ${apkname}/assets/config/all_platform_config.xml

# encode xx.apk
apktool b -o mhzx-${newip}.apk ${apkname}



# sign.key.gen
keytool -genkey -alias demo.keystore -keyalg RSA -validity 40000 -keystore demo.keystore

# password:123456
# ymc.dev.zero.haikou.hainan.cn

# Enter keystore password:
# Re-enter new password:
# What is your first and last name?
#   [Unknown]:  ymc
# What is the name of your organizational unit?
#   [Unknown]:  dev
# What is the name of your organization?
#   [Unknown]:  zero
# What is the name of your City or Locality?
#   [Unknown]:  haikou
# What is the name of your State or Province?
#   [Unknown]:  hainan
# What is the two-letter country code for this unit?
#   [Unknown]:  cn
# Is CN=ymc, OU=dev, O=zero, L=haikou, ST=hainan, C=cn correct?
#   [no]:  y

# sign.key.use
jarsigner -verbose -keystore demo.keystore mhzx-${newip}.apk demo.keystore

# del untaged images
docker rmi $(docker images -f "dangling=true" -q)
# docker images --format "{{.ID}}" | awk '{print $1}'

# docker images --format "{{.ID}}" | awk '{print $1}'

# get id of zero
docker images | grep zero | awk '{print $3}'

# get
docker images --format "{{.ID}} {{.Repository}}" | grep zero | awk '{print $1}'
# del
docker rmi $(docker images --format "{{.ID}} {{.Repository}}" | grep zero | awk '{print $1}')
```

```powershell
# centos.docker.uninstall
file="centos.docker.uninstall";
chmod +x /mnt/d/book/wsl2/${file}.sh;
/mnt/d/book/wsl2/${file}.sh;

# centos.docker.install
file="centos.docker.install.china";
chmod +x /mnt/d/book/wsl2/${file}.sh;
/mnt/d/book/wsl2/${file}.sh;

# docker.mirror.china.use
mkdir -p  ~/.config/docker
cp /mnt/d/book/wsl2/daemon.json /etc/docker/daemon.json
systemctl daemon-reload;systemctl restart docker.service;

# docker.clean
rm -rf /etc/systemd/system/docker.service.d;
rm -rf /var/lib/docker;

docker pull alpine
docker run -it --rm alpine echo "[zero] hello world"

# ; generated by /usr/sbin/dhclient-script
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 114.114.114.114" > /etc/resolv.conf

cat /etc/resolv.conf

docker pull alpine



```

## setup mhzx server

```bash
# 7z x mhzx.7z subdir/xx.tar
# extract zip file
7z x 安卓端【本地验证】梦幻诛仙14职业.7z 【本地验证】梦幻诛仙14职业/Linux手工端/mhzx14.zip



# upload to server root /
cp 【本地验证】梦幻诛仙14职业/Linux手工端/mhzx14.zip /

# list file
unzip -v  /mhzx14.zip

# unzip
unzip /mhzx14.zip -d / -o

# add rights
chmod -R 777 /bin;chmod -R 777 /home;chmod -R 777 /root;chmod -R 777 /www;

# ls /root
# jre-8u181-linux-x64.tar.gz

# open baota ui, and add site /www/wwwroot/mhzxgx

# cat /home/mhzx/zdir/android/meta/servers.xml
o="192.168.5.28";
n="192.168.0.105";
sed -i "s/$o/$n/g" /home/mhzx/zdir/android/meta/servers.xml #
sed -i "s/$o/$n/g" /home/mhzx/zdir/android/meta/version.xml #

sed -i "s/$o/$n/g" /home/mhzx/zdir/ios/meta/servers.xml #
sed -i "s/$o/$n/g" /home/mhzx/zdir/ios/meta/version.xml #
# cat /home/mhzx/zdir/android/meta/version.xml | grep resource_update

# set baota database root user password
# cat /home/mhzx/mhzx_4095/conf.m4 | grep 1085202075
# cat /home/mhzx/mhzx_4095/gs/gsx.xdb.xml
```

## tell dockerd to set remote api to enable

```bash
# docker.remote.api.on
cat /usr/lib/systemd/system/docker.service
# cat /usr/lib/systemd/system/docker.service | grep "ExecStart=/usr/bin/dockerd"
# ...

sed -i -E "s#ExecStart=.*#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock#g" /usr/lib/systemd/system/docker.service


# ps aux | grep dockerd | grep -v grep
sudo systemctl daemon-reload;sudo systemctl restart docker;


docker -H tcp://127.0.0.1:2375 version

# [tell dockerd to set remote api to enable ](https://cloud.tencent.com/developer/article/1683689)
```

- [懒人源码网](https://www.lrymw.com/)
- [7chaowan](https://www.7chaowan.com/)
- [mir6.com](mir6.com)
