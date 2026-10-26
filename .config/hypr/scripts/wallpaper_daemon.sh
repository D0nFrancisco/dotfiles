#!/bin/bash
# Rota el wallpaper cada 15 minutos automáticamente
INTERVAL=900  # segundos (900 = 15 min)

while true; do
    bash ~/.config/hypr/scripts/wallpaper.sh
    sleep "$INTERVAL"
done
