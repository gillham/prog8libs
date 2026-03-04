#
# Makefile fragment for timer
#

timerlibdir	:= $(dir $(lastword $(MAKEFILE_LIST)))
PROG8_LIBS	+= timer
PROG8_LIBSRCS	+= $(timerlibdir)src/$(platform)$(SEP)timer.p8
PROG8_SRCDIRS	+= $(timerlibdir)src
PROG8_SRCDIRS	+= $(timerlibdir)src$(SEP)$(platform)

#
# end-of-file
#
