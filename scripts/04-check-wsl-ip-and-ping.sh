# get wsl ip in wsl:
wslip=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1;)
echo $wslip;

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
    ping -c $count $wslip  > /dev/null 2>&1;
    check_result "ping wsl ip in wsl" 1;

    # ping internet in wsl:
    ping -c $count www.baidu.com > /dev/null 2>&1;
    check_result "ping internet in wsl" 1;
}

ping_network 3
