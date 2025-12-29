%import debug
%import math
%import textio

main {
    sub start() {
        uword ub_one = $80
        uword ub_two = $81
        uword uw_one = $1200
        uword uw_two = $1210

        ub_one++
        ub_two++
        uw_one++
        uw_two++

        repeat 100 {
            ; should all succeed
            void debug.assert(ub_one, ub_two, debug.NE, "ub_one != ub_two")
            void debug.assert(uw_one, uw_two, debug.NE, "uw_one != uw_two")
            void debug.assert(uw_one, uw_two, debug.LT, "uw_one < uw_two")
            void debug.assert(uw_one, uw_two, debug.LE, "uw_one <= uw_two")
            void debug.assert(uw_two, uw_one, debug.GT, "uw_two > uw_one")
            void debug.assert(uw_two, uw_one, debug.GE, "uw_two >= uw_one")
            void debug.assert(uw_one, uw_one, debug.EQ, "uw_one == uw_one")

            ; random failure
            void debug.assert(uw_one+math.randrange($14), uw_two, debug.NE, "uw_one != uw_two")
            void debug.assert(uw_one+math.randrange($11), uw_two, debug.LT, "uw_one < uw_two")
        }

        txt.print("-= done =-")
        sys.wait(180)
    }
}
