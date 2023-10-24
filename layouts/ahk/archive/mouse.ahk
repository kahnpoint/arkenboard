#Persistent
SetTimer, WatchMouse, 10 ; Check every 10 milliseconds
global originalX := 0
global originalY := 0
global originalLock := False
return

WatchMouse:
KeyIsDown := GetKeyState("LAlt", "P") ; Check if LShift is pressed

if (KeyIsDown) {

    if (originalX = 0 and originalY = 0 and originalLock = False) {
        MouseGetPos, originalX, originalY ; Capture the original position when LShift is first pressed
        originalLock := True
    }

    MouseGetPos, x2, y2 ; Get current mouse position
    
    ; Calculate the distance moved
    dx := x2 - originalX
    dy := y2 - originalY

    ; Proportionally send scroll based on Y-axis movement
    WheelDelta := dy / 30 ; Adjust the divisor for desired sensitivity
    Loop, % Round(Abs(WheelDelta)) {
        if (WheelDelta > 0)
            Send {WheelUp}
        else
            Send {WheelDown}
    }
    
    ; Lock the mouse to the original position
    MouseMove, originalX, originalY, 0 ; Reset mouse position to original position without animation
} else {
    originalX := 0 ; Reset the original X and Y coordinates when LShift is released
    originalY := 0
    originalLock := False
}
return
