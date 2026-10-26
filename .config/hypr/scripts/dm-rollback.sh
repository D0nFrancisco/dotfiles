#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-rollback · vuelve de la config Lua a la config .conf
#  Desactiva hyprland.lua (no lo borra) y restaura hypridle/wlogout
#  del último backup de la migración.
# ─────────────────────────────────────────────────────────────
set -u

HYP="$HOME/.config/hypr"
BK="$(cat "$HYP/.dm-last-lua-backup" 2>/dev/null || true)"

if [ -f "$HYP/hyprland.lua" ]; then
    mv "$HYP/hyprland.lua" "$HYP/hyprland.lua.off"
    echo "hyprland.lua → hyprland.lua.off"
fi

if [ -n "$BK" ] && [ -d "$BK" ]; then
    [ -f "$BK/hypr/hypridle.conf" ] && cp -a "$BK/hypr/hypridle.conf" "$HYP/hypridle.conf"
    [ -f "$BK/wlogout/layout" ]     && cp -a "$BK/wlogout/layout" "$HOME/.config/wlogout/layout"
    echo "hypridle.conf y wlogout restaurados desde $BK"
fi

hyprctl reload full-reset >/dev/null
sleep 1
pkill -x hypridle 2>/dev/null; setsid -f hypridle >/dev/null 2>&1
pgrep -f dm-fullscreen.sh >/dev/null || setsid -f "$HYP/scripts/dm-fullscreen.sh" >/dev/null 2>&1

hyprctl configerrors
echo "De vuelta en la config .conf. Para reactivar Lua: mv ~/.config/hypr/hyprland.lua.off ~/.config/hypr/hyprland.lua && hyprctl reload full-reset"
