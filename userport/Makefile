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
DISKNAME=uptest
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
PCCARGSPET32=-srcdirs src:src/pet32 -asmlist -target pet32 -out build
PCCARGSVIC20=-srcdirs src:src/vic20 -asmlist -target config/vic20.properties -out build
PCCARGSPLUS4=-srcdirs src:src/plus4 -asmlist -target config/plus4.properties -out build

PROGS	= build/main-c64.prg build/main-pet32.prg build/main-plus4.prg build/main-vic20.prg
SRCS	= src/main.p8 src/userport.p8

all: build $(PROGS)

build:
	$(MD) build

build/main-c64.prg: src/main.p8 $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	$(CP) build/main.prg $@
	$(RM) build/main.prg

build/main-pet32.prg: src/main.p8 src/pet32/*
	$(PCC) $(PCCARGSPET32) $<
	$(CP) build/main.prg $@
	$(RM) build/main.prg

build/main-plus4.prg: src/main.p8 src/plus4/*
	$(PCC) $(PCCARGSPLUS4) $<
	$(CP) build/main.prg $@
	$(RM) build/main.prg

build/main-vic20.prg: src/main.p8 src/vic20/*
	$(PCC) $(PCCARGSVIC20) $<
	$(CP) build/main.prg $@
	$(RM) build/main.prg

clean:
	$(RM) build$(SEP)*

disk:
	c1541 -format $(DISKNAME),52 $(DISKTYPE) $(DISK)
	c1541 -attach $(DISK) -write build/main-c64.prg main,p

emu-c64:	all disk
	$(EMU) -autostartprgmode 1 build/main-c64.prg

emu-pet32:	clean build/main-pet32.prg
	xpet-sdl -default -model 4032 -keymap 0 $(EMU_JOYSTICK) -autostartprgmode 1 build/main-pet32.prg

emu-plus4:	build/main-plus4.prg
	xplus4-sdl -default -keymap 1 $(EMU_JOYSTICK) -autostartprgmode 1 build/main-plus4.prg 

emu-vic20:	build/main-vic20.prg
	#xvic -keymap 1 -memory none -extrajoydev1 4 -userportdevice 18 -autostartprgmode 1 build/main-vic20.prg
	xvic-sdl -default -model vic20ntsc -keymap 1 -memory none $(EMU_JOYSTICK) -autostartprgmode 1 build/main-vic20.prg

#
# end-of-file
#
