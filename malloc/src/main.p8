%import libmem
%import math
%import textio
;%zeropage donotuse

main {
    sub start() {
        const uword MAXBLOCKS = 256
        uword[MAXBLOCKS] blocks
        ubyte i
        uword temp

        ; initialize the memory pool
        mem.init()
        ;mem.initm($8000, $9f00)

        ; how many operations do we want
        ;uword count = 65000
        uword count = 2240

        ubyte op
        ubyte index
        ubyte tmp
        index = 0

        while count > 0 {
            op = math.randrange(5)
            when op {
                0 -> {
                    ;txt.chrout('.')

                    ; avoid losing track of an allocation
                    ; free checks for null.
                    mem.free(blocks[index])
                    blocks[index] = mem.malloc(math.randrangew(500)+1)
                    index++
                }
                1 -> {
                    ;txt.chrout('.')

                    ; avoid losing track of an allocation
                    ; free checks for null.
                    mem.free(blocks[index])

                    ; random calloc()
                    blocks[index] = mem.calloc(math.randrangew(50)+1, math.randrangew(10)+1)
                    index++
                }
                2 -> {
                    ;txt.chrout('.')
                    tmp = math.randrange(255)

                    ; try to find a used block to realloc
                    while blocks[tmp] == mem.NULL {
                        tmp++
                        ; break eventually even if all NULL
                        if tmp == 0 break
                    }
                    ; realloc will return NULL if this is a NULL allocation
                    ; or it can't find the new requested size
                    ; keep the old allocation if realloc fails
                    temp = mem.realloc(blocks[tmp], math.randrangew(500)+1)
                    if temp != mem.NULL
                        blocks[tmp] = temp
                }
                3,4 -> {
                    ;txt.chrout('.')
                    tmp = math.randrange(127)

                    ; free checks for null.
                    mem.free(blocks[tmp])
                    blocks[tmp] = mem.NULL
                }
                5 -> txt.print(" five ")
            }
            count--
        }

        txt.nl()
        txt.print("operations complete, dumping blocks")
        txt.nl()

        ; dump after all allocation
        mem.dump()

        repeat 24 {
            txt.print("freeing some random blocks")
            txt.nl()
            for i in 0 to MAXBLOCKS-1 {
                if blocks[i] == $0000 continue
                if math.randrange(5) == 3 {
                    mem.free(blocks[i])
                    blocks[i] = $0000
                }
            }

            ; dump after random free
            mem.dump()
        }

        txt.print("freeing all of blocks[]")
        txt.nl()

        for i in 0 to MAXBLOCKS-1 {
            if blocks[i] == $0000 continue
            mem.free(blocks[i])
            blocks[i] = $0000
        }
        mem.dump()
        repeat {}
    }
}
