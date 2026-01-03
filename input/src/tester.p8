%zeropage dontuse

%import input
%import input_joykey
%import input_joystick
%import input_snes_petscii

%import textio

main {
    sub start() {
        ubyte i
        ubyte key
        ubyte port = 255
        uword pins
        uword last_pins
        txt.lowercase()
        repeat {
            last_pins = 255
            txt.cls()
            ;input.info()
            txt.print("--=== Controller Menu ===--")
            txt.nl()
            for i in 1 to input.count() {
                ^^input.Device mydev = input.getdev(i-1)
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

            mydev = input.getdev(port)

            txt.cls()
            repeat {
                if cbm.GETIN2() == ' ' break
                pins = input.get(port)
                if pins == last_pins continue
                last_pins = pins
                txt.plot(0,0)
                txt.print_uwbin(pins, false)
                txt.spc()
                txt.print(mydev.name)
                input.decode(1,pins)
            }
            key = port = 0
        }
    }
}
