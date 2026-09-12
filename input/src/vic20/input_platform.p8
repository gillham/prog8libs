; this imported module should relocate
%import cbm_compat

input_platform {
    const ubyte dpad_color = cbm.COLOR_BLUE
    const ubyte select_color = cbm.COLOR_WHITE
    const ubyte start_color = cbm.COLOR_WHITE
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
