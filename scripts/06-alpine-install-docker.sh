#!/bin/sh

# to use sudo in alpine linux, you need to install sudo
# apk add --no-cache sudo

# intall docker
apk add --no-cache docker

# add user to docker group (let docker run without sudo)
addgroup $USER docker

# let docker start automatically when the system starts
# rc-update add docker

# start docker
# service docker start

# run dockerd directly
dockerd &> /var/log/dockerd.log &

# sleep 3
# if docker info &> /dev/null; then
#     echo "Docker started successfully"
#     docker run --rm hello-world
# else
#     echo "Docker started faily , please check /var/log/dockerd.log"
#     exit 1
# fi

# rc-update add docker boot
# rc-service docker start
# rc-service docker status
# docker run --rm hello-world
