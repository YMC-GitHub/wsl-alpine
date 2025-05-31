## wsl - let window enable-feature for wsl

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /norestart

# reboot

# wsl --install
```

## wsl - list/stop/rm machine

```powershell
wsl -l -v
# wsl --shutdown ubuntu-20.04
```

## docker - install in window

```powershell
scoop install docker
docker version
# dockerd --register-service
# dockerd --unregister-service`
```

## podman - install in window

```powershell
# install podman with scoop ? do
scoop install podman
```

## podman - machine init/list/start/stop/rm/info

```powershell
podman machine init

podman info

podman machine start

#  you prefer root mode ? do
podman machine set --rootful

#  you prefer rootless mode ? do
podman machine stop;podman machine set --rootful=false;

# run a simple http server httpd in container? do
podman run --rm -d -p 8080:80 --name httpd docker.io/library/httpd
curl http://localhost:8080/ -UseBasicParsing

# Volume Mounting ? do
# podman run --rm -v /c/Users/User/myfolder:/myfolder ubi8-micro ls /myfolder

# podman machine ls

# podman machine ssh sudo dnf upgrade -y

# up machine with wsl ? do
wsl -d podman-machine-default

# code --install-extension ms-vscode-remote.vscode-remote-extensionpack
# code --install-extension ms-vscode-remote.remote-containers
# code --install-extension ms-vscode-remote.remote-wsl


# code --install-extension ms-vscode-remote.remote-ssh

# code --install-extension  ms-azure.vscode-docker

# {
#     "docker.host": "unix:///run/user/1000/podman/podman.sock",
#     "docker.dockerPath": "/usr/bin/podman"
# }

# access the embedded WSL distribution ? do
wsl -d podman-machine-default

# wsl -d podman-machine-default enterns systemctl status

# podman --version
# ip addr
# id
# ping -c 2 127.0.0.1
# ping -c 2 192.168.0.107
# ping -c 2 www.baidu.com
# ping -c 2 google.com
# ping -c 2 142.251.43.14

# from rootless user to root ? do
# sudo su -

# win:
$Env:http_proxy="http://127.0.0.1:7890";$Env:https_proxy="http://127.0.0.1:7890"
sh -c "curl -vv https://www.google.com"
$Env:http_proxy="";$Env:https_proxy=""


# witch to a non-privileged user for rootless podman commands ？ do
# su user

# podman machine ls
# podman machine stop
# podman machine rm
# dir $HOME/.ssh
```

## podman - fix - exit status 0xffffffff

```powershell
# Error: the WSL import of guest OS failed: exit status 0xffffffff
# https://github.com/containers/podman/issues/17849
```

## podman - fix - unable to connect to Podman socket

```powershell
# fix
# unable to connect to Podman socket: failed to connect: dial tcp 127.0.0.1:61042:
# https://github.com/containers/podman/issues/20424

podman machine list
podman machine stop
podman machine rm podman-machine-default
podman machine init
podman machine start
```

[podman for window](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)
[Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh)
[Alternate ways to install Docker - Podman](https://code.visualstudio.com/remote/advancedcontainers/docker-options#_podman)

## podman - Migrating from Docker to Podman

```powershell
# way 1
# set alias docker=podman to  .bashr file

```

[Migrating from Docker to Podman](https://marcusnoble.co.uk/2021-09-01-migrating-from-docker-to-podman/)

## podman - run podman in windows

```powershell
podman run -it --rm -d -p 8080:80 –-name web -v o:/podman/site-content:/usr/share/nginx/html docker.io/libary/nginx

# run podman in linux:
# podman run --rm -it --publish 8000:80 --network bridge docker.io/library/nginx:latest

```

[run podman in windows](https://www.redhat.com/sysadmin/run-podman-windows)

## podman - use podman to build image

```powershell
#
```

[k8s - use podman to build image](https://imroc.cc/kubernetes/basics/images/podman)

## podman - user docker client to manage podman

```powershell
# [user docker clikent to manage podman](https://xie.infoq.cn/article/8eaab3ee40aa48e389ba37525)

# 1.
systemctl enable --now podman.socket
# output: /run/podman/podman.sock

# 2
docker -H unix:///run/podman/podman.sock ps -a
```

## k8s - efficient use of kubectl - use kubectx,kubens,kubecm to use kubectl

[ use kubectx and kubens to use kubectl](https://imroc.cc/kubernetes/basics/kubectl/quick-switch-with-kubectx)

## k8s - use cfssl to gen cert

[k8s - use cfssl to gen cert](https://imroc.cc/kubernetes/basics/certs/sign-certs-with-cfssl)

## k8s - use cert-manager to sign free cert

[k8s - use cert-manager to sign free cert](https://imroc.cc/kubernetes/basics/certs/sign-free-certs-with-cert-manager)

```powershell
#
# API forwarding for Docker API clients is not available due to the following startup failures.
#         CreateFile \\.\pipe\docker_engine: All pipe instances are busy.

# Podman clients are still able to connect.
# Error: machine did not transition into running state: ssh error: machine is not listening on ssh port
```
