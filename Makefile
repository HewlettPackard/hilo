#

.PATH:	${SRCTOP}/sys/dev/hpilo

KMOD	= hpilo
SRCS	= hpilo.c
SRCS	+= hpilo.h hpilo_port.h

SRCS+=  ${LINUXKPI_GENSRCS}

CFLAGS+= -I${SRCTOP}/sys/compat/linuxkpi/common/include

# Remember to do `make cleandepend` if changing KERNCONF!
KERNCONF?=    GENERIC
KERNCONFDIR=  /usr/src/sys/${MACHINE_ARCH}/conf
.if !empty(KERNCONF)
SRCS+=        ${.OBJDIR}/.kconf/opt_global.h
CFLAGS+=      -include ${.OBJDIR}/.kconf/opt_global.h
.endif

${.OBJDIR}/.kconf/opt_global.h: ${KERNCONFDIR}/${KERNCONF}
	cd ${KERNCONFDIR} && config -d ${.OBJDIR}/.kconf ${KERNCONF}

.include <bsd.kmod.mk>
