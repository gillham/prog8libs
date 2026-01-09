;
; VIC-20 control port joystick
; This module supports vanilla VIC-20 joysticks
; with a single fire button as well as C64GS
; style with a 2nd on ????.  A 3rd on ????
; is also supported. 
;
; A 5 button joystick using up&down and left&right
; for buttons 4 and 5 should be easy enough to
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
    ^^input.Device dev1 = ^^input.Device: [ read_cp1gs,
                                            input.JOYSTICK,
                                            2,
                                            input.JOY_CPGS,
                                            "c64gs port 1",
                                            "cp1gs" ]

    sub read_port1() {
        input.get.result = input.remap(read_cp1())
    }

    sub read_cp1gs() {
        input.get.result = input.remap(read_cpgs_ub())
    }

    asmsub read_cp1() -> ubyte @A {
        %asm {{
            sei
            ;lda  vic20.VIA1PA1      ; read port A?
            lda  vic20.VIA1PA2      ; read port A mirror
            and  #%00111100         ; mask joystick pins
            sta  P8ZP_SCRATCH_B1    ; save
            lda  #%01111111
            sta  vic20.VIA2DDRB     ; set pin 7 input
            ldx  vic20.VIA2PB       ; read joy 3 into X
            lda  #%11111111
            sta  vic20.VIA2DDRB     ; back to all output
            txa
            and  #%10000000         ; mask off the bit we want
            ora  P8ZP_SCRATCH_B1    ; combine with other joystick bits
            ora  #%01000011          ; turn on unused bits for now
            cli
            rts
        }}
    }

    sub read_cpgs_ub() -> ubyte {
        ubyte pins

        pins = read_cp1()
        read_potxy($7f)

        if joystick.read_potxy.potx < $10 {
            pins &= ~input.FIRE_B
        }
        if joystick.read_potxy.poty < $10 {
            pins &= ~input.FIRE_C
        }
        return pins
    }

    sub read_potxy(ubyte cfg) {
        ubyte potx = vic20.VICCR8
        ubyte poty = vic20.VICCR9
;        txt.plot(0,4)
;        txt.print_ubhex(potx, false)
;        txt.spc()
;        txt.print_ubhex(poty, false)
;        txt.spc()

        return
        %asm {{
            sei         ; disable interrupts
            lda  p8b_joystick.p8s_read_potxy.p8v_cfg
            sta  $dc00  ; set to read control port potx/poty
            ldx  #$72   ; burn 1023 cycles (ish)
-           nop
            nop
            dex
            bne  -
            lda  $d419  ; read paddle X value
            sta  p8b_joystick.p8s_read_potxy.p8v_potx
            lda  $d41a  ; read paddle Y value
            sta  p8b_joystick.p8s_read_potxy.p8v_poty
            cli
        }}
    }



}
