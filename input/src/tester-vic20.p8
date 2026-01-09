%zeropage dontuse

%import input
%import input_keyboard
%import input_joystick
%import input_snes_petscii

%import platform

%import strings
%import textio

main {
    ^^input.Device mydev
    ubyte key

    sub start() {
        ubyte port = 255
        uword pins
        uword last_pins

        platform.init()

;        txt.cls()
;        repeat {
;            txt.plot(0,0)
;            txt.print_ubbin(joystick.read_cp1(), false)
;        }

        repeat {
            last_pins = 255
            txt.cls()
            draw.screen()
            txt.plot(0,0)
            port = selector()
            mydev = input.getdev(port)

            txt.cls()
            draw.screen()
            repeat {
                key = cbm.GETIN2()
                if key == ' ' or key == 'j' or key == 'm' break
                pins = input.get(port)
                if pins == last_pins continue
                last_pins = pins
                txt.plot(0,0)
                txt.color(cbm.COLOR_WHITE)
                txt.print_uwbin(pins, false)
                txt.nl()
                txt.nl()
                txt.print(mydev.name)
                decode(pins)
            }
            key = port = 0
        }
    }

    sub decode(uword temp) {

        ; upper byte
        if (temp & input.BUTTON_B) == 0 {
            draw.buttons.circle(16,17,2)     ; B
        } else {
            draw.buttons.circle(16,17,6)     ; B
        }
        if (temp & input.BUTTON_Y) == 0 {
            draw.buttons.circle(14,15,2)     ; Y
        } else {
            draw.buttons.circle(14,15,3)    ; Y
        }
        if (temp & input.BUTTON_SELECT) == 0 {
            draw.selectstart.half(9,16,2)      ; select
            draw.selectstart.half(10,15,2)      ; select
        } else {
            draw.selectstart.half(9,16,platform.select_color)      ; select
            draw.selectstart.half(10,15,platform.select_color)      ; select
        }
        if (temp & input.BUTTON_START) == 0 {
            draw.selectstart.half(11,16,2)      ; start
            draw.selectstart.half(12,15,2)      ; start
        } else {
            draw.selectstart.half(11,16,platform.start_color)      ; start
            draw.selectstart.half(12,15,platform.start_color)      ; start
        }
        if (temp & input.DPAD_UP) == 0 {
            draw.dpad.updown(14, 2)      ; up
        } else {
            draw.dpad.updown(14, platform.dpad_color)      ; up
        }
        if (temp & input.DPAD_DOWN) == 0 {
            draw.dpad.updown(17, 2)      ; down
        } else {
            draw.dpad.updown(17, platform.dpad_color)      ; down
        }
        if (temp & input.DPAD_LEFT) == 0 {
            draw.dpad.leftright(4, 2)    ; left
        } else {
            draw.dpad.leftright(4, platform.dpad_color)    ; left
        }
        if (temp & input.DPAD_RIGHT) == 0 {
            draw.dpad.leftright(7, 2)   ; right
        } else {
            draw.dpad.leftright(7, platform.dpad_color)   ; right
        }

        ; lower byte
        if (temp & input.BUTTON_A) == 0 {
            draw.buttons.circle(18,15,2)     ; A
        } else {
            draw.buttons.circle(18,15,6)     ; A
        }
        if (temp & input.BUTTON_X) == 0 {
            draw.buttons.circle(16,13,2)    ; X
        } else {
            draw.buttons.circle(16,13,3)    ; X
        }
        if (temp & input.BUTTON_L) == 0 {
            draw.shoulders.left(2)            ; left shoulder
        } else {
            draw.shoulders.left(platform.shoulder_color)            ; left shoulder
        }
        if (temp & input.BUTTON_R) == 0 {
            draw.shoulders.right(2)           ; right shoulder
        } else {
            draw.shoulders.right(platform.shoulder_color)           ; right shoulder
        }
    }

    sub menu() -> ubyte {
        ubyte i
        ubyte port
        txt.plot(0,0)
        txt.print("-= controller menu =-")
        txt.nl()
        for i in 1 to input.count() {
            mydev = input.getdev(i-1)
            txt.print_ub(i)
            txt.chrout('.')
            txt.spc()
            txt.print(mydev.name)
            txt.nl()
        }

        txt.print("choice? 1-")
        txt.print_ub(input.count())
        while port < 1 or port > input.count() {
            key = txt.waitkey()
            port = key - '0'
        }
        port--
        return port
    }

    sub selector() -> ubyte {
        ubyte index = 0
        ubyte last_index = 1        ; needs to be different from index initially
        ubyte count = input.count()
        bool done = false
        ;uword pins = $ffff
        ubyte length
        bool last_button_a
        bool last_dpad_left
        bool last_dpad_right

        do {
            if index != last_index {
                last_index = index
                txt.plot(0,8)
                repeat txt.DEFAULT_WIDTH {
                    txt.spc()
                }
            }
            mydev = input.getdev(index)
            length = strings.length(mydev.name)
            if length+2 < txt.DEFAULT_WIDTH {
                txt.plot((txt.DEFAULT_WIDTH-length)/2,8)
            } else {
                txt.plot(0,8)
            }
            txt.color(5)
            txt.rvs_on()
;            txt.print("< ")
            txt.print(mydev.name)
;            txt.print(" >")
            txt.rvs_off()
            ;input.clear()
            input.scan_all()
            ;decode(pins)
            done = input.button_a or input.button_b or input.button_x
            done = done or input.button_y or input.button_r or input.button_l
            ;if input.button_a != last_button_a and input.button_a == true done=true
            if input.dpad_left != last_dpad_left and input.dpad_left == true {
                if index > 0
                    index--
            }
            if input.dpad_right != last_dpad_right and input.dpad_right == true {
                if index < count-1
                    index++
            }
            last_button_a = input.button_a
            last_dpad_left = input.dpad_left
            last_dpad_right = input.dpad_right
            ;pins = $ffff
            if cbm.GETIN2() == 'm' {
                txt.plot(0,9)
                repeat txt.DEFAULT_WIDTH {
                    txt.spc()
                }
                return menu()
            }
        } until done
        return index
    }
}

draw {
    sub screen() {
        ; draw initial state
        controller()
        dpad()
        selectstart()
        buttons()
        shoulders()
    }

    sub controller() {

        ; top line
        txt.color(15)       ; need color defines
        txt.plot(3,11)
        txt.chrout(scr2pet($4e))
        repeat 14 {
            txt.chrout(scr2pet($77))
        }
        txt.chrout(scr2pet($4d))
        ; second line
        txt.plot(2,12)
        txt.chrout(scr2pet($4e))
        txt.plot(19,12)
        txt.chrout(scr2pet($4d))

        ; third line
        txt.plot(1,13)
        txt.chrout(scr2pet($4e))
        txt.plot(20,13)
        txt.chrout(scr2pet($4d))

        ; 4th line
        txt.plot(0,14)
        txt.chrout(scr2pet($5d))
        txt.plot(21,14)
        txt.chrout(scr2pet($5d))

        ; 5th line
        txt.plot(0,15)
        txt.chrout(scr2pet($5d))
        txt.plot(21,15)
        txt.chrout(scr2pet($5d))

        ; 6th line
        txt.plot(0,16)
        txt.chrout(scr2pet($5d))
        txt.plot(21,16)
        txt.chrout(scr2pet($5d))

        ; 7th line
        txt.plot(0,17)
        txt.chrout(scr2pet($5d))
        txt.plot(21,17)
        txt.chrout(scr2pet($5d))

        ; 8th line
        txt.plot(0,18)
        txt.chrout(scr2pet($5d))
        txt.plot(21,18)
        txt.chrout(scr2pet($5d))

        ; 9th line
        txt.plot(1,19)
        txt.chrout(scr2pet($4d))
        txt.plot(20,19)
        txt.chrout(scr2pet($4e))

        ; 10th line
        txt.plot(2,20)
        txt.chrout(scr2pet($4d))
        txt.plot(19,20)
        txt.chrout(scr2pet($4e))

        ; 11th line
        txt.plot(3,21)
        txt.chrout(scr2pet($4d))
        txt.plot(8,21)
        txt.chrout(scr2pet($4e))
        repeat 4 {
            txt.chrout(scr2pet($77))
        }
        txt.chrout(scr2pet($4d))
        txt.plot(18,21)
        txt.chrout(scr2pet($4e))

        ; 12th line
        txt.plot(4,22)
        repeat 4 {
            txt.chrout(scr2pet($77))
        }
        txt.plot(14,22)
        repeat 4 {
            txt.chrout(scr2pet($77))
        }
    }

    sub dpad() {
        txt.color(platform.dpad_color)
        ; center of dpad
        txt.plot(5,15)
        txt.rvs_on()
        txt.chrout(scr2pet($fe))
        txt.chrout(scr2pet($fc))
        txt.plot(5,16)
        txt.chrout(scr2pet($fb))
        txt.chrout(scr2pet($ec))
        txt.rvs_off()

        updown(14, platform.dpad_color)  ; up
        updown(17, platform.dpad_color)  ; down
        leftright(4, platform.dpad_color) ; left
        leftright(7, platform.dpad_color) ; right

;        label_left(1)   ; color white
;        label_right(1)   ; color white
;        label_up(1)   ; color white
;        label_down(1)   ; color white

        sub label_left(ubyte color) {
            txt.color(color)
            txt.plot(3,14)
            txt.chrout('l')
            txt.plot(3,15)
            txt.chrout('e')
            txt.plot(3,16)
            txt.chrout('f')
            txt.plot(3,17)
            txt.chrout('t')
        }

        sub label_right(ubyte color) {
            txt.color(color)
            txt.plot(8,14)
            txt.chrout('r')
            txt.plot(8,15)
            txt.chrout('i')
            txt.plot(8,16)
            txt.chrout('g')
            txt.plot(8,17)
            txt.chrout('h')
            txt.plot(8,18)
            txt.chrout('t')
        }

        sub label_up(ubyte color) {
            txt.color(color)
            txt.plot(5,12)
            txt.print("up")
        }

        sub label_down(ubyte color) {
            txt.color(color)
            txt.plot(4,19)
            txt.print("down")
        }

        sub leftright(ubyte col, ubyte color) {
            txt.color(color)
            txt.plot(col,15)
            txt.chrout(scr2pet($62))
            txt.plot(col,16)
            txt.rvs_on()
            txt.chrout(scr2pet($e2))
            txt.rvs_off()
        }

        sub leftrightfull(ubyte col, ubyte color) {
            txt.color(color)
            txt.plot(col,17)
            txt.rvs_on()
            txt.chrout(scr2pet($a0))
            txt.plot(col,18)
            txt.chrout(scr2pet($a0))
            txt.rvs_off()
        }

        sub updown(ubyte row, ubyte color) {
            txt.color(color)
            txt.plot(5,row)
            txt.rvs_on()
            txt.chrout(scr2pet($e1))
            txt.rvs_off()
            txt.chrout(scr2pet($61))
        }

        sub updownfull(ubyte row, ubyte color) {
            txt.color(color)
            txt.plot(9,row)
            txt.rvs_on()
            txt.chrout(scr2pet($a0))
            txt.chrout(scr2pet($a0))
            txt.rvs_off()
        }
    }

    sub selectstart() {
        half(9,16,platform.select_color)
        half(10,15,platform.select_color)
        half(11,16,platform.start_color)
        half(12,15,platform.start_color)
;        label_select(1) ; color white
;        label_start(1) ; color white

        sub label_select(ubyte color) {
            txt.color(color)
            txt.plot(7,13)
            txt.print("select")
        }

        sub label_start(ubyte color) {
            txt.color(color)
            txt.plot(10,18)
            txt.print("start")
        }

        sub half(ubyte col, ubyte row, ubyte color) {
            txt.color(color)
            txt.plot(col,row)
            txt.rvs_on()
            txt.chrout(scr2pet($e9))
            txt.rvs_off()
            txt.chrout(scr2pet($69))
        }
    }

    sub buttons() {
        circle(18,15,6)     ; A
        circle(16,17,6)     ; B
        circle(16,13,3)    ; X
        circle(14,15,3)    ; Y

        txt.setcc(19,14,$1,1)   ; A in white
        txt.setcc(16,19,$2,1)   ; B in white
        txt.setcc(17,12,$18,1)  ; X in white
        txt.setcc(14,17,$19,1)  ; Y in white

        sub circle(ubyte col, ubyte row, ubyte color) {
            txt.color(color)
            txt.plot(col,row)
            txt.chrout(scr2pet($55))
            txt.chrout(scr2pet($49))
            txt.plot(col,row+1)
            txt.chrout(scr2pet($4a))
            txt.chrout(scr2pet($4b))
        }
    }

    sub shoulders() {
        left(platform.shoulder_color)
        right(platform.shoulder_color)

;        label_left(1)   ; color white
;        label_right(1)  ; color white

        sub label_left(ubyte color) {
            txt.color(color)
            txt.plot(3,11)
            txt.print("left")
        }

        sub label_right(ubyte color) {
            txt.color(color)
            txt.plot(32,11)
            txt.print("right")
        }

        sub left(ubyte color) {
            txt.color(color)
            txt.plot(4,10)
            txt.chrout(scr2pet($62))
            txt.chrout(scr2pet($62))
            txt.chrout(scr2pet($79))
            txt.chrout(scr2pet($79))
            txt.chrout(scr2pet($6f))
            txt.chrout(scr2pet($6f))
        }
        sub right(ubyte color) {
            txt.color(color)
            txt.plot(12,10)
            txt.chrout(scr2pet($6f))
            txt.chrout(scr2pet($6f))
            txt.chrout(scr2pet($79))
            txt.chrout(scr2pet($79))
            txt.chrout(scr2pet($62))
            txt.chrout(scr2pet($62))
        }
    }

    sub scr2pet(ubyte scr) -> ubyte {
        when scr {
            0 to 31     -> return scr+64
            32 to 63    -> return scr
            64 to 93    -> return scr+128
            94          -> return 255
            95          -> return 223
            96 to 127   -> return scr+64
            128 to 191  -> return scr-128
            192 to 255  -> return scr-64
        }
    }
}
