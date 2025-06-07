## opv workflow
- ask for ai to code or note (01-ask-ai)
- version control (02-git)
- code on github (03-github)
- ...

## touch files
```powershell
# del unused files
sh -c "rm -rf wsl2/scripts/*todel*"
yours touch docs/ask.ai.wsl.01-intro.md
yours touch docs/ask.ai.wsl.02-intro.md
yours touch docs/ask.ai.wsl.03-intro.md
yours touch docs/ask.ai.wsl.04-intro.md
yours touch docs/ask.ai.wsl.05-intro.md
yours touch docs/ask.ai.wsl.06-intro.md

yours touch docs/ask.ai.wsl.alpine.01-intro.md
yours touch docs/ask.ai.wsl.alpine.02-intro.md
yours touch docs/ask.ai.wsl.alpine.03-intro.md
yours touch docs/ask.ai.wsl.alpine.04-intro.md
yours touch docs/ask.ai.wsl.alpine.05-intro.md 
yours touch docs/ask.ai.wsl.alpine.06-intro.md
yours touch docs/ask.ai.wsl.alpine.07-intro.md
yours touch docs/ask.ai.wsl.alpine.08-intro.md
yours touch docs/ask.ai.wsl.alpine.09-intro.md
yours touch docs/ask.ai.wsl.alpine.10-intro.md
yours touch docs/ask.ai.wsl.alpine.11-intro.md
yours touch docs/ask.ai.wsl.alpine.12-intro.md



yours touch docs/ask.ai.wsl.centos.01-intro.md
yours touch docs/ask.ai.wsl.centos.02-intro.md
yours touch docs/ask.ai.wsl.centos.03-intro.md
yours touch docs/ask.ai.wsl.centos.04-intro.md
yours touch docs/ask.ai.wsl.centos.05-intro.md

yours touch docs/ask.ai.wsl.ubuntu.01-intro.md
yours touch docs/ask.ai.wsl.ubuntu.02-intro.md
yours touch docs/ask.ai.wsl.ubuntu.03-intro.md
yours touch docs/ask.ai.wsl.ubuntu.04-intro.md
yours touch docs/ask.ai.wsl.ubuntu.05-intro.md


yours touch docs/ask.ai.wsl.faqs.01-intro.md
yours touch docs/ask.ai.wsl.faqs.02-intro.md

yours touch docs/opv.this.repo.01-ask-ai.md
yours touch docs/opv.this.repo.02-git.md
yours touch docs/opv.this.repo.03-github.md
yours touch docs/opv.this.repo.04-days.md
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

# move opv.this.repo.md to docs/opv.this.repo.md
# git mv opv.this.repo.md docs/opv.this.repo.md
git mv opvthis.md docs/opv.this.repo.md
git add docs/opv.this*.md ; git commit -m "docs(core): rename and put note"

# 
sh -c "rm opvthis.md"

git add docs/opv.this*.md ; git commit -m "docs(core): rename and put note"
git add docs/opv.this*.md ; git commit -m "docs(core): put repo desc"

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

git add .editorconfig;
git add scripts/*.sh;
git commit -m "build(core): put eof and indent_size"

git add scripts/*.md
git add docs/opv.*.md
git add *.md
git commit -m "docs(core): put note"

```