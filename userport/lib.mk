#
# Makefile fragment for userport
#

# *unique* variable name required here
userportlibdir	:= $(dir $(lastword $(MAKEFILE_LIST)))
PROG8_LIBS	+= userport
PROG8_LIBSRCS	+= $(userportlibdir)src/userport.p8
PROG8_LIBSRCS	+= $(userportlibdir)src/$(platform)$/*.p8
PROG8_SRCDIRS	+= $(userportlibdir)src
PROG8_SRCDIRS	+= $(userportlibdir)src$(SEP)$(platform)

#
# end-of-file
#
