# Windows 10 Debloat Script
# Remoção de bloatware, desativação de telemetria, otimizações e limpeza de processos desnecessários.
# Execute este script como Administrador no PowerShell.

# Função para checar privilégios de administrador
function Test-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "Este script precisa ser executado como Administrador."
        exit 1
    }
}

# Função para remover aplicativos indesejados (bloatware)
function Remove-Bloatware {
    param (
        [string[]]$bloatApps = @(
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
    )
    foreach ($app in $bloatApps) {
        try {
            Write-Host "Removendo pacote: $app"
            # Remover pacote para usuários existentes
            Get-AppxPackage -AllUsers -Name $app -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
            # Remover pacote provisionado para novas instalações
            Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "$app*" } | ForEach-Object {
                Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
            }
        }
        catch {
            Write-Warning "Falha ao remover $app: $_"
        }
    }
    Write-Host "Aplicativos removidos com sucesso!"
}

# Função para desativar telemetria
function Disable-Telemetry {
    Write-Host "Desativando serviços de telemetria..."
    $telemetryServices = @("DiagTrack", "dmwappushservice")
    foreach ($service in $telemetryServices) {
        try {
            if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Host "Serviço '$service' desativado."
            }
            else {
                Write-Host "Serviço '$service' não encontrado."
            }
        }
        catch {
            Write-Warning "Erro ao desativar o serviço '$service': $_"
        }
    }
    # Ajustes no registro para desativar coleta de dados
    try {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
        Write-Host "Ajustes de registro para telemetria aplicados."
    }
    catch {
        Write-Warning "Erro ao ajustar o registro de telemetria: $_"
    }
    Write-Host "Telemetria desativada!"
}

# Função para otimizar o sistema
function Optimize-System {
    Write-Host "Otimizando o sistema..."
    # Desativar Cortana
    try {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f | Out-Null
        Write-Host "Cortana desativada."
    }
    catch {
        Write-Warning "Erro ao desativar Cortana: $_"
    }
    # Ajustar desempenho visual para priorizar performance
    try {
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f | Out-Null
        Write-Host "Ajuste de efeitos visuais aplicado."
    }
    catch {
        Write-Warning "Erro ao ajustar efeitos visuais: $_"
    }
    # Desativar OneDrive
    try {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f | Out-Null
        Write-Host "OneDrive desativado."
    }
    catch {
        Write-Warning "Erro ao desativar OneDrive: $_"
    }
    Write-Host "Sistema otimizado!"
}

# Função para limpar processos em segundo plano
function Clean-BackgroundProcesses {
    Write-Host "Desativando processos desnecessários..."
    $services = @(
        "WSearch",      # Indexação de pesquisa
        "SysMain",      # Superfetch
        "BITS",         # Transferência inteligente
        "Fax",          # Serviço de fax
        "XblGameSave",  # Salvar jogos Xbox
        "XboxNetApiSvc" # Serviço de rede Xbox
    )
    foreach ($service in $services) {
        try {
            if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Host "Serviço '$service' desativado."
            }
            else {
                Write-Host "Serviço '$service' não encontrado."
            }
        }
        catch {
            Write-Warning "Erro ao desativar o serviço '$service': $_"
        }
    }
    Write-Host "Processos desnecessários desativados!"
}

# Execução principal do script
Test-Admin
Remove-Bloatware
Disable-Telemetry
Optimize-System
Clean-BackgroundProcesses

Write-Host "Debloat do Windows 10 concluído! Reinicie o computador para aplicar todas as mudanças."
