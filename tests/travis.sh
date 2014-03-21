#!/bin/sh

# fix-timestamp.sh: prevents useless rebuilds after "cvs update"
sleep 1
# aclocal-generated aclocal.m4 depends on locally-installed
# '.m4' macro files, as well as on 'configure.ac'
! test -e aclocal.m4 || touch aclocal.m4
sleep 1
# autoconf-generated configure depends on aclocal.m4 and on
# configure.ac
! test -e configure || touch configure
# so does autoheader-generated config.h.in
! test -e config.h.in || touch config.h.in
# and all the automake-generated Makefile.in files
for filename in `find . -name Makefile.in -print`; do
  ! test -e "$filename" || touch "$filename"
done
# finally, the makeinfo-generated '.info' files depend on the
# corresponding '.texi' files if any exist
infofiles="`printf '%s' doc/*info`"
if test -n "$infofiles" && test 'doc/*info' != "$infofiles"; then
  touch $infofiles
fi
# config/make/install/distclean with restrictive settings
env CFLAGS="-D_POSIX_C_SOURCE=200809L -Wall -Wextra -pedantic-errors -Wno-overlength-strings -static -fomit-frame-pointer -std=c99 -O3 -march=native" ./configure && \
make && \
sudo make install && \
make distclean || exit 1
