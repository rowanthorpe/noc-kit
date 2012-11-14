dnl FIXME: add --help and --version to showsigs to avoid the below exemption
AM_INSTALLCHECK_STD_OPTIONS_EXEMPT = showsigs
bin_PROGRAMS = showsigs
showsigs_SOURCES = showsigs.c
dist_bin_SCRIPTS = slaughter.sh
dist_pkglibexec_SCRIPTS = shell_common.sh
install-data-hook:
	cd $(DESTDIR)$(bindir) && \
	[ -h slaughterall.sh ] || \
	$(LN_S) slaughter.sh slaughterall.sh
	cd $(DESTDIR)$(bindir) && \
	[ -h slaughter ] || \
	$(LN_S) slaughter.sh slaughter
	cd $(DESTDIR)$(bindir) && \
	[ -h slaughterall ] || \
	$(LN_S) slaughter.sh slaughterall
