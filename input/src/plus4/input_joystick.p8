;
; C64 control port joysticks
; This module supports vanilla C64 joysticks
; with a single fire button as well as C64GS
; style with a 2nd on POTX.  A 3rd on POTY
; is also supported. 
;
; A 5 button joystick using up&down and left&right
; for buttons 4 and 5 should be easy enouhg to
; support once I get one.
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

l_joystick:
    %asm {{
        .word p8b_joystick.p8v_dev0
        .word p8b_joystick.p8v_dev1
    }}
}

;
; 
;
joystick {
%option force_output
%option merge

    ^^input.Device dev0 = ^^input.Device: [ read_port1,
                                            input.JOYSTICK,
                                            1,
                                            input.JOY_CP,
                                            "joystick 1",
                                            "port1" ]
    ^^input.Device dev1 = ^^input.Device: [ read_port2,
                                            input.JOYSTICK,
                                            1,
                                            input.JOY_CP,
                                            "joystick 2",
                                            "port2" ]

    sub read_port1() {
        input.get.result = input.remap(read_cp1())
    }

    sub read_port2() {
        input.get.result = input.remap(read_cp2())
    }

    asmsub read_cp1() -> ubyte @A {
        %asm {{
            sei
            ldx  #%11111111     ; don't read keyboard
            stx  plus4.PIO2     ; store to keyboard latch
            ldx  #%11111011     ; select port 1
            stx  plus4.KEYBOARD ; write to joystick latch
            lda  plus4.KEYBOARD ; load response
            tax                 ; save response
            and  #%01000000     ; check for fire button
            bne  +              ; no fire button (0 = pressed, 1 = not pressed)
            txa                 ; restore response
            and  #%11101111     ; clear fire button bit (to indicate pressed)
            ora  #%11100000     ; mask off non joystick bits
            cli
            rts
+           txa                 ; restore response
            ora  #%11110000     ; mask off non joystick bits ( and shifted fire button)
            cli
            rts
        }}
    }

    asmsub read_cp2() -> ubyte @A {
        %asm {{
            sei
            ldx  #%11111111     ; don't read keyboard
            stx  plus4.PIO2     ; store to keyboard latch
            ldx  #%11111101     ; select port 2
            stx  plus4.KEYBOARD ; write to joystick latch
            lda  plus4.KEYBOARD ; load response
            tax                 ; save response
            and  #%10000000     ; check for fire button
            bne  +              ; no fire button (0 = pressed, 1 = not pressed)
            txa                 ; restore response
            and  #%11101111     ; clear fire button bit (to indicate pressed)
            ora  #%11100000     ; mask off non joystick bits
            cli
            rts
+           txa                 ; restore response
            ora  #%11110000     ; mask off non joystick bits ( and shifted fire button)
            cli
            rts
        }}
    }
}
