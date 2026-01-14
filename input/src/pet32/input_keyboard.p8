;
; Simplistic "virtual joystick" via the keyboard
;
; This makes it easy to have a "keyboard" choice
; when selecting inputs.  It also conveniently
; returns data in the SNES 16-bit data format.
;
; This is just reading the matrix coordinate of
; the current key pressed from $CB
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

    ^^input.Device dev0 = ^^input.Device: [ read,
                                            input.KEYBOARD,
                                            1,
                                            input.JOY_CP,
                                            "keyboard",
                                            "keyb" ]

    ; get the keyboard matrix scan code
    ; the state of shift is set to bit 7
    ; this allows detecting the correct arrow key
    sub read() {
        ubyte key = @($97)
        key |= (@($98) & 1) << 7
        uword temp
        when key {
            $ff     -> {}
            $91,$57     -> temp |= input.DPAD_UP
            $9d,$41 -> temp |= input.DPAD_LEFT
            $11,$53     -> temp |= input.DPAD_DOWN
            $1d,$44     -> temp |= input.DPAD_RIGHT
            $0d     -> temp |= input.BUTTON_A
            ;else -> txt.print_ubhex(key, true)
        }
        input.get.result = ~temp
    }
}
