;
; GameTank gamepad port controllers.
;
; Either GameTank gamepads or Genesis control pad or joypad
; should work.  TBD with real hardware.
; 
; See: https://wiki.gametank.zone/doku.php?id=hardware:gamepads
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
%option ignore_unused

l_gamepad:
    %asm {{
        .word p8b_gamepad.p8v_dev0
        .word p8b_gamepad.p8v_dev1
    }}
}

;
; 
;
gamepad {
%option force_output
%option merge
%option ignore_unused

    ^^input.Device dev0 = ^^input.Device: [ read_gamepad1,
                                            input.CONTROLLER,
                                            1,
                                            input.JOY_CP,
                                            "gamepad 1",
                                            "port1" ]
    ^^input.Device dev1 = ^^input.Device: [ read_gamepad2,
                                            input.CONTROLLER,
                                            1,
                                            input.JOY_CP,
                                            "gamepad 2",
                                            "port2" ]

    sub read_gamepad1() {
        input.get.result = input.remap16(read_port1())
    }

    sub read_gamepad2() {
        input.get.result = input.remap16(read_port2())
    }

    asmsub read_port1() -> uword @AY {
        %asm {{
            php
            sei
            lda  gametank.GAMEPAD2  ; causes *other* controller to reset select line
            lda  gametank.GAMEPAD1  ; read 1st set of buttons
            ldy  gametank.GAMEPAD1  ; read 2nd set of buttons
            plp
            rts
        }}
    }

    asmsub read_port2() -> uword @AY {
        %asm {{
            php
            sei
            lda  gametank.GAMEPAD1  ; causes *other* controller to reset select line
            lda  gametank.GAMEPAD2  ; read 1st set of buttons
            ldy  gametank.GAMEPAD2  ; read 2nd set of buttons
            plp
            rts
        }}
    }
}
