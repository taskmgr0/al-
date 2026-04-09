Set-Location "C:\Users\black\Desktop\chat\github仓库"

# 发送 Windows 通知的函数
function Show-Notification {
    param([string]$Title, [string]$Message)
    
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
    $textNodes = $template.GetElementsByTagName("text")
    $textNodes[0].AppendChild($template.CreateTextNode($Title)) | Out-Null
    $textNodes[1].AppendChild($template.CreateTextNode($Message)) | Out-Null
    
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Windows PowerShell")
    $notifier.Show($template)
}

# 添加所有更改
git add . 2>&1 | Out-Null

# 检查是否有待提交的内容
git diff --cached --quiet 2>&1
if ($LASTEXITCODE -eq 0) {
    Show-Notification "同步" "没有需要提交的更改。"
    exit
}

# 提交
git commit -m "🤖 自动同步: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Show-Notification "同步 ❌" "提交失败"
    exit
}

# 推送
git push 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Show-Notification "同步 ✅" "同步成功！"
} else {
    Show-Notification "同步 ❌" "推送失败，请检查网络或权限"
}
