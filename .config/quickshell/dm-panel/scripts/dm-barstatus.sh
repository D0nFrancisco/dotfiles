#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-barstatus · botón único de Waybar que abre el panel
#  Muestra en una sola pastilla: volumen · red · notificaciones
# ─────────────────────────────────────────────────────────────
LC_ALL=C
FG="#d6d3cd"; MUTED="#6e6c69"; ACCENT="#d9d4c7"; ALERT="#a15c5c"

# Volumen
v=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
pct=$(awk '{printf "%d", $2 * 100}' <<<"$v")
if [[ $v == *MUTED* ]];   then vol="<span color='$MUTED'>󰖁</span>"
elif (( pct < 34 ));      then vol="󰕿"
elif (( pct < 67 ));      then vol="󰖀"
else                           vol="󰕾"
fi

# Red
dev=$(ip route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}')
if [ -z "$dev" ];                        then net="<span color='$ALERT'>󰌙</span>"
elif [ -d "/sys/class/net/$dev/wireless" ]; then net="󰤨"
else                                          net="󰈀"
fi

# Notificaciones
count=$(swaync-client -c 2>/dev/null || echo 0)
dnd=$(swaync-client -D 2>/dev/null || echo false)
if [ "$dnd" = "true" ];   then bell="<span color='$MUTED'>󰂛</span>"
elif (( count > 0 ));     then bell="<span color='$ACCENT'>󰂚</span><span color='$ACCENT' size='small' rise='4000'>$count</span>"
else                           bell="<span color='$MUTED'>󰂚</span>"
fi

printf '{"text":"%s  %s  %s","tooltip":"Volumen %s%%","class":"%s"}\n' \
    "$vol" "$net" "$bell" "$pct" "$([ "$count" -gt 0 ] 2>/dev/null && echo notif || echo idle)"
