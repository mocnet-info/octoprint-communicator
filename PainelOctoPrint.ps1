Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Painel do Comunicador OctoPrint"
$form.Size = New-Object System.Drawing.Size(400,250)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::White

$label = New-Object System.Windows.Forms.Label
$label.Text = "O que você deseja fazer?"
$label.Location = New-Object System.Drawing.Point(20,20)
$label.Size = New-Object System.Drawing.Size(350,30)
$label.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$label.TextAlign = "MiddleCenter"
$form.Controls.Add($label)

$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "▶ Iniciar Comunicador OctoPrint"
$btnStart.Location = New-Object System.Drawing.Point(50, 70)
$btnStart.Size = New-Object System.Drawing.Size(280, 45)
$btnStart.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$btnStart.BackColor = [System.Drawing.Color]::LightGreen
$btnStart.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnStart.Add_Click({
    $form.Close()
    Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"d:\Projetos\ComunicadorOctoPrint\IniciarComunicador.ps1`""
})
$form.Controls.Add($btnStart)

$btnUpdate = New-Object System.Windows.Forms.Button
$btnUpdate.Text = "🔄 Atualizar OctoPrint"
$btnUpdate.Location = New-Object System.Drawing.Point(50, 130)
$btnUpdate.Size = New-Object System.Drawing.Size(280, 45)
$btnUpdate.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$btnUpdate.BackColor = [System.Drawing.Color]::LightBlue
$btnUpdate.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnUpdate.Add_Click({
    $form.Close()
    Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"d:\Projetos\ComunicadorOctoPrint\AtualizarOctoPrint.ps1`""
})
$form.Controls.Add($btnUpdate)

$form.ShowDialog()
