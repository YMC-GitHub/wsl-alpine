# get wsl ip in wsl:
wslip=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1;)
echo $wslip;

check_result(){
    local msg_head=$1
    local flag_exit=$2
    if [ $? -eq 0 ]; then
        echo "$msg_head success";
    else
        echo "$msg_head failed";
        [ $flag_exit -eq 0 ] && exit 1;
    fi
}

# ping loop address in wsl:
ping -c 2 127.0.0.1 > /dev/null 2>&1
check_result "ping loop address in wsl" 0;


# ping wsl ip in wsl:
ping -c 2 $wslip  > /dev/null 2>&1;
check_result "ping wsl ip in wsl" 1;

# ping internet in wsl:
ping -c 2 www.baidu.com > /dev/null 2>&1;
check_result "ping internet in wsl" 1;


# check_result "ping internet in wsl"

# use emoji to show result:
# if [ $? -eq 0 ]; then
#     echo "✅";
# else
#     echo "❌";
# fi