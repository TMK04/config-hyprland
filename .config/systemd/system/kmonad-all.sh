#!/bin/sh
find "/usr/lib/systemd/system/kmonad/" -name '*.kbd' | parallel kmonad
