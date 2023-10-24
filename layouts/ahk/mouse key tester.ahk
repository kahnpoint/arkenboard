; Arkenboard AHK Script
; @kahnpoint 2023

#NoEnv
#SingleInstance, Force
#MaxThreadsPerHotkey 1 
#MaxHotkeysPerInterval 20000
#Persistent
;SendMode, Input
SetBatchLines, -1

~LButton Up:: ; The tilde (~) means the original key's function is kept.
    MsgBox, Left mouse button was released!
return
~LButton::
    MsgBox, Left mouse button was pressed! 
 