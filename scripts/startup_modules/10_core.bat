@echo off
:: Wait for system to be ready
timeout /t 3 /nobreak >nul

:: Start komorebi
"C:\Program Files\komorebi\bin\komorebic.exe" start

:: Start AHK
start "" /B "C:\Users\liker\ahk\AutoHotkey.exe" "C:\Users\liker\komorebi.ahk"

:: Retile
"C:\Program Files\komorebi\bin\komorebic.exe" retile
