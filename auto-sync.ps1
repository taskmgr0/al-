# 配置仓库路径
$targetDir = "C:\Users\black\Desktop\chat\github仓库"

Write-Host "👀 开始监控文件夹：$targetDir"
Write-Host "🔄 文件变动后将自动同步到 GitHub (每 5 秒批量提交一次)..."
Write-Host "⚠️  请保持此窗口打开以维持同步，按 Ctrl+C 可停止。" -ForegroundColor Yellow

# 创建文件系统监视器
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $targetDir
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# 定义变动处理逻辑
$action = {
    # 延迟 5 秒执行，防止频繁提交（防抖）
    Start-Sleep -Seconds 5

    # 切换到目标目录
    Set-Location $using:targetDir

    # 检查是否有待提交的变动
    $status = git status --porcelain

    if ($status) {
        Write-Host "`n📦 检测到文件变更，正在自动同步..." -ForegroundColor Green

        # 添加所有变动
        git add .

        # 提交变动
        git commit -m "🤖 自动同步：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        # 推送到远程仓库
        $pushResult = git push 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ 同步成功！" -ForegroundColor Green
        } else {
            Write-Host "❌ 推送失败，请检查网络或权限。" -ForegroundColor Red
        }
    }
}

# 注册事件监听
Register-ObjectEvent $watcher "Changed" -Action $action
Register-ObjectEvent $watcher "Created" -Action $action
Register-ObjectEvent $watcher "Deleted" -Action $action

# 保持脚本运行
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    $watcher.EnableRaisingEvents = $false
    Unregister-Event -SourceIdentifier *
    Write-Host "🛑 监控已停止。"
}
