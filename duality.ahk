; Duality is a 5x3+2 keyboard layout
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
global _mouseDown := False
global _mouseMDown := False
global _mouseRDown := False
global _mouseLDown := False

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
    } else If (_mouseMDown) {
      _mouseMDown := False
      Send, {MButton Up}
    } else If (_mouseLDown) {
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
iKeyq := new iKey("q", "`~", "0", "{F10}")
iKeyw := new iKey("u", "`-", "1", "{F1}")
iKeye := new iKey("i", "{+}", "2", "{F2}")
iKeyr := new iKey("o", "`/", "3", "{F3}")
iKeyt := new iKey("y", "{*}", "4", "{F4}")

iKeyy := new iKey("k", "%", "5", "{F5}")
iKeyu := new iKey("s", "_", "6", "{F6}")
iKeyi := new iKey("h", "{Up}", "7", "{F7}")
iKeyo := new iKey("l", "`=", "8", "{F8}")
iKeyp := new iKey("{Esc}", "{RWin Down}.{RWin Up}", "9", "{F9}")

iKeya := new iKey("w", "{#}", "{@}", "{F11}")
iKeys := new iKey("a", "{Backspace}","{Backspace}",  "{Backspace}")
iKeyd := new iKey("e", "{Delete}", "{Delete}", "{Delete}") 
iKeyf := new iMouseKey("{LButton Down}",   "{RButton Down}", "{MButton Down}", "{MButton Down}")
iKeyg := new iKey("g", ["SoundDn, -5"], ["SoundUp, +5"], ["SoundSet, 0"])

iKeyh := new iKey("f", "^+;", "^``", "^``^b") 
iKeyj := new iKey(" ",  "{Left}", "{Tab}", "{Tab}")
iKeyk := new iKey("{Enter}", "{Down}", "{PgDn}",  "<{!}--{Space}{Space}-->{Left 4}")
iKeyl := new iKey("t", "{Right}", "{PgUp}", "/*{Space}{Space}*/{Left 3}")   
lKeySemicolon := new iKey("p", ";", ":ff", "::")

iKeyz := new iKey("z", "`|","`\", "{F12}")
iKeyx := new iKey("x", "{{}", "{}}", "{{}{}}{Left}")
iKeyc := new iKey("c", "(", ")", "(){Left}")
iKeyv := new iKey("v",  "<", ">", "<>{Left}")
iKeyb := new iKey("b", "[", "]", "[]{Left}")

iKeyn := new iKey("m", "{!}","`{^}", "{PrintScreen}")
iKeym := new iKey("r", "`&", "``", "````{Left}")
iKeyComma := new iKey("n", ",", "`'", "`'`'{Left}")
iKeyPeriod := new iKey("d", ".", """", """""{Left}")
iKeySlash := new iKey("j", "`?", "{$}", "${{}{}}{Left}")

; map the modifier keys to their objects  3
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