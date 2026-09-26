$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Inicializador do Comunicador PrusaSlicer -> Easythreed K9" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Tenta encontrar o serviço do OctoPrint
$serviceName = "OctoPrint"
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($service) {
    if ($service.Status -ne "Running") {
        Write-Host "Iniciando o serviço do OctoPrint..." -ForegroundColor Yellow
        Start-Service -Name $serviceName
        Write-Host "Serviço iniciado." -ForegroundColor Green
    } else {
        Write-Host "Serviço do OctoPrint já está em execução." -ForegroundColor Green
    }
} else {
    Write-Host "Aviso: O serviço do Windows 'OctoPrint' não foi encontrado." -ForegroundColor Yellow
    Write-Host "Tentando executar o OctoPrint manualmente..." -ForegroundColor Yellow
    $octoprintExe = "D:\Impressao3D\OctoPrint\venv\Scripts\octoprint.exe"
    if (Test-Path $octoprintExe) {
        Start-Process -FilePath $octoprintExe -ArgumentList "serve" -WindowStyle Minimized
        Write-Host "OctoPrint iniciado em segundo plano." -ForegroundColor Green
    } else {
        Write-Host "Executável não encontrado em $octoprintExe. O OctoPrint foi instalado corretamente?" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Abrindo a interface web do OctoPrint..." -ForegroundColor Cyan
Start-Sleep -Seconds 3
Start-Process "http://localhost:5000"

Write-Host ""
Write-Host "=== INSTRUÇÕES PARA A EASYTHREED K9 ===" -ForegroundColor Yellow
Write-Host "1. Na interface do OctoPrint, na seção 'Connection':"
Write-Host "   - Serial Port: AUTO (ou selecione a porta COM correspondente à impressora)"
Write-Host "   - Baudrate: 115200"
Write-Host "2. Clique em 'Connect' e marque 'Save connection settings' se desejar."
Write-Host ""
Write-Host "=== INSTRUÇÕES PARA O PRUSASLICER ===" -ForegroundColor Yellow
Write-Host "1. No PrusaSlicer, vá em Configurações da Impressora -> Configurações Gerais."
Write-Host "2. Na seção 'Servidor de Impressão':"
Write-Host "   - Tipo de Host: OctoPrint"
Write-Host "   - Hostname, IP ou URL: http://localhost:5000"
Write-Host "   - Chave da API: (Pegue essa chave no OctoPrint em Settings -> Application Keys)"
Write-Host "3. Agora você pode enviar G-codes e imprimir diretamente do PrusaSlicer!"
Write-Host ""

Write-Host "Pressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
