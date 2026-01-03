;
; Simplistic "virtual joystick" via the keyboard
;
; This should get more keys/buttons assigned since
; the keyboard has plenty.
; A custom keyboard driver/scanner would allow
; detecting 2+ keys and generally would be better
; than this which just calls cbm.GETIN2()

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

l_joykey:
    %asm {{
        .word p8b_joykey.p8v_dev0
    }}
}

;
; Device blocks should be unique and should potentially be
; longer to avoid any collisions with common keywords.
;
joykey {
%option force_output
%option merge

    ^^input.Device dev0 = ^^input.Device: [ read_keyb,
                                            input.JOYSTICK,
                                            1,
                                            input.JOY_CP,
                                            "keyboard koystick",
                                            "keyb" ]

    sub read_keyb() {
        ubyte key = cbm.GETIN2()
        uword temp
        when key {
            $00      -> {}
            'w', 'W', $91 -> temp |= input.DPAD_UP
            'a', 'A', $9d -> temp |= input.DPAD_LEFT
            's', 'S', $11 -> temp |= input.DPAD_DOWN
            'd', 'D', $1d -> temp |= input.DPAD_RIGHT
            $0d           -> temp |= input.BUTTON_A
            else -> txt.print_ubhex(key, true)
        }
        input.get.result = ~temp
    }
}
