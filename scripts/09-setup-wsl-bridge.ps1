<#
.SYNOPSIS
create external virtual switch and configure.wslconfig to use bridge network

.DESCRIPTION
1. create external virtual switch
2. configure .wslconfig to use bridge network
3. notify restart wsl
#>

# Requires -RunAsAdministrator

# set default netAdapterName and switchName
param(
    [string]$netAdapterName = $(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1 -ExpandProperty Name),
    [string]$switchName = "WSLBridgeSwitch",
    [int]$Action
)

function Create_VirtualSwitch {
    param (
        [string]$SwitchName,
        [string]$NetAdapterName
    )

    Info-Step -msg "create external virtual switch"
    if (-not (Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue)) {
        New-VMSwitch -Name $SwitchName -NetAdapterName $NetAdapterName -AllowManagementOS $true
    }else{
        Write-Host "Virtual switch already exists: $SwitchName, no need to create"
    }
    Info_Status -msg_body "create external virtual switch" -status 0
}

function Configure_WSLConfig {
    param (
        [string]$SwitchName
    )
    Info-Step -msg "configure .wslconfig to use bridge network"
    $wslConfigPath = "$env:USERPROFILE\.wslconfig"
    @"
[wsl2]
networkingMode=bridged
vmSwitch=$SwitchName
dhcp=false
"@ | Out-File -FilePath $wslConfigPath -Encoding UTF8
    Info_Status -msg_body "configure .wslconfig to use bridge network" -status 0
}

function Notify_WSLRestart {
    param (
        [string]$SwitchName
    )
    Info-Step -msg "notify restart wsl"
    Write-Host "WSL bridge network configured successfully, using switch: $SwitchName"
    Write-Host "Please restart WSL with command: wsl --shutdown;wsl;"
    Info_Status -msg_body "notify restart wsl" -status 0
}

function Msg-Padd {
    param (
        [string]$msg,
        [int]$msgMaxLen
    )
    $msgLen = $msg.Length
    $msgFillLength = [math]::Floor(($msgMaxLen - $msgLen + 2) / 2)
    $msgPadding = '-' * $msgFillLength
    $result = "$msgPadding-$msg-$msgPadding"
    return $result.Substring(0, [math]::Min($result.Length, $msgMaxLen))
}

function Info-Step {
    param (
        [string]$msg
    )
    Write-Output (Msg-Padd -msg $msg -msgMaxLen 60)
}

function Info_Status {
    param (
        [string]$msg_body,
        [int]$status
    )

    $msg_success = [char]0x2705
    $msg_failed = [char]0x274C
    $msg_warn = [char]0x2139

    if ($status -eq 0) {
        Write-Host "$msg_success $msg_body"
    }
    elseif ($status -eq 1) {
        Write-Host "$msg_failed $msg_body"
    }
    else {
        Write-Host "$msg_warn $msg_body"
    }
}

if ($Action) {
    switch ($Action) {
        1 {
            Create_VirtualSwitch -SwitchName $switchName -NetAdapterName $netAdapterName
        }
        2 {
            Configure_WSLConfig -SwitchName $switchName
        }
        3 {
            Notify_WSLRestart -SwitchName $switchName
        }
        default {
            Write-Host "Invalid action number. Please use 1, 2, or 3." -ForegroundColor Red
        }
    }
} else {
    # 1. create external virtual switch
    
    Create_VirtualSwitch -SwitchName $switchName -NetAdapterName $netAdapterName

    # 2. configure .wslconfig to use bridge network
    Configure_WSLConfig -SwitchName $switchName

    # 3. notify restart wsl
    Notify_WSLRestart -SwitchName $switchName
}