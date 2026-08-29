;
; Fake "dummy" keyboard
;
; This makes it easy to have a "keyboard" choice
; when selecting inputs.
;
; It does not actually scan the keyboard or return data.
; Use input_joykey for a keyboard based virtual joystick

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
%option ignore_unused

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
%option ignore_unused

    ^^input.Device dev0 = ^^input.Device: [ read,
                                            input.KEYBOARD,
                                            1,
                                            input.JOY_CP,
                                            "keyboard",
                                            "keyb" ]

    ; always returns "nothing pressed"
    sub read() {
        input.get.result = $ffff
    }
}
