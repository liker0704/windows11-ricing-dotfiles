# Windows Ricing Setup - Full Installer
# Run as Administrator: powershell -ExecutionPolicy Bypass -File install.ps1

param(
    [switch]$SkipApps,
    [switch]$SkipFonts,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║         Windows Ricing Setup - Hyprland Style             ║
║         Komorebi + Yasb + Alacritty + AHK                 ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[ERROR] Run as Administrator!" -ForegroundColor Red
    exit 1
}

$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$userHome = $env:USERPROFILE

# ============================================================
# STEP 1: Install Applications
# ============================================================
if (-not $SkipApps) {
    Write-Host "`n[1/8] Installing Applications..." -ForegroundColor Yellow

    $apps = @(
        @{id="LGUG2Z.komorebi"; name="Komorebi"},
        @{id="Alacritty.Alacritty"; name="Alacritty"},
        @{id="AutoHotkey.AutoHotkey"; name="AutoHotkey"},
        @{id="AmN.yasb"; name="Yasb"},
        @{id="Flow-Launcher.Flow-Launcher"; name="Flow Launcher"},
        @{id="Skillbrains.Lightshot"; name="Lightshot"},
        @{id="Windhawk.Windhawk"; name="Windhawk"}
    )

    foreach ($app in $apps) {
        $installed = winget list --id $app.id 2>$null | Select-String $app.id
        if ($installed) {
            Write-Host "  [SKIP] $($app.name) already installed" -ForegroundColor Gray
        } else {
            Write-Host "  [INSTALL] $($app.name)..." -ForegroundColor White
            winget install $app.id --accept-package-agreements --accept-source-agreements -h
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [OK] $($app.name) installed" -ForegroundColor Green
            } else {
                Write-Host "  [WARN] $($app.name) may need manual install" -ForegroundColor Yellow
            }
        }
    }
} else {
    Write-Host "`n[1/8] Skipping app installation" -ForegroundColor Gray
}

# ============================================================
# STEP 2: Install Font (JetBrainsMono Nerd Font)
# ============================================================
if (-not $SkipFonts) {
    Write-Host "`n[2/8] Installing JetBrainsMono Nerd Font..." -ForegroundColor Yellow

    $fontName = "JetBrainsMono NF"
    $fontInstalled = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" |
                     Get-Member -MemberType NoteProperty |
                     Where-Object { $_.Name -like "*JetBrainsMono*Nerd*" }

    if ($fontInstalled) {
        Write-Host "  [SKIP] Font already installed" -ForegroundColor Gray
    } else {
        $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        $fontZip = "$env:TEMP\JetBrainsMono.zip"
        $fontDir = "$env:TEMP\JetBrainsMono"

        Write-Host "  [DOWNLOAD] Downloading font..." -ForegroundColor White
        Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip -UseBasicParsing

        Write-Host "  [EXTRACT] Extracting..." -ForegroundColor White
        Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force

        Write-Host "  [INSTALL] Installing fonts..." -ForegroundColor White
        $fonts = Get-ChildItem -Path $fontDir -Filter "*.ttf" | Where-Object { $_.Name -notmatch "Propo" }

        $shellApp = New-Object -ComObject Shell.Application
        $fontsFolder = $shellApp.Namespace(0x14)  # Fonts folder

        foreach ($font in $fonts) {
            $fontsFolder.CopyHere($font.FullName, 0x10)  # 0x10 = overwrite
        }

        # Cleanup
        Remove-Item $fontZip -Force -ErrorAction SilentlyContinue
        Remove-Item $fontDir -Recurse -Force -ErrorAction SilentlyContinue

        Write-Host "  [OK] Font installed" -ForegroundColor Green
    }
} else {
    Write-Host "`n[2/8] Skipping font installation" -ForegroundColor Gray
}

# ============================================================
# STEP 3: Copy Configs
# ============================================================
Write-Host "`n[3/8] Copying configs..." -ForegroundColor Yellow

# Komorebi config
$komorebiDir = "$userHome\.config\komorebi"
New-Item -ItemType Directory -Path $komorebiDir -Force | Out-Null
Copy-Item "$repoDir\config\komorebi\*" -Destination $komorebiDir -Force
Write-Host "  [OK] Komorebi config -> $komorebiDir" -ForegroundColor Green

# Alacritty config
$alacrittyDir = "$userHome\.config\alacritty"
New-Item -ItemType Directory -Path $alacrittyDir -Force | Out-Null
Copy-Item "$repoDir\config\alacritty\*" -Destination $alacrittyDir -Force
Write-Host "  [OK] Alacritty config -> $alacrittyDir" -ForegroundColor Green

# Yasb config
$yasbDir = "$userHome\.config\yasb"
New-Item -ItemType Directory -Path $yasbDir -Force | Out-Null
Copy-Item "$repoDir\config\yasb\*" -Destination $yasbDir -Force
Write-Host "  [OK] Yasb config -> $yasbDir" -ForegroundColor Green

# Wallpapers
$wallpaperDir = "$userHome\iCloudDrive\Wallpapers\Themes\Monochrome"
New-Item -ItemType Directory -Path $wallpaperDir -Force | Out-Null
Copy-Item "$repoDir\wallpapers\*" -Destination $wallpaperDir -Force
Write-Host "  [OK] Wallpapers -> $wallpaperDir" -ForegroundColor Green

# AHK script
$ahkDir = "$userHome\ahk"
New-Item -ItemType Directory -Path $ahkDir -Force | Out-Null
Copy-Item "$repoDir\ahk\komorebi.ahk" -Destination $ahkDir -Force
Write-Host "  [OK] AHK script -> $ahkDir" -ForegroundColor Green

# PowerShell profile
$psProfileDir = Split-Path $PROFILE -Parent
New-Item -ItemType Directory -Path $psProfileDir -Force | Out-Null
Copy-Item "$repoDir\config\powershell\profile.ps1" -Destination $PROFILE -Force
Write-Host "  [OK] PowerShell profile -> $PROFILE" -ForegroundColor Green

# Copy AHK executable
$ahkExe = "$ahkDir\AutoHotkey.exe"
if (-not (Test-Path $ahkExe)) {
    $ahkPaths = @(
        "${env:ProgramFiles}\AutoHotkey\v2\AutoHotkey64.exe",
        "${env:ProgramFiles}\AutoHotkey\v2\AutoHotkey32.exe",
        "${env:ProgramFiles}\AutoHotkey\AutoHotkey.exe"
    )
    foreach ($path in $ahkPaths) {
        if (Test-Path $path) {
            Copy-Item $path -Destination $ahkExe
            Write-Host "  [OK] AutoHotkey.exe copied" -ForegroundColor Green
            break
        }
    }
}

# ============================================================
# STEP 4: Copy Startup Scripts
# ============================================================
Write-Host "`n[4/8] Setting up startup scripts..." -ForegroundColor Yellow

$scriptsDir = "$userHome\scripts"
New-Item -ItemType Directory -Path "$scriptsDir\startup_modules" -Force | Out-Null
Copy-Item "$repoDir\scripts\*.bat" -Destination $scriptsDir -Force
Copy-Item "$repoDir\scripts\*.vbs" -Destination $scriptsDir -Force
Copy-Item "$repoDir\scripts\startup_modules\*" -Destination "$scriptsDir\startup_modules" -Force

# Create Yasb shortcut for startup script
$yasbExe = Get-ChildItem "${env:ProgramFiles}\yasb\yasb.exe" -ErrorAction SilentlyContinue
if (-not $yasbExe) {
    $yasbExe = Get-ChildItem "${env:LocalAppData}\Microsoft\WinGet\Packages\*yasb*\yasb.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
}
if ($yasbExe) {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut("$scriptsDir\YASB.lnk")
    $shortcut.TargetPath = $yasbExe.FullName
    $shortcut.Save()
    Write-Host "  [OK] Yasb shortcut created" -ForegroundColor Green
}

Write-Host "  [OK] Scripts -> $scriptsDir" -ForegroundColor Green

# ============================================================
# STEP 5: Configure Monitors for Yasb
# ============================================================
Write-Host "`n[5/8] Configuring monitors..." -ForegroundColor Yellow

# Yasb's windows_app_bar doesn't work correctly on primary monitor (Windows AppBar API limitation)
# Detect monitors where WorkingArea equals full height (no taskbar space reserved)
Add-Type -AssemblyName System.Windows.Forms
$monitors = [System.Windows.Forms.Screen]::AllScreens
$monitorsNeedingOffset = @()
$monitorIndex = 0

foreach ($monitor in $monitors) {
    $needsOffset = $monitor.WorkingArea.Height -eq $monitor.Bounds.Height
    $status = if ($needsOffset) { "needs offset" } else { "OK (Yasb app_bar working)" }
    Write-Host "  Monitor $monitorIndex ($($monitor.DeviceName)): $status" -ForegroundColor $(if ($needsOffset) { "Yellow" } else { "Gray" })
    if ($needsOffset) {
        $monitorsNeedingOffset += $monitorIndex
    }
    $monitorIndex++
}

if ($monitorsNeedingOffset.Count -gt 0) {
    Write-Host "  [INFO] Monitors $($monitorsNeedingOffset -join ', ') will get work_area_offset via startup script" -ForegroundColor Cyan
} else {
    Write-Host "  [OK] All monitors have proper work area reserved by Yasb" -ForegroundColor Green
}

# ============================================================
# STEP 6: Registry Tweaks
# ============================================================
Write-Host "`n[6/8] Applying registry tweaks..." -ForegroundColor Yellow

# Disable Win+L lock (so AHK can use it)
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "DisableLockWorkstation" -Value 1 -Type DWord
Write-Host "  [OK] Win+L disabled (use Win+Alt+L to lock)" -ForegroundColor Green

# Enable X-Mouse (focus follows mouse)
$desktopPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $desktopPath -Name "UserPreferencesMask" -Value ([byte[]](0x9F,0x1E,0x07,0x80,0x12,0x00,0x00,0x00))
Set-ItemProperty -Path $desktopPath -Name "ActiveWndTrkTimeout" -Value 100 -Type DWord
Set-ItemProperty -Path $desktopPath -Name "ActiveWndTrack" -Value 1 -Type DWord
Write-Host "  [OK] X-Mouse enabled (focus follows mouse)" -ForegroundColor Green

# Apply X-Mouse immediately via Windows API
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class XMouse {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, ref bool pvParam, uint fWinIni);
    public const uint SPI_SETACTIVEWINDOWTRACKING = 0x1001;
    public const uint SPIF_SENDCHANGE = 0x02;
}
"@
$enabled = $true
[XMouse]::SystemParametersInfo([XMouse]::SPI_SETACTIVEWINDOWTRACKING, 0, [ref]$enabled, [XMouse]::SPIF_SENDCHANGE) | Out-Null

# Enable Taskbar Auto-Hide (needed for full taskbar hiding with Windhawk)
$stuckRectsPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
$stuckRectsValue = (Get-ItemProperty -Path $stuckRectsPath -ErrorAction SilentlyContinue).Settings
if ($stuckRectsValue) {
    $stuckRectsValue[8] = 0x03  # Enable auto-hide
    Set-ItemProperty -Path $stuckRectsPath -Name "Settings" -Value $stuckRectsValue
    Write-Host "  [OK] Taskbar auto-hide enabled" -ForegroundColor Green
}

# Configure Windhawk mods (if installed)
$whModsPath = "HKLM:\SOFTWARE\Windhawk\Engine\Mods"
if (Test-Path $whModsPath) {
    # Taskbar icon size - set all to 0 for hidden taskbar
    $iconSizePath = "$whModsPath\taskbar-icon-size\Settings"
    if (Test-Path $iconSizePath) {
        Set-ItemProperty -Path $iconSizePath -Name "TaskbarHeight" -Value 0
        Set-ItemProperty -Path $iconSizePath -Name "IconSize" -Value 0
        Set-ItemProperty -Path $iconSizePath -Name "TaskbarButtonWidth" -Value 0
        Set-ItemProperty -Path $iconSizePath -Name "IconSizeSmall" -Value 0
        Set-ItemProperty -Path $iconSizePath -Name "TaskbarButtonWidthSmall" -Value 0
        Write-Host "  [OK] Windhawk taskbar-icon-size configured" -ForegroundColor Green
    }

    # Taskbar styler - hide background
    $stylerPath = "$whModsPath\windows-11-taskbar-styler\Settings"
    if (Test-Path $stylerPath) {
        Set-ItemProperty -Path $stylerPath -Name "controlStyles[0].target" -Value "Rectangle#BackgroundFill"
        Set-ItemProperty -Path $stylerPath -Name "controlStyles[0].styles[0]" -Value "Visibility=Collapsed"
        Set-ItemProperty -Path $stylerPath -Name "controlStyles[1].target" -Value "Rectangle#BackgroundStroke"
        Set-ItemProperty -Path $stylerPath -Name "controlStyles[1].styles[0]" -Value "Visibility=Collapsed"
        Write-Host "  [OK] Windhawk taskbar-styler configured" -ForegroundColor Green
    }
}

# ============================================================
# STEP 7: Create Scheduled Task
# ============================================================
Write-Host "`n[7/8] Creating startup task..." -ForegroundColor Yellow

$taskName = "KomorebiStartup"
$taskExists = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($taskExists -and -not $Force) {
    Write-Host "  [SKIP] Task already exists (use -Force to recreate)" -ForegroundColor Gray
} else {
    if ($taskExists) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }

    $action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$scriptsDir\silent_rice.vbs`""
    $trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
    Write-Host "  [OK] Scheduled task created" -ForegroundColor Green
}

# ============================================================
# STEP 8: Done
# ============================================================
Write-Host "`n[8/8] Finalizing..." -ForegroundColor Yellow

Write-Host @"

╔═══════════════════════════════════════════════════════════╗
║                  INSTALLATION COMPLETE                     ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  IMPORTANT: LOG OUT and LOG IN to apply all changes!      ║
║                                                           ║
║  Or start manually now:                                   ║
║    komorebic start                                        ║
║    Start-Process "$userHome\ahk\AutoHotkey.exe" "$userHome\ahk\komorebi.ahk"
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║  KEYBINDINGS (press Win+F1 for full list):                ║
║                                                           ║
║    Win + H/J/K/L         Focus windows (Vim-style)        ║
║    Win + Shift + HJKL    Move windows                     ║
║    Win + Ctrl + HJKL     Resize windows                   ║
║    Win + 1-5             Switch workspace                 ║
║    Win + Shift + 1-5     Move to workspace                ║
║    Win + Enter           Open Alacritty (WSL)             ║
║    Win + Shift + Q       Close window                     ║
║    Win + V               Toggle floating                  ║
║    Win + F               Toggle fullscreen                ║
║    Win + Shift + G       Gaming Mode (disable hotkeys)    ║
║    Win + Alt + L         Lock screen                      ║
║    Win + F1              Show all keybindings             ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
