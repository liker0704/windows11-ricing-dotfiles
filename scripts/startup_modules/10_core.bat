@echo off
:: Wait for system to be ready
timeout /t 3 /nobreak >nul

:: Activate X-Mouse (focus follows cursor)
powershell -NoProfile -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class X { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, ref bool c, uint d); }'; $e=$true; [X]::SystemParametersInfo(0x1001,0,[ref]$e,2)"

:: Start komorebi
"C:\Program Files\komorebi\bin\komorebic.exe" start

:: Start AHK (no need to wait for komorebi)
start "" /B "C:\Users\liker\ahk\AutoHotkey.exe" "C:\Users\liker\komorebi.ahk"

:: Retile after everything is ready
"C:\Program Files\komorebi\bin\komorebic.exe" retile
