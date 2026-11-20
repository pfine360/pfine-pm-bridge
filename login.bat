@echo off
setlocal
cd /d "C:\Users\PFine\pfine-pm-bridge"

set "FORGE_EMAIL=patadvent@gmail.com"
echo Logging in as %FORGE_EMAIL%...
echo Paste your NEW Atlassian API Token (input is hidden) and press Enter:

for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "$s = Read-Host -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))"`) do set "FORGE_API_TOKEN=%%T"

if "%FORGE_API_TOKEN%"=="" (
    echo Error: No token entered.
    pause
    exit /b 1
)

echo.
echo Deploying to development environment...
call forge deploy -e development --approve MAJOR_VERSION_RULE
if errorlevel 1 (
    echo Deploy failed. Check the error above.
    pause
    exit /b 1
)

echo.
echo Upgrading Jira development installation...
call forge install --upgrade -e development
echo.
echo Done!
pause