#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-ws · cambia de workspace desde waybar
#  Uso: dm-ws.sh e+1 | e-1 | <número>
#  Usa hl.dsp.focus (config Lua) y cae a la sintaxis clásica (hyprlang).
# ─────────────────────────────────────────────────────────────
t="${1:?uso: dm-ws.sh e+1|e-1|N}"
out=$(hyprctl dispatch "hl.dsp.focus({ workspace = \"$t\" })" 2>&1)
[ "$out" = "ok" ] || hyprctl dispatch workspace "$t" >/dev/null 2>&1
