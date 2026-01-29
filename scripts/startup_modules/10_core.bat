@echo off
start "" /B "C:\Program Files\komorebi\bin\komorebic.exe" start
timeout /t 3 /nobreak >nul

:: Auto-detect monitors that need work_area_offset (where Yasb's windows_app_bar doesn't work)
:: This happens on primary monitor due to Windows AppBar API limitation
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $i=0; [System.Windows.Forms.Screen]::AllScreens | ForEach-Object { if ($_.WorkingArea.Height -eq $_.Bounds.Height) { & 'C:\Program Files\komorebi\bin\komorebic.exe' monitor-work-area-offset $i 0 0 0 36 }; $i++ }"

"C:\Program Files\komorebi\bin\komorebic.exe" retile
start "" /B "C:\Users\liker\ahk\AutoHotkey.exe" "C:\Users\liker\komorebi.ahk"
start "" /B "C:\Program Files\Windhawk\windhawk.exe" -safe-mode
