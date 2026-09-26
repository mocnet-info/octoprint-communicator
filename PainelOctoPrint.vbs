Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""d:\Projetos\ComunicadorOctoPrint\PainelOctoPrintWPF.ps1""", 0, False
