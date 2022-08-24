# Makefile

PREFIX= ${HOME}/.local
TARGET= \
	5 \
	a \
	cmdinfo \
	cr \
	match \
	mc \
	mktempfifo \
	normpath \
	nyps \
	pick \
	rank \
	repeat \
	zap

all:
	@echo 'run "make install"'

install:
	mkdir -p "${PREFIX}/bin"
	for i in ${TARGET}; do \
		rm -f "${PREFIX}/bin/$$i"; \
		cp "$$i" ${PREFIX}/bin || exit $$?; \
		chmod +x "${PREFIX}/bin/$$i" || exit $$?; \
	done
