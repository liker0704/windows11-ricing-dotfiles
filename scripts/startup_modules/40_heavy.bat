@echo off
start "" /B "C:\Users\liker\AppData\Roaming\Spotify\Spotify.exe" --autostart --minimized

:: Activate X-Mouse at the end (needs desktop to be ready)
timeout /t 2 /nobreak >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\liker\scripts\activate_xmouse.ps1"
