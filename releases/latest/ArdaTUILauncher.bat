@echo off
openfiles >nul 2>&1
if '%errorlevel%' neq '0' (
    echo [ARDAT-UI][INFO]:Requesting Admin privileges
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "UI.ps1" -LaunchUICode "9Gj9Gjxxx4RFRGI38"
