## native docker - rootful - add

```bash
# sudo apt update
# sudo apt install docker.io -y
curl -fsSL https://get.docker.com/ | sh

# dockerd-rootless-setuptool.sh install
```

## native docker - rootful - not use sudo to run docker cli

```bash
# don’t need to use sudo to run Docker commands
sudo usermod -aG docker $USER
```

## native docker - rootful - start docker daemon automatically

```bash
# let wsl start docker daemon automatically
echo '# Start Docker daemon automatically when logging in if not running.' >> ~/.zshrc
echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> ~/.zshrc
echo 'if [ -z "$RUNNING" ]; then' >> ~/.zshrc
echo '    sudo dockerd > /dev/null 2>&1 &' >> ~/.zshrc
echo '    disown' >> ~/.zshrc
echo 'fi' >> ~/.zshrc


# -H fd:// --containerd=/run/containerd/containerd.sock
# docker run --rm -it alpine echo hi
```

[ docker - rootful - install - docker-ce](https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/)

## native docker - rootful - del

```bash
sudo apt-get autoremove docker docker-ce docker-engine  docker.io  containerd runc
sudo apt-get autoremove docker-ce-*
sudo rm -rf /etc/systemd/system/docker.service.d
sudo rm -rf /var/lib/docker
docker --version
```

## native docker - rootful - set mirror in china

```powershell
yours edit-json --file daemon.json --name "data-root" --value "/mnt/i/dockerdata"  --defaut-text "{}"

yours edit-json/stra --file daemon.json --name "registry-mirrors" --include "https://mirror.gcr.io,https://mirror.aliyuncs.com"

# [20240616 Recently, due to special reasons, the mirror sources that can be used in China have all hung up}(https://blog.csdn.net/clearloe/article/details/139711335)

yours edit-json/stra --file daemon.json --name "registry-mirrors" --include "https://https://dockerhub.icu"


yours edit-json/stra --file daemon.json --name "registry-mirrors" --include "https://ttps://hub.uuuadc.top,https://docker.anyhub.us.kg,https://dockerhub.jobcher.com,https://dockerhub.icu,https://docker.ckyl.me,https://docker.awsl9527.cn"
```

```bash

# dockerd rootful restart ? do
cp /mnt/d/book/daemon.json /etc/docker/daemon.json;
cat /etc/docker/daemon.json;
sudo systemctl daemon-reload;sudo systemctl restart docker;
# docker.service: Start request repeated too quickly.

# docker pull hub.uuuadc.top/library/mysql:5.7
# docker pull alpine
```

## native docker - rootful - run test

```bash
docker pull alpine
# enter alpine bash ?do
docker run -it --rm --name alpine alpine /bin/sh

# info alpine pwd ?do
docker run -it --rm alpine pwd

docker run -it --rm alpine echo "[zero] hello world!"

# docker run -d --name nginx -p 80:80 nginx
```

## native docker - rootful - get dockerd running args

```bash
ps aux | grep dockerd | grep -v grep
```

## native docker - rootful - get path of container state storage

```bash
dockerd --help |grep exec-root -A 5

ls /var/run/docker
# --exec-root xx

```

## native docker - rootful - get path of data storage

```bash
# Paths to store persistent data such as images, volumes, and cluster state

dockerd --help |grep data-root -A 5

ls /var/lib/docker
# --exec-root xx

# dockerd --help |grep graph -A 5
```

## native docker - rootful - get path of deamon.json config

```bash
dockerd --help |grep config-file -A 5

ls /etc/docker
cat /etc/docker/daemon.json
# --exec-root xx
```

## native docker - rootful - get conext

```bash
docker context ls
```

## native docker - rootfull - set remote api to enable - a (fail)

- edit /etc/default/docker

```bash
# DOCKER_OPTS="-H tcp://0.0.0.0:2375"
echo DOCKER_OPTS="-H tcp://0.0.0.0:2375" | sudo tee -a /etc/default/docker;
sudo systemctl daemon-reload;sudo systemctl restart docker;

# [tell dockerd to set remote api to enable ](https://cloud.tencent.com/developer/article/1683689)
```

## native docker - rootfull - set remote api to enable - b

- edit file /usr/lib/systemd/system/docker.service

- use `tcp://127.0.0.1:2375` in docker.service
- use `d://` as `unix:///var/run/docker.sock` in docker.service
- use `--containerd=/run/containerd/containerd.sock` in docker.service

```bash
cat /usr/lib/systemd/system/docker.service
# cat /usr/lib/systemd/system/docker.service | grep "ExecStart=/usr/bin/dockerd"
# ...

sed -i -E "s#ExecStart=.*#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock#g" /usr/lib/systemd/system/docker.service


# ps aux | grep dockerd | grep -v grep
sudo systemctl daemon-reload;sudo systemctl restart docker;


docker -H tcp://127.0.0.1:2375 version

# [tell dockerd to set remote api to enable ](https://cloud.tencent.com/developer/article/1683689)


# sed -E "s#ExecStart=.*#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock#g" /usr/lib/systemd/system/docker.service

# default:
# ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

## native docker - rootfull - set remote api to enable - c (fail)

- edit file /etc/docker/daemon.json

```powershell

# unix:///var/run/docker.sock for local client to connect to docker daemon
# tcp://0.0.0.0:2375 for remote client to connect to docker daemon
# yours edit-json/stra --file daemon.json --name "hosts" --include "unix:///var/run/docker.sock,tcp://0.0.0.0:2375"

yours edit-json/stra --file daemon.json --name "hosts" --include "tcp://0.0.0.0:2375"
```

```bash
cp /mnt/d/book/daemon.json /etc/docker/daemon.json;
cat /etc/docker/daemon.json
sudo systemctl daemon-reload;sudo systemctl restart docker; # fail !!


# [tell dockerd to set remote api to enable ](https://cloud.tencent.com/developer/article/1683689)

# [why retart dockerd fail](https://blog.csdn.net/weixin_42803662/article/details/109471333)
# Docker socket configuration hosts conflict

# about -H fd:// --containerd=/run/containerd/containerd.sock
# [about -H fd://](https://blog.csdn.net/michaelwoshi/article/details/107601744)

# [about -H unix:///var/run/docker.sock](https://runebook.dev/zh/docs/docker/engine/reference/commandline/dockerd/index)

# about -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock

```

## native docker - rootfull - set remote api to enable - c (fix)

- use `tcp://127.0.0.1:2375` in daemon.json
- use `unix:///var/run/docker.sock` in daemon.json

```bash
sed -i -E "s#ExecStart=.*#ExecStart=/usr/bin/dockerd#g" /usr/lib/systemd/system/docker.service

cp /mnt/d/book/daemon.b.json /etc/docker/daemon.json;
cat /etc/docker/daemon.json
sudo systemctl daemon-reload;sudo systemctl restart docker;

docker -H tcp://127.0.0.1:2375 version
```

## native docker - rootfull - set remote api to enable - c (fix-2)

- use `tcp://127.0.0.1:2375` in daemon.json
- use `unix:///var/run/docker.sock` in daemon.json
- use `--containerd=/run/containerd/containerd.sock` in docker.service

```bash
sed -i -E "s#ExecStart=.*#ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock#g" /usr/lib/systemd/system/docker.service

cp /mnt/d/book/daemon.b.json /etc/docker/daemon.json;
cat /etc/docker/daemon.json
sudo systemctl daemon-reload;sudo systemctl restart docker;

docker -H tcp://127.0.0.1:2375 version
```

## native docker - rootful - remote client connect docker daemon

```bash
docker context rm wsl -f
# docker context create wsl --docker "host=tcp://0.0.0.0:2375"
docker context create wsl --docker "host=tcp://127.0.0.1:2375"
docker context ls
docker context use wsl

docker info

# docker -H tcp://127.0.0.1:2375 version
```

## native docker - daemon and containerd

```bash
# cat /etc/containerd/config.toml

# get default config of containerd ?do
containerd config default

# set default config of containerd to /etc/containerd/config.toml ?do
# containerd config default > /etc/containerd/config.toml

# cat /etc/systemd/system/containerd.service

# tell systemd to enbale containerd service ?do
# systemctl enable containerd --now

# get containerd version ? do
ctr version


# [native docker - daemon and containerd](https://cloud.tencent.com/developer/article/1868071)
```

## native docker - rootful - set data-root - a (fail)

```bash
# du -sh /var/lib/docker

cp /mnt/d/book/daemon.b.json /etc/docker/daemon.json;
cat /etc/docker/daemon.json
sudo systemctl daemon-reload;sudo systemctl restart docker;

docker info | grep Root
# [set data-root in 3 way](https://xie.infoq.cn/article/18a4ce2fd7e7410314baf49da)
```

## native docker - rootful - set data-root - b

```bash
# du -sh /var/lib/docker

sudo systemctl stop docker;
mv /var/lib/docker /data;
ln -s /data/docker /var/lib/;
systemctl start docker

# check
docker images
du -sh /var/lib/docker
du -sh /data/docker/

# docker info | grep Root
# [set data-root in 3 way](https://xie.infoq.cn/article/18a4ce2fd7e7410314baf49da)
```
