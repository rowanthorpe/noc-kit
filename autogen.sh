#!/bin/sh
sed -e "s/@PACKAGE_VERSION@/`git describe --abbrev=0 | tr -d '\n'`/g" README.in > README
autoreconf --verbose --force --install -I config -I m4 --warnings=all || exit 1
