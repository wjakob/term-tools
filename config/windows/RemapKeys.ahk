#Requires AutoHotkey v2.0
#SingleInstance Force

#NoTrayIcon

$CapsLock::Escape
$ScrollLock::CapsLock

#HotIf WinActive("ahk_class org.wezfurlong.wezterm")
^j::PGDN
^k::PGUP
^h::HOME
^l::END
^Backspace::Delete
#Enter::Send('!{Enter}')
