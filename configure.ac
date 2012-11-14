dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([NOC-Kit], m4_esyscmd([sed -n '1s/^.*version //p' README | tr -d '\n']), [http://www.github.com/rowanthorpe/noc-kit/issues], [noc-kit], [http://www.github.com/rowanthorpe/noc-kit])
AC_CONFIG_SRCDIR([src/general/shell_common.sh])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([config])
if test -z "$PACKAGE_VERSION"; then
	AC_MSG_ERROR([could not find version on first line of README file.])
fi
AM_INIT_AUTOMAKE([gnits] [dist-bzip2] [dist-xz] [no-dist-gzip] [filename-length-max=99] [std-options] [tar-ustar] [1.11.6] [-Wall])
dnl WHEN NEEDED: LT_PREREQ([2.2.6])
dnl WHEN NEEDED: IT_PROG_INTLTOOL([0.40.0])

dnl Check for toolchain and install components (check for sed already "done"
dnl  while getting version number above):
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MKDIR_P

dnl Check for standard headers:
AC_CHECK_HEADERS([stdlib.h signal.h unistd.h])

dnl Makefile to create:
AC_CONFIG_FILES([Makefile] [src/general/Makefile] [src/system-specific/Makefile] [src/app-specific/Makefile])
AC_OUTPUT
