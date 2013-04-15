#!/bin/sh
autoreconf --verbose --force --install -I config -I m4 --warnings=all || exit 1
