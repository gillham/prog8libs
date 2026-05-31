platform {
    const bool SCAN_ALL = false
    const bool MONOCHROME = true

    sub init() {
        ;c64.EXTCOL = 0
        ;c64.BGCOL0 = 0
    }

    ; adjust characters returned from waitkey?
    sub adjust(ubyte char) -> ubyte {
        ; debug
        txt.plot(0,3)
        txt.print("debug: ")
        txt.chrout(char)
        txt.nl()
        when char {
            '0' -> return $30
            '1' -> return $31
            '2' -> return $32
            '3' -> return $33
            '4' -> return $34
            '5' -> return $35
            '6' -> return $36
            '7' -> return $37
            '8' -> return $38
            '9' -> return $39
        }
        return $ff
    }
}

;
; platforms should define native joystick directions
; for input.remap() to decode and create SNES data.
; (must be defined, even if not used on this platform)
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
