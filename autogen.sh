#!/bin/sh
autoreconf --force --install -I config -I m4 --warnings=all || exit 1
