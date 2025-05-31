#!/bin/bash

# Configure Alpine bridged network static IP
# Parameters:
#   $1 - Static IP address (e.g. 192.168.0.106/24)
#   $2 - Gateway address (e.g. 192.168.0.1)
#   $3 - DNS server (e.g. 192.168.0.1)


# check_result(){
#     local msg_body=$1
#     local flag_exit=$2
#     local msg_success="✅"
#     local msg_failed="❌"

#     if [ $? -eq 0 ]; then
#         echo "$msg_success $msg_body";
#     else
#         echo "$msg_failed $msg_body";
#         [ $flag_exit -eq 0 ] && exit 1;
#     fi
# }

# msg_padd(){
#     local msg=$1
#     local msg_max_len=$2
#     local msg_len=${#msg} 
#     local msg_fill_length=$((($msg_max_len-$msg_len+2)/2))
#     local msg_padding=$(printf "%-${msg_fill_length}s" | tr ' ' '-') 
#     echo "$msg_padding-$msg-$msg_padding" | cut -c 1-$msg_max_len
# }


# info_step(){
#     local msg=$1
#     # echo "-------------------------$msg-------------------------"
#     msg_padd "$msg" 60
# }

# info_status(){
#     local msg_body=$1
#     local status=$2
#     local msg_success="✅"
#     local msg_failed="❌"
#     if [ $status -eq 0 ]; then
#         echo "$msg_success $msg_body";
#     else
#         echo "$msg_failed $msg_body";
#     fi
# }

# Check parameters
if [ $# -ne 3 ]; then
    echo "Error: Invalid number of parameters"
    echo "Usage: $0 <IP/CIDR> <Gateway> <DNS>"
    exit 1
fi

# check_ip_cidr_format(){
#     local ip_cidr=$1
#     # Validate IP/CIDR format
#     echo "$ip_cidr" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$' >/dev/null 2>&1;
# }

# info_step "Check IP/CIDR format"
# check_ip_cidr_format "$1"
# check_result "IP/CIDR format is valid" 0


if ! echo "$1" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$'; then
    echo "Error: Invalid IP/CIDR format: $1"
    exit 1
fi

IPADDR=$(echo $1 | awk -F '/' '{print $1}')
# Configure static IP
mkdir -p /etc/network
cat > /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet static
    address $IPADDR
    netmask 255.255.255.0
    gateway $2
    dns-nameservers $3
EOF

# echo "nameserver $3" > /etc/resolv.conf
# echo "nameserver 8.8.4.4" >> /etc/resolv.conf
# echo "nameserver 192.168.0.107" > /etc/resolv.conf
if ! grep -q "nameserver $3" /etc/resolv.conf; then
    echo "nameserver $3" >> /etc/resolv.conf
fi
if ! grep -q "nameserver 8.8.8.8" /etc/resolv.conf; then
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
fi

# get win ip
# ipconfig
# ifdown eth0 >/dev/null 2>&1
# ifup eth0 >/dev/null 2>&1

# 4. Enable systemd-networkd configuration network, disable DNS autogeneration
file=/etc/wsl.conf;
cat > $file<<EOF
[network]
generateResolvConf=false
EOF

# [Set up permanent static routes with ip route](https://www.cnblogs.com/panblack/p/centos7_static_routes.html)
# ip route show
# ip route del 192.168.0.0/24
# ip route add 192.168.0.0/24 via 192.168.0.105 dev eth0
# ip route add 192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.1
# ip route add 192.168.0.0/24 via 192.168.0.1 dev eth0

# cat /etc/sysconfig/network-scripts/route-eth0
# echo "192.168.0.0/24 via 192.168.0.1 dev eth0" > /etc/sysconfig/network-scripts/route-eth0

# 5.1 del docker0net
# 172.17.0.0/16 dev docker0 scope link  src 172.17.0.1
# ip route del 172.17.0.0/16
# docker0net=$(ip route | grep docker0 | awk '{print $1}')
# [ $? -eq 0 ]  && ip route del $docker0net

# 5.2 add route
ip route del default >/dev/null 2>&1
ip route del $1 dev eth0 >/dev/null 2>&1

ip route add default via $2
# ip addr add $1 dev eth0
ip route add $(echo $1 | awk -F '.' '{print $1"."$2"."$3".0/24"}') dev eth0 scope link src $IPADDR

# ensure eth0 is up
if ! ip link show eth0 | grep -q "state UP"; then
    ip link set eth0 up || {
        echo "❌ up eth0 failed"
        exit 1
    }
    sleep 2
fi



# 5.3 add route when wsl boot
cat > /etc/profile.d/wsl_network.sh <<EOF
#!/bin/sh
ip route add default via $2
ip route add $(echo $1 | awk -F '.' '{print $1"."$2"."$3".0/24"}') dev eth0 scope link src $IPADDR
if ! ip link show eth0 | grep -q "state UP"; then
    ip link set eth0 up || {
        echo "up eth0 failed"
        exit 1
    }
    sleep 2
fi
EOF
chmod +x /etc/profile.d/wsl_network.sh

# Output summary
echo "Alpine network configuration completed successfully"
echo "IP Address: $1"
echo "Gateway:    $2"
echo "DNS:       $3"

IPADDR=$(echo $1 | awk -F '/' '{print $1}')
# echo $IPADDR


# ping loop address
ping -c 3 127.0.0.1
# ping gateway ip
ping -c 3 $2
# win ip
# ping -c 3 192.168.0.107
# wsl ip
ping -c 3 $IPADDR

ping -c 3 $(echo $1 | awk -F '.' '{print $1"."$2"."$3".107"}') 

ping -c 3 www.baidu.com

echo "
ip route add default via $2
ip route add $(echo $1 | awk -F '.' '{print $1"."$2"."$3".0/24"}') dev eth0 scope link src $IPADDR
ping -c 3 127.0.0.1
ping -c 3 $2
ping -c 3 $IPADDR
ping -c 3 www.baidu.com
"

cleanup_files() {
    echo "=== 清理网络配置文件 ==="
    rm -f /etc/network/interfaces
    rm -f /etc/wsl.conf
    rm -f /etc/profile.d/wsl_network.sh
    echo "清理完成"
}
# cleanup_files