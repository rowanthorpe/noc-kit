dnl Initial Setup
define([m4_chop], [m4_substr($1, 0, m4_decr(m4_len($1)))])
AC_PREREQ([2.69])
dnl set version manually below so there is no chicken-or-the-egg situation with git tagging
AC_INIT([NOC-Kit], 0.3.0, [http://www.github.com/rowanthorpe/noc-kit/issues], [noc-kit], [http://www.github.com/rowanthorpe/noc-kit])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([version.h.in])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_FILES(README Makefile src/general/Makefile src/system-specific/Makefile src/distro-specific/Makefile src/app-specific/Makefile doc/Makefile version.h src/general/showsigs.c src/system-specific/_miniprlimit.c src/general/nk_common.sh src/general/nk_logic_ops.sh src/general/slaughter.sh src/general/tryedit.sh src/system-specific/miniprlimit.sh src/distro-specific/zfd.sh)
AC_PREFIX_DEFAULT([/usr/local])
AC_REVISION([-- DO NOT EDIT THIS FILE!  See the instructions in configure.ac --])
PACKAGE_AUTHOR="Rowan Thorpe"
PACKAGE_AUTHOR_TARNAME="rowanthorpe"
PACKAGE_COPYRIGHT_YEARS="2012, 2013, 2014"
AC_COPYRIGHT([
 Copyright © 2012, 2013, 2014 Rowan Thorpe

 This file is part of NOC-Kit.

 NOC-Kit is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 NOC-Kit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.

])
AM_INIT_AUTOMAKE([gnits dist-bzip2 dist-xz no-dist-gzip filename-length-max=99 std-options tar-ustar 1.11.6 -Wall])
dnl ..when needed.. LT_PREREQ([2.2.6])
dnl ..when needed.. IT_PROG_INTLTOOL([0.40.0])

dnl Tests
AC_PROG_CC
AC_LANG([C])
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MKDIR_P
AC_PROG_SED
AC_HEADER_STDC
AC_CHECK_HEADERS([stdio.h signal.h unistd.h sys/resource.h sys/time.h])
AC_CHECK_FUNCS([prlimit])

dnl Instantiations/output
AC_MSG_CHECKING([location of pkglibexec directory])
dnl the below is really ugly, there must be a better way (I must study autotools more...)
m4_changequote(<<,>>)
PKGLIBEXECDIR=`if test "x$package" = xNONE; then package=; fi; if test "x$prefix" = xNONE; then prefix=; fi; if test "x$exec_prefix" = xNONE; then exec_prefix=; fi; if test "x$libexecdir" = xNONE; then libexecdir=; fi; if test "x$pkglibexecdir" = xNONE; then pkglibexecdir=; fi; if test -z "$package"; then package="noc-kit"; fi; if test -z "$prefix"; then prefix="/usr/local"; fi; if test -z "$exec_prefix"; then exec_prefix="$prefix"; fi; if test -z "$libexecdir"; then libexecdir="$exec_prefix/libexec"; fi; if test -z "$pkglibexecdir"; then pkglibexecdir="$libexecdir/$package"; fi; while echo $pkglibexecdir | grep -q '\${[a-zA-Z_][a-zA-Z_]*}\|\$[a-zA-Z_][a-zA-Z0-9]*'; do eval pkglibexecdir=\"$pkglibexecdir\"; done; readlink -m "$pkglibexecdir"`
m4_changequote([,])
AC_MSG_RESULT(["$PKGLIBEXECDIR"])
AC_MSG_CHECKING([contents of showsigs.c.in])
SHOWSIGS_SOURCE=["\"`sed -e 's/\\t/    /g; s/"/\\\\"/g; s/$/\\\\n/g' $srcdir/src/general/showsigs.c.in | tr -d '\\n'`\""]
MINIPRLIMIT_SOURCE=["\"`sed -e 's/\\t/    /g; s/"/\\\\"/g; s/$/\\\\n/g' $srcdir/src/system-specific/_miniprlimit.c.in | tr -d '\\n'`\""]
AC_MSG_RESULT([done])
AC_PATH_PROG(SHELL, sh)
AC_SUBST([PACKAGE_VERSION])
AC_SUBST([PACKAGE_BUGREPORT])
AC_SUBST([PACKAGE_TARNAME])
AC_SUBST([PACKAGE_NAME])
AC_SUBST([PACKAGE_STRING])
AC_SUBST([PACKAGE_URL])
AC_SUBST([PACKAGE_AUTHOR])
AC_SUBST([PACKAGE_AUTHOR_TARNAME])
AC_SUBST([PACKAGE_COPYRIGHT_YEARS])
AC_SUBST([PKGLIBEXECDIR])
AC_SUBST([SHOWSIGS_SOURCE])
AC_SUBST([MINIPRLIMIT_SOURCE])
AC_OUTPUT
