$wslConfigPath = "$env:USERPROFILE\\.wslconfig"
if (-not (Test-Path $wslConfigPath)) {
    New-Item -ItemType File -Path $wslConfigPath -Force
}
$configContent = @"
[wsl2]
networkingMode=nat
vmSwitch=Default Switch
"@
$configContent | Out-File -FilePath $wslConfigPath -Encoding UTF8 -Force

# wsl --shutdown;wsl;