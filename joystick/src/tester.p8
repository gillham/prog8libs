%import joystick
%import textio
main {
    uword temp
    ubyte key
    ubyte port = 0
    sub start() {
        txt.lowercase()
        repeat {
            txt.cls()
            txt.print("SNES 16-bit data:\n")
            txt.print("1. Regular joystick port 1\n")
            txt.print("2. C64GS two-button joystick port 1\n")
            txt.print("3. Regular joystick port 2\n")
            txt.print("4. C64GS two-button joystick port 2\n")
            txt.print("5. PETSCII Robots SNES on UserPort\n")
            txt.nl()
            txt.print("Classic joystick byte:\n")
            txt.print("6. Regular joystick port 1\n")
            txt.print("7. C64GS two-button joystick port 1\n")
            txt.print("8. Regular joystick port 2\n")
            txt.print("9. C64GS two-button joystick port 2\n")

            txt.print("Number 1-9?")
            while port < 1 or port > 9 {
                key = txt.waitkey()
                port = key - '0'
            }
            txt.cls()
            when port {
                1 -> test_cp1()
                2 -> test_cp1gs()
                3 -> test_cp2()
                4 -> test_cp2gs()
                5 -> test_snes()
                6 -> test_cp1_ub()
                7 -> test_cp1gs_ub()
                8 -> test_cp2_ub()
                9 -> test_cp2gs_ub()
            }
            port = key = 0
        }
    }

    sub test_snes() {
        repeat {
            sys.waitrasterline(60)
            flash_on()
            temp = joystick.get(5)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_uwbin(temp, false)
            txt.nl()
            joystick.decode(temp)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp1() {
        uword pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get(1)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_uwbin(pins, false)
            txt.nl()
            joystick.decode(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp1_ub() {
        ubyte pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get_ub(1)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_ubbin(pins, false)
            txt.nl()
            joystick.decode_ub(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp1gs() {
        uword pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get(3)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_uwbin(pins, false)
            txt.nl()
            joystick.decode(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp1gs_ub() {
        ubyte pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get_ub(3)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_ubbin(pins, false)
            txt.nl()
            joystick.decode_ub(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp2() {
        uword pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get(4)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_uwbin(pins, false)
            txt.nl()
            joystick.decode(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp2_ub() {
        ubyte pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get_ub(2)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_ubbin(pins, false)
            txt.nl()
            joystick.decode_ub(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp2gs() {
        uword pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get(4)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_uwbin(pins, false)
            txt.nl()
            joystick.decode(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    sub test_cp2gs_ub() {
        ubyte pins
        repeat {
            sys.waitrasterline(60)
            flash_on()
            pins = joystick.get_ub(4)
            flash_off()
            txt.cls()
;            txt.plot(0,0)
            txt.print_ubbin(pins, false)
            txt.nl()
            joystick.decode_ub(pins)
            if cbm.GETIN2() != 00 break
        }
    }

    inline asmsub flash_off() {
        %asm {{
            dec $d020
        }}
    }

    inline asmsub flash_on() {
        %asm {{
            inc $d020
        }}
    }

}
