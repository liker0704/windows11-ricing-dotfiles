@echo off
:: Wait for system to be ready before starting komorebi
timeout /t 5 /nobreak >nul

:: Activate X-Mouse (focus follows cursor)
powershell -NoProfile -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class X { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, ref bool c, uint d); }'; $e=$true; [X]::SystemParametersInfo(0x1001,0,[ref]$e,2)"

:: Run komorebic directly (it handles its own process spawning and waits for startup)
"C:\Program Files\komorebi\bin\komorebic.exe" start
timeout /t 2 /nobreak >nul

:: Auto-detect monitors that need work_area_offset (where Yasb's windows_app_bar doesn't work)
:: This happens on primary monitor due to Windows AppBar API limitation
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $i=0; [System.Windows.Forms.Screen]::AllScreens | ForEach-Object { if ($_.WorkingArea.Height -eq $_.Bounds.Height) { & 'C:\Program Files\komorebi\bin\komorebic.exe' monitor-work-area-offset $i 0 0 0 36 }; $i++ }"

"C:\Program Files\komorebi\bin\komorebic.exe" retile
start "" /B "C:\Users\liker\ahk\AutoHotkey.exe" "C:\Users\liker\komorebi.ahk"
:: Windhawk runs as Windows service - no need to start manually
