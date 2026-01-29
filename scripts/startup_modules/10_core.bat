@echo off
:: Wait for system to be ready
timeout /t 3 /nobreak >nul

:: Activate X-Mouse (focus follows cursor)
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\liker\scripts\activate_xmouse.ps1"

:: Start komorebi
"C:\Program Files\komorebi\bin\komorebic.exe" start

:: Start AHK (no need to wait for komorebi)
start "" /B "C:\Users\liker\ahk\AutoHotkey.exe" "C:\Users\liker\komorebi.ahk"

:: Retile after everything is ready
"C:\Program Files\komorebi\bin\komorebic.exe" retile
