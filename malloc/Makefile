#
# Simple Makefile for a Prog8 program.
#

# Cross-platform commands
ifeq ($(OS),Windows_NT)
    CLEAN = del /Q build\*
    CP = copy
    RM = del /Q
    MD = mkdir
    SEP = \\
else
    CLEAN = rm -f build/*
    CP = cp -p
    RM = rm -f
    MD = mkdir -p
    SEP = /
endif

# disk image settings
DISKTYPE=d64
DISKNAME=malloc
DISK=build/$(DISKNAME).$(DISKTYPE)

# Emulator settings
EMU_CMD=x64sc
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK08=-8 $(DISK) -drive8type 1542
#EMU_DISK10=-fs10 build -device10 1 -iecdevice10 -virtualdev10
EMU_DISK10=
EMU_CART=
EMU_DISK=$(EMU_DISK08) $(EMU_DISK10)
EMU_DOS=
EMU_KERNAL=
EMU_REUSIZE=512
EMU_REU=-reu -reusize $(EMU_REUSIZE)
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_DOS) $(EMU_REU)

PCC=prog8c
PCCARGSC64=-srcdirs src:src/c64 -asmlist -target c64 -out build
PCCARGSCX16=-srcdirs src:src/cx16 -asmlist -target cx16 -out build

PROGS	= build/mainc64.prg build/maincx16.prg
#PROGS	= build/mainc64.prg
SRCS	= src/main.p8 src/libmem.p8

all: build $(PROGS)

build:
	$(MD) build

build/mainc64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	$(CP) build/main.prg $@
	$(RM) build/main.prg

build/maincx16.prg: $(SRCS)
	$(PCC) $(PCCARGSCX16) $<
	$(CP) build/main.prg $@
	$(RM) build/main.prg

clean:
	$(RM) build$(SEP)*

disk:
	c1541 -format $(DISKNAME),52 $(DISKTYPE) $(DISK)
	c1541 -attach $(DISK) -write build/mainc64.prg mainc64,p

emu-c64:	build/mainc64.prg
	$(EMU) -monitorfont "JetBrains Mono 16" -autostartprgmode 1 build/mainc64.prg

emu-cx16:	build/maincx16.prg
	x16emu -debug -scale 2 -rtc -run -prg build/maincx16.prg

#
# end-of-file
#
