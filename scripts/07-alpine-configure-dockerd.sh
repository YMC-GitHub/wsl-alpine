#!/bin/sh

# 创建docker配置目录
# mkdir -p /etc/docker

# 配置daemon.json（镜像加速、数据根目录等）
# cat > /etc/docker/daemon.json <<EOF
# {
#   "hosts": ["fd://", "tcp://0.0.0.0:2375"],
#   "registry-mirrors": [
#     "https://registry.cn-hangzhou.aliyuncs.com",
#     "https://docker.mirrors.ustc.edu.cn"
#   ],
#   "data-root": "/var/lib/docker",
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "10m",
#     "max-file": "3"
#   }
# }
# EOF

# # 创建systemd服务配置文件（Alpine使用OpenRC）
# cat > /etc/init.d/docker <<EOF
# #!/sbin/openrc-run

# name="Docker daemon"
# description="Docker Application Container Engine"

# command="/usr/bin/dockerd"
# command_args="--config-file=/etc/docker/daemon.json"
# pidfile="/var/run/docker.pid"

# depend() {
#     need localmount
#     after networking
# }
# EOF

# # 设置权限并启用服务
# chmod +x /etc/init.d/docker
# rc-update add docker boot
# rc-service docker restart

# 1. create docker daemon config file
mkdir -p /etc/docker
# cat > /etc/docker/daemon.yaml <<EOF
# registry-mirrors:
#   - "https://registry.cn-hangzhou.aliyuncs.com"
#   - "https://hub-mirror.c.163.com"
#   - "https://mirror.ccs.tencentyun.com"
#   - "https://docker.mirrors.tuna.tsinghua.edu.cn"
# EOF

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


# 2. use dockerd to start docker daemon (cmd)
# echo "dockerd --config-file=/etc/docker/daemon.json --pidfile /var/run/docker.pid &> /var/log/dockerd.log &" >> ~/.profile
DOCKERD_CMD="dockerd --host=fd:// --host=tcp://0.0.0.0:2375 --config-file=/etc/docker/daemon.yaml --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

# dockerd cmd with logfile + Unix socket + local tcp socket + registry-mirrors in daemon.json
DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --config-file=/etc/docker/daemon.json &> /var/log/dockerd.log &"

# dockerd cmd with logfile + Unix socket + local tcp socket
# DOCKERD_CMD="dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 &> /var/log/dockerd.log &"

# dockerd cmd with pidfile and logfile
# DOCKERD_CMD="dockerd --pidfile /var/run/docker.pid &> /var/log/dockerd.log &"

# 3. stop docker daemon
if [ -f /var/run/docker.pid ]; then
    kill $(cat /var/run/docker.pid) 2>/dev/null
    rm -f /var/run/docker.pid
fi
pkill -9 dockerd 2>/dev/null

# 4. run dockerd cmd
sh -c "$DOCKERD_CMD"
sleep 3 

# 5. check docker daemon status
if docker info >/dev/null 2>&1; then
    echo "✅ Docker Start success (PID: $(pgrep dockerd))"
else
    echo "❌ Docker Start fail (Please check /var/log/dockerd.log)"
    cat /var/log/dockerd.log
    exit 1
fi

# 6. use dockerd to start docker daemon (auto start when system boot up)
if grep -q "dockerd.*" ~/.profile; then
    sed -i "/dockerd.*/c\\$DOCKERD_CMD" ~/.profile
else
    echo "$DOCKERD_CMD" >> ~/.profile
fi

# 7. get registry-mirrors
docker info | grep -iA5 "registry mirrors"
