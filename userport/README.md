# Prog8 Commodore User Port library

This is an extremely simple library for Prog8 for reading/writing to the User Port.
Should work on C64, PET32, Plus/4, and VIC-20.

## Usage

First add `%import userport` and you'll need to modify the Prog8 compiler's
`-srcdirs` argument to include `src/` and `src/<yourplatform>/` with something
like: `-srcdirs src:src/c64` on Linux/Mac and `-target c64`.

You can call `userport.init()` with a pin direction argument.  If the bit is set
then pin will be output.  So `userport.init($ff)` would be all output.

This direction argument is used to create a read & write mask.

Reading from the User Port is just `userport.read()` and it will mask off any
output bits (based on the call to `userport.init()` to zero.

Writing is `userport.write(%10001000)` and it will also mask just the output
pins and the other bits will be zero.

