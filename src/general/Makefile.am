bin_PROGRAMS = showsigs
dist_showsigs_SOURCES = showsigs.c
dist_bin_SCRIPTS = slaughter.sh
dist_pkglibexec_SCRIPTS = nk_common.sh nk_logic_ops.sh

showsigs.c: showsigs.c.in

slaughter.sh: slaughter.sh.in

install-data-hook:
	cd $(DESTDIR)$(bindir) && [ -h slaughterall.sh ] || $(LN_S) slaughter.sh slaughterall.sh
	cd $(DESTDIR)$(bindir) && [ -h slaughter ] || $(LN_S) slaughter.sh slaughter
	cd $(DESTDIR)$(bindir) && [ -h slaughterall ] || $(LN_S) slaughter.sh slaughterall
