#
# Simple Makefile for a Prog8 program.
#

# Cross-platform removal command
ifeq ($(OS),Windows_NT)
    CLEAN = del /Q build\* 
    CP = copy
    RM = del /Q
    MD = mkdir
    MV = ren
else
    CLEAN = rm -f build/*
    CP = cp -p
    RM = rm -f
    MD = mkdir -p
    MV = mv
endif

# disk image settings
DISKTYPE=d64
DISKNAME=argparse
DISK=build/$(DISKNAME).$(DISKTYPE)

# Emulator settings
EMU_CMD=x64sc
EMU_CMD128=x128
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK08=-8 $(DISK) -drive8type 1571
EMU_DISK10=-fs10 build -device10 1 -iecdevice10 -virtualdev10
EMU_DISK=$(EMU_DISK08) $(EMU_DISK10)
#EMU_KERNAL=-kernal jiffykernal
EMU_REUSIZE=2048
#EMU_REUSIZE=256
#EMU_REU=-reu -reusize $(EMU_REUSIZE) -reuimage build/reu-image.bin -reuimagerw
#EMU_REU=-reu -reusize $(EMU_REUSIZE)
EMU_REU=-georam -georamsize $(EMU_REUSIZE) -georamimage georam-image.bin -georamimagerw
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_REU)
EMU128=$(EMU_CMD128) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_REU)
EMUX16=x16emu -scale 2 -rtc -fsroot build/

PCC=prog8c
PCCARGSC64=-srcdirs src -asmlist -target c64 -out build
PCCARGSC128=-srcdirs src -asmlist -target c128 -out build
PCCARGSX16=-srcdirs src -asmlist -target cx16 -out build

PROGS	= build/demo64.prg build/demo128.prg build/demox16.prg
SRCS	= demo/demo.p8 src/args.p8

all: build $(PROGS) disk

build:
	$(MD) build/

build/demo64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	$(MV) build/demo.prg $@

build/demo128.prg: $(SRCS)
	$(PCC) $(PCCARGSC128) $<
	$(MV) build/demo.prg $@

build/demox16.prg: $(SRCS)
	$(PCC) $(PCCARGSX16) $<
	$(MV) build/demo.prg $@

clean:
	$(RM) build/*

copy:
	$(CP) test/load.bin build/

disk:
	c1541 -format $(DISKNAME),52 $(DISKTYPE) $(DISK) > /dev/null
	c1541 -attach $(DISK) -write build/demo64.prg demo64,p > /dev/null
	c1541 -attach $(DISK) -write build/demo128.prg demo128,p > /dev/null

emu:
	$(EMU)

emu128:
	$(EMU128)

emux16:
	$(EMUX16)

#
# end-of-file
#
