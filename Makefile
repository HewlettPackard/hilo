SHELL = /bin/bash
KDIR=/lib/modules/`uname -r`/build # installed by 'kernel-default-devel'
MDIR=$(shell pwd)

obj-m := hpilo.o

all: build

build:
	make -C $(KDIR) M=$(MDIR) modules 

buildc: clean build

clean:
	make -C $(KDIR) M=$(MDIR) clean

premake:
	make -C $(KDIR) oldconfig
	make -C $(KDIR) prepare
	make -C $(KDIR) scripts
	make -C $(KDIR) modules_prepare

ilorest: insmod
	sudo ilorest login

# .ONESHELL will not break make for fail return recipe 
.ONESHELL:
insmod: build
	@lsmod|grep hpilo > /dev/null && echo 'remove existing hpilo' && sudo rmmod hpilo
	@sudo insmod $(MDIR)/hpilo.ko && echo "$(MDIR)/hpilo.ko inserted"
	
test: ilorest

restore:
	@sudo rmmod hpilo
	@sudo modprobe hpilo

help:
	make -C $(KDIR) M=$(MDIR) help

