# Makefile

prefix= ${HOME}
TARGET= \
	cr \
	mc \
	mktempfifo \
	normpath \
	pio \
	zap

all:
	@echo 'run "make install" to install utilities at $${prefix}/bin = ${prefix}/bin'

install:
	for i in ${TARGET}; do \
		cp "$$i" ${prefix}/bin || exit $$?; \
		chmod +x "${prefix}/bin/$$i" || exit $$?; \
	done
