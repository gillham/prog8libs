;
; Shows timer.simple() which allows a *single*
; timer to be queued with nearly no setup.
; This timer is automatically removed when it
; expires.
;
%import syslib
%import textio
%import timer

main {
    bool simple_fired = false

    sub start() {
        ; required to establish IRQ routine
        timer.init()

        ; queue a simple one-shot timer for 20 jiffies.
        timer.simple(20, simplecallback)

        ; loop forever
        repeat {
            if simple_fired {
                ; Prevent IRQ while updating
                sys.set_irqd()
                simple_fired = false
                sys.clear_irqd()
                txt.print("simple timer fired\n")
                ; requeue the timer for 1 second
                timer.simple(60, simplecallback)
            }
        }
    }

    ; Called from IRQ. Keep this as simple as possible.
    sub simplecallback() {
        main.simple_fired = true
    }
}
