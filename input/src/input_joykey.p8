;
; dummy example of a test joystick
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

l_joykey:
    %asm {{
        .word p8b_joykey.p8v_dev0
    }}
}

;
; Should "name" be just the index 0 entry of "devnames" here?
; Then loops could be 1 to count instead of 0 to count-1?
;
joykey {
%option force_output
%option merge

    ^^input.Device dev0 = ^^input.Device: [ read_keyb, 5, "Keyboard Joystick", "keyb" ]

    sub read_keyb() {
        ubyte key = cbm.GETIN2()
        uword temp
        when key {
            $00      -> {}
            'w', 'W', $91 -> temp |= input.DPAD_UP_MASK
            'a', 'A', $9d -> temp |= input.DPAD_LEFT_MASK
            's', 'S', $11 -> temp |= input.DPAD_DOWN_MASK
            'd', 'D', $1d -> temp |= input.DPAD_RIGHT_MASK
            $0d           -> temp |= input.BUTTON_A_MASK
            else -> txt.print_ubhex(key, true)
        }
        input.get.result = ~temp
    }
}
