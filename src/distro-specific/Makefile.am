.POSIX:

dist_bin_SCRIPTS = zfd.sh

install-data-hook:
	cd $(DESTDIR)$(bindir) && [ -h zfd ] || $(LN_S) zfd.sh zfd

distclean-local:
	-for filename in *.c *.sh; do ! test -e "${filename}.in" || rm -f "$filename"; done
