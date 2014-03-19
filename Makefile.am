.POSIX:

ACLOCAL_AMFLAGS = -I m4

SUBDIRS = src/general src/system-specific src/app-specific doc tests
EXTRA_DIST = autogen.sh
dist_doc_DATA = AUTHORS COPYING NEWS README ChangeLog THANKS

distclean-local:
	-for filename in *.c *.sh; do ! test -e "${filename}.in" || rm -f "$filename"; done
	printf "This file is auto-generated. Run ./configure then re-read this, or read\nREADME.in if you don't mind the raw template vars.\n" > README

.SECONDARY: README
