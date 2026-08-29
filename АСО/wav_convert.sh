#!/bin/sh
ogg="$1"
wav="${1%ogg}wav"
rm -f "$wav"
sox "$ogg" "$wav" >/dev/null 2>&1
rm "$ogg"
