#!/bin/bash
# ~/.config/hypr/scripts/keybinds.sh
# Hyprland keybind viewer using fzf
# Parses hyprland.conf at runtime

CONF="$HOME/.config/hypr/hyprland.conf"

# ── Icons for modifiers ──────────────────────────────────────────────────────
format_key() {
    local mod="$1"
    local key="$2"
    local desc="$3"

    # Replace modifier names with icons/symbols
    mod=$(echo "$mod" | sed \
        -e 's/SUPER/󰖳 /g' \
        -e 's/SHIFT/⇧ /g' \
        -e 's/CTRL/⌃ /g' \
        -e 's/ALT/⌥ /g' \
        -e 's/CAPS/⇪ /g')

    # Replace common key names with icons
    key=$(echo "$key" | sed \
        -e 's/Return/↵/g' \
        -e 's/Print/⎙/g' \
        -e 's/space/␣/g' \
        -e 's/Tab/⇥/g' \
        -e 's/left/←/g' \
        -e 's/right/→/g' \
        -e 's/up/↑/g' \
        -e 's/down/↓/g' \
        -e 's/slash/\//g' \
        -e 's/comma/,/g' \
        -e 's/period/./g' \
        -e 's/semicolon/;/g' \
        -e 's/minus/-/g' \
        -e 's/equal/=/g' \
        -e 's/backspace/⌫/g' \
        -e 's/escape/⎋/g' \
        -e 's/F\([0-9]*\)/F\1/g')

    # Format the combo
    local combo=""
    [ -n "$mod" ] && combo="$mod+ " || combo="   "
    combo="$combo$key"

    printf "%-30s %s\n" "$combo" "$desc"
}

# ── Parse hyprland.conf ───────────────────────────────────────────────────────
parse_binds() {
    while IFS= read -r line; do
        # Match bind lines: bind = MOD, key, dispatcher, args
        if [[ "$line" =~ ^[[:space:]]*bind[[:space:]]*=[[:space:]]*(.*) ]]; then
            local rest="${BASH_REMATCH[1]}"

            # Split by comma
            IFS=',' read -r mod key dispatcher args <<< "$rest"

            # Trim whitespace
            mod=$(echo "$mod" | xargs)
            key=$(echo "$key" | xargs)
            dispatcher=$(echo "$dispatcher" | xargs)
            args=$(echo "$args" | xargs)

            # Build description from dispatcher + args
            local desc=""
            case "$dispatcher" in
                exec)               desc="  run: $args" ;;
                killactive)         desc="  close window" ;;
                exit)               desc="  exit hyprland" ;;
                togglefloating)     desc="  toggle floating" ;;
                fullscreen)         desc="  fullscreen" ;;
                togglesplit)        desc="  toggle split" ;;
                movefocus)          desc="  focus $args" ;;
                movewindow)         desc="  move window $args" ;;
                workspace)          desc="  workspace $args" ;;
                movetoworkspace)    desc="  move to workspace $args" ;;
                movetoworkspacesilent) desc="  move to ws (silent) $args" ;;
                togglespecialworkspace) desc="  special workspace $args" ;;
                movetospecialworkspace) desc="  move to special ws" ;;
                resizeactive)       desc="  resize $args" ;;
                cyclenext)          desc="  cycle next window" ;;
                swapnext)           desc="  swap next window" ;;
                pin)                desc="  pin window" ;;
                pseudo)             desc="  toggle pseudo" ;;
                *)                  desc="  $dispatcher $args" ;;
            esac

            format_key "$mod" "$key" "$desc"
        fi
    done < "$CONF"
}

# ── Check dependencies ────────────────────────────────────────────────────────
if ! command -v fzf &>/dev/null; then
    echo "fzf not found. Install with: sudo pacman -S fzf"
    exit 1
fi

if [ ! -f "$CONF" ]; then
    echo "hyprland.conf not found at $CONF"
    exit 1
fi

# ── Run fzf ───────────────────────────────────────────────────────────────────
parse_binds | fzf \
    --prompt="  keybinds > " \
    --header="$(printf '%-30s %s' 'COMBO' 'ACTION')" \
    --header-lines=1 \
    --layout=reverse \
    --border=rounded \
    --color="bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,\
hl:#89b4fa,hl+:#89b4fa,border:#45475a,\
prompt:#cba6f7,pointer:#f38ba8,marker:#a6e3a1,\
header:#6c7086" \
    --no-sort \
    --no-multi \
    --bind "esc:abort" \
    --bind "enter:abort"
