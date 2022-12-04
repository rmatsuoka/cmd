# Makefile

PREFIX= ${HOME}/.local
TARGETDIR= ./sh

all:
	@echo 'run "make install"'

install:
	mkdir -p "${PREFIX}/bin"
	for f in `ls -A ${TARGETDIR}`; \
	do \
		rm -f "${PREFIX}/bin/$$f"; \
		cp "${TARGETDIR}/$$f" ${PREFIX}/bin || exit $$?; \
		chmod +x "${PREFIX}/bin/$$f" || exit $$?; \
	done
