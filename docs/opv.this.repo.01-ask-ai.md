- 解释代码，推荐一个更具有语义化的名字，包含centos
- wsl: 检测到 localhost 代理配置，但未镜像到 WSL。NAT 模式下的 WSL 不支持 localhost 代理。 解释并修复

- centos7_switch_to_aliyun_yum_repo.sh
- 搭建环境。win -> wsl (alpine) 使用桥接网络，wsl使用静态地址192.168.0.106。win的ip为192.168.0.107。
- 更改名字，使其更具有语义化。包含setup，wsl，bridge等关键词
- 是否应提取为bash脚本。
- 如何在win中让wsl(alpine)执行这个脚本。
- 提取为powershell脚本，并存放在wsl2/scripts目录下，命名为00-xx.ps1，其中xx为语义化的脚本名称。
- 提取为powershell脚本，并存放在wsl2/scripts目录下，命名为01-xx.ps1，其中xx为语义化的脚本名称。
- 提取为powershell脚本，并存放在wsl2/scripts目录下，命名为02-xx.ps1，其中xx为语义化的脚本名称。输入参数3时，下载，输入4时解压，输入5时删除，输入6时安装。接受url作为参数。接受workspace作为参数
- 在scripts/README.md中添加相应脚本的介绍和使用示例
- 在scripts中添加powershell脚本，命名为03-xx.ps1，其中xx为语义化的脚本名称。让wsl使用nat网络。包含设置window中的.wslconfig文件
- 在scripts中添加bash脚本，命名为04-xx.sh，其中xx为语义化的脚本名称。

- 在scripts中添加bash脚本，让 alpine 系统使用上海时区，命名为05-alpine-xx.sh，其中xx为语义化的脚本名称。
- 代码解释，解释硬件时钟，系统时间，chrony时间，阿里云NTP服务器
- 在scripts中添加bash脚本，让 alpine 系统使用国内apk repo源，命名为05-alpine-xx.sh，其中xx为语义化的脚本名称。支持接收源名称。输入aliyun时使用阿里云源，qinghua时使用清华源，alpine时使用官方源。支持国内所有源，其他国内源名字请自行提供。

- 在scripts中添加bash脚本，让 alpine 系统安装docker，命名为06-alpine-xx.sh，其中xx为语义化的脚本名称。
- 在scripts中添加bash脚本，让 alpine 系统设置dockerd，命名为07-alpine-xx.sh，其中xx为语义化的脚本名称。让dockerd使用国内镜像源。
- 在scripts中添加bash脚本，在alpine中配置dockerd。
- alpine中配置dockerd。包含其配置文件，host设置，-fd -host等介绍。使用yaml格式。

- Alpine 默认使用 OpenRC 而不是 systemd ?
- 在scripts中添加powershell脚本，命名为09-xx.ps1，其中xx为语义化的脚本名称。让wsl使用桥接网络。包含设置window中的.wslconfig文件，创建external switch。
- 否应替换为/etc/init.d，因为当前只有进入wsl就会执行（没必要）需要的是：只有当wsl关机后启动时才执行。alpine中使用/etc/init.是否可行。
- wsl(alpine)中是否支持rc-update 管理服务