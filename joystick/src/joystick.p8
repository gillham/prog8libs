;
; read joystick ports
;
joystick {
    const ubyte UP      = %0000001
    const ubyte DOWN    = %0000010
    const ubyte LEFT    = %0000100
    const ubyte RIGHT   = %0001000
    const ubyte FIRE    = %0010000
    const ubyte FIRE_B  = %0100000
    const ubyte FIRE_C  = %1000000

    sub get(ubyte joynum) -> uword {
        when joynum {
            0 -> return $00
            1 -> return remap(read_cp1())
            2 -> return remap(read_cp2())
            3 -> return remap(read_cpgs_ub(1))
            4 -> return remap(read_cpgs_ub(2))
            5 -> return read_petscii_snes()
        }
    }

    sub get_ub(ubyte joynum) -> ubyte {
        when joynum {
            0 -> return $00
            1 -> return read_cp1()
            2 -> return read_cp2()
            3 -> return read_cpgs_ub(1)
            4 -> return read_cpgs_ub(2)
        }
    }

    inline asmsub set_potxy(ubyte value @A) {
        %asm {{
            sta  $dc00  ; set which control port paddles for SID to read 
        }}
    }

    ; map classic joystick byte to SNES style 16-bit value
    sub remap(ubyte pins) -> uword {
        uword result
        pins = ~pins
        if pins & UP != 0 {
            result |= DPAD_UP_MASK
        }
        if pins & DOWN != 0 {
            result |= DPAD_DOWN_MASK
        }
        if pins & LEFT != 0 {
            result |= DPAD_LEFT_MASK
        }
        if pins & RIGHT != 0 {
            result |= DPAD_RIGHT_MASK
        }
        if pins & FIRE != 0 {
            result |= BUTTON_A_MASK
        }
        if pins & FIRE_B != 0 {
            result |= BUTTON_B_MASK
        }
        if pins & FIRE_C != 0 {
            result |= BUTTON_X_MASK
        }
        return ~result
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
            pins &= ~FIRE_B
        }
        if joystick.read_potxy.poty < $10 {
            pins &= ~FIRE_C
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


    const uword BUTTON_B_MASK       = %1000000000000000
    const uword BUTTON_Y_MASK       = %0100000000000000
    const uword BUTTON_SELECT_MASK  = %0010000000000000
    const uword BUTTON_START_MASK   = %0001000000000000
    const uword DPAD_UP_MASK        = %0000100000000000
    const uword DPAD_DOWN_MASK      = %0000010000000000
    const uword DPAD_LEFT_MASK      = %0000001000000000
    const uword DPAD_RIGHT_MASK     = %0000000100000000
    const uword BUTTON_A_MASK       = %0000000010000000
    const uword BUTTON_X_MASK       = %0000000001000000
    const uword BUTTON_L_MASK       = %0000000000100000
    const uword BUTTON_R_MASK       = %0000000000010000

    sub decode(uword temp) {
        ; upper byte
        if (temp & BUTTON_B_MASK) == 0 txt.print("button_b\n")
        if (temp & BUTTON_Y_MASK) == 0 txt.print("button_y\n")
        if (temp & BUTTON_SELECT_MASK) == 0 txt.print("button_select\n")
        if (temp & BUTTON_START_MASK) == 0 txt.print("button_start\n")
        if (temp & DPAD_UP_MASK) == 0 txt.print("dpad_up\n")
        if (temp & DPAD_DOWN_MASK) == 0 txt.print("dpad_down\n")
        if (temp & DPAD_LEFT_MASK) == 0 txt.print("dpad_left\n")
        if (temp & DPAD_RIGHT_MASK) == 0 txt.print("dpad_right\n")

        ; lower byte
        if (temp & BUTTON_A_MASK) == 0 txt.print("button_a\n")
        if (temp & BUTTON_X_MASK) == 0 txt.print("button_x\n")
        if (temp & BUTTON_L_MASK) == 0 txt.print("button_l\n")
        if (temp & BUTTON_R_MASK) == 0 txt.print("button_r\n")

    }

    sub decode_ub(ubyte temp) {
        ; classic byte
        if (temp & joystick.FIRE) == 0 txt.print("fire\n")
        if (temp & joystick.FIRE_B) == 0 txt.print("fire_b\n")
        if (temp & joystick.FIRE_C) == 0 txt.print("fire_c\n")
        if (temp & joystick.UP) == 0 txt.print("up\n")
        if (temp & joystick.DOWN) == 0 txt.print("down\n")
        if (temp & joystick.LEFT) == 0 txt.print("left\n")
        if (temp & joystick.RIGHT) == 0 txt.print("right\n")
    }

    sub read_petscii_snes() -> uword {
        uword pins

        ; set data direction pins
        sys.set_irqd()
        c64.CIA2DDRB |= %00101000
        sys.clear_irqd()

        ; set latch high on pin 5
        c64.CIA2PRB  = %00100000
        ; set latch low
        c64.CIA2PRB  = %00000000

        repeat 16 {
            ; make room for next bit
            pins = pins << 1

            ; read pin 6
            if (c64.CIA2PRB & %01000000) != 0 {
                pins |= 1
            }

            ; pulse clock high on pin 3
            c64.CIA2PRB  = %00001000

            ; set clock low
            c64.CIA2PRB  = %00000000
        }
        return pins
    }
}
