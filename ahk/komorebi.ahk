#Requires AutoHotkey v2.0
#SingleInstance Force
SetControlDelay -1

; Prevent Win key from opening Start Menu
A_MenuMaskKey := "vkE8" 

GamingMode := false

; ==============================================================================
; GAMING MODE TOGGLE (WIN + SHIFT + G)
; ==============================================================================
#+g::
{
    global GamingMode
    GamingMode := !GamingMode
    if (GamingMode) {
        Run("C:\Program Files\komorebi\bin\komorebic.exe toggle-pause",, "Hide")
        ToolTip("Gaming Mode: ON")
        SetTimer () => ToolTip(), -1000
    } else {
        Run("C:\Program Files\komorebi\bin\komorebic.exe toggle-pause",, "Hide")
        ToolTip("Gaming Mode: OFF")
        SetTimer () => ToolTip(), -1000
    }
}

#HotIf !GamingMode
; --- MONITORS ---
#vkDB::Run("C:\Program Files\komorebi\bin\komorebic.exe cycle-monitor previous",, "Hide")
#vkDD::Run("C:\Program Files\komorebi\bin\komorebic.exe cycle-monitor next",, "Hide")
#+vkDB::Run("C:\Program Files\komorebi\bin\komorebic.exe cycle-move-to-monitor previous",, "Hide")
#+vkDD::Run("C:\Program Files\komorebi\bin\komorebic.exe cycle-move-to-monitor next",, "Hide")

; --- FOCUS ---
#h::Run("C:\Program Files\komorebi\bin\komorebic.exe focus left",, "Hide")
#j::Run("C:\Program Files\komorebi\bin\komorebic.exe focus down",, "Hide")
#k::Run("C:\Program Files\komorebi\bin\komorebic.exe focus up",, "Hide")
#l::Run("C:\Program Files\komorebi\bin\komorebic.exe focus right",, "Hide")
#vkBA::Run("C:\Program Files\komorebi\bin\komorebic.exe focus right",, "Hide")

; --- MOVE ---
#+h::Run("C:\Program Files\komorebi\bin\komorebic.exe move left",, "Hide")
#+j::Run("C:\Program Files\komorebi\bin\komorebic.exe move down",, "Hide")
#+k::Run("C:\Program Files\komorebi\bin\komorebic.exe move up",, "Hide")
#+l::Run("C:\Program Files\komorebi\bin\komorebic.exe move right",, "Hide")

; --- RESIZE ---
#^h::Run("C:\Program Files\komorebi\bin\komorebic.exe resize-axis horizontal decrease",, "Hide")
#^l::Run("C:\Program Files\komorebi\bin\komorebic.exe resize-axis horizontal increase",, "Hide")
#^k::Run("C:\Program Files\komorebi\bin\komorebic.exe resize-axis vertical decrease",, "Hide")
#^j::Run("C:\Program Files\komorebi\bin\komorebic.exe resize-axis vertical increase",, "Hide")

; --- ACTIONS ---
#+q::Run("C:\Program Files\komorebi\bin\komorebic.exe close",, "Hide")
#Enter::Run("C:\Program Files\Alacritty\alacritty.exe")
#v::Run("C:\Program Files\komorebi\bin\komorebic.exe toggle-float",, "Hide")
#+v::Run("C:\Program Files\komorebi\bin\komorebic.exe flip-layout vertical",, "Hide")
#f::Run("C:\Program Files\komorebi\bin\komorebic.exe toggle-monocle",, "Hide")
#b::Run("C:\Program Files\komorebi\bin\komorebic.exe flip-layout horizontal",, "Hide")
#+r::Run("C:\Program Files\komorebi\bin\komorebic.exe reload-configuration",, "Hide")
#+t::Run("C:\Program Files\komorebi\bin\komorebic.exe retile",, "Hide")
#!l::
{
    RegWrite(0, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
    Sleep(100)
    DllCall("LockWorkStation")
    Sleep(1000)
    RegWrite(1, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
}

; --- WORKSPACES ---
#1::Run("C:\Program Files\komorebi\bin\komorebic.exe focus-workspace 0",, "Hide")
#2::Run("C:\Program Files\komorebi\bin\komorebic.exe focus-workspace 1",, "Hide")
#3::Run("C:\Program Files\komorebi\bin\komorebic.exe focus-workspace 2",, "Hide")
#4::Run("C:\Program Files\komorebi\bin\komorebic.exe focus-workspace 3",, "Hide")
#5::Run("C:\Program Files\komorebi\bin\komorebic.exe focus-workspace 4",, "Hide")
#+1::Run("C:\Program Files\komorebi\bin\komorebic.exe move-to-workspace 0",, "Hide")
#+2::Run("C:\Program Files\komorebi\bin\komorebic.exe move-to-workspace 1",, "Hide")
#+3::Run("C:\Program Files\komorebi\bin\komorebic.exe move-to-workspace 2",, "Hide")
#+4::Run("C:\Program Files\komorebi\bin\komorebic.exe move-to-workspace 3",, "Hide")
#+5::Run("C:\Program Files\komorebi\bin\komorebic.exe move-to-workspace 4",, "Hide")

#HotIf GamingMode
; --- WORKSPACES ---
#1::return
#2::return
#3::return
#4::return
#5::return
#+1::return
#+2::return
#+3::return
#+4::return
#+5::return

; --- FOCUS ---
#h::return
#j::return
#k::return
#l::return
#vkBA::return

; --- MOVE ---
#+h::return
#+j::return
#+k::return
#+l::return

; --- RESIZE ---
#^h::return
#^j::return
#^k::return
#^l::return

; --- MONITORS ---
#vkDB::return
#vkDD::return
#+vkDB::return
#+vkDD::return

; --- ACTIONS ---
#+q::return
#Enter::return
#v::return
#+v::return
#f::return
#b::return
#+r::return
#+t::return
#!l::return

; --- HELP ---
#F1::return
#HotIf

ShowHelp() {
    helpText := "
    (
══════════════════════════════════════════
         KOMOREBI KEYBINDINGS
══════════════════════════════════════════
  FOCUS (Vim-style)
    Win + H/J/K/L    Focus left/down/up/right
    Win + ;          Focus right (alt)
──────────────────────────────────────────
  MOVE WINDOWS
    Win + Shift + H/J/K/L   Move window
──────────────────────────────────────────
  RESIZE
    Win + Ctrl + H/L   Horizontal +/-
    Win + Ctrl + K/J   Vertical +/-
──────────────────────────────────────────
  WORKSPACES
    Win + 1-5              Switch
    Win + Shift + 1-5      Move to
──────────────────────────────────────────
  MONITORS
    Win + [ ]            Cycle monitor
    Win + Shift + [ ]    Move to monitor
──────────────────────────────────────────
  LAYOUT
    Win + V         Toggle float
    Win + Shift + V Flip vertical
    Win + B         Flip horizontal
    Win + F         Toggle monocle
──────────────────────────────────────────
  ACTIONS
    Win + Enter         Alacritty
    Win + Shift + Q     Close window
    Win + Alt + L       Lock screen
    Win + Shift + R     Reload config
    Win + Shift + T     Retile
──────────────────────────────────────────
  SYSTEM
    Win + Shift + G     Gaming Mode
    Win + F1            This help
══════════════════════════════════════════
    )"
    MsgBox(helpText, "Komorebi Keybindings")
}

#F1::ShowHelp()
