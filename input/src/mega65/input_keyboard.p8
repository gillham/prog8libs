;
; Simplistic "virtual joystick" via the keyboard
;
; This makes it easy to have a "keyboard" choice
; when selecting inputs.  It also conveniently
; returns data in the SNES 16-bit data format.
;
; On MEGA65 this reads the keyboard matrix registers
; and decodes any of WASD/Return or cursor keys.
; These are decoded into appropriate SNES data bits.
;

;
; This block holds a uword pointer to a Device
; struct. *NOTHING* else should be in this block.
;
; The <drivername> can be a short name or the block,
; but needs to be unique across all devices.
; Also the label isn't strictly needed unless the
; driver needs to find its own struct.
;
; l_<drivername>:
;
inputdev {
%option force_output
%option merge

l_keyboard:
    %asm {{
        .word p8b_keyboard.p8v_dev0
    }}
}

;
; Device blocks should be unique and should potentially be
; longer to avoid any collisions with common keywords.
;
keyboard {
%option force_output
%option merge

    ubyte[10] keymatrix                     ; 9 key matrix columns + disambiguation bits

    ^^input.Device dev0 = ^^input.Device: [ read,
                                            input.KEYBOARD,
                                            1,
                                            input.JOY_CP,
                                            "keyboard",
                                            "keyb" ]

    ; scan the key matrix
    ; return the decoded (to SNES) data
    sub read() {
        key_scan()
        input.get.result = key_decode_snes()
    }

    sub key_decode_snes() -> uword {
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
        return ~temp
    }

    sub key_scan() {
        uword temp
        %asm {{
            ldx  #0                             ; index 0 column & keymatrix
-           txa
            sta  $d614                          ; C65 matrix column select
            lda  $d613                          ; read matrix column data
            sta  p8b_keyboard.p8v_keymatrix,x
            inx                                 ; increment column & keymatrix
            txa
            cmp #9                              ; check if we did all 0-8 indexes
            bne -
            lda  mega65.MISCKEY                 ; disambiguation bits
            and  #%00000011                     ; bit 1 set = up, bit 0 set = left
            sta  p8b_keyboard.p8v_keymatrix,x   ; final byte in array
            rts
        }}
    }
}
