#

.PATH:	${SRCTOP}/sys/dev/hpilo

KMOD	= hpilo
SRCS	= hpilo.c
SRCS	+= hpilo.h hpilo_port.h

SRCS+=  ${LINUXKPI_GENSRCS}

CFLAGS+= -I${SRCTOP}/sys/compat/linuxkpi/common/include

.include <bsd.kmod.mk>
