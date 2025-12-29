monitor {
    sub open() {
        %asm {{
            jmp $2000
        }}
    }
}

monbin $2000 {
%option force_output
%asmbinary "monitor2", 2, 4096
}
