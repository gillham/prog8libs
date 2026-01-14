%import syslib
%import textio

%import timer

%zeropage basicsafe

main {
    uword count = 0
    ^^timer.Timer mytimer

    sub start() {
        ubyte timeridx

        mytimer = ^^timer.Timer: [  $08,
                                    mycallback,
                                    timer.FLAG_INTERVAL,
                                    $08 ]

        txt.print("calling timer.init()\n")
        timer.init()

        repeat 1 {
            ; add timer(s)
            txt.print("calling timer.add(mytimer)\n")
            timeridx = timer.add(mytimer)
            txt.print("timeridx = ")
            txt.print_ub(timeridx)
            txt.nl()
        }

        txt.print("timer.number = ")
        txt.print_ub(timer.number)
        txt.nl()

        txt.print("waiting...\n")
        sys.wait(137)

        txt.print("calling timer.shutdown()\n")
        timer.shutdown()

        txt.print("done... main.count: ")
        txt.print_uw(main.count)
        txt.nl()
        repeat 0 {
            ; halt without exiting
        }

    }

    sub mycallback() {
        main.count++
    }
}
