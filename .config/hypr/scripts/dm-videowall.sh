#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-videowall · Dark Minimal
#  Pone de fondo un video al azar de ~/Vídeos/Fondos con mpvpaper.
#  - No repite el último video usado.
#  - Se detiene (0 % GPU) con cualquier ventana en pantalla completa
#    y retoma donde iba al salir.
# ─────────────────────────────────────────────────────────────
set -u

VIDEOS="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Vídeos")"
DIR="$VIDEOS/Fondos"
MON="HDMI-A-1"
LAST="${XDG_STATE_HOME:-$HOME/.local/state}/dm-videowall.last"
MPV_OPTS="no-audio --loop --hwdec=auto-safe --panscan=1.0"

mapfile -t vids < <(find "$DIR" -maxdepth 1 -type f \
    \( -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' -o -iname '*.mov' \) | sort)

if [ "${#vids[@]}" -eq 0 ]; then
    notify-send "Fondo animado" "No hay videos en $DIR" 2>/dev/null
    exit 1
fi

last="$(cat "$LAST" 2>/dev/null || true)"
cands=()
for v in "${vids[@]}"; do
    [ "$v" != "$last" ] && cands+=("$v")
done
[ "${#cands[@]}" -eq 0 ] && cands=("${vids[@]}")

pick="${cands[RANDOM % ${#cands[@]}]}"
mkdir -p "$(dirname "$LAST")"
printf '%s' "$pick" > "$LAST"

pkill -x mpvpaper 2>/dev/null
sleep 0.2

exec mpvpaper -s -a FULL -o "$MPV_OPTS" "$MON" "$pick"
