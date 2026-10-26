#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-net · estado de red en JSON (una línea) para el panel
# ─────────────────────────────────────────────────────────────
LC_ALL=C

esc() { printf '%s' "$1" | sed 's/\\:/:/g; s/\\/\\\\/g; s/"/\\"/g'; }

line=$(nmcli -t -f TYPE,STATE,CONNECTION,DEVICE device 2>/dev/null \
       | grep -E '^(ethernet|wifi):connected:' | head -1)

type=""; conn=""; dev=""; ip=""; gw=""; signal=""
if [ -n "$line" ]; then
    type=${line%%:*}
    dev=${line##*:}
    conn=$(printf '%s' "$line" | sed -E 's/^[^:]+:connected://; s/:[^:]*$//')
    ip=$(nmcli -g IP4.ADDRESS device show "$dev" 2>/dev/null | head -1)
    gw=$(nmcli -g IP4.GATEWAY device show "$dev" 2>/dev/null | head -1)
    if [ "$type" = wifi ]; then
        signal=$(nmcli -t -f IN-USE,SIGNAL device wifi 2>/dev/null | awk -F: '$1=="*"{print $2; exit}')
    fi
fi
wifi=$(nmcli radio wifi 2>/dev/null)

printf '{"type":"%s","name":"%s","device":"%s","ip":"%s","gateway":"%s","wifi":"%s","signal":"%s"}\n' \
    "$type" "$(esc "$conn")" "$dev" "$ip" "$gw" "${wifi:-disabled}" "${signal:-0}"
