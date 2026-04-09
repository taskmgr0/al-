# Git自动同步监控脚本 - 后台运行版本
$repoPath = "C:\Users\black\Desktop\chat\github仓库"
$logFile = Join-Path $repoPath "sync.log"
$monitorInterval = 60 # 监控间隔（秒）

function Show-Notification {
    param([string]$title, [string]$message)
    
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
    
    $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">$title</text>
            <text id="2">$message</text>
        </binding>
    </visual>
</toast>
"@
    
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Git同步监控").Show($toast)
}

function Write-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

function Sync-Repo {
    Set-Location $repoPath
    
    # 检查是否有更改
    $status = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Log "没有需要提交的更改"
        return $false
    }
    
    # 执行同步
    Write-Log "开始同步..."
    
    git add .
    $commitResult = git commit -m "🤖 自动同步: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "提交失败: $commitResult"
        Show-Notification "Git同步失败" "提交更改时出错"
        return $false
    }
    
    $pushResult = git push 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "推送失败: $pushResult"
        Show-Notification "Git同步失败" "推送到远程仓库时出错"
        return $false
    }
    
    Write-Log "同步成功"
    Show-Notification "Git同步成功" "已自动提交并推送到GitHub"
    return $true
}

# 主循环
Write-Log "========== Git监控启动 =========="
Show-Notification "Git监控启动" "开始监控仓库变化，间隔${monitorInterval}秒"

while ($true) {
    try {
        Sync-Repo
    } catch {
        Write-Log "发生错误: $_"
        Show-Notification "Git监控错误" "执行同步时发生异常"
    }
    
    Start-Sleep -Seconds $monitorInterval
}
