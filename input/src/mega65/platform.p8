;
; Platform specific bits
;
platform {
    const bool SCAN_ALL = true
    const bool MONOCHROME = false

    sub init() {

        ; black background & border
        c64.EXTCOL = 0
        c64.BGCOL0 = 0

        ; switch to 40 column mode
        txt.chrout(27)
        txt.chrout('4')

        ; delay long enough for any keys to clear
        ; could just be emulator, needs more testing
        sys.wait(10)
    }
}

;
; platforms should define native joystick directions
; for input.remap() to decode and create SNES data.
;
input {
%option merge
    ; joystick bits
    const ubyte UP      = %0000001
    const ubyte DOWN    = %0000010
    const ubyte LEFT    = %0000100
    const ubyte RIGHT   = %0001000
    const ubyte FIRE    = %0010000
    const ubyte FIRE_B  = %0100000  ; POTX
    const ubyte FIRE_C  = %1000000  ; POTY
    const ubyte SELECT  = %0000011  ; UP+DOWN together
    const ubyte START   = %0001100  ; LEFT+RIGHT together
}
