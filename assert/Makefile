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
DISKNAME=testdisk
DISK=build/$(DISKNAME).$(DISKTYPE)

# Emulator settings
EMU_CMD=x64sc
#EMU_CMD=~/Applications/vice-arm64-sdl2-3.10/bin/x64sc
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
PCCARGSC64=-srcdirs src:src/c64 -asmlist -target c64 -out build
PCCARGSX16=-srcdirs src:src/cx16 -asmlist -target cx16 -out build

PROGS	= build/main-c64.prg build/main-cx16.prg
SRCS	= src/main.p8 src/debug.p8 src/c64/monitor.p8 src/cx16/monitor.p8

all: build $(PROGS)

build:
	$(MD) build

build/main-c64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	$(CP) build$(SEP)main.prg $@
	$(RM) build/main.prg

build/main-cx16.prg: $(SRCS)
	$(PCC) $(PCCARGSX16) $<
	$(CP) build$(SEP)main.prg $@
	$(RM) build/main.prg

clean:
	$(RM) build$(SEP)*

disk:
	c1541 -format $(DISKNAME),52 $(DISKTYPE) $(DISK)
	c1541 -attach $(DISK) -write build/main-c64.prg mainc64,p

emu-c64:	clean all disk
	$(EMU) -autostartprgmode 1 build/main-c64.prg

emu-cx16:	clean build/main-cx16.prg
	x16emu -scale 2 -run -prg build/main-cx16.prg

#
# end-of-file
#
