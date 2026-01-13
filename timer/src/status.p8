%import syslib
%import textio

%import timer

%zeropage basicsafe

main {
    const ubyte STATUS_LINE = txt.DEFAULT_HEIGHT - 1    ; make zero relative
    uword count = 0
    ^^timer.Timer mytimer1
    ^^timer.Timer mytimer2
    ubyte timeridx1
    ubyte timeridx2
    str status_message = "your file was trashed, sorry!"

    bool timer1_fired = false
    bool timer2_fired = false
    bool simple_fired = false

    sub start() {
        ; 2 second one-shot timer
        mytimer1 = ^^timer.Timer: [  20,
                                    mycallback1,
                                    0,
                                    0 ]
        ; 3 second timer
        mytimer2 = ^^timer.Timer: [  30,
                                    mycallback2,
                                    0,
                                    0 ]
        timer.init()

        timeridx1 = timer.add(mytimer1)

        txt.print("started timer1")
        txt.nl()
        txt.nl()
        txt.print("just waiting..")
        txt.nl()

        ; loop forever
        repeat {
            if txt.get_row() == STATUS_LINE
                txt.cls()

            if timer1_fired {
                txt.print("timer1 fired, queuing timer2\n")
                mytimer2.time = 30
                timeridx2 = timer.add(mytimer2)
                timer.simple(5, simplecallback)
                ; do the thing
                draw_status()
                ; reset (probably should IRQ protect update)
                timer1_fired = false
            }

            if timer2_fired {
                txt.print("timer2 fired, queuing timer1\n")
                mytimer1.time = 20
                timeridx1 = timer.add(mytimer1)
                timer.simple(5, simplecallback)
                ; do the thing
                clear_status()
                ; reset (probably should IRQ protect update)
                timer2_fired = false
            }

            if simple_fired {
                simple_fired = false
                simple_status()
            }
        }

        txt.print("calling timer.shutdown()\n")
        timer.shutdown()
    }

    sub mycallback1() {
        main.timer1_fired = true
    }
    sub mycallback2() {
        main.timer2_fired = true
    }
    sub simplecallback() {
        main.simple_fired = true
    }

    sub simple_status() {
        ubyte i
        ubyte col,row
        col = txt.get_column()
        row = txt.get_row()

        txt.plot(30, STATUS_LINE)
        txt.print(" simple ")
        txt.plot(col, row)
    }

    sub clear_status() {
        ubyte i
        ubyte col,row
        col = txt.get_column()
        row = txt.get_row()

        txt.plot(0, STATUS_LINE)
        ; drawing 1 char short to avoid a scroll
        ; on some platforms
        for i in 0 to txt.DEFAULT_WIDTH - 2 {
            txt.spc()
        }
        txt.plot(col, row)
    }

    sub draw_status() {
        ubyte col,row
        col = txt.get_column()
        row = txt.get_row()
        txt.plot(0, STATUS_LINE)
        txt.print(main.status_message)
        txt.plot(col, row)
    }
}
