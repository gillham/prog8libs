%import input
%import input_joykey
%import input_joystick
%import input_snes_petscii
%import textio
main {
    uword snes
    ubyte pins
    sub start() {
        ^^input.Device dev = input.getdev(5)

        txt.lowercase()

        repeat {
            txt.cls()
            ; the device order varies by what is imported above
            ; these return a SNES uword
;            snes = input.get(0)  ; virtual joystick on keyboard
;            snes = input.get(1)  ; control port 1 vanilla
;            snes = input.get(2)  ; control port 2 vanilla
;            snes = input.get(3)  ; control port 1 potx/poty buttons
;            snes = input.get(4)  ; control port 2 potx/poty buttons
            snes = input.get(5)  ; SNES via PETSCII Robots UserPort adapter
            txt.print_uwbin(snes, false)
            txt.spc()
            txt.print(dev.name)
            txt.nl()
            decode(snes)

        }
    }

    sub decode(uword temp) {
        ; upper byte
        if (temp & input.BUTTON_B_MASK) == 0 txt.print("button_b\n")
        if (temp & input.BUTTON_Y_MASK) == 0 txt.print("button_y\n")
        if (temp & input.BUTTON_SELECT_MASK) == 0 txt.print("button_select\n")
        if (temp & input.BUTTON_START_MASK) == 0 txt.print("button_start\n")
        if (temp & input.DPAD_UP_MASK) == 0 txt.print("dpad_up\n")
        if (temp & input.DPAD_DOWN_MASK) == 0 txt.print("dpad_down\n")
        if (temp & input.DPAD_LEFT_MASK) == 0 txt.print("dpad_left\n")
        if (temp & input.DPAD_RIGHT_MASK) == 0 txt.print("dpad_right\n")

        ; lower byte
        if (temp & input.BUTTON_A_MASK) == 0 txt.print("button_a\n")
        if (temp & input.BUTTON_X_MASK) == 0 txt.print("button_x\n")
        if (temp & input.BUTTON_L_MASK) == 0 txt.print("button_l\n")
        if (temp & input.BUTTON_R_MASK) == 0 txt.print("button_r\n")
    }
}
