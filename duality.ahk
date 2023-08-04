; Duality is my keyboard layout
; - @kahnpoint (adam kahn) 2023

#NoEnv
#SingleInstance, Force
#MaxThreadsPerHotkey 1 
#MaxHotkeysPerInterval 20000
;SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

; These global variables are used to keep track of 
; the state of the modifier keys
global _subDown := False
global _subFirstDown := False
global _superDown := False
global _superFirstDown := False
global _shiftDown := False
global _ctrlDown := False 
global _mouseDown := False

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
        } else {
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
    If (_superDown) {
      result := this.super
      _mouseDown := True
      Send, % result
    }
    
    If(not _mouseDown) {
      If (_subDown and _superDown) {
        result := this.supersub
      } else If (_superDown ) {
        result := this.super
      } else If (_subDown) {
        result := this.sub
      }else{
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
        Send, % result
      } 
        _mouseDown := True
    }
    
    release(){   
    global _subDown, _superDown, _mouseDown
    _mouseDown := False
    If (_subDown and _superDown) {
      Send, {MButton Up}
    } else If (_subDown) {
      Send, {RButton Up}
    } else {
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

; this class tracks the shift key
class iShiftKey {
  press() {
    global
    _shiftDown := True
    SendInput, {Shift Down}
  }
  release() {
    global
    _shiftDown := False
    SendInput, {Shift Up}
  }
}

; this class tracks the ctrl key
class iCtrlKey {
  press() {
    global
    _ctrlDown := True
    SendInput, {Ctrl Down}
  }
  release() {
    global
    _ctrlDown := False
    SendInput, {Ctrl Up}
  }
}

; create the modifier key objects 
iSubKey := new iSubKey()
iSuperKey := new iSuperKey()
;iShiftKey := new iShiftKey()
;iCtrlKey := new iCtrlKey()
;{Ctrl Down}l{Ctrl Up}cmd{Enter}", "sleep, 1200", "code . {Enter}"]
iKeyq := new iKey("q", "``", "{%}", "````{Left}")
iKeyw := new iKey("w", "`'", "{-}", "`'`'{Left}")
iKeye := new iKey("e", """", "{+}", """""{Left}")
iKeyr := new iKey("r", "_", "$", "${{}{}}{Left}")
iKeyt := new iKey("t", "λ", "Δ", "π")
iKeyy := new iKey("y", "<", ">", "<>{Left}")
iKeyu := new iKey("u", "(", ")", "(){Left}")
iKeyi := new iKey("i", "","{Up}", "")
iKeyo := new iKey("o", "{{}", "{}}", "{{}{}}{Left}")
iKeyp := new iKey("{Esc}", "{Esc}", "{Esc}", "{Esc}")

iKeya := new iKey("s", "@", "{*}", "{#}")
iKeys := new iKey("a", "`\", "`/", "{F11}")
iKeyd := new iKey("d", "`=","{Backspace}", "{F12}")
iKeyf := new iKey(" ", "{Tab}", "{Delete}", "/*{Space}{Space}*/{Left 3}")
iKeyg := new iKey("g", "`~", "", "{RWin Down}.{RWin Up}")
iKeyh := new iKey("h", "[", "]", "[]{Left}")
iKeyj := new iMouseKey("{LButton Down}",  "{RButton Down}", "{Left}", "{MButton Down}")
iKeyk := new iKey("{Enter}", "^+;", "{Down}", "")
iKeyl := new iKey("l", "^``","{Right}", "^``^b")   
lKeySemicolon := new iKey("p", ";", ":", "::")

iKeyz := new iKey("z", "0", "", "{F10}")
iKeyx := new iKey("x", "1", "", "{F1}")
iKeyc := new iKey("c", "2", "", "{F2}")
iKeyv := new iKey("v", "3", "{^}", "{F3}")
iKeyb := new iKey("b", "4", "`|", "{F4}")
iKeyn := new iKey("n", "5", "`&", "{F5}")
iKeym := new iKey("m", "6", "{`!}", "{F6}")
iKeyComma := new iKey("f", "7", "`,", "{F7}")
iKeyPeriod := new iKey("k", "8", "`.", "{F8}")
iKeySlash := new iKey("j", "9", "`?", "{F9}")

; map the modifier keys to their objects  3
*LAlt::iSubKey.press()
*LAlt Up::iSubKey.release()
*Space::iSuperKey.press()
*Space Up::iSuperKey.release()


;*LShift::iShiftKey.press()
;*LShift Up::iShiftKey.release()
;*RShift::iShiftKey.press()
;*RShift Up::iShiftKey.release()

;*LCtrl::iCtrlKey.press()
;*LCtrl Up::iCtrlKey.release()
;*RCtrl::iCtrlKey.press()
;*RCtrl Up::iCtrlKey.release()

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
*g::iKeyg.press()
*h::iKeyh.press()
*j::iKeyj.press()
*j Up::iKeyj.release()
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
