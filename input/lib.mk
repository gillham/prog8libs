#
# Makefile fragment for input
#

# *unique* variable name required here
inputlibdir	:= $(dir $(lastword $(MAKEFILE_LIST)))
PROG8_LIBS	+= input
PROG8_LIBSRCS	+= $(inputlibdir)src/input.p8
PROG8_LIBSRCS	+= $(inputlibdir)src/$(platform)$(SEP)*.p8
PROG8_SRCDIRS	+= $(inputlibdir)src
PROG8_SRCDIRS	+= $(inputlibdir)src$(SEP)$(platform)

#
# end-of-file
#


#
# end-of-file
#
