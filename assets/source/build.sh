#!/bin/bash
# Renders every assets/source/<name>.html to assets/<name>.png with headless Chrome.
# Usage (from anywhere): assets/source/build.sh            all images
#                        assets/source/build.sh banner     one image
# Each page sets its own height on <body>; the size table below must match it.
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
# name:height pairs (macOS ships bash 3.2, so no associative arrays)
ALL="banner:640 live:900 update-30m:900 pillars:620 loop:760 fuse:560 tiers:640 token:640 roadmap:520 footer:420"
height() { for p in $ALL; do [ "${p%%:*}" = "$1" ] && echo "${p##*:}"; done; }
names="$*"; [ -z "$names" ] && names=$(for p in $ALL; do printf '%s ' "${p%%:*}"; done)
for n in $names; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1600,$(height $n) --virtual-time-budget=10000 \
    --screenshot="$PWD/../$n.png" "file://$PWD/$n.html" 2>/dev/null
  echo "assets/$n.png"
done
