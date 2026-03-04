#
# Makefile fragment for args
#

argslibdir	:= $(dir $(lastword $(MAKEFILE_LIST)))
PROG8_LIBS	+= args
PROG8_LIBSRCS	+= $(argslibdir)src/args.p8
PROG8_SRCDIRS	+= $(argslibdir)src

#
# end-of-file
#
