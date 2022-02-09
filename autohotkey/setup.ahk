; Recommended, but not required:
SendMode Input
#NoEnv
#SingleInstance force

#Include %A_LineFile%\..\third-party\dual\dual.ahk
dual := new Dual

#Include %A_LineFile%\..\third-party\dual\defaults.ahk

#If true ; Override defaults.ahk. There will be "duplicate hotkey" errors otherwise.

; Steve Losh shift buttons.
*LShift::
*LShift UP::dual.combine(A_ThisHotkey, "(")
*RShift::
*RShift UP::dual.combine(A_ThisHotkey, ")")

; CapsLock to LCtrl
*CapsLock::
*CapsLock UP::dual.combine("LCtrl", A_ThisHotkey)

; Enter to RCtrl
*Enter::
*Enter UP::dual.combine("RCtrl", A_ThisHotkey)

#If

*ScrollLock::dual.reset()