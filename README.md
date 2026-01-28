# Windows Ricing - Hyprland Style

Tiling window manager setup for Windows 11 with Vim-style keybindings.

![Preview](preview.png)

## Features

- **Tiling WM**: Komorebi (BSP layout)
- **Status Bar**: Yasb
- **Terminal**: Alacritty (launches WSL Ubuntu)
- **Hotkeys**: AutoHotkey v2 (Hyprland/i3-style bindings)
- **Focus follows mouse**: Native Windows X-Mouse
- **Gaming Mode**: Disable all hotkeys with one keystroke

## Requirements

- Windows 10/11
- [Winget](https://github.com/microsoft/winget-cli) (comes with Windows 11)
- Administrator access
- WSL with Ubuntu (for Alacritty terminal)

## Quick Install

```powershell
# Run as Administrator
git clone https://github.com/liker0704/dotfiles-windows.git
cd dotfiles-windows
powershell -ExecutionPolicy Bypass -File install.ps1
```

Then **log out and log in** to apply changes.

### Install Options

```powershell
install.ps1              # Full install
install.ps1 -SkipApps    # Skip app installation (if already installed)
install.ps1 -SkipFonts   # Skip font installation
install.ps1 -Force       # Recreate scheduled task
```

## What Gets Installed

| Component | Description |
|-----------|-------------|
| Komorebi | Tiling window manager |
| Alacritty | GPU-accelerated terminal |
| AutoHotkey v2 | Hotkey automation |
| Yasb | Status bar |
| Flow Launcher | App launcher (like Rofi) |
| Lightshot | Screenshot tool |
| JetBrainsMono NF | Nerd Font for terminal |

## Manual Install

### 1. Install Apps

```powershell
winget install LGUG2Z.komorebi
winget install Alacritty.Alacritty
winget install AutoHotkey.AutoHotkey
winget install AmN.yasb
winget install Flow-Launcher.Flow-Launcher
winget install Skillbrains.Lightshot
```

### 2. Copy Configs

```
config/komorebi/    -> %USERPROFILE%\.config\komorebi\
config/alacritty/   -> %USERPROFILE%\.config\alacritty\
ahk/komorebi.ahk    -> %USERPROFILE%\ahk\
scripts/            -> %USERPROFILE%\scripts\
```

### 3. Registry Tweaks

```powershell
# Disable Win+L (so AHK can override it)
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLockWorkstation" -Value 1

# Enable focus follows mouse
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x9F,0x1E,0x07,0x80,0x12,0x00,0x00,0x00))
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ActiveWndTrkTimeout" -Value 100
```

### 4. Create Startup Task

Create a scheduled task to run `scripts\silent_rice.vbs` at logon with highest privileges.

## Keybindings

Press `Win + F1` for full list.

### Focus (Vim-style)
| Key | Action |
|-----|--------|
| `Win + H` | Focus left |
| `Win + J` | Focus down |
| `Win + K` | Focus up |
| `Win + L` | Focus right |

### Move Windows
| Key | Action |
|-----|--------|
| `Win + Shift + H/J/K/L` | Move window |

### Resize
| Key | Action |
|-----|--------|
| `Win + Ctrl + H/L` | Resize horizontal |
| `Win + Ctrl + K/J` | Resize vertical |

### Workspaces
| Key | Action |
|-----|--------|
| `Win + 1-5` | Switch workspace |
| `Win + Shift + 1-5` | Move window to workspace |

### Monitors
| Key | Action |
|-----|--------|
| `Win + [ / ]` | Cycle monitors |
| `Win + Shift + [ / ]` | Move window to monitor |

### Layout
| Key | Action |
|-----|--------|
| `Win + V` | Toggle float |
| `Win + Shift + V` | Flip vertical |
| `Win + B` | Flip horizontal |
| `Win + F` | Toggle monocle (fullscreen) |

### Actions
| Key | Action |
|-----|--------|
| `Win + Enter` | Open Alacritty |
| `Win + Shift + Q` | Close window |
| `Win + Alt + L` | Lock screen |
| `Win + Shift + R` | Reload Komorebi config |
| `Win + Shift + T` | Retile windows |

### System
| Key | Action |
|-----|--------|
| `Win + Shift + G` | Toggle Gaming Mode |
| `Win + F1` | Show keybindings help |

## Gaming Mode

Press `Win + Shift + G` to toggle Gaming Mode:
- Pauses Komorebi tiling
- Disables all hotkeys (so they don't interfere with games)
- Press again to exit

## Structure

```
dotfiles-windows/
├── config/
│   ├── komorebi/
│   │   ├── komorebi.json      # Komorebi config
│   │   └── applications.yaml  # App-specific rules
│   ├── alacritty/
│   │   └── alacritty.toml     # Terminal config (monochrome theme)
│   └── yasb/
│       ├── config.yaml        # Status bar config
│       └── styles.css         # Status bar styles
├── ahk/
│   └── komorebi.ahk           # All keybindings (Hyprland-style)
├── scripts/
│   ├── fix_rice.bat           # Main startup script
│   ├── silent_rice.vbs        # Silent launcher (no console window)
│   └── startup_modules/
│       ├── 00_cleanup.bat     # Kill old processes
│       ├── 10_core.bat        # Start Komorebi + AHK
│       ├── 20_utils.bat       # Flow Launcher, Lightshot
│       ├── 30_interface.bat   # Yasb
│       └── 40_heavy.bat       # Spotify (minimized)
├── install.ps1                # Full installer (apps, fonts, configs, registry)
├── uninstall.ps1              # Clean uninstaller
└── README.md
```

## Uninstall

```powershell
# Remove scheduled task
Unregister-ScheduledTask -TaskName "KomorebiStartup" -Confirm:$false

# Re-enable Win+L
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLockWorkstation"

# Stop services
komorebic stop
taskkill /F /IM AutoHotkey.exe
```

## Credits

- [Komorebi](https://github.com/LGUG2Z/komorebi) - Tiling WM
- [Yasb](https://github.com/amnweb/yasb) - Status bar
- [Alacritty](https://alacritty.org/) - Terminal
- [AutoHotkey](https://www.autohotkey.com/) - Hotkeys

## License

MIT
