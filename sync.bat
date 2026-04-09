@echo off
chcp 65001 >nul
cd /d "C:\Users\black\Desktop\chat\github仓库"

echo 🔄 正在同步到 GitHub...
echo.

git add .

git status --porcelain >nul
if errorlevel 1 (
    echo ✅ 没有需要提交的更改。
    pause
    exit
)

for /f "tokens=*" %%i in ('git status --porcelain') do set HAS_CHANGES=1

if not defined HAS_CHANGES (
    echo ✅ 没有需要提交的更改。
    pause
    exit
)

git commit -m "🤖 自动同步: %date% %time:~0,8%"

if errorlevel 1 (
    echo ❌ 提交失败，请检查。
    pause
    exit
)

git push

if errorlevel 1 (
    echo ❌ 推送失败，请检查网络或权限。
) else (
    echo.
    echo ✅ 同步成功！
)

pause
