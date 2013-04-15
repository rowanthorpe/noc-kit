dist_bin_SCRIPTS = zfd.sh

zfd.sh: zfd.sh.in

install-data-hook:
	cd $(DESTDIR)$(bindir) && [ -h zfd ] || $(LN_S) zfd.sh zfd
