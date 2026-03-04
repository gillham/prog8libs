#
# Makefile fragment for malloc
#

malloclibdir	:= $(dir $(lastword $(MAKEFILE_LIST)))
PROG8_LIBS	+= malloc
PROG8_LIBSRCS	+= $(malloclibdir)src/libmem.p8
PROG8_SRCDIRS	+= $(malloclibdir)src

#
# end-of-file
#
