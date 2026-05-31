%zeropage dontuse
%import textio

main {
    ubyte key
    bool status
    sub start() {
        ubyte i

        mega65.speed(1)
        txt.cls()
        
        uword pins
        repeat {
            input.key_scan()            ; scan into input.keymatrix
            pins = input.key_decode()   ; decode matrix to SNES pins
            txt.plot(0,0)
            txt.print_uwbin(pins, false)
            txt.nl()

            for i in 0 to 8 {
                txt.print_ubbin(scancolumns(i), false)
                txt.nl()
            }
        }
    }

    asmsub scancolumns(ubyte column @A) -> ubyte @A {
        %asm {{
            sta  $d614          ; C65 matrix column select
            lda  $d613          ; read matrix column data
            rts                 ; return column data
        }}
    }
}

input {
    ubyte[10] keymatrix         ; 9 key matrix columns + disambiguation bits

    sub key_decode() -> uword {
        uword temp

        ; up/down arrow
        if keymatrix[0] & %10000000 == 0 {
            if keymatrix[9] & %00000010 == 0 {
                temp |= input.DPAD_DOWN
            } else {
                temp |= input.DPAD_UP
            }
        }
        ; left/right arrow
        if keymatrix[0] & %00000100 == 0 {
            if keymatrix[9] & %00000001 == 0 {
                temp |= input.DPAD_RIGHT
            } else {
                temp |= input.DPAD_LEFT
            }
        }
        ; w/W
        if keymatrix[1] & %00000010 == 0 {
            temp |= input.DPAD_UP
        }
        ; a/A
        if keymatrix[1] & %00000100 == 0 {
            temp |= input.DPAD_LEFT
        }
        ; s/S
        if keymatrix[1] & %00100000 == 0 {
            temp |= input.DPAD_DOWN
        }
        ; d/D
        if keymatrix[2] & %00000100 == 0 {
            temp |= input.DPAD_RIGHT
        }
        ; return
        if keymatrix[0] & %00000010 == 0 {
            temp |= input.BUTTON_A
        }

        return temp
    }

    sub key_scan() {
        uword temp
        %asm {{
            ldx  #0             ; index 0 column & keymatrix
-           txa
            sta  $d614          ; C65 matrix column select
            lda  $d613          ; read matrix column data
            sta  p8b_input.p8v_keymatrix,x
            inx                 ; index 1 column & keymatrix
            txa
            cmp #9              ; check if we did all 0-8 indexes
            bne -
            lda  $d60f          ; disambiguation bits
            and  #%00000011     ; bit 1 set = up, bit 0 set = left
            sta  p8b_input.p8v_keymatrix,x  ; final byte in array
            rts
        }}
    }

    ; SNES bits
    ; high byte
    const uword BUTTON_B        = %1000000000000000
    const uword BUTTON_Y        = %0100000000000000
    const uword BUTTON_SELECT   = %0010000000000000
    const uword BUTTON_START    = %0001000000000000
    const uword DPAD_UP         = %0000100000000000
    const uword DPAD_DOWN       = %0000010000000000
    const uword DPAD_LEFT       = %0000001000000000
    const uword DPAD_RIGHT      = %0000000100000000
    ; low byte
    const uword BUTTON_A        = %0000000010000000
    const uword BUTTON_X        = %0000000001000000
    const uword BUTTON_L        = %0000000000100000
    const uword BUTTON_R        = %0000000000010000


}
