# Accept input parameters
param (
    [int]$Action,
    [string]$url = "https://ghfast.top/https://github.com/mishamosher/CentOS-WSL/releases/download/9-stream-20230626/CentOS9-stream.zip",
    [string]$workspace = "I:/10_wsl2",
    [string]$WSL_DISTRO,
    [string]$TODYFOMAT = (Get-Date).ToString("yyyyMMdd")
)

# Extract filename from URL if WSL_DISTRO not provided
$name=$url.split("/")[-1]
if (-not $WSL_DISTRO) {
    $WSL_DISTRO=$url.split("/")[-1].split(".")[0]
    $WSL_DISTRO=$WSL_DISTRO.split("-")[0]
}

# Display configuration summary
$output = [PSCustomObject] @{
    Name = $name
    WSL_DISTRO = $WSL_DISTRO
    TODYFOMAT = $TODYFOMAT
}
$output | Format-Table -AutoSize

# Execute action based on input parameter
switch ($Action) {
    3 {
        # Download operation
        cmd.exe /c idman /n /d $url /p "$workspace/mirror"
    }
    4 {
        # Extract operation
        7z x "$workspace/mirror/$name" -o"$workspace/mirror/$WSL_DISTRO"
    }
    5 {
        # Delete operation
        Remove-Item -Path "$workspace/mirror/$WSL_DISTRO" -Recurse -Force
    }
    6 {
        # Install operation
        wsl --import "$WSL_DISTRO" "$workspace/machine/$WSL_DISTRO-$TODYFOMAT" "$workspace/mirror/$WSL_DISTRO/rootfs.tar.gz" --version 2
    }
    7 {
        # Set default distro
        wsl --setdefault "$WSL_DISTRO"
    }
    8 {
        # Unregister distro
        wsl --unregister "$WSL_DISTRO"
    }
    default {
        Write-Host "Invalid parameter, please enter 3 (download), 4 (extract), 5 (delete), or 6 (install)."
    }
}
