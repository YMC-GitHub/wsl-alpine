## wsl - use docker as rootless - a

## ubuntu - add/del user - zero

```bash
# add user and set password ? do:
cuser="zero";
useradd $cuser -m -s /bin/bash
passwd $cuser
cat /etc/shadow | grep $cuser | cut -d: -f2

# del user and user dir ? do:
# sudo deluser $cuser --remove-home
# cat /etc/passwd | grep $cuser | cut -d: -f1
# rm -rf /home/$cuser

# ls /home/

# add user zero,ymc
# cuser="ymc";
```

## ubuntu - add/del user - ymc

```bash
# useradd --help

# add user and set password ? do:
cuser="ymc";
useradd $cuser --uid 1001 --user-group --create-home --shell /bin/bash
passwd $cuser
cat /etc/shadow | grep $cuser | cut -d: -f2

# del user and user dir ? do:
# sudo deluser $cuser --remove-home
# cat /etc/passwd | grep $cuser | cut -d: -f1
# rm -rf /home/$cuser

# ls /home/

# add user zero,ymc
# cuser="ymc";
```

## ubuntu - set docker group gid

```bash
id -u

grep ^$(whoami): /etc/subuid

grep ^$(whoami): /etc/subgid

# see what group IDs are already assigned that are 1000 or above ?do
getent group | cut -d: -f3 | grep -E '^[0-9]{4}' | sort -g

# what number to use? May I suggest 36257
getent group | grep 36257 || echo "Yes, that ID is free"


# change the id in group file ? do
sudo sed -i -e 's/^\(docker:x\):[^:]\+/\1:36257/' /etc/group

# change group id ? do
sudo groupmod -g 36257 docker
```

## ubuntu - add/del user as sudoer - ymc

```bash
su $cuser
sudo -v

# is your user a "sudoer"?
grep -E 'sudo|wheel' /etc/group

# add the user in question to that group ? do
# Alpine:
addgroup $cuser wheel
# Fedora:
usermod -aG wheel $cuser
# Ubuntu/Debian:
usermod -aG sudo $cuser

# as root, make sure that the admin group ? do
grep -E '%sudo|%wheel' /etc/sudoers

su $cuser
sudo -v # If you are prompted for the password, then all is well

# [set a non-root user](https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9)
```

## wsl - use systemd and set default user

```bash
#  Windows build 18980+ & wsl ? do:
cat /etc/wsl.conf

printf "\n[user]\ndefault = $cuser\n" | sudo tee -a /etc/wsl.conf

# echo "$cuser" >> /etc/wsl.conf
#sudo  sed -i -E "s/default.*//" /etc/wsl.conf
#sudo  sed -i -E "s/default.*//" /etc/wsl.conf
#sudo  sed -i -E "s/[user].*//" /etc/wsl.conf


printf "\n[boot]\nsystemd= true\n" | sudo tee -a /etc/wsl.conf
printf "\n[user]\ndefault = $cuser\n" | sudo tee -a /etc/wsl.conf
cat etc/wsl.conf

# use systemd and set default user ? do
printf "\n[boot]\nsystemd= true\n\n[user]\ndefault = $cuser\n" | sudo tee /etc/wsl.conf

# use systemd ? do
printf "\n[boot]\nsystemd= true\n" | sudo tee /etc/wsl.conf

```

```bash
#  Windows build 18980- & wsl ? do:

# 1
id -u

# 2
wsl -l

# 3
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq Alpine  | Set-ItemProperty -Name DefaultUid -Value 1000
```

## wsl - update/upgrade packages

```bash
# Debian/Ubuntu:
sudo apt update && sudo apt upgrade
# Fedora:
sudo dnf upgrade
# Alpine:
sudo apk upgrade -U

# [Update/upgrade packages and test network connectivity](https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9)
```

## wsl - prpare for docker installation

## wsl - pfdi - remove residue

```bash
# Debian/Ubuntu:
sudo apt remove docker docker-engine docker.io containerd runc

# Fedora:
sudo dnf remove moby-engine docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine

# Alpine (probably not necessary, but just in case):
sudo apk del docker-cli docker-ce docker-openrc docker-compose docker
```

## wsl - pfdi - install dependencies

```bash
# Debian/Ubuntu:
sudo apt install --no-install-recommends apt-transport-https ca-certificates curl gnupg2

# Fedora:
sudo dnf install dnf-plugins-core

# Alpine: Nothing needed. Dependencies will be installed later, automatically.
```

## wsl - pfdi - Debian: switch to legacy iptables

```bash
update-alternatives --config iptables
```

## wsl - pfdi - Debian/Ubuntu package repository configuration

```bash
# cat /etc/os-release | grep ID=
. /etc/os-release

curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc

echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
```

## wsl - pfdi - Fedora package repository configuration

```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

## native docker - install - rootful

```bash
# Debian/Ubuntu:
sudo apt install docker-ce docker-ce-cli containerd.io

# Fedora:
sudo dnf install docker-ce docker-ce-cli containerd.io

# Alpine (install the latest from edge):
sudo apk add docker --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
```

## native docker - add user to docker group

```bash
# Fedora/Ubuntu/Debian:
sudo usermod -aG docker $USER
# Alpine:
sudo addgroup $USER docker
```

## wsl - dockerd - choose a common ID for the docker group

```bash
# see what group IDs are already assigned that are 1000 or above ?do
getent group | cut -d: -f3 | grep -E '^[0-9]{4}' | sort -g

# what number to use? May I suggest 36257
getent group | grep 36257 || echo "Yes, that ID is free"


# change the id in group file ? do
sudo sed -i -e 's/^\(docker:x\):[^:]\+/\1:36257/' /etc/group

# change group id ? do
sudo groupmod -g 36257 docker
```

## wsl - prepare a shared diretory

```bash
# sudo chgrp --help
# chgrp [OPTION]... GROUP FILE

DOCKER_DIR=/mnt/i/shared-docker;
mkdir -pm o=,ug=rwx "$DOCKER_DIR";
sudo chgrp docker "$DOCKER_DIR";
```

## wsl - Configure dockerd to use the shared directory

```bash
cat /etc/docker/daemon.json
```

## wsl - launch dockerd

```bash

sudo dockerd
# docker run --rm hello-world
```

## wsl - launch dockerd with script

```bash
DOCKER_DISTRO="ubuntu-20.04"
DOCKER_DIR=/mnt/i/shared-docker
DOCKER_SOCK="$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://$DOCKER_SOCK"
if [ ! -S "$DOCKER_SOCK" ]; then
    mkdir -pm o=,ug=rwx "$DOCKER_DIR"
    sudo chgrp docker "$DOCKER_DIR"
    /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
fi

# cat /var/run/docker.sock

# DOCKER_DISTRO="ubuntu-20.04"
# DOCKER_LOG_DIR=$HOME/docker_logs
# mkdir -pm o=,ug=rwx "$DOCKER_LOG_DIR"
# /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_LOG_DIR/dockerd.log 2>&1"
```

## fix

```bash
# docker info
# ERROR: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock
```

## wsl - Passwordless launch of dockerd

```bash
# sudo visudo
# %docker ALL=(ALL)  NOPASSWD: /usr/bin/dockerd

# sudo cat /etc/sudoers

echo "%docker ALL=(ALL)  NOPASSWD: /usr/bin/dockerd" >> /etc/sudoers

sudo dockerd
```

## wsl - Make sure DOCKER_HOST is always set

```bash
# ls /mnt/wsl/resolv.conf
# cat /mnt/wsl/resolv.conf

# DOCKER_SOCK="/mnt/i/shared-docker/docker.sock"
# test -S "$DOCKER_SOCK" && export DOCKER_HOST="unix://$DOCKER_SOCK"

# [ -d /mnt/wsl ] && export DOCKER_HOST="unix:///mnt/wsl/shared-docker/docker.sock"
```

## wsl - running docker from windows

```powershell
scoop install docker docker-compose
# docker context ls

# cat
```

## wsl - use docker as rootless - b

## wsl - set docker-data-root to custom location

```bash

# stop docker and del ? do
# sudo systemctl disable --now docker.service docker.socket
# sudo rm /var/run/docker.sock

# let zero user use sudo without password ? do
# ...
# echo "%docker ALL=(ALL)  NOPASSWD: /usr/bin/dockerd" >> /etc/sudoers


sudo apt install -y uidmap
# cat /etc/security/limits.conf
sudo echo '* soft nofile 5120' >> /etc/security/limits.conf
sudo echo '* hard nofile 5120' >> /etc/security/limits.conf
ulimit -n

wsl --shutdown

# cat  /etc/sysctl.conf
cat /etc/sysctl.conf
echo 'net.ipv4.ip_unprivileged_port_start=80' >>/etc/sysctl.conf
echo 'fs.inotify.max_user_instances=1024' >> /etc/sysctl.conf
# check ?do
# sysctl -p


# useradd zero -m -s /bin/bash
# password zero

# useradd ymc -m -s /bin/bash
# password ymc



curl -fsSL https://get.docker.com/rootless | sh

# export PATH=/usr/bin:$PATH
# export DOCKER_HOST=unix:///run/user/1000/docker.sock

# export PATH=/home/ymc/bin:$PATH
# export DOCKER_HOST=unix:///run/user/1001/docker.sock

# userid=`id -u`;echo "$userid";

echo "export PATH=/home/$USER/bin:$PATH" >> ~/.bashrc
echo "export DOCKER_HOST=unix:///run/user/$UID/docker.sock" >> ~/.bashrc
# ls /run/user/1001


source ~/.bashrc
echo "$PATH"
echo "$DOCKER_HOST"

systemctl --user start docker.service
systemctl --user status docker.service
# docker context --help
# docker context ls
# ls /var/run

# systemctl --user (start|stop|restart) docker.service

# sudo loginctl enable-linger zero


# systemctl --user start docker

# systemctl --user enable docker

# systemctl --user status docker


#  ~/.config/docker/daemon.json
yours edit-json --file daemon.json --name "data-root" --value "/mnt/i/dockerdata"  --defaut-text "{}"

yours edit-json/stra --file daemon.json --name "registry-mirrors" --include "https://mirror.gcr.io,https://mirror.aliyuncs.com"


systemctl --user stop docker
mkdir -p  ~/.config/docker
cp /mnt/d/book/daemon.json ~/.config/docker/daemon.json
systemctl --user start docker



# systemctl --user stop docker;rm -f ~/.config/docker/daemon.json;systemctl --user start docker;

docker info | grep Root
docker info | grep -E "Registry|http"

# systemctl --user restart docker.service



docker run hello-world

# https://docs.docker.com/config/daemon/#configuration-file
```

## export docker api scoket through tcp - rootless

```bash
DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="-p 0.0.0.0:2376:2376/tcp" \
  dockerd-rootless.sh \
  -H tcp://0.0.0.0:2376 \
  --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem
```

[export docker api scoket through tcp - rootless](https://docs.docker.com/engine/security/rootless/#expose-docker-api-socket-through-tcp)

## export docker api scoket through ssh - rootless

```bash
# ssh -l <REMOTEUSER> <REMOTEHOST> 'echo $DOCKER_HOST'
# unix:///run/user/1001/docker.sock
# docker -H ssh://<REMOTEUSER>@<REMOTEHOST> run ...
```

[use docker as rootless](https://runebook.dev/zh/docs/docker/engine/security/rootless/index)

[run docker as rootless](https://blog.csdn.net/fanghailiang2016/article/details/127100079)

## wsl - use docker as rootless - c

```bash
# curl -o install-docker-rootless.sh -fsSL https://get.docker.com/rootless
# sh ./install-docker-rootless.sh
# rm ./install-docker-rootless.sh

# download
curl -fsSL https://get.docker.com/rootless | sh


# install dependencies
sudo apt-get install -y uidmap

# install
dockerd-rootless-setuptool.sh install
```

## wsl - info docker

```bash
# systemd unit file is installed as ~/.config/systemd/user/docker.service ?
# ls ~/.config/systemd/user/

# to use systemctl --user to manage the lifecycle of the daemon ? do
systemctl --user start docker

# To launch the daemon on system startup, enable the systemd service and lingering ? do:
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)

# $XDG_RUNTIME_DIR is typically set to /run/user/$UID ?
# export XDG_RUNTIME_DIR=/run/user/$UID;
echo "$XDG_RUNTIME_DIR"


#the socket path is set to $XDG_RUNTIME_DIR/docker.sock by default ?
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock;
echo "$DOCKER_HOST"
echo "unix://$XDG_RUNTIME_DIR/docker.sock"

# docker context update rootless --docker "host=unix://$XDG_RUNTIME_DIR/docker.sock"

# The data dir is set to ~/.local/share/docker by default ?
ls ~/.local/share

# The daemon config dir is set to ~/.config/docker by default ?
ls ~/.config/docker
cat ~/.config/docker/daemon.json
echo "$XDG_CONFIG_HOME"
# export XDG_CONFIG_HOME=~/.config
# $XDG_CONFIG_HOME/docker/daemon.json

# dockerd --help
# cat /etc/docker/daemon.json


# This client config is set to ~/.docker by default ?


# a
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock;
# docker run -d -p 8080:80 nginx

# docker context --help
# docker context ls
# docker context show
# docker context use rootless
# docker context update --help
# docker context create --help

# To expose the Docker API socket through TCP ?
echo "$DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS";
DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="-p 0.0.0.0:2376:2376/tcp";
dockerd-rootless.sh -H tcp://0.0.0.0:2376;
```

## wsl - docker up - rootless

```bash
systemctl --user start docker
# fix - Failed to connect to bus: No such file or directory
# sudo apt install systemd-container
# machinectl shell ymc@

# fix - System has not been booted with systemd as init system (PID 1)
# https://blog.csdn.net/qfyh_djh/article/details/139197614
# about sysv init and systemd
# ps -p 1 -o comm=
# systemctl start docker
# sudo service ssh status

# sudo service docker status


sudo loginctl enable-linger $(whoami)
```

## wsl - uninstall docker - rootlesss

```bash
# https://github.com/docker/docker-install/issues/166
# rootlesss docker inatlled with binary not apt pkg
systemctl --user stop docker
systemctl --user disable docker
rm -f ~/bin/dockerd

# cat ~/.bashrc | grep "export PATH"
# cat ~/.bashrc | grep "DOCKER_HOST"
# sed  -E "s/.*DOCKER_HOST.*//g" ~/.bashrc
sed -i -E "s/.*DOCKER_HOST.*//g" ~/.bashrc

dockerd-rootless-setuptool.sh uninstall -f;

rootlesskit rm -rf ~/.local/share/docker;
cd ~/bin;
rm -f *docker* *containerd* *runc* *rootlesskit* *vpnkit*;
rm -f ~/.local/share/docker*

# reinstall docker client with snap ? do
# sudo snap remove --purge docker; snap install docker;

# journalctl --user -xe
ls ~/.config/systemd/user
rm ~/.config/systemd/user/docker.service

# sudo deluser --remove-home zero

```

## wsl - install docker - rootless -d

```bash
curl -o install.sh -fsSL https://get.docker.com
sudo sh install.sh

dockerd-rootless-setuptool.sh install

# [Rootless Docker/Moby ](https://rootlesscontaine.rs/getting-started/docker/)
```

[wsl - install docker - rootless -d](https://github.com/containerd/containerd/blob/main/docs/rootless.md)
