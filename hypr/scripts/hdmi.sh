#!/bin/bash

# Listen to Hyprland socket events
handle() {
    case $1 in
        # Fires when monitor is connected
        monitoradded*)
            MONITOR=$(echo $1 | cut -d'>' -f2)
            notify-send "Monitor connected: $MONITOR"

            # Move workspace 6 to the new monitor
            hyprctl dispatch moveworkspacetomonitor 6 HDMI-A-1

            # Switch projector to workspace 6
            hyprctl dispatch focusmonitor HDMI-A-1
            hyprctl dispatch workspace 6
            ;;

        # Fires when monitor is disconnected
        monitorremoved*)
            notify-send "Monitor disconnected"
            # Move workspace 6 back to laptop
            hyprctl dispatch moveworkspacetomonitor 6 eDP-1
            ;;
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read line; do
    handle "$line"
done
