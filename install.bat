@echo off
:: Windows Ricing Installer - Auto-elevate to Admin
:: Just double-click this file to install

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: We have admin rights, run the installer
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0install.ps1"
