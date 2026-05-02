%import userport
%import textio
main {
    ubyte pins
    sub start() {
        txt.lowercase()

        repeat {
            txt.cls()
            txt.print_ubhex(userport.read(), true)
            void userport.write(%10001000)
        }
    }
}
