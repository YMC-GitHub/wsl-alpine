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

```powershell
# del unused files
sh -c "rm -rf wsl2/scripts/*todel*"
yours touch wsl2/ask.ai.wsl.01-intro.md
yours touch wsl2/ask.ai.wsl.02-intro.md
yours touch wsl2/ask.ai.wsl.03-intro.md
yours touch wsl2/ask.ai.wsl.04-intro.md
yours touch wsl2/ask.ai.wsl.05-intro.md
yours touch wsl2/ask.ai.wsl.06-intro.md

yours touch wsl2/ask.ai.wsl.alpine.01-intro.md
yours touch wsl2/ask.ai.wsl.alpine.02-intro.md
yours touch wsl2/ask.ai.wsl.alpine.03-intro.md
yours touch wsl2/ask.ai.wsl.alpine.04-intro.md
yours touch wsl2/ask.ai.wsl.alpine.05-intro.md 
yours touch wsl2/ask.ai.wsl.alpine.06-intro.md
yours touch wsl2/ask.ai.wsl.alpine.07-intro.md
yours touch wsl2/ask.ai.wsl.alpine.08-intro.md
yours touch wsl2/ask.ai.wsl.alpine.09-intro.md
yours touch wsl2/ask.ai.wsl.alpine.10-intro.md
yours touch wsl2/ask.ai.wsl.alpine.11-intro.md
yours touch wsl2/ask.ai.wsl.alpine.12-intro.md



yours touch wsl2/ask.ai.wsl.centos.01-intro.md
yours touch wsl2/ask.ai.wsl.centos.02-intro.md
yours touch wsl2/ask.ai.wsl.centos.03-intro.md
yours touch wsl2/ask.ai.wsl.centos.04-intro.md
yours touch wsl2/ask.ai.wsl.centos.05-intro.md

yours touch wsl2/ask.ai.wsl.ubuntu.01-intro.md
yours touch wsl2/ask.ai.wsl.ubuntu.02-intro.md
yours touch wsl2/ask.ai.wsl.ubuntu.03-intro.md
yours touch wsl2/ask.ai.wsl.ubuntu.04-intro.md
yours touch wsl2/ask.ai.wsl.ubuntu.05-intro.md


yours touch wsl2/ask.ai.wsl.faqs.01-intro.md
yours touch wsl2/ask.ai.wsl.faqs.02-intro.md
```

- 在window上，使用wsl2,安装alpine


```powershell
# WslRegisterDistribution failed with error: 0x800701bc
# Error: 0x800701bc WSL 2
netsh winsock reset
```


### daily operation and maintenance

```powershell
# ini/add/put/del - name
$name="wsl2";$desc="docs(core): put $name note";
git add $name/* ; git commit -m "$desc"

$name="wsl2";$desc="docs(core): add $name note";
git add $name/* ; git commit -m "$desc"

$name="wsl2";$desc="docs(core): ini $name note";
git add $name/* ; git commit -m "$desc"

$name="wsl2";$desc="docs(core): del $name note";
git add $name/* ; git commit -m "$desc"

# ini/add/put/del - name-topic
$thistpoickey="private-registry";$thisfilekey="*${thistpoickey}*";
$name="wsl2";$desc="docs(core): add $thistpoickey note";
git add "$name/${thisfilekey}" ; git commit -m "$desc"

git log --oneline;

$name="wsl2"
git add $name/* ; git commit -m "docs(core): init $name note"

git log --oneline;

$name="wsl2";
git add $name/* ; git commit -m "docs($name): use native docker in ubuntu"

$name="wsl2";
git add $name/* ; git commit -m "docs($name): set remote api to enable  with 3 ways"

$name="wsl2";

```

## opv - docs files
```bash 
sh -c "mkdir -p $name/docs"
sh -c "cp $name/ask.ai* $name/docs"
sh -c "rm $name/ask.ai*.md"
git add $name/docs/*.md;git commit -m "docs($name): add note"


# git mv wsl2/*docker*.md git mv wsl2/docs 
sh -c "cp $name/*docker*.md $name/docs"
sh -c "rm $name/*docker*.md"

sh -c "cp $name/*podman*.md $name/docs"
sh -c "rm $name/*podman*.md"

git add $name/opvthis.md ; git commit -m "docs($name): add note for opv.this.repo"
git add $name/README.md ; git commit -m "docs($name): put usage"

```

## opv - scripts files
```bash 
git add $name/scripts/*enable-wsl*;git commit -m "scripts($name): enable wsl feature"
git add $name/scripts/*set-wsl-version*;git commit -m "scripts($name): set wsl version as 2"
git add $name/scripts/*download-unpack*;git commit -m "scripts($name): download distro from github and install it"
git add $name/scripts/*set-wsl-nat*;git commit -m "scripts($name): use nat network"

git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): get wsl ip and ping network"
git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): use check_result func"
git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): use emoji to show result"
git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): use ping_network func"
git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): use get_wsl_ip func"
git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): use ip_route_show func"
git add $name/scripts/*check-wsl-ip-and-ping*;git commit -m "scripts($name): fix check_result func"

git add $name/scripts/*set-apk-repo*;git commit -m "scripts($name): use china source to set apk repo"

git add $name/scripts/*set-timezone*;git commit -m "scripts($name): use shanghai timezone"

git add $name/scripts/*alpine-install-docker*;git commit -m "scripts($name): alpine install docker"

git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): alpine configure dockerd"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): del unused code"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): use funcs to configure dockerd"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): use msg_padd func"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): put registries mirror and insecure registries"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): use /etc/init.d/dockerd and openrc"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): use status + body as msg order"
git add $name/scripts/*alpine-configure-dockerd*;git commit -m "scripts($name): use info_status func"

git add $name/scripts/*alpine-stop-dockerd*;git commit -m "scripts($name): use info_status func"

git add $name/scripts/*setup-wsl-bridge*;git commit -m "scripts($name): use bridge network"
git add $name/scripts/*setup-wsl-bridge*;git commit -m "scripts($name): add Remove_VirtualSwitch func"

git add $name/scripts/*alpine_configure_bridged*;git commit -m "scripts($name): init alpine configure bridged network"
git add $name/scripts/*alpine_configure_bridged*;git commit -m "scripts($name): use static ip and eth0_up on boot"
git add $name/scripts/*README*;git commit -m "docs($name): add note for scripts"

sh -c "rm $name/*.ps1"
sh -c "rm $name/*.sh
```

## git - move files
```bash
# move opv.this.repo.md to docs/opv.this.repo.md
# git mv opv.this.repo.md docs/opv.this.repo.md
git mv opvthis.md docs/opv.this.repo.md
```