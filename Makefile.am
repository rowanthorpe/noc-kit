ACLOCAL_AMFLAGS = -I m4

SUBDIRS = src/general src/system-specific src/app-specific doc tests
EXTRA_DIST = autogen.sh
dist_doc_DATA = AUTHORS COPYING NEWS README ChangeLog THANKS

distclean-local:
	-for filename in *.c *.sh; do ! test -e "${filename}.in" || rm -f "$filename"; done
