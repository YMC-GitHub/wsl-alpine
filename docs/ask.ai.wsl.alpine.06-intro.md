```bash
rc-service docker status
#  * You are attempting to run an openrc service on a
#  * system which openrc did not boot.
#  * You may be inside a chroot or you may have used
#  * another initialization system to boot this system.
#  * In this situation, you will get unpredictable results!
#  * If you really want to do this, issue the following command:
#  * touch /run/openrc/softlevel

# WSL 中使用 OpenRC 服务管理存在问题。以下是修改后的 Docker 安装脚本，改用直接启动 Docker 守护进程的方式：
dockerd &> /var/log/dockerd.log &
```
