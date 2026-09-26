# Comunicador OctoPrint (PrusaSlicer -> Easythreed K9)

Este projeto contém scripts e uma interface gráfica (Painel) criados para facilitar a inicialização, gerenciamento e atualização do OctoPrint no Windows, focado na integração entre o **PrusaSlicer** e a impressora 3D **Easythreed K9**.

## 📁 Estrutura de Arquivos

Os arquivos estão localizados em `D:\Projetos\ComunicadorOctoPrint` e a instalação do OctoPrint encontra-se em `D:\Impressao3D\OctoPrint`.

- **PainelOctoPrintWPF.ps1**: O coração da interface. Script em PowerShell utilizando WPF (Windows Presentation Foundation) para gerar uma janela nativa, moderna e interativa.
- **PainelOctoPrint.vbs**: Script "lançador" invisível. Ele executa o Painel do PowerShell sem abrir a janela preta do console (Prompt de Comando) de fundo.
- **octoprint.png / octoprint.ico**: Arquivos de imagem do logo oficial do OctoPrint usados na interface e no atalho da Área de Trabalho.
- **IniciarComunicador.ps1** / **AtualizarOctoPrint.ps1**: (Opcionais/Integrados) Scripts com as lógicas separadas caso deseje rodá-las sem a interface gráfica.

## 🚀 Como Usar o Painel

Há um atalho na sua Área de Trabalho chamado **Painel OctoPrint**. 

Ao abrir o painel, o sistema checa o status do serviço do OctoPrint no Windows e adapta os botões automaticamente:
1. **INICIAR SERVICO**: Liga o serviço do OctoPrint no Windows e abre o navegador em `http://localhost:5000`.
2. **REINICIAR SERVICO**: (Aparece apenas quando já está rodando) Útil caso a comunicação USB com a impressora trave e precise de um reset.
3. **ATUALIZAR OCTOPRINT**: Baixa a versão mais recente do `OctoPrint-WindowsInstaller` do GitHub e instala silenciosamente por cima da versão atual.

## 🔌 Configurações de Conexão

### 1. Conectando a Easythreed K9 no OctoPrint
Quando acessar o painel web do OctoPrint (padrão em `http://localhost:5000`), vá na aba **Connection** e configure:
- **Serial Port**: `AUTO` (ou a porta COM correspondente à impressora).
- **Baudrate**: `115200`
- Marque **Save connection settings** para conectar automaticamente nas próximas vezes.

### 2. Configurando o PrusaSlicer
Para enviar o G-Code e mandar imprimir diretamente do fatiador:
1. No PrusaSlicer, vá em **Configurações da Impressora** -> **Configurações Gerais**.
2. Na seção **Servidor de Impressão**:
   - **Tipo de Host**: `OctoPrint`
   - **Hostname, IP ou URL**: `http://localhost:5000`
   - **Chave da API**: No OctoPrint, vá no ícone de Chave Inglesa (Settings) -> **Application Keys** e gere uma chave. Copie e cole ela aqui no PrusaSlicer.
3. Aperte o botão "Testar" para validar a comunicação!

## ⚙️ Manutenção
- Caso haja algum erro ao Iniciar/Reiniciar o serviço ou ao Atualizar, tente **Executar o Painel como Administrador** (clique com o botão direito no atalho -> Executar como Administrador).
- Toda a instalação raiz do OctoPrint e de seu ambiente virtual Python está preservada em `D:\Impressao3D\OctoPrint`.
