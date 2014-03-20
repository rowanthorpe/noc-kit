#!/bin/sh
env CFLAGS="-D_POSIX_C_SOURCE=200809L -Wall -Wextra -pedantic-errors -Wno-overlength-strings -static -fomit-frame-pointer -O3 -march=native" ./configure
make CC=c99
sudo make install
make distclean
