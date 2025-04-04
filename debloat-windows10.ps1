# Debloat Windows 10
# Autor: rivaed

function Remove-Bloatware {
    $bloatApps = @(
        "Microsoft.3DBuilder",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Messaging",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MixedReality.Portal",
        "Microsoft.NetworkSpeedTest",
        "Microsoft.News",
        "Microsoft.Office.Lens",
        "Microsoft.Office.OneNote",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.SkypeApp",
        "Microsoft.StorePurchaseApp",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCamera",
        "microsoft.windowscommunicationsapps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )

    foreach ($app in $bloatApps) {
        try {
            Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction Stop
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "$app*" | Remove-AppxProvisionedPackage -Online -NoRestart
        } catch {
            Write-Warning "Falha ao remover $app: ${_}"
        }
    }
    Write-Output "Aplicativos removidos com sucesso!"
}

function Disable-Telemetry {
    Write-Output "Desativando serviços de telemetria..."
    $telemetryServices = @("DiagTrack", "dmwappushservice")

    foreach ($service in $telemetryServices) {
        try {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled
        } catch {
            Write-Warning "Erro ao desativar o serviço $service: ${_}"
        }
    }

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

    Write-Output "Telemetria desativada!"
}

function Optimize-System {
    Write-Output "Otimizando o sistema..."

    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f

    Write-Output "Sistema otimizado!"
}

function Clean-BackgroundProcesses {
    Write-Output "Desativando processos desnecessários..."

    $services = @("WSearch", "SysMain", "BITS", "Fax", "XblGameSave", "XboxNetApiSvc")

    foreach ($service in $services) {
        try {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled
        } catch {
            Write-Warning "Erro ao processar serviço $service: ${_}"
        }
    }

    Write-Output "Processos desnecessários desativados!"
}

Remove-Bloatware
Disable-Telemetry
Optimize-System
Clean-BackgroundProcesses

Write-Output "Debloat do Windows 10 concluído! Reinicie o computador para aplicar todas as mudanças."
