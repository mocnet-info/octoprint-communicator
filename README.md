# Comunicador OctoPrint (PrusaSlicer -> Easythreed K9)

Este projeto contém scripts e uma interface gráfica (Painel) criados para facilitar a inicialização, gerenciamento e atualização do OctoPrint no Windows, focado na integração entre o **PrusaSlicer** e a impressora 3D **Easythreed K9**.

## 📁 Estrutura de Arquivos

- **PainelOctoPrintWPF.ps1**: O coração da interface. Script em PowerShell utilizando WPF (Windows Presentation Foundation) para gerar uma janela nativa, moderna e interativa.
- **PainelOctoPrint.exe**: O arquivo executável principal. Compilado a partir do script para exibir o ícone nativamente na barra de tarefas e rodar a interface graficamente.
- **octoprint.png / octoprint.ico**: Arquivos de imagem do logo oficial do OctoPrint usados na interface e no atalho.
- **IniciarComunicador.ps1** / **AtualizarOctoPrint.ps1**: (Opcionais/Integrados) Scripts com as lógicas separadas caso deseje rodá-las sem a interface gráfica.

*Nota: O painel gerencia diretamente o processo do OctoPrint (`octoprint.exe`) rodando em segundo plano no Windows, sem depender do gerenciador de serviços do sistema.*

## 🚀 Como Usar o Painel

Ao abrir o programa `PainelOctoPrint.exe` (ou seu atalho respectivo), o sistema checa se o processo do OctoPrint está rodando e adapta os botões automaticamente:
1. **ABRIR / INICIAR COMUNICADOR**: Inicia o servidor do OctoPrint de forma invisível e abre o navegador em `http://localhost:5000`.
2. **LIGAR / DESLIGAR OCTOPRINT**: Controla diretamente o processo. Útil caso a comunicação USB com a impressora trave e precise de um reset.
3. **ATUALIZAR OCTOPRINT**: Baixa a versão mais recente do instalador do GitHub e atualiza silenciosamente.

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
- O Painel não necessita de permissões de Administrador para ligar ou desligar o OctoPrint, já que ele controla um processo de nível de usuário. Apenas a função de **Atualizar** pode requerer permissões adicionais.
