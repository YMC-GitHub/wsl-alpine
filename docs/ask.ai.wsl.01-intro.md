## enable wsl2 in window

- Enable the Windows Subsystem for Linux (WSL) and Virtual Machine Platform (VMP) features, which are essential prerequisites for running WSL 2.（启用 Windows 子系统 for Linux (WSL) 和虚拟机平台 (VMP) 功能，这是运行 WSL 2 的必要先决条件。）
- Restart the machine to apply the changes made by enabling the features. This step is crucial to ensure that the new settings take effect.（重启计算机以应用启用功能所做的更改。此步骤对于确保新设置生效至关重要。）
- Set the default WSL version to 2, which offers improved performance and compatibility compared to WSL 1.（将默认 WSL 版本设置为 2，与 WSL 1 相比，它提供了更好的性能和兼容性。）
- List all available Linux distribution versions to choose the one that suits your needs.（列出所有可用的 Linux 发行版版本，以便选择适合您需求的版本。）

```powershell
# need admin right
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Restart-Computer -Force
# ...

wsl --set-default-version 2
wsl --list --all
```

[enable wsl2 in window](https://cn.linux-console.net/?p=21057)

```powershell
.\wsl2\scripts\00-enable-wsl-vmp.ps1

.\wsl2\scripts\01-set-wsl-version-and-list.ps1
```