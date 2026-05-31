%zeropage dontuse
%import textio

main {
    ubyte key
    bool status
    sub start() {
        ubyte i

        mega65.speed(1)
        txt.cls()
        repeat {
            ;key = cbm.GETIN2()
            ;status,key = cbm.GETIN()
            txt.plot(0,0)
            txt.print_uwbin(scankeys(), false)
            txt.nl()
            for i in 0 to 8 {
                txt.print("key: ")
                txt.print_ubbin(scancolumns(i), false)
                txt.nl()
            }
            ;txt.nl()
            ;txt.print("status: ")
            ;txt.print_bool(status)
            ;if key != $00 {
            ;    txt.plot(0,0)
            ;    txt.print("key: ")
            ;    txt.print_ubhex(key, true)
            ;}
        }
    }

    asmsub scancolumns(ubyte column @A) -> ubyte @A {
        %asm {{
            sta  $d614          ; C65 matrix column select
            lda  $d613          ; read matrix column data
            rts                 ; return column data
        }}
    }

    sub scankeys() -> uword {
        uword temp
        %asm {{
            lda  #%00000000     ; zeroth column
            sta  $d614          ; C65 matrix column select
            lda  $d613          ; read matrix column data
            tax                 ; stash current value
            and  #%10000000     ; bit 7 = up/down cursor key
            bne  ++             ; check next bit
            ; save fact that up or down is pressed
            lda  $d60f          ; disambiguation register
            and  #%00000010     ; check for cursor up
            beq  +              ; bit 1 not set = down arrow
            lda  p8s_scankeys.p8v_temp+1
            ora  #>p8b_input.p8c_DPAD_UP            ; signal UP
            sta  p8s_scankeys.p8v_temp+1
            clc
            bcc  ++
+           lda  p8s_scankeys.p8v_temp+1
            ora  #>p8b_input.p8c_DPAD_DOWN          ; signal DOWN
            sta  p8s_scankeys.p8v_temp+1
            ; check for bit 2 (left/right arrow)
+           txa                             ; restore value
            and  #%00000100     ; bit 2 = left/right cursor key
            bne  ++             ; check next bit
            ; save fact that up or down is pressed
            lda  $d60f          ; disambiguation register
            and  #%00000010     ; check for cursor up
            beq  +              ; bit 1 not set = down arrow
            lda  p8s_scankeys.p8v_temp+1
            ora  #>p8b_input.p8c_DPAD_UP            ; signal UP
            sta  p8s_scankeys.p8v_temp+1
            clc
            bcc  ++
+           lda  p8s_scankeys.p8v_temp+1
            ora  #>p8b_input.p8c_DPAD_DOWN          ; signal DOWN
            sta  p8s_scankeys.p8v_temp+1
            ; check next column

            ; return inverted uword (1=not pressed, 0=pressed)
+           lda  p8s_scankeys.p8v_temp+1
            eor  #255
            tay
            lda  p8s_scankeys.p8v_temp
            eor  #255
            rts
        }}
    }
}

input {

    ; SNES bits
    ; high byte
    const uword BUTTON_B        = %1000000000000000
    const uword BUTTON_Y        = %0100000000000000
    const uword BUTTON_SELECT   = %0010000000000000
    const uword BUTTON_START    = %0001000000000000
    const uword DPAD_UP         = %0000100000000000
    const uword DPAD_DOWN       = %0000010000000000
    const uword DPAD_LEFT       = %0000001000000000
    const uword DPAD_RIGHT      = %0000000100000000
    ; low byte
    const uword BUTTON_A        = %0000000010000000
    const uword BUTTON_X        = %0000000001000000
    const uword BUTTON_L        = %0000000000100000
    const uword BUTTON_R        = %0000000000010000


}
