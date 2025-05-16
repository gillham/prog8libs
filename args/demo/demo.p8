%zeropage basicsafe
%option no_sysinit
%import textio

%import args

main {
    sub start() {
        ubyte i = 0

        txt.print("looking for args...")
        txt.nl()

        if args.parse() {
            txt.print("argc: ")
            txt.print_ub(args.argc)
            txt.nl()
            repeat args.argc {
                txt.print("argv: ")
                txt.print(args.argv[i])
                txt.nl()
                i++
            }
        }
    }
}

