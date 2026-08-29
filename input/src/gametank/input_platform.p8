input_platform {
    const bool SCAN_ALL = false
    const bool MONOCHROME = false

    sub init() {
    }
}

input {
%option merge
%option ignore_unused

    ; GameTank gamepad bits
    ; second port read pins
    const uword RIGHT       = %00000001
    const uword LEFT        = %00000010
    const uword DOWN        = %00000100
    const uword UP          = %00001000
    const uword FIRE_B      = %00010000
    const uword FIRE_C      = %00100000
    ; first port read pins
    const uword FIRE        = %00010000
    const uword START       = %00100000
    const uword SELECT      = %01000000 ; not on gamepad (extra pin on mobo)
    ; UP/DOWN duplicated here. Use this one?

    ; map two GameTank gampad bytes to SNES style 16-bit value
    sub remap16(uword pins) -> uword {
        uword result
        pins = ~pins
        ubyte pina = lsb(pins)
        ubyte pinb = msb(pins)
        if pinb & UP != 0 {
            result |= DPAD_UP
        }
        if pinb & DOWN != 0 {
            result |= DPAD_DOWN
        }
        if pinb & LEFT != 0 {
            result |= DPAD_LEFT
        }
        if pinb & RIGHT != 0 {
            result |= DPAD_RIGHT
        }
        if pina & FIRE != 0 {
            result |= BUTTON_A
        }
        if pinb & FIRE_B != 0 {
            result |= BUTTON_B
        }
        if pinb & FIRE_C != 0 {
            result |= BUTTON_X
        }
        if pina & SELECT != 0 {
            result |= BUTTON_SELECT
        }
        if pina & START != 0 {
            result |= BUTTON_START
        }
        return ~result
    }
}
