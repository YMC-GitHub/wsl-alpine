#!/bin/sh

info_status(){
    local msg_body=$1
    local status=$2
    local msg_success="✅"
    local msg_failed="❌"
    local msg_warn="ℹ️"

    if [ $status -eq 0 ]; then
        echo "$msg_success $msg_body"
    elif [ $status -eq 1 ]; then
        echo "$msg_failed $msg_body"
    else
        echo "$msg_warn $msg_body"
    fi
}
# info_status "check docker status" 0

stop_dockerd(){
    if pgrep dockerd >/dev/null; then
        echo "Stoping Dockerd..."
        pkill dockerd
        sleep 2
        if pgrep dockerd >/dev/null; then
            pkill -9 dockerd
        fi
        info_status "Dockerd stopped" 0
    else
        info_status "Dockerd not running, no need to stop" 2
    fi

}
stop_dockerd

# # way 1: stop with PID file
# if [ -f /var/run/docker.pid ]; then
#     kill $(cat /var/run/docker.pid) && echo "Docker已停止"
# else
#     # way 2:stop with process name
#     pkill dockerd && echo "Docker已停止" || echo "Docker未运行"
# fi