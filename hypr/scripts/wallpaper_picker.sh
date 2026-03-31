#!/bin/bash
WALLPAPER_DIR="/home/deadfish/Pictures/Wallpapers"

SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | \
    rofi -dmenu -p "Wallpaper")

[ -z "$SELECTED" ] && exit

hyprctl hyprpaper wallpaper "eDP-1, $SELECTED, cover"

# Persist to config
sed -i "s|path = .*|path = $SELECTED|" /home/deadfish/.config/hypr/hyprpaper.conf
