%import userport
%import textio
main {
    ubyte pins
    sub start() {
        txt.lowercase()

        userport.pinmode(userport.PIN_C, userport.OUTPUT)
        userport.pinmode(userport.PIN_D, userport.INPUT)
        userport.pinmode(userport.PIN_E, userport.OUTPUT)
        userport.pinmode(userport.PIN_F, userport.INPUT)
        userport.pinmode(userport.PIN_H, userport.OUTPUT)
        userport.pinmode(userport.PIN_J, userport.INPUT)
        userport.pinmode(userport.PIN_K, userport.OUTPUT)
        userport.pinmode(userport.PIN_L, userport.INPUT)

        repeat {
            txt.cls()
            txt.print_ubhex(userport.read(), true)
            userport.write(%10001000)
            void userport.pinread(userport.PIN_C)
            void userport.pinread(userport.PIN_D)
            void userport.pinread(userport.PIN_E)
            void userport.pinread(userport.PIN_F)
            void userport.pinread(userport.PIN_H)
            void userport.pinread(userport.PIN_J)
            void userport.pinread(userport.PIN_K)
            void userport.pinread(userport.PIN_L)

            userport.pinwrite(userport.PIN_C, userport.LOW)
            userport.pinwrite(userport.PIN_D, userport.LOW)
            userport.pinwrite(userport.PIN_E, userport.LOW)
            userport.pinwrite(userport.PIN_F, userport.LOW)
            userport.pinwrite(userport.PIN_H, userport.LOW)
            userport.pinwrite(userport.PIN_J, userport.LOW)
            userport.pinwrite(userport.PIN_K, userport.LOW)
            userport.pinwrite(userport.PIN_L, userport.LOW)

            sys.wait(20)

            userport.pinwrite(userport.PIN_C, userport.HIGH)
            userport.pinwrite(userport.PIN_D, userport.HIGH)
            userport.pinwrite(userport.PIN_E, userport.HIGH)
            userport.pinwrite(userport.PIN_F, userport.HIGH)
            userport.pinwrite(userport.PIN_H, userport.HIGH)
            userport.pinwrite(userport.PIN_J, userport.HIGH)
            userport.pinwrite(userport.PIN_K, userport.HIGH)
            userport.pinwrite(userport.PIN_L, userport.HIGH)

        }
    }
}
