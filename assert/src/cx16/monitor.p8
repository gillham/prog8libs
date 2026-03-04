monitor {
    %option ignore_unused

    sub open() {
        %asm {{
            brk
        }}
    }
}
