# get wsl ip in wsl:
get_wsl_ip(){
    local wslip=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1;)
    echo $wslip;
}

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

ping_network(){
    local count=$1;
    # ping loop address in wsl:
    ping -c $count 127.0.0.1 > /dev/null 2>&1
    check_result "ping loop address in wsl" 0;

    # ping wsl ip in wsl:
    wslip=$(get_wsl_ip)
    ping -c $count $wslip  > /dev/null 2>&1;
    check_result "ping wsl ip in wsl" 1;

    # ping internet in wsl:
    ping -c $count www.baidu.com > /dev/null 2>&1;
    check_result "ping internet in wsl" 1;
}

ip_route_show(){
    ip route show
    ip addr show eth0
    # ip addr
}

ip_route_add(){
    local ip=$1;
    local gateway=$2;
    local dns=$3;

    # add route
    ip route del default >/dev/null 2>&1
    old_ip=$(get_wsl_ip)
    ip route del $old_ip dev eth0 >/dev/null 2>&1

    ip route add default via $gateway
    ip route add $(echo $ip | awk -F '.' '{print $1"."$2"."$3".0/24"}') dev eth0 scope link src $ip

    # ensure eth0 is up
    ip link show eth0 | grep -q "state UP" >/dev/null 2>&1
    [ $? -ne 0 ] && {
        ip link set eth0 up >/dev/null 2>&1
        check_result "up eth0" 0
        sleep 2
    }
    # add route when wsl boot
    cat > /etc/profile.d/wsl_network.sh <<EOF   
    #!/bin/sh
    check_result(){
        local msg_head=\$1
        local flag_exit=\$2
        local msg_success="✅"
        local msg_failed="❌"

        if [ \$? -eq 0 ]; then
            echo "\$msg_head \$msg_success";
        else
            echo "\$msg_head \$msg_failed";
            [ \$flag_exit -eq 0 ] && exit 1;
        fi
    }

    ip route add default via $gateway
    ip route add $(echo $ip | awk -F '.' '{print $1"."$2"."$3".0/24"}') dev eth0 scope link src $ip
    ip link show eth0 | grep -q "state UP" >/dev/null 2>&1
    [ \$? -ne 0 ] && {
        ip link set eth0 up >/dev/null 2>&1
        check_result "up eth0" 0
        sleep 2
    }
EOF
    chmod +x /etc/profile.d/wsl_network.sh
}

wslip=$(get_wsl_ip)
echo $wslip;
ping_network 3

ip_route_show
