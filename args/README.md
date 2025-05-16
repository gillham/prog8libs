# Prog8 "command line" arguments

This module will parse the BASIC line that is used to start a program.
It will look for arguments *after* a `:` and possible `REM` statement or spaces.

```
RUN:REM ARG1:ARG2:ARG3

RUN 100:REM ARG1:ARG2:ARG3

SYS2071:REM ARG1:ARG3:ARG3
```

# Usage

You need to `%import args` and then call `args.parse()` before using `args.argc` or `args.argv`.
The call to `args.parse()` will return true if any arguments are found, otherwise false.

Example:
```Prog8
%import args
%import textio

main {
    sub start() {
        ubyte i = 0

        if args.parse() {
            txt.print("argc: ")
            txt.print_ub(args.argc)
            txt.nl()
            repeat args.argc {
                txt.print("argv: ")
                txt.print(args.argv[i])
                txt.nl()
                i++
            }
        }
    }
}
```
