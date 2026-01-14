;
; SNES controller with the PETSCII Robots UserPort adapter.
; This modules supports a single SNES controller.
;

;
; This block holds a uword pointer to a Device
; struct. *NOTHING* else should be in this block.
;
; The <drivername> can be a short name or the block,
; but needs to be unique across all devices.
; Also the label isn't strictly needed unless the
; driver needs to find its own struct.
;
; l_<drivername>:
;
inputdev {
%option force_output
%option merge

l_snes_petscii:
    %asm {{
        .word p8b_snes_petscii.p8v_dev0
    }}
}

;
; Should "name" be just the index 0 entry of "devnames" here?
; Then loops could be 1 to count instead of 0 to count-1?
;
snes_petscii {
%option force_output
%option merge

    ^^input.Device dev0 = ^^input.Device: [ read,
                                            input.CONTROLLER,
                                            8,
                                            input.CTL_SNES,
                                            "snes petscii uport",
                                            "snes-up" ]

    sub read() {
        uword pins

        ; set data direction pins
        sys.set_irqd()
        @($e843) |= %00101000
        sys.clear_irqd()

        ; set latch high on pin 5
        @($e841)  = %00100000
        ; set latch low
        @($e841)  = %00000000

        repeat 16 {
            ; make room for next bit
            pins = pins << 1

            ; read pin 6
            if (@($e841) & %01000000) != 0 {
                pins |= 1
            }

            ; pulse clock high on pin 3
            @($e841) = %00001000

            ; set clock low
            @($e841) = %00000000
        }
        input.get.result = pins
    }
}
