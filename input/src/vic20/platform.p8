platform {
    const ubyte dpad_color = cbm.COLOR_BLUE
    const ubyte select_color = cbm.COLOR_PURPLE
    const ubyte start_color = cbm.COLOR_PURPLE
    const ubyte ab_color = cbm.COLOR_BLUE
    const ubyte xy_color = cbm.COLOR_CYAN
    const ubyte shoulder_color = cbm.COLOR_GREEN

    sub init() {
        cbm.bgcol(0)
        cbm.bdcol(0)
    }
}

input {
%option merge
    ; joystick bits
    const ubyte UP      = %00000100
    const ubyte DOWN    = %00001000
    const ubyte LEFT    = %00010000
    const ubyte RIGHT   = %10000000
    const ubyte FIRE    = %00100000
    const ubyte FIRE_B  = %00000001  ; POTX equiv?
    const ubyte FIRE_C  = %00000010  ; POTY equiv?
    const ubyte SELECT  = %00001100  ; UP+DOWN together
    const ubyte START   = %10010000  ; LEFT+RIGHT together
}

cbm {
%option merge

    ; VIC-20 colors
    ; border only does first 8 (3 bits)
    const ubyte COLOR_BLACK = 0
    const ubyte COLOR_WHITE = 1
    const ubyte COLOR_RED = 2
    const ubyte COLOR_CYAN = 3
    const ubyte COLOR_PURPLE = 4
    const ubyte COLOR_GREEN = 5
    const ubyte COLOR_BLUE = 6
    const ubyte COLOR_YELLOW = 7
    const ubyte COLOR_ORANGE = 8
    const ubyte COLOR_LIGHT_ORANGE = 9
    const ubyte COLOR_PINK = 10
    const ubyte COLOR_LIGHT_CYAN = 11
    const ubyte COLOR_LIGHT_PURPLE = 12
    const ubyte COLOR_LIGHT_GREEN = 13
    const ubyte COLOR_LIGHT_BLUE = 14
    const ubyte COLOR_LIGHT_YELLOW = 15

    ;
    ; the ora/and makes sure we don't keep any of the
    ; upper 4 bits currently in the register
    ;
    inline asmsub bgcol(ubyte color @Y) {
        %asm {{
            pha
            lda P8ZP_SCRATCH_B1
            pha
            tya
            ; shift lower nibble to upper nibble
            asl
            asl
            asl
            asl
            ; save upper nibble
            sta P8ZP_SCRATCH_B1
            lda $900f
            ; clear the upper nibble of current contents of $900f
            and #%00001111
            ; combine upper and lower nibbles
            ora P8ZP_SCRATCH_B1
            ; store back
            sta $900f
            ; restore
            pla
            sta P8ZP_SCRATCH_B1
            pla
        }}
    }

    inline asmsub bdcol(ubyte color @Y) {
        %asm {{
            lda P8ZP_SCRATCH_B1
            pha
            tya
            ; mask off just the 3 bits we want to change
            and #%00000111
            sta P8ZP_SCRATCH_B1
            lda $900f
            and #%11111000
            ora P8ZP_SCRATCH_B1
            sta $900f
            pla
            sta P8ZP_SCRATCH_B1
        }}
    }
}
