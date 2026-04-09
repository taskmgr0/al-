@echo off
chcp 65001 >nul

echo 正在启动Git同步监控...
echo.

:: 启动后台监控程序
start "" "sync-launcher.vbs"

echo ✅ 监控程序已在后台启动！
echo    监控间隔: 60秒
echo    日志文件: sync.log
echo.
echo 使用任务管理器可以停止 powershell.exe 进程
timeout /t 3 >nul
