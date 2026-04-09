@echo off
chcp 65001 >nul

echo 正在设置Git同步监控开机自启...
echo.

:: 创建启动文件夹快捷方式（如果不存在）
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" (
    mkdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
)

:: 复制到启动文件夹
copy /Y "%~dp0sync-launcher.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\GitSync.vbs" >nul

if %errorlevel% equ 0 (
    echo ✅ 开机自启设置成功！
    echo    文件位置: %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\GitSync.vbs
    echo.
    echo 下次开机时将自动启动Git同步监控
) else (
    echo ❌ 设置失败，请以管理员身份运行
)

echo.
pause
