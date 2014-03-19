.POSIX:

bin_PROGRAMS = _miniprlimit
dist__miniprlimit_SOURCES = _miniprlimit.c
dist_bin_SCRIPTS = miniprlimit.sh

install-data-hook:
	cd $(DESTDIR)$(bindir) && [ -h miniprlimit ] || $(LN_S) -f miniprlimit.sh miniprlimit

distclean-local:
	-for filename in *.c *.sh; do ! test -e "${filename}.in" || rm -f "$filename"; done
