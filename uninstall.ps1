# Windows Ricing Setup - Uninstaller
# Run as Administrator

Write-Host "Uninstalling Windows Ricing Setup..." -ForegroundColor Yellow

# Stop processes
Write-Host "[1/4] Stopping processes..." -ForegroundColor Yellow
komorebic stop 2>$null
Stop-Process -Name AutoHotkey -Force -ErrorAction SilentlyContinue
Stop-Process -Name yasb -Force -ErrorAction SilentlyContinue
Write-Host "  [OK] Processes stopped" -ForegroundColor Green

# Remove scheduled task
Write-Host "[2/4] Removing scheduled task..." -ForegroundColor Yellow
Unregister-ScheduledTask -TaskName "KomorebiStartup" -Confirm:$false -ErrorAction SilentlyContinue
Write-Host "  [OK] Task removed" -ForegroundColor Green

# Restore registry
Write-Host "[3/4] Restoring registry..." -ForegroundColor Yellow
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLockWorkstation" -ErrorAction SilentlyContinue
Write-Host "  [OK] Win+L restored" -ForegroundColor Green

# Info
Write-Host "[4/4] Done!" -ForegroundColor Yellow
Write-Host @"

Uninstall complete.

To fully remove, also delete:
  - %USERPROFILE%\.config\komorebi
  - %USERPROFILE%\.config\alacritty
  - %USERPROFILE%\ahk
  - %USERPROFILE%\scripts

And uninstall apps via winget:
  winget uninstall LGUG2Z.komorebi
  winget uninstall Alacritty.Alacritty
  winget uninstall AutoHotkey.AutoHotkey

"@ -ForegroundColor Cyan
