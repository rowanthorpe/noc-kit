.POSIX:

SUBDIRS = src/general src/system-specific src/app-specific doc
EXTRA_DIST = autogen.sh
dist_doc_DATA = AUTHORS COPYING NEWS README ChangeLog THANKS TODO
# set this to override the default so README doesn't also get deleted by distclean
CONFIG_CLEAN_FILES = version.h

distclean-local:
	-for filename in *.c *.sh; do ! test -e "${filename}.in" || rm -f "$filename"; done

.SECONDARY: README

