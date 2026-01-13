;
; Software timers.
;

%import syslib
%import textio

timer {
    ; 8 timer slots
    const ubyte MAX_TIMERS = 8
    uword[MAX_TIMERS] @nosplit queue
    ubyte number

    ; whether IRQ is started or not
    bool irq_started = false

    ; quick timer (uword based)
    ; 1092 seconds, ~18 minutes maximum
    struct Timer {
        uword time
        uword callback
        ubyte flags
        uword reset
    }

    ; timer flags
    const ubyte FLAG_PAUSED     = %10000000
    const ubyte FLAG_INTERVAL   = %01000000
    const ubyte FLAG_CANCEL     = %00100000
    const ubyte FLAG_RESET      = %00010000
    const ubyte FLAG_EXPIRED    = %00001000
    const ubyte FLAG_PRECISE    = %00000100
    const ubyte FLAG_REALTIME   = %00000010
    const ubyte FLAG_SIMPLE     = %00000001

    const ubyte QUEUE_FULL      = $ff
    const ubyte EMPTY_SLOT      = $0000

    sub add(^^Timer ttimer) -> ubyte {
        ubyte i

        ; all slots full
        if timer.number >= MAX_TIMERS return QUEUE_FULL

        ; turn off interrupts while manipulating timers
        sys.irqsafe_set_irqd()

        ; find empty timer slot
        while i < MAX_TIMERS {
            if timer.queue[i] == EMPTY_SLOT {
                timer.queue[i] = ttimer
                timer.number++
                sys.irqsafe_clear_irqd()
                return i
            }
            i++
        }
        ; should not fail to find an empty slot
        sys.irqsafe_clear_irqd()
        return QUEUE_FULL
    }

    sub del(ubyte timer_index) -> bool {
        if timer_index >= MAX_TIMERS return false

        ; turn off interrupts while manipulating timers
        sys.irqsafe_set_irqd()

        timer.queue[timer_index] = EMPTY_SLOT
        timer.number--
        sys.irqsafe_clear_irqd()
        return true
    }

    ^^timer.Timer stimer = ^^timer.Timer: [ $0000, $0000, 0, 0 ]
    sub simple(uword jiffies, uword callback) -> bool {
        if not timer.irq_started
            timer.init()
        stimer.time = jiffies
        stimer.callback = callback
        stimer.flags = FLAG_SIMPLE
        stimer.reset = 0
        return add(stimer) != QUEUE_FULL
    }

    sub init() {
        ;txt.print("enabling irqhandler\n")
        sys.set_irq(&irq.irqhandler)     ; register irq handler
        timer.irq_started = true
    }

    sub shutdown() {
        ;txt.print("restoring default irq\n")
        sys.restore_irq()
    }
}


irq {
    ^^timer.Timer itimer

    ; do callbacks on any expired timers
    sub callbacks() {
        ubyte i
        for i in 0 to timer.MAX_TIMERS-1 {
            ; skip empy timer slots (they are non-contiguous)
            if timer.queue[i] != timer.EMPTY_SLOT {
                ; process timer
                itimer = timer.queue[i]
                if itimer.flags & timer.FLAG_EXPIRED != 0 {
                    ; clear expired flag
                    itimer.flags &= ~timer.FLAG_EXPIRED
                    ; simple timers get removed automatically
                    if itimer.flags & timer.FLAG_SIMPLE !=0 {
                        timer.queue[i] = timer.EMPTY_SLOT
                        timer.number--
                    }
                    ; do the timer callback
                    void call(itimer.callback)
                }
            }
        }
    }

    ; check all active timers and count
    ; them down
    sub countdown() {
        ubyte i
        for i in 0 to timer.MAX_TIMERS-1 {
            ; skip empty timer slots (they are non-contiguous)
            if timer.queue[i] != timer.EMPTY_SLOT {
                ; process timer
                itimer = timer.queue[i]

                ; remove canceled timers and continue for loop
                if itimer.flags & timer.FLAG_CANCEL != 0 {
                    timer.queue[i] = timer.EMPTY_SLOT
                    timer.number--
                    continue
                }

                ; don't touch paused timers
                if itimer.flags & timer.FLAG_PAUSED != 0 {
                    continue
                }

                if itimer.time == 0 {
                    ; timer has expired
                    itimer.flags |= timer.FLAG_EXPIRED
                    ; reload an interval timer
                    if itimer.flags & timer.FLAG_INTERVAL != 0 {
                        ; load the reset value
                        itimer.time = itimer.reset
                    }
                } else {
                    ; or just count it down
                    itimer.time--
                }
            }
        }
    }

    sub irqhandler() -> bool {
        if timer.number != 0 {
            countdown()
            callbacks()
        }
        return true ; run the system handler
    }
}
