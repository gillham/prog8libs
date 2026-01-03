;
; C64 control port joysticks
; This module supports vanilla C64 joysticks
; with a signle fire button as well as C64GS
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
        .word p8b_joystick.p8v_dev2
        .word p8b_joystick.p8v_dev3
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
    ^^input.Device dev2 = ^^input.Device: [ read_cp1gs,
                                            input.JOYSTICK,
                                            2,
                                            input.JOY_CPGS,
                                            "c64gs port 1",
                                            "cp1gs" ]
    ^^input.Device dev3 = ^^input.Device: [ read_cp2gs,
                                            input.JOYSTICK,
                                            2,
                                            input.JOY_CPGS,
                                            "c64gs port 2",
                                            "cp2gs" ]

    sub read_port1() {
        input.get.result = input.remap(read_cp1())
    }

    sub read_port2() {
        input.get.result = input.remap(read_cp2())
    }

    sub read_cp1gs() {
        input.get.result = input.remap(read_cpgs_ub(1))
    }

    sub read_cp2gs() {
        input.get.result = input.remap(read_cpgs_ub(2))
    }

    asmsub read_cp1() -> ubyte @A {
        %asm {{
            sei
            ldx  #$7f
            stx  c64.CIA1ICR    ; disable all CIA1 interrupts
            ldx  #$ff
            stx  c64.CIA1PRA    ; set all port *A* high to ignore all columns
            lda  c64.CIA1PRB    ; read port *B* (control port 1) now
            ora  #%11100000     ; mask off non joystick bits
            ldx  #$81
            stx  c64.CIA1ICR    ; re-enable CIA1 timer A interrupt
            cli
            rts
        }}
    }

    asmsub read_cp2() -> ubyte @A {
        %asm {{
            sei
            ldx  #$7f
            stx  c64.CIA1ICR    ; disable all CIA1 interrupts
;            ldx  #$ff
;            stx  c64.CIA1PRA    ; set all port *A* high to ignore all columns
            lda  c64.CIA1PRA    ; read port two
            ora  #%11100000     ; mask off non joystick bits
            ldx  #$81
            stx  c64.CIA1ICR    ; re-enable CIA1 timer A interrupt
            cli
            rts
        }}
    }

    sub read_cpgs_ub(ubyte port) -> ubyte {
        ubyte pins

        when port {
            1 -> {
                pins = read_cp1()
                read_potxy($7f)
            }
            2 -> {
                pins = read_cp2()
                read_potxy($bf)
            }
        }

        if joystick.read_potxy.potx < $10 {
            pins &= ~input.FIRE_B
        }
        if joystick.read_potxy.poty < $10 {
            pins &= ~input.FIRE_C
        }
        return pins
    }

    sub read_potxy(ubyte cfg) {
        ubyte potx
        ubyte poty
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
