#!/bin/bash

# Configure Alpine bridged network static IP
# Parameters:
#   $1 - Static IP address (e.g. 192.168.0.106/24)
#   $2 - Gateway address (e.g. 192.168.0.1)
#   $3 - DNS server (e.g. 192.168.0.1)


check_result(){
    local status=$?
    local msg_body=$1
    local flag_exit=$2
    local msg_success="✅"
    local msg_failed="❌"

    if [ $status -eq 0 ]; then
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

# Check parameters
if [ $# -ne 3 ]; then
    echo "Error: Invalid number of parameters"
    echo "Usage: $0 <IP/CIDR> <Gateway> <DNS>"
    exit 1
fi

check_ip_cidr_format(){
    local step_name="Check IP/CIDR format"
    local ip_cidr=$1
    info_step "$step_name"
    echo "$ip_cidr" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$' >/dev/null 2>&1;
    check_result "$step_name" 0
}

register_eth0_as_bridged_network_dhcp(){
    # register eth0 as bridged network
    local step_name="Register eth0 as bridged network (dhcp)"
    info_step "$step_name"
    mkdir -p /etc/network
    cat > /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet dhcp
    bridge_ports eth0
    bridge_stp off
    bridge_fd 0
EOF
    info_status "$step_name" 0
}
# register_eth0_as_bridged_network_dhcp

register_eth0_as_bridged_network_static(){
    local step_name="Register eth0 as bridged network (static)"
    info_step "$step_name"
    mkdir -p /etc/network
    cat > /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet static
    address $wslIp
    netmask 255.255.255.0
    gateway $gateway
    dns-nameservers $dns
EOF
    info_status "$step_name" 0
}

set_dns_servers() {
    local step_name="set dns"

    local custom_dns=$1
    local dns_servers=("$custom_dns" "8.8.8.8" "8.8.4.4")
    local resolv_conf="/etc/resolv.conf"
    info_step "$step_name"

    for dns in "${dns_servers[@]}"; do
        if ! grep -q "nameserver $dns" "$resolv_conf"; then
            echo "nameserver $dns" >> "$resolv_conf"
        fi
    done
    echo "cat $resolv_conf"
    info_status "$step_name" 0
}

set_generate_resolv_conf() {
    local wsl_conf_path=$1
    local config_key=$2
    local config_value=$3
    local section_name=$4
    local config_line="${config_key}=${config_value}"

    local step_name="set generate resolv"
    info_step "$step_name"
    if [ -f "$wsl_conf_path" ]; then
        if grep -q "$config_key" "$wsl_conf_path"; then
            # 存在则替换
            sed -i "s/^${config_key}.*/$config_line/" "$wsl_conf_path"
        else
            # 不存在则添加
            if ! grep -q "^\[${section_name}\]" "$wsl_conf_path"; then
                echo "[${section_name}]" >> "$wsl_conf_path"
            fi
            echo "$config_line" >> "$wsl_conf_path"
        fi
    else
        # 文件不存在则创建并写入配置
        cat > "$wsl_conf_path" <<EOF
[${section_name}]
$config_line
EOF
    fi
    echo "cat $wsl_conf_path"
    info_status "$step_name" 0
}

ip_route_del_docker0(){
    local step_name="ip route del docker0net"
    info_step "$step_name"
    # 172.17.0.0/16 dev docker0 scope link  src 172.17.0.1
    # ip route del 172.17.0.0/16

    # get docker0 net
    docker0net=$(ip route | grep docker0 | awk '{print $1}')
    # del docker0 net
    [ $? -eq 0 ]  && ip route del $docker0net
    check_result "$step_name" 1
}
docker0_up(){
    local step_name="docker0 up"
    info_step "$step_name"
    ifdown docker0;ifup docker0;
    sleep 2
    info_status "$step_name" 1
}

ip_route_add_bridge(){
    local step_name="ip route add bridgenet"
    info_step "$step_name"

    ip link set eth0 down
    ip route del default >/dev/null 2>&1
    # ip route del $1 dev eth0 >/dev/null 2>&1
    ip route del $bridgenet dev eth0 >/dev/null 2>&1

    ip route add default via $gateway
    # ip addr add $1 dev eth0
    ip route add $bridgenet dev eth0 scope link src $wslIp
    info_status "$step_name" 0
}

info_network(){
    local step_name="info network"
    info_step "$step_name"
    echo "network:$bridgenet"
    echo "gateway:$gateway"
    echo "dns:$dns"
    echo "wsl ip:$wslIp"
    info_status "$step_name" 0
}

setup_wsl_network_script() {
    local step_name="Set up wsl network script"
    info_step "$step_name"
    local gateway=$1
    local bridgenet=$2
    local wslIp=$3
    cat > /etc/profile.d/wsl_network.sh <<EOF
#!/bin/sh
ip link set eth0 down
ip route del default >/dev/null 2>&1
ip route del $bridgenet dev eth0 >/dev/null 2>&1
ip route add default via $gateway  >/dev/null 2>&1
ip route add $bridgenet dev eth0 scope link src $wslIp  >/dev/null 2>&1
ifdown eth0;ifup eth0;
sleep 2
EOF
    chmod +x /etc/profile.d/wsl_network.sh
    echo "cat /etc/profile.d/wsl_network.sh"
    info_status "$step_name" 0
}

eth0_up(){
    local step_name="eth0 up"
    info_step "$step_name"
    # ip link show eth0 | grep -q "state UP"  >/dev/null 2>&1
    # ip link set eth0 up
    ifdown eth0;ifup eth0;
    sleep 2
    info_status "$step_name" 0
}

ping_network() {
    local step_name="ping network"
    info_step "$step_name"
    

    local count=$1;
    local gateway=$2
    local wslIp=$3
    local winIp=$4

    # ping loop address in wsl:
    ping -c $count 127.0.0.1 > /dev/null 2>&1
    check_result "ping loop address in wsl" 0;

    # ping wsl ip in wsl:
    ping -c $count $wslip  > /dev/null 2>&1;
    check_result "ping wsl ip in wsl" 0;

    ping -c 3 "$winIp"  > /dev/null 2>&1;
    check_result "ping win ip in wsl" 0

    # ping internet in wsl:
    ping -c $count www.baidu.com > /dev/null 2>&1;
    check_result "ping baidu in wsl" 1;

    ping -c $count google.com > /dev/null 2>&1;
    check_result "ping google in wsl" 1;

    # ip route add 192.168.0.1/24 via 192.168.0.1 dev eth0 src 192.168.0.106
    # check_result "Add custom route" 0

    # alpine restart network
    # way 1: 
    # ip link set eth0 down;ip link set eth0 up

    # way 2: dhcp + udhcpc
    # udhcpc -n -k -i eth0;udhcpc -i eth0

    # way 3: /etc/network/interfaces + ifdown + ifup
    # ifdown eth0;ifup eth0;ip addr show eth0;

    ip route 
    ip addr
    info_status "$step_name" 0
}


cleanup_files() {
    local step_name="clean network config"
    rm -f /etc/network/interfaces
    rm -f /etc/wsl.conf
    rm -f /etc/profile.d/wsl_network.sh
    info_status "$step_name" 0
}
# cleanup_files

check_ip_cidr_format "$1"

# get bridge net
bridgenet=$(echo $1 | awk -F '.' '{print $1"."$2"."$3".0/24"}')
gateway=$2
dns=$3
# get wsl ip from ip/cidr
wslIp=$(echo $1 | awk -F '/' '{print $1}')
winIp=$(echo $1 | awk -F '.' '{print $1"."$2"."$3".107"}') 

info_network
register_eth0_as_bridged_network_static
set_dns_servers $dns
set_generate_resolv_conf "/etc/wsl.conf" "generateResolvConf" "false" "network"
# ip_route_del_docker0
# docker0_up
ip_route_add_bridge
setup_wsl_network_script "$gateway" "$bridgenet" "$wslIp"
eth0_up
ping_network 3 "$gateway" "$wslIp" "$winIp"
