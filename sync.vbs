Set ws = CreateObject("WScript.Shell")
psPath = "C:\Users\black\Desktop\chat\github仓库\sync.ps1"
cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & psPath & """"
ws.Run cmd, 0, False
