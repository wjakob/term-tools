#Requires AutoHotkey v2.0
#SingleInstance Force

#NoTrayIcon

CapsLock::Escape
ScrollLock::CapsLock

#HotIf WinActive("ahk_class org.wezfurlong.wezterm")
^j::PGUP
^k::PGDN
#Enter::Send('!{Enter}')