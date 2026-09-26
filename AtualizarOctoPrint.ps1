$ErrorActionPreference = "Stop"

Write-Host "Verificando a versão mais recente do OctoPrint Windows Installer..."
$releaseUrl = "https://api.github.com/repos/jneilliii/OctoPrint-WindowsInstaller/releases/latest"

try {
    $release = Invoke-RestMethod -Uri $releaseUrl
    $asset = $release.assets | Where-Object { $_.name -match "OctoPrint\.Setup.*\.exe" } | Select-Object -First 1

    if ($null -eq $asset) {
        Write-Host "Não foi possível encontrar o arquivo de instalação na release mais recente." -ForegroundColor Red
        Exit
    }

    $downloadUrl = $asset.browser_download_url
    $installerPath = "$env:TEMP\" + $asset.name

    Write-Host "Baixando a versão $($release.tag_name) de $downloadUrl ..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    Write-Host "Executando a instalação/atualização..."
    # A atualização manterá a pasta padrão D:\Impressao3D\OctoPrint já usada na instalação inicial
    $process = Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT /DIR=D:\Impressao3D\OctoPrint" -Wait -PassThru

    if ($process.ExitCode -eq 0) {
        Write-Host "Atualização concluída com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "O instalador retornou o código de erro: $($process.ExitCode)" -ForegroundColor Red
    }

    # Limpeza
    Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue

} catch {
    Write-Host "Ocorreu um erro durante a atualização: $_" -ForegroundColor Red
}

Write-Host "Pressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
