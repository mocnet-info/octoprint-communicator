Add-Type -AssemblyName PresentationFramework

[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="OctoPrint Communicator" Height="460" Width="400"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize"
        Background="#F9F9F9" FontFamily="Segoe UI"
        Icon="d:\Projetos\ComunicadorOctoPrint\octoprint.ico">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#FFFFFF" />
            <Setter Property="Foreground" Value="#333333" />
            <Setter Property="FontSize" Value="14" />
            <Setter Property="Margin" Value="0,8,0,8" />
            <Setter Property="BorderBrush" Value="#D1D1D1" />
            <Setter Property="BorderThickness" Value="1" />
            <Setter Property="Cursor" Value="Hand" />
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="8">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#F0F8FF" />
                                <Setter Property="BorderBrush" Value="#0078D7" />
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="Background" Value="#CCE4F7" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    
    <Border Padding="20">
        <StackPanel>
            <Image Source="d:\Projetos\ComunicadorOctoPrint\octoprint.png" Width="80" Height="80" Margin="0,0,0,10" />
            
            <TextBlock Text="Menu do OctoPrint" FontSize="20" FontWeight="SemiBold" Foreground="#111111" HorizontalAlignment="Center" Margin="0,0,0,5" />
            
            <!-- Linha de Status do Servico -->
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,0,0,15">
                <TextBlock Text="Status do Servico: " FontSize="13" Foreground="#666666"/>
                <TextBlock Name="txtServiceStatus" Text="Verificando..." FontSize="13" FontWeight="Bold" Foreground="#666666"/>
            </StackPanel>
            
            <Button Name="btnStart" Height="45">
                <TextBlock Text="ABRIR / INICIAR COMUNICADOR" FontWeight="SemiBold" Foreground="#0078D7"/>
            </Button>
            
            <Button Name="btnRestart" Height="45">
                <TextBlock Name="txtBtnRestart" Text="REINICIAR SERVICO" FontWeight="SemiBold" Foreground="#D83B01"/>
            </Button>
            
            <Button Name="btnUpdate" Height="45">
                <TextBlock Text="ATUALIZAR OCTOPRINT" FontWeight="SemiBold" Foreground="#107C10"/>
            </Button>

            <TextBlock Name="txtStatus" Text="Pronto." Margin="0,15,0,0" Foreground="#555555" TextWrapping="Wrap" HorizontalAlignment="Center" TextAlignment="Center"/>
        </StackPanel>
    </Border>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$btnStart = $window.FindName("btnStart")
$btnRestart = $window.FindName("btnRestart")
$btnUpdate = $window.FindName("btnUpdate")
$txtStatus = $window.FindName("txtStatus")
$txtServiceStatus = $window.FindName("txtServiceStatus")
$txtBtnRestart = $window.FindName("txtBtnRestart")

# Rotina de checagem automatica de status
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)

$UpdateUI = {
    $proc = Get-Process -Name "octoprint" -ErrorAction SilentlyContinue
    if ($proc) {
        $txtServiceStatus.Text = "RODANDO"
        $txtServiceStatus.Foreground = "#107C10"
        $txtBtnRestart.Text = "DESLIGAR OCTOPRINT"
        $txtBtnRestart.Foreground = "#D83B01"
    } else {
        $txtServiceStatus.Text = "PARADO"
        $txtServiceStatus.Foreground = "#D83B01"
        $txtBtnRestart.Text = "LIGAR OCTOPRINT"
        $txtBtnRestart.Foreground = "#107C10"
    }
}

$timer.Add_Tick($UpdateUI)
$timer.Start()
# Checa imediatamente a primeira vez
$timer.Dispatcher.Invoke([Action]$UpdateUI)

$btnStart.Add_Click({
    $txtStatus.Text = "Verificando servico do OctoPrint..."
    $btnStart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
    
    $proc = Get-Process -Name "octoprint" -ErrorAction SilentlyContinue

    if (-not $proc) {
        $octoprintExe = "D:\Impressao3D\OctoPrint\venv\Scripts\octoprint.exe"
        if (Test-Path $octoprintExe) {
            $txtStatus.Text = "Iniciando processo em segundo plano..."
            $btnStart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
            Start-Process -FilePath $octoprintExe -ArgumentList "serve" -WindowStyle Hidden
        } else {
            $txtStatus.Text = "Instalacao nao finalizada ou arquivo nao encontrado."
            return
        }
    }

    $txtStatus.Text = "DICA K9: Serial Port (AUTO) | Baudrate (115200)`nAbrindo navegador..."
    $btnStart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:5000"
})

$btnRestart.Add_Click({
    $proc = Get-Process -Name "octoprint" -ErrorAction SilentlyContinue
    
    if ($proc) {
        $txtStatus.Text = "Desligando o servidor... Por favor, aguarde."
        $btnRestart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
        Stop-Process -Name "octoprint" -Force -ErrorAction SilentlyContinue
        $txtStatus.Text = "OctoPrint desligado com sucesso!"
    } else {
        $txtStatus.Text = "Iniciando o servidor... Por favor, aguarde."
        $btnRestart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
        $octoprintExe = "D:\Impressao3D\OctoPrint\venv\Scripts\octoprint.exe"
        if (Test-Path $octoprintExe) {
            Start-Process -FilePath $octoprintExe -ArgumentList "serve" -WindowStyle Hidden
            $txtStatus.Text = "OctoPrint iniciado com sucesso!"
        } else {
            $txtStatus.Text = "Arquivo nao encontrado."
        }
    }
})

$btnUpdate.Add_Click({
    $txtStatus.Text = "Buscando versao no GitHub..."
    $btnStart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
    
    try {
        $releaseUrl = "https://api.github.com/repos/jneilliii/OctoPrint-WindowsInstaller/releases/latest"
        $release = Invoke-RestMethod -Uri $releaseUrl
        $asset = $release.assets | Where-Object { $_.name -match "OctoPrint\.Setup.*\.exe" } | Select-Object -First 1

        if ($null -eq $asset) {
            $txtStatus.Text = "Erro: Instalador nao encontrado no Github."
            return
        }

        $txtStatus.Text = "Baixando atualizacao... Por favor, aguarde (Isso pode demorar dependendo da internet)."
        $btnStart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)

        $downloadUrl = $asset.browser_download_url
        $installerPath = "$env:TEMP\" + $asset.name
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

        $txtStatus.Text = "Atualizando... Por favor aguarde."
        $btnStart.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
        
        $process = Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT /DIR=D:\Impressao3D\OctoPrint" -Wait -PassThru

        if ($process.ExitCode -eq 0) {
            $txtStatus.Text = "Pronto! Atualizacao concluida com sucesso."
        } else {
            $txtStatus.Text = "Erro durante a atualizacao. Tente rodar o Painel como Administrador."
        }
        Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue
    } catch {
        $txtStatus.Text = "Ocorreu um erro ao buscar atualizacao. Verifique a internet."
    }
})

$window.ShowDialog() | Out-Null
