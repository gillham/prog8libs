%import joystick
%import textio
main {
    uword snes
    ubyte pins
    sub start() {

        repeat {
            txt.cls()
            ; these return a SNES uword
;            snes = joystick.get(1)  ; control port 1 vanilla
;            snes = joystick.get(2)  ; control port 1 potx/poty buttons
;            snes = joystick.get(3)  ; control port 2
;            snes = joystick.get(4)  ; control port 2 potx/poty buttons
;            snes = joystick.get(5)  ; SNES via PETSCII Robots UserPort adapter
;            txt.print_uwbin(snes, false)
;            txt.nl()
;            decode(snes)

            ; these return a "classic" joystick uybte
;            pins = joystick.get_ub(1)  ; control port 1 vanilla
;            pins = joystick.get_ub(2)  ; control port 1 potx/poty buttons
;            pins = joystick.get_ub(3)  ; control port 2
            pins = joystick.get_ub(4)  ; control port 2 potx/poty buttons
            txt.print_ubbin(pins, false)
            txt.nl()
            decode_ub(pins)
        }
    }

    sub decode(uword temp) {
        ; upper byte
        if (temp & joystick.BUTTON_B_MASK) == 0 txt.print("button_b\n")
        if (temp & joystick.BUTTON_Y_MASK) == 0 txt.print("button_y\n")
        if (temp & joystick.BUTTON_SELECT_MASK) == 0 txt.print("button_select\n")
        if (temp & joystick.BUTTON_START_MASK) == 0 txt.print("button_start\n")
        if (temp & joystick.DPAD_UP_MASK) == 0 txt.print("dpad_up\n")
        if (temp & joystick.DPAD_DOWN_MASK) == 0 txt.print("dpad_down\n")
        if (temp & joystick.DPAD_LEFT_MASK) == 0 txt.print("dpad_left\n")
        if (temp & joystick.DPAD_RIGHT_MASK) == 0 txt.print("dpad_right\n")

        ; lower byte
        if (temp & joystick.BUTTON_A_MASK) == 0 txt.print("button_a\n")
        if (temp & joystick.BUTTON_X_MASK) == 0 txt.print("button_x\n")
        if (temp & joystick.BUTTON_L_MASK) == 0 txt.print("button_l\n")
        if (temp & joystick.BUTTON_R_MASK) == 0 txt.print("button_r\n")
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


}
