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
DISKNAME=joytest
DISK=build/$(DISKNAME).$(DISKTYPE)

# Emulator settings
#EMU_CMD=x64sc
EMU_CMD=~/Applications/vice-arm64-sdl2-3.10/bin/x64sc
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK08=-8 $(DISK) -drive8type 1542
#EMU_DISK10=-fs10 build -device10 1 -iecdevice10 -virtualdev10
EMU_DISK10=
EMU_CART=
EMU_DISK=$(EMU_DISK08) $(EMU_DISK10)
EMU_DOS=
EMU_KERNAL=
EMU_JOYSTICK=-userportdevice 18 -extrajoydev1 4
EMU_REUSIZE=512
EMU_REU=-reu -reusize $(EMU_REUSIZE)
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_DOS) $(EMU_REU) $(EMU_JOYSTICK)

PCC=prog8c
PCCARGSC64=-srcdirs src -asmlist -target c64 -out build

PROGS	= build/main.prg build/tester.prg
SRCS	= src/main.p8 src/joystick.p8

all: build $(PROGS)

build:
	$(MD) build

build/main.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<

build/tester.prg: src/tester.p8 $(SRCS)
	$(PCC) $(PCCARGSC64) $<

clean:
	$(RM) build$(SEP)*

disk:
	c1541 -format $(DISKNAME),52 $(DISKTYPE) $(DISK)
	c1541 -attach $(DISK) -write build/main.prg main,p
	c1541 -attach $(DISK) -write build/tester.prg tester,p

emu-c64:	all disk
	$(EMU) -autostartprgmode 1 build/main.prg

emu-c64-tester:	all disk
	$(EMU) -autostartprgmode 1 build/tester.prg

#
# end-of-file
#
