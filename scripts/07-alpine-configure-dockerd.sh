#!/bin/sh

check_result(){
    local msg_body=$1
    local flag_exit=$2
    local msg_success="✅"
    local msg_failed="❌"

    if [ $? -eq 0 ]; then
        echo "$msg_success $msg_body";
    else
        echo "$msg_failed $msg_body";
        [ $flag_exit -eq 0 ] && exit 1;
    fi
}

msg_padd(){
    local msg=$1
    local msg_max_len=$2
    local msg_len=${#msg} 
    local msg_fill_length=$((($msg_max_len-$msg_len+2)/2))
    local msg_padding=$(printf "%-${msg_fill_length}s" | tr ' ' '-') 
    echo "$msg_padding-$msg-$msg_padding" | cut -c 1-$msg_max_len
}


info_step(){
    local msg=$1
    # echo "-------------------------$msg-------------------------"
    msg_padd "$msg" 60
}

info_status(){
    local msg_body=$1
    local status=$2
    local msg_success="✅"
    local msg_failed="❌"
    if [ $status -eq 0 ]; then
        echo "$msg_success $msg_body";
    else
        echo "$msg_failed $msg_body";
    fi
}
# info_status "check docker status" 0


create_docker_daemon_config_file(){
    mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors" : ["https://docker.registry.cyou",
    "https://docker-cf.registry.cyou",
    "https://dockercf.jsdelivr.fyi",
    "https://docker.jsdelivr.fyi",
    "https://dockertest.jsdelivr.fyi",
    "https://mirror.aliyuncs.com",
    "https://dockerproxy.com",
    "https://mirror.baidubce.com",
    "https://docker.m.daocloud.io",
    "https://docker.nju.edu.cn",
    "https://docker.mirrors.sjtug.sjtu.edu.cn",
    "https://docker.mirrors.ustc.edu.cn",
    "https://mirror.iscas.ac.cn",
    "https://docker.rainbond.cc",
    "https://do.nark.eu.org",
    "https://dc.j8.work",
    "https://dockerproxy.com",
    "https://gst6rzl9.mirror.aliyuncs.com",
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "http://mirrors.ustc.edu.cn/",
    "https://mirrors.tuna.tsinghua.edu.cn/",
    "http://mirrors.sohu.com/" 
    ],
    "insecure-registries" : [
        "registry.docker-cn.com",
        "docker.mirrors.ustc.edu.cn"
    ]
}
EOF
}

get_wsl_ip(){
    local wslip=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1;)
    echo $wslip;
}

prepare_dockerd_cmd(){
    wslip=$(get_wsl_ip);
    # echo "dockerd --config-file=/etc/docker/daemon.json --pidfile /var/run/docker.pid &> /var/log/dockerd.log &" >> ~/.profile
    DOCKERD_CMD="dockerd --host=fd:// --host=tcp://0.0.0.0:2375 --config-file=/etc/docker/daemon.yaml --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

    # dockerd cmd with logfile + Unix socket + local tcp socket + registry-mirrors in daemon.json + wsl ip
    DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --host=tcp://$wslip:2375 --tls=false --config-file=/etc/docker/daemon.json &> /var/log/dockerd.log &"

    # dockerd cmd with logfile + Unix socket + local tcp socket + registry-mirrors in daemon.json
    # DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --config-file=/etc/docker/daemon.json &> /var/log/dockerd.log &"

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
        info_status "Docker Start success (PID: $(pgrep dockerd))" 0
    else
        info_status "Docker Start fail (Please check /var/log/dockerd.log)" 1
        cat /var/log/dockerd.log
        exit 1
    fi
}

start_dockerd_on_login(){
    # start dockerd on login
    echo "$DOCKERD_CMD"
    if grep -q "dockerd.*" /etc/rc.local > /dev/null 2>&1; then
        sed -i "/dockerd.*/c\\$DOCKERD_CMD" /etc/rc.local
    else
        echo "$DOCKERD_CMD" >> /etc/rc.local
    fi
}
unregister_dockerd_on_login(){
    # unregister dockerd on login
    if grep -q "dockerd.*" /etc/rc.local > /dev/null 2>&1; then
        sed -i "/dockerd.*/d" /etc/rc.local
    fi
    # cat /etc/rc.local
}

start_dockerd_on_boot(){
    # start dockerd on boot
    echo "$DOCKERD_CMD"
    DOCKER_ARGS=$(echo $DOCKERD_CMD | sed 's/dockerd//g')
    cat > /etc/init.d/dockerd <<EOF
#!/sbin/openrc-run
command="dockerd"
command_args="$DOCKER_ARGS"
command_background=true
EOF
    # cat /etc/init.d/dockerd
    chmod +x /etc/init.d/dockerd
    rc-update add dockerd default
}

unregister_dockerd_on_boot(){
    # unregister dockerd on boot
    rc-update del dockerd default
    rm -f /etc/init.d/dockerd   
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


# unregister dockerd on login
step_name="unregister dockerd on login"
info_step "$step_name"
unregister_dockerd_on_login
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
