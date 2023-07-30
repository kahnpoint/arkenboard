; Duality is my keyboard layout
; - @kahnpoint (adam kahn) 2023

#NoEnv
#SingleInstance, Force
;#MaxThreadsPerHotkey 1
SendMode, Input
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
    global _subDown, _superDown, _shiftDown, _ctrlDown
    result := ""
    If (_subDown and _superDown) {
      result := this.supersub
    } else If (_subDown) {
      result := this.sub
    } else If (_superDown) {
      result := this.super
    } else {
      ; add modifiers to the default value
      result := this.default
      if (_shiftDown) {
        result := "+" . result
      }
      if (_ctrlDown) {
        result := "^" . result
      }
      if (GetKeyState("Alt")){
        result := "!" . result
      }
      if (GetKeyState("LWin") or GetKeyState("RWin")){
        result := "#" . result
      }
      
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
      SendInput, % result
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
iSubKeyd := new iSubKey()
iSuperKeyk := new iSuperKey()
iShiftKey := new iShiftKey()
iCtrlKey := new iCtrlKey()

; create the key objects
iKeyq := new iKey("q", 5, 0, "{Ctrl Down}{Shift Down}p{Shift Up}{Ctrl Up}")
iKeyw := new iKey("w", 6, 1, "#.")
iKeye := new iKey("e", 7, 2, "{Esc}")
iKeyr := new iKey("r", 8, 3, "{F2}")
iKeyt := new iKey("t", 9, 4, ["{Ctrl Down}l{Ctrl Up}cmd{Enter}", "sleep, 1200", "code . {Enter}"])
iKeyy := new iKey("y", "{CtrlDown}``{CtrlUp}", "{Ctrl Down}{b}{CtrlUp}", "^+`;")
iKeyu := new iKey("u", "<", ">", "<>{Left}")
iKeyi := new iKey("i", "[", "]", "[]{Left}")
iKeyo := new iKey("o", "{", "}", "{{}{}}{Left}")
iKeyp := new iKey("p", "(", ")", "(){Left}")
iKeya := new iKey("a", "/", "@", "/*{Space}{Space}*/{Left 3}")
iKeys := new iKey("s", "{Tab}", "{Backspace}", "{Alt Down}{Tab}{Alt Up}")
iKeyf := new iKey("f", "{Shift Down}", "{Delete}", "{Shift Down}")
iKeyg := new iKey("g", "λ", "Δ", "π")
iKeyh := new iKey("h", "_", "-", "#")
iKeyj := new iKey(" ", "{Down}", "{Left}", "{Down}")
iKeyl := new iKey("{Enter}", "{Up}", "{Right}","{Up}")
lKeySemicolon := new iKey("l", "{RButton}",";", "{MButton}")
iKeyz := new iKey("z", "`'", "{Ctrl Down}z{Ctrl Up}", "`'`'{Left}")
iKeyx := new iKey("x", """", "{Ctrl Down}x{Ctrl Up}", """""{Left}")
iKeyc := new iKey("c", ":", "{Ctrl Down}c{Ctrl Up}", "::")
iKeyv := new iKey("v", "``", "{Ctrl Down}v{Ctrl Up}", "````{Left}")
iKeyb := new iKey("b", "|", "{Ctrl Down}y{Ctrl Up}", "\")
iKeyn := new iKey("n", "&", "+", "{^}")
iKeym := new iKey("m", "`!", "*", "<{!}--{Space}{Space}-->{Left}{Left}{Left}{Left}")
iKeyComma := new iKey("d", ",", "%", "")
iKeyPeriod := new iKey("k", ".", "=", ":=")
iKeySlash := new iKey("j", "?", "$", "${{}{}}{Left}")

; map the modifier keys to their objects
*d::iSubKeyd.press()
*d Up::iSubKeyd.release()
*k::iSuperKeyk.press()
*k Up::iSuperKeyk.release()

*LShift::iShiftKey.press()
*LShift Up::iShiftKey.release()
*RShift::iShiftKey.press()
*RShift Up::iShiftKey.release()

*LCtrl::iCtrlKey.press()
*LCtrl Up::iCtrlKey.release()
*RCtrl::iCtrlKey.press()
*RCtrl Up::iCtrlKey.release()

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
*f::iKeyf.press()
*f Up::iShiftKey.release() ; this is a special case for the f key's downshift behavior
*g::iKeyg.press()
*h::iKeyh.press()
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
*j::iKeyj.press()
*l::iKeyl.press()
*`;::lKeySemicolon.press()