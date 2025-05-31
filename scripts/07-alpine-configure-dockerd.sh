#!/bin/sh

check_result(){
    local msg_head=$1
    local flag_exit=$2
    local msg_success="✅"
    local msg_failed="❌"

    if [ $? -eq 0 ]; then
        echo "$msg_head $msg_success";
    else
        echo "$msg_head $msg_failed";
        [ $flag_exit -eq 0 ] && exit 1;
    fi
}

info_step(){
    local msg=$1
    echo "-------------------------$msg-------------------------"
}

info_status(){
    local msg_head=$1
    local status=$2
    local msg_success="✅"
    local msg_failed="❌"
    if [ $status -eq 0 ]; then
        echo "$msg_head $msg_success";
    else
        echo "$msg_head $msg_failed";
    fi
}
# info_status "check docker status" 0


create_docker_daemon_config_file(){
    mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://registry.cn-hangzhou.aliyuncs.com",
    "https://hub-mirror.c.163.com", 
    "https://mirror.ccs.tencentyun.com",
    "https://docker.mirrors.tuna.tsinghua.edu.cn"
  ]
}
EOF
}

prepare_dockerd_cmd(){
    # echo "dockerd --config-file=/etc/docker/daemon.json --pidfile /var/run/docker.pid &> /var/log/dockerd.log &" >> ~/.profile
    DOCKERD_CMD="dockerd --host=fd:// --host=tcp://0.0.0.0:2375 --config-file=/etc/docker/daemon.yaml --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

    # dockerd cmd with logfile + Unix socket + local tcp socket + registry-mirrors in daemon.json
    DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --config-file=/etc/docker/daemon.json &> /var/log/dockerd.log &"

    # dockerd cmd with logfile + Unix socket + local tcp socket
    # DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 &> /var/log/dockerd.log &"

    # dockerd cmd with pidfile and logfile
    # DOCKERD_CMD="dockerd --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"
    echo $DOCKERD_CMD
}

stop_dockerd(){
    if [ -f /var/run/docker.pid ]; then
        kill $(cat /var/run/docker.pid) 2>/dev/null
        rm -f /var/run/docker.pid
    fi
    pkill -9 dockerd 2>/dev/null
}

start_dockerd(){
    echo "$DOCKERD_CMD"
    sh -c "$DOCKERD_CMD"
    sleep 3
}

check_docker_daemon_status(){
    if docker info >/dev/null 2>&1; then
        echo "✅ Docker Start success (PID: $(pgrep dockerd))"
    else
        echo "❌ Docker Start fail (Please check /var/log/dockerd.log)"
        cat /var/log/dockerd.log
        exit 1
    fi
}

start_dockerd_on_boot(){
    # start dockerd on boot
    echo "$DOCKERD_CMD"
    if grep -q "dockerd.*" /etc/rc.local > /dev/null 2>&1; then
        sed -i "/dockerd.*/c\\$DOCKERD_CMD" /etc/rc.local
    else
        echo "$DOCKERD_CMD" >> /etc/rc.local
    fi
}

get_registry_mirrors(){
    docker info | grep -iA5 "registry mirrors"
}

step_name="create docker daemon config file"
info_step "$step_name"
create_docker_daemon_config_file
info_status "$step_name" $?

step_name="prepare dockerd cmd"
info_step "$step_name"
DOCKERD_CMD=$(prepare_dockerd_cmd)
info_status "$step_name" $?

step_name="stop docker daemon"
info_step "$step_name"
stop_dockerd
info_status "$step_name" $?


# start dockerd
step_name="start docker daemon"
info_step "$step_name"
start_dockerd
info_status "$step_name" $?


# 5. check docker daemon status
step_name="check docker daemon status"
info_step "$step_name"
check_docker_daemon_status
info_status "$step_name" $?


# 6. start when system boot up
step_name="start dockerd on boot"
info_step "$step_name"
start_dockerd_on_boot
info_status "$step_name" $?


# 7. get registry mirrors
step_name="get registry mirrors"
info_step "$step_name"
get_registry_mirrors
info_status "$step_name" $?
