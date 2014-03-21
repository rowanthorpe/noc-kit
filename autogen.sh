#!/bin/sh
autoreconf --verbose --install --warnings=all || exit 1
## Maintainer version ;-)  (upgrades autotools, sanity-checks the build)
#autoreconf --verbose --install --warnings=all --make --force || exit 1
