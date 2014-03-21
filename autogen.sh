#!/bin/sh
autoreconf --verbose --install -I config -I m4 --warnings=all || exit 1
