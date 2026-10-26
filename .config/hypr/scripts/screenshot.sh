#!/bin/bash
# screenshot.sh — Capturas con grim + slurp
# Instalar: yay -S grim slurp libnotify

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$SCREENSHOT_DIR/ss_$TIMESTAMP.png"

mkdir -p "$SCREENSHOT_DIR"

case "$1" in
    "region")
        # Selección de región interactiva
        grim -g "$(slurp -d -b 8b000033 -c e8b4b8ff)" "$FILENAME"
        ;;
    "window")
        # Ventana activa
        hyprctl -j activewindow | jq -r '.at, .size | map(tostring) | join(",")' | \
        awk -F, '{print $1","$2" "$3"x"$4}' | xargs -I{} grim -g {} "$FILENAME"
        ;;
    *)
        # Pantalla completa
        grim "$FILENAME"
        ;;
esac

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"   # Copia al portapapeles automáticamente
    notify-send " Captura guardada" "$FILENAME" -t 2000
fi
