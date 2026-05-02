;
; read/write User Port pins / bits
;
platform {

    sub init() {
        ;c64.EXTCOL = 0
        ;c64.BGCOL0 = 0
        ;userport.init(%10101010)
    }
}

userport {
%option merge
%option ignore_unused

    ; default User Port pin states (FIXME)
    const ubyte PINDIR   = %11111111     ; (set/high ==output) pin direction test
    const ubyte PINSTATE = %11111111     ; (set/high == logic high) pins all high

    ; requested pin directions (default should probably be all in) (but this is a test)
    ubyte pindir     = PINDIR
    ; default read mask to all input pins
    ubyte readmask   = ~PINDIR
    ; default write mask to all output pins (aka pin direction byte)
    ubyte writemask  = PINDIR

    ;
    ; call once to set pins for direciton and read/write masks
    ;
    sub init(ubyte pins) {
        pindir = pins
        readmask = ~pins
        writemask = pins
    }

    ;
    ; returns current pin state, ignoring outputs
    ;
    sub read() -> ubyte {
        ; set data direction pins
        sys.set_irqd()
        c64.CIA2DDRB |= pindir
        sys.clear_irqd()

        ; read pin state / mask wanted pins, return it
        return (c64.CIA2PRB & readmask)
    }

    ;
    ; sets output pins, masking input pins to zero.
    ;
    sub write(ubyte pins) {
        ; set data direction pins
        sys.set_irqd()
        c64.CIA2DDRB |= pindir
        sys.clear_irqd()

        ; mask only output pin values and write it
        c64.CIA2PRB = (pins & writemask)
    }
}
