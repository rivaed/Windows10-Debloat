# Executar como Administrador

# Função para remover aplicativos indesejados (bloatware)
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
        Get-AppxPackage -Name $app | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "$app*" | Remove-AppxProvisionedPackage -Online -NoRestart
    }
    Write-Output "Aplicativos removidos com sucesso!"
}

# Função para desativar telemetria
function Disable-Telemetry {
    Write-Output "Desativando serviços de telemetria..."
    $telemetryServices = @(
        "DiagTrack",  # Serviço de rastreamento de diagnóstico
        "dmwappushservice"  # Serviço de telemetria
    )

    foreach ($service in $telemetryServices) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled
    }

    # Ajustes no registro para desativar coleta de dados
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

    Write-Output "Telemetria desativada!"
}

# Função para otimizar o sistema
function Optimize-System {
    Write-Output "Otimizando o sistema..."
    
    # Desativar Cortana
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

    # Ajustar desempenho visual para priorizar performance
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

    # Desativar OneDrive
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f

    Write-Output "Sistema otimizado!"
}

# Função para limpar processos em segundo plano
function Clean-BackgroundProcesses {
    Write-Output "Desativando processos desnecessários..."

    $services = @(
        "WSearch",   # Desativa indexação de pesquisa
        "SysMain",   # Desativa Superfetch
        "BITS",      # Serviço de transferência inteligente em segundo plano
        "Fax",       # Serviço de fax inútil
        "XblGameSave", # Serviço de jogo Xbox
        "XboxNetApiSvc" # Serviço de rede Xbox
    )

    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled
    }

    Write-Output "Processos desnecessários desativados!"
}

# Executar todas as funções
Remove-Bloatware
Disable-Telemetry
Optimize-System
Clean-BackgroundProcesses

Write-Output "Debloat do Windows 10 concluído! Reinicie o computador para aplicar todas as mudanças."
