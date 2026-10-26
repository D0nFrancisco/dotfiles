#!/bin/bash
# wallpaper.sh — Rotador de fondos anime oscuro con swww

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/Anime"
TRANSITION_TYPE="fade"     # fade | wipe | grow | outer
TRANSITION_DURATION="1.5"
TRANSITION_FPS="60"

# Verifica que swww esté corriendo
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

# Selecciona imagen aleatoria
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( \
    -name "*.jpg" -o -name "*.png" \
    -o -name "*.jpeg" -o -name "*.webp" \
    \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "No se encontraron wallpapers en $WALLPAPER_DIR"
    exit 1
fi

awww img "$WALLPAPER" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-duration "$TRANSITION_DURATION" \
    --transition-fps "$TRANSITION_FPS" \
    --transition-bezier ".43,1.19,1,.4"

echo "Wallpaper: $WALLPAPER"
