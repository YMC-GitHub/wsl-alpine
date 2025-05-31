## custom installing location of wsl machine  

```powershell
# wsl --help

# prepare vars
$TODYFOMAT=sh -c 'date +"%Y%m%d';$WSL_DISTRO="ubuntu-22.04";
"$TODYFOMAT";"$WSL_DISTRO";

# $WSL_DISTRO="ubuntu-20.04";$TODYFOMAT="20240704"
# $WSL_DISTRO="ubuntu-20.04";$TODYFOMAT="20240704"

# install from ms store ? do
wsl --install -d "$WSL_DISTRO";

# exit

wsl -d "${WSL_DISTRO}" --shutdown
wsl -l -v
# mkdir -p "I:/10_wsl2/mirror/${WSL_DISTRO}/${TODYFOMAT}-proxy"
wsl --export "${WSL_DISTRO}" I:/10_wsl2/mirror/${WSL_DISTRO}/${TODYFOMAT}-proxy/rootfs.tar
wsl --unregister "${WSL_DISTRO}"
wsl --import "${WSL_DISTRO}" I:/10_wsl2/machine/${WSL_DISTRO}-${TODYFOMAT} I:/10_wsl2/mirror/"${WSL_DISTRO}"/${TODYFOMAT}-proxy/rootfs.tar --version 2
```