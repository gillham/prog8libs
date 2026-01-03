;
; scaffolding / getters / setters?
; query metadata here
;
input {
%option force_output
    ; joystick bits
    const ubyte UP      = %0000001
    const ubyte DOWN    = %0000010
    const ubyte LEFT    = %0000100
    const ubyte RIGHT   = %0001000
    const ubyte FIRE    = %0010000
    const ubyte FIRE_B  = %0100000
    const ubyte FIRE_C  = %1000000

    ; SNES bits
    const uword BUTTON_B        = %1000000000000000
    const uword BUTTON_Y        = %0100000000000000
    const uword BUTTON_SELECT   = %0010000000000000
    const uword BUTTON_START    = %0001000000000000
    const uword DPAD_UP         = %0000100000000000
    const uword DPAD_DOWN       = %0000010000000000
    const uword DPAD_LEFT       = %0000001000000000
    const uword DPAD_RIGHT      = %0000000100000000
    const uword BUTTON_A        = %0000000010000000
    const uword BUTTON_X        = %0000000001000000
    const uword BUTTON_L        = %0000000000100000
    const uword BUTTON_R        = %0000000000010000

    ; input device types
    ; (more like classes)
    const ubyte JOYSTICK    = 0
    const ubyte CONTROLLER  = 1
    const ubyte JOYKEY      = 2
    const ubyte KEYBOARD    = 3
    const ubyte MOUSE       = 4
    const ubyte TRACKBALL   = 6

    ; predefined features
    const uword JOY_CP      = DPAD_UP|DPAD_DOWN|DPAD_LEFT|DPAD_RIGHT|BUTTON_A
    const uword JOY_CPGS    = JOY_CP|BUTTON_B|BUTTON_X
    const uword CTL_SNES    = %1111111111110000

    struct Device {
        uword get           ; address of get routine for call()
        ubyte type          ; input device type
        ubyte buttons       ; number of buttons (excluding dpad / directions)
        uword features      ; SNES bit set (1) if button present
        str name
        str short_name
    }

    sub count() -> ubyte {
        ubyte num
        ^^uword temp = &inputdev.l_inputdevtab
        while temp^^ != $0000 {
            temp++
            num++
        }
        return num
    }

    sub decode(ubyte line, uword temp) {
        txt.plot(0,line)
        ubyte i
        for i in 1 to 10 {
            txt.print(" " * 15)
            txt.nl()
        }
        txt.plot(0,line)
        ; upper byte
        if (temp & BUTTON_B) == 0 txt.print("button_b\n")
        if (temp & BUTTON_Y) == 0 txt.print("button_y\n")
        if (temp & BUTTON_SELECT) == 0 txt.print("button_select\n")
        if (temp & BUTTON_START) == 0 txt.print("button_start\n")
        if (temp & DPAD_UP) == 0 txt.print("dpad_up\n")
        if (temp & DPAD_DOWN) == 0 txt.print("dpad_down\n")
        if (temp & DPAD_LEFT) == 0 txt.print("dpad_left\n")
        if (temp & DPAD_RIGHT) == 0 txt.print("dpad_right\n")

        ; lower byte
        if (temp & BUTTON_A) == 0 txt.print("button_a\n")
        if (temp & BUTTON_X) == 0 txt.print("button_x\n")
        if (temp & BUTTON_L) == 0 txt.print("button_l\n")
        if (temp & BUTTON_R) == 0 txt.print("button_r\n")
    }

    sub init() -> bool {
        return true
    }

    ; read joystick
    ; call(dev.get) places result directly in result
    sub get(ubyte index) -> uword {
        uword result
        ^^Device dev = getdev(index)
        call(dev.get)
;        %asm {{
;            sta  p8b_input.p8s_get.p8v_result
;            sty  p8b_input.p8s_get.p8v_result+1
;        }}
        return result
    }

    ; returns uword entry from devtab by index
    ; dereferenced twice to get to the Device struct
    sub getdev(ubyte dev) -> uword {
        ^^uword temp = &inputdev.l_inputdevtab+(dev<<1)
        temp = temp^^
        return temp^^
        ;return gettab()+(dev<<1)
    }

    ; returns address of device table
    sub gettab() -> uword {
        return &inputdev.l_inputdevtab
    }

    sub info() {
        ^^input.Device mydev
        ubyte index

        txt.print("Number of devices: ")
        txt.print_ub(count())

        repeat count() {
            txt.nl()
            mydev = getdev(index)
            txt.print("Device index: ")
            txt.print_ub(index)
            txt.nl()
            if mydev != $0000 {
                txt.print("Device name: ")
                txt.print(mydev.name)
                txt.nl()
                txt.print("Device short name: ")
                txt.print(mydev.short_name)
                txt.nl()
            }
            index++
        }
    }

    ; map classic joystick byte to SNES style 16-bit value
    sub remap(ubyte pins) -> uword {
        uword result
        pins = ~pins
        if pins & UP != 0 {
            result |= DPAD_UP
        }
        if pins & DOWN != 0 {
            result |= DPAD_DOWN
        }
        if pins & LEFT != 0 {
            result |= DPAD_LEFT
        }
        if pins & RIGHT != 0 {
            result |= DPAD_RIGHT
        }
        if pins & FIRE != 0 {
            result |= BUTTON_A
        }
        if pins & FIRE_B != 0 {
            result |= BUTTON_B
        }
        if pins & FIRE_C != 0 {
            result |= BUTTON_X
        }
        return ~result
    }
}

;
; other modules should merge here.
; this could have device structs (defined in input block)
; or I guess at the top of this block before the label?
;
inputdev {
%option force_output

l_inputdevtab:
    %asm {{
        ;.byte $12, $34
    }}
}

; input device table termination byte
inputdevtab_terminator {
    %option force_output
    ;l_inputdevtab_terminator:
    %asm {{
        .byte $00, $00  ; which termination?
        .byte $FF, $FF  ; which termination?
    }}
}

