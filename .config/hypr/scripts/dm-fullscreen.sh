#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-fullscreen · Dark Minimal
#  borderangle "loop" obliga a Hyprland a renderizar a 180 Hz siempre.
#  Con una ventana en fullscreen lo pasa a "once"; al salir, vuelve a "loop".
#  Funciona con config hyprlang (hyprctl keyword) y Lua (hyprctl eval).
#  Requiere: socat, jq
# ─────────────────────────────────────────────────────────────
set -u

# Una sola instancia
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/dm-fullscreen.lock"
flock -n 9 || exit 0

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
SPEED=100
CURVE=dmLinear
state=""

apply() {
    local style=$1 out
    out=$(hyprctl keyword animation "borderangle,1,$SPEED,$CURVE,$style" 2>&1)
    if [ "$out" != "ok" ]; then
        hyprctl eval "hl.animation({ leaf = \"borderangle\", enabled = true, speed = $SPEED, bezier = \"$CURVE\", style = \"$style\" })" >/dev/null 2>&1
    fi
}

check() {
    local fs want=loop
    fs=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.hasfullscreen // false')
    [ "$fs" = "true" ] && want=once
    [ "$want" = "$state" ] && return
    apply "$want"
    state=$want
}

check

socat -U - UNIX-CONNECT:"$SOCK" | while IFS= read -r line; do
    case "$line" in
        fullscreen\>\>*|workspacev2\>\>*|focusedmonv2\>\>*|closewindow\>\>*|openwindow\>\>*)
            check ;;
        configreloaded\>\>*)
            state=""; check ;;
    esac
done
