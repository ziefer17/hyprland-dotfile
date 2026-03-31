#!/bin/bash
# ~/.config/hypr/scripts/ss-preview.sh

TMPFILE=$(mktemp /tmp/screenshot-XXXXXX.png)

grim -g "$(slurp)" "$TMPFILE" && qimgv "$TMPFILE" &

sleep 0.5 && rm -f "$TMPFILE"
