#
# Makefile fragment for assert
#

assertlibdir	:= $(dir $(lastword $(MAKEFILE_LIST)))
PROG8_LIBS	+= assert
PROG8_LIBSRCS	+= $(assertlibdir)src/debug.p8
PROG8_LIBSRCS	+= $(assertlibdir)src/$(platform)$(SEP)monitor.p8
PROG8_SRCDIRS	+= $(assertlibdir)src
PROG8_SRCDIRS	+= $(assertlibdir)src$(SEP)$(platform)

#
# end-of-file
#
