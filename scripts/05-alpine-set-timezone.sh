#!/bin/sh

timezone=$1

set_timezone() {
    local timezone=$1;
    # add tzdata package
    apk add --no-cache tzdata
    # get area from timezone
    area=$(echo $timezone | awk -F '/' '{print $1}')
    # set timezone
    mkdir -p /usr/share/zoneinfo/$area
    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
}

check_time(){
    # check system time
    echo "current system time:"
    date
    echo "current hardware time:"
    hwclock -r
}

use_chrony(){
    # add openrc package to manage services
    apk add --no-cache openrc
    # add chrony package to manage time
    apk add --no-cache chrony
    # start chrony service
    rc-service chronyd start
    # add chrony service to run at boot time
    rc-update add chronyd
}

use_aliyun_ntp(){
    # use aliyun ntp server
    sed -i 's/^pool.*/server ntp.aliyun.com iburst/' /etc/chrony/chrony.conf
    rc-service chronyd restart
}

# set_timezone "Asia/Shanghai"
set_timezone $timezone
# sync hardware clock
hwclock --systohc
check_time
use_chrony
use_aliyun_ntp

# list services
# wsl rc-status