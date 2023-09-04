; Arkenboard AHK Script
; @kahnpoint 2023

#NoEnv
#SingleInstance, Force
#MaxThreadsPerHotkey 1 
#MaxHotkeysPerInterval 20000
#Persistent
;SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
SetTimer, WatchMouse, 5 ; Check every 5 milliseconds
global originalX := 0
global originalY := 0
global originalLock := False

; These global variables are used to keep track of the state of the modifier keys
global _subDown := False
global _subFirstDown := False
global _superDown := False
global _superFirstDown := False
global _mouseDown := False
global _mouseMDown := False
global _mouseRDown := False
global _mouseLDown := False

; Initialize the tap count and the timer
global escTapCount := 0
global escTapTimer := 0
global enableFunctionLayer := True

; iKey is the base class for the standard keys
class iKey {

  ; default is the key's default value
  ; sub is the key's value when the sub key is pressed
  ; super is the key's value when the super key is pressed
  ; supersub is the key's value when both the sub and super keys are pressed
  __New(default, sub, super, supersub) {
    this.default := default
    this.super := super
    this.sub := sub
    this.supersub := supersub
  }

  press() {
    
    global _subDown, _superDown
    result := ""
    If (_subDown and _superDown) {
      result := this.supersub
    } else If (_subDown) {
      result := this.sub
    } else If (_superDown) {
      result := this.super
    } else {
      result := this.default
    }
    
      if (GetKeyState("RAlt")){
        result := "!" . result
      }
      if (GetKeyState("RWin") or GetKeyState("LWin")){
        result := "#" . result
      }
      
      if (GetKeyState("Shift")){
        result := "+" . result
      }
      if (GetKeyState("Ctrl")){
        result := "^" . result
      }

    ; some keys require pauses between commands
    if IsObject(result) { ; check if the result is a list
      for index, command in result { ; iterate over the list
        ; handle sleep commands separately
        if InStr(command, "sleep,") {
          Sleep, % SubStr(command, InStr(command, ",") + 1)
        }  if InStr(command, "SoundDn,") {
          Send {Volume_Down}
        }else if InStr(command, "SoundUp,") {
          Send {Volume_Up}
        }else if InStr(command, "SoundSet,") {
          SoundSet, +0, , mute
        }else{
          SendInput, % command
        }
      }
    } else {
      Send, % result
    }
  }
}


class iMouseKey extends iKey {

  press() {
    
    global _subDown, _superDown, _mouseDown
    result := "" 
    
    If(not _mouseDown) {
      global _subDown, _superDown, _mouseDown, _mouseMDown, _mouseRDown, _mouseLDown
      result := ""
      If (_subDown and _superDown) {
        result := this.supersub
        _mouseMDown := True
      } else If (_subDown) {
        result := this.sub
        _mouseRDown := True
      } else If (_superDown) {
        result := this.super
        _mouseMDown := True
      } else {
        result := this.default
        _mouseLDown := True
      }
      
        if (GetKeyState("RAlt")){
          result := "!" . result
        }
        if (GetKeyState("RWin") or GetKeyState("LWin")){
          result := "#" . result
        }
        
        if (GetKeyState("Shift")){
          result := "+" . result
        }
        if (GetKeyState("Ctrl")){
          result := "^" . result
        }
        Send, % result
      } 
        _mouseDown := True
    }
    
    release(){   
    global _subDown, _superDown, _mouseDown, _mouseMDown, _mouseRDown, _mouseLDown
    _mouseDown := False
    If (_mouseRDown) {
      _mouseRDown := False
      Send, {RButton Up}
    }
    If (_mouseMDown) {
      _mouseMDown := False
      Send, {MButton Up}
    }
    If (_mouseLDown) {
      _mouseLDown := False
      Send, {LButton Up}
    }
  }
}


; this class tracks the sub key
class iSubKey {
  press() {
    global
    _subDown := True
    If (not _superDown) {
      _subFirstDown := True
    }
  }
  release() {
    global
    _subDown := False
    _subFirstDown := False
  }
}


; this class tracks the super key
class iSuperKey {
  press() {
    global
    _superDown := True
    If (not _subDown) {
      _superFirstDown := True
    }
  }
  release() {
    global
    _superDown := False
    _superFirstDown := False
  }
}

; create the modifier key objects 
iSubKey := new iSubKey()
iSuperKey := new iSuperKey()

;["{Ctrl Down}l{Ctrl Up}cmd{Enter}", "sleep, 1200", "code . {Enter}"]
iKeyq := new iKey("q", "`=", "0", "{F10}")
iKeyw := new iKey("u", "_", "1", "{F1}")
iKeye := new iKey("o", "`-", "2", "{F2}")
iKeyr := new iKey("i", "{+}", "3", "{F3}")
iKeyt := new iKey("k", "{RWin Down}.{RWin Up}", "4", "{F4}")

iKeyy := new iKey("w", "%", "5", "{F5}")
iKeyu := new iKey("t", "`~", "6", "{F6}")
iKeyi := new iKey("h", "{Up}", "7", "{F7}")
iKeyo := new iKey("s", "`/", "8", "{F8}")
iKeyp := new iKey("{Esc}", "{*}", "9", "{F9}")

iKeya := new iKey("y", "{#}", "{@}", "{F11}")
iKeys := new iKey("a", "{Backspace}","{Backspace}",  "{Backspace}")
iKeyd := new iKey("e", "{Delete}", "{Delete}", "{Delete}") 
iKeyf := new iMouseKey("{LButton Down}",   "{RButton Down}", "{MButton Down}", "{MButton Down}")
iKeyg := new iKey("g", ["SoundDn, -5"], ["SoundUp, +5"], ["SoundSet, 0"])

iKeyh := new iKey("m", "^+;", "^``", "^``^b") 
iKeyj := new iKey(" ",  "{Left}", "{Tab}", "{Tab}")
iKeyk := new iKey("{Enter}", "{Down}", "{PgDn}",  "<{!}--{Space}{Space}-->{Left 4}")
iKeyl := new iKey("l", "{Right}", "{PgUp}", "/*{Space}{Space}*/{Left 3}")   
lKeySemicolon := new iKey("p", ";", ":", "::")

iKeyz := new iKey("z", "`|","`\", "{F12}")
iKeyx := new iKey("x", "{{}", "{}}", "{{}{}}{Left}")
iKeyc := new iKey("c", "(", ")", "(){Left}")
iKeyv := new iKey("v",  "<", ">", "<>{Left}")
iKeyb := new iKey("b", "[", "]", "[]{Left}")

iKeyn := new iKey("f", "`&","`{^}", "{PrintScreen}")
iKeym := new iKey("r", "{!}", "``", "````{Left}")
iKeyComma := new iKey("n", ",", "`'", "`'`'{Left}")
iKeyPeriod := new iKey("d", ".^{Space}", """", """""{Left}")
iKeySlash := new iKey("j", "`?", "{$}", "${{}{}}{Left}")


#IF enableFunctionLayer

; map the modifier keys to their objects
*LAlt::iSubKey.press()
*LAlt Up::iSubKey.release()
*Space::iSuperKey.press()
*Space Up::iSuperKey.release()


; map the keys to their objects
*q::iKeyq.press()
*w::iKeyw.press()
*e::iKeye.press()
*r::iKeyr.press()
*t::iKeyt.press()
*y::iKeyy.press()
*u::iKeyu.press()
*i::iKeyi.press()
*o::iKeyo.press()
*p::iKeyp.press()
*a::iKeya.press()
*s::iKeys.press()
*d::iKeyd.press()
*f::iKeyf.press()
*f Up::iKeyf.release()
*g::iKeyg.press()
*h::iKeyh.press()
*j::iKeyj.press()
*k::iKeyk.press()
*l::iKeyl.press()
*z::iKeyz.press()
*x::iKeyx.press()
*c::iKeyc.press()
*v::iKeyv.press()
*b::iKeyb.press()
*n::iKeyn.press()
*m::iKeym.press()
*,::iKeyComma.press()
*.::iKeyPeriod.press()
*/::iKeySlash.press()
*`;::lKeySemicolon.press()


; alt tab abilities
RAlt & j::AltTabMenu
RAlt & l::AltTab
RAlt & k::ShiftAltTab


; allow the mouse to function as a scroll wheel
WatchMouse:
global _subDown
global _superDown
if (_subDown) {
    
    if (originalX = 0 and originalY = 0 and originalLock = False) {
        MouseGetPos, originalX, originalY ; Capture the original position when LShift is first pressed
        originalLock := True
    }

    MouseGetPos, x2, y2 ; Get current mouse position
    
    ; Calculate the distance moved
    dx := x2 - originalX
    dy := y2 - originalY
    
    ShiftDown := GetKeyState("LShift", "P") ; Check if LShift is pressed

    ; Scroll vertically with the sub key
    if (_subDown and not ShiftDown) {
        ; Proportionally send scroll based on Y-axis movement
        WheelDelta := dy / 10 ; Adjust the divisor for desired sensitivity
        Loop, % Round(Abs(WheelDelta)) {
            if (WheelDelta > 0)
                Send {WheelDown}
            else
                Send {WheelUp}
        }
    }
    
    ; Scroll horizontally with the super key
    if (_subDown and ShiftDown) {
        ; Proportionally send scroll based on X-axis movement
        WheelDeltaX := dx / 10 ; Adjust the divisor for desired sensitivity
        Loop, % Round(Abs(WheelDeltaX)) {
            if (WheelDeltaX > 0)
                Send +{WheelDown}
            else
                Send +{WheelUp}
        }
    }
    
    ; Lock the mouse to the original position
    MouseMove, originalX, originalY, 0 ; Reset mouse position to original position without animation
} else {
    originalX := 0 ; Reset the original X and Y coordinates when LShift is released
    originalY := 0
    originalLock := False
}
return

#IF

; The main Esc key detection hotkey
Esc::
    ; Increment the tap count
    escTapCount++
    
    ; If this is the first tap, start the timer
    if (escTapCount = 1) {
        ; Start a timer that will reset escTapCount after 500 milliseconds
        ; Change 500 to any amount of time (in milliseconds) that works for you
        SetTimer, ResetEscTapCount, -500
    }
    
    ; Check if the Esc key has been tapped 3 times
    if (escTapCount = 3) {
        ; Reset the tap count
        escTapCount := 0
        
        ; Enable or disable the function layer
        enableFunctionLayer := not enableFunctionLayer
        

        ; Reset the timer
        escTapTimer := 0
        ;MsgBox, Function Layer %enableFunctionLayer%
    }
    
return

; The timer label that resets the tap count
ResetEscTapCount:
    escTapCount := 0
    escTapTimer := 0
return
