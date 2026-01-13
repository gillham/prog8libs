%import syslib
%import textio
%import timer

main {
    ^^timer.Timer mytimer
    ubyte timeridx
    bool timer_fired = false

    sub start() {
        ; 1 second interval timer
        mytimer = ^^timer.Timer: [  60,
                                    mycallback,
                                    timer.FLAG_INTERVAL,
                                    60 ]
        timer.init()
        timeridx = timer.add(mytimer)

        ; loop forever
        repeat {
            if timer_fired {
                txt.print("timer fired\n")
                timer_fired = false
            }
        }
        ; currently unreachable
        txt.print("calling timer.shutdown()\n")
        timer.shutdown()
    }

    sub mycallback() {
        main.timer_fired = true
    }
}
