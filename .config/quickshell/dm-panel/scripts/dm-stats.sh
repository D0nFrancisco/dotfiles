#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dm-stats · datos del sistema para el panel Dark Minimal
#  Sin argumentos: una línea JSON por segundo (CPU, RAM, red…)
#  --info: una sola línea JSON con datos fijos (CPU, GPU, SO…)
# ─────────────────────────────────────────────────────────────
set -u
LC_ALL=C

if [ "${1:-}" = "--info" ]; then
    cpu=$(awk -F': *' '/^model name/{print $2; exit}' /proc/cpuinfo)
    gpu=$(lspci 2>/dev/null | awk -F': ' '/VGA|3D|Display/{print $2; exit}' \
          | sed -E 's/^[^[]*\[([^]]+)\].*\[([^]]+)\].*/\1 \2/; s/ \(rev [0-9a-f]+\)//')
    os=$(. /etc/os-release 2>/dev/null; echo "${NAME:-Linux}")
    kernel=$(uname -r)
    wm=$(hyprctl version 2>/dev/null | sed -n 's/^Tag: v\([0-9.]*\).*/Hyprland \1/p' | head -1)
    host=$(cat /proc/sys/kernel/hostname)
    esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
    printf '{"cpu":"%s","gpu":"%s","os":"%s","kernel":"%s","wm":"%s","host":"%s"}\n' \
        "$(esc "$cpu")" "$(esc "${gpu:-desconocida}")" "$(esc "$os")" "$(esc "$kernel")" \
        "$(esc "${wm:-Hyprland}")" "$(esc "$host")"
    exit 0
fi

# Sensor de temperatura de la CPU (coretemp / k10temp / zenpower)
temp_file=""
for d in /sys/class/hwmon/hwmon*; do
    case "$(cat "$d/name" 2>/dev/null)" in
        coretemp|k10temp|zenpower|cpu_thermal) temp_file="$d/temp1_input"; break ;;
    esac
done
[ -z "$temp_file" ] && [ -r /sys/class/thermal/thermal_zone0/temp ] && temp_file=/sys/class/thermal/thermal_zone0/temp

read_cpu() { awk '/^cpu /{idle=$5+$6; t=0; for(i=2;i<=NF;i++) t+=$i; print t, idle; exit}' /proc/stat; }
iface() { ip route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}'; }
read_net() { awk -v i="$1:" '$1==i{print $2, $10}' /proc/net/dev; }

read -r t0 i0 < <(read_cpu)
dev=$(iface); read -r rx0 tx0 < <(read_net "${dev:-lo}"); rx0=${rx0:-0}; tx0=${tx0:-0}
n=0

while sleep 1; do
    read -r t1 i1 < <(read_cpu)
    dt=$((t1 - t0)); di=$((i1 - i0))
    cpu=$(awk -v dt="$dt" -v di="$di" 'BEGIN{ if(dt>0) printf "%.1f", (dt-di)*100/dt; else print 0 }')
    t0=$t1; i0=$i1

    # Cada 5 s se revisa si cambió la interfaz de red por defecto
    if [ $((n % 5)) -eq 0 ]; then
        nd=$(iface)
        if [ "$nd" != "$dev" ]; then
            dev=$nd; read -r rx0 tx0 < <(read_net "${dev:-lo}"); rx0=${rx0:-0}; tx0=${tx0:-0}
        fi
    fi
    read -r rx1 tx1 < <(read_net "${dev:-lo}"); rx1=${rx1:-$rx0}; tx1=${tx1:-$tx0}
    rx=$((rx1 - rx0)); tx=$((tx1 - tx0)); rx0=$rx1; tx0=$tx1
    [ "$rx" -lt 0 ] && rx=0; [ "$tx" -lt 0 ] && tx=0

    temp=0
    [ -n "$temp_file" ] && temp=$(( $(cat "$temp_file" 2>/dev/null || echo 0) / 1000 ))

    read -r up _ < /proc/uptime
    read -r l1 l5 l15 _ < /proc/loadavg

    awk -v cpu="$cpu" -v temp="$temp" -v rx="$rx" -v tx="$tx" -v dev="${dev:-}" \
        -v up="${up%.*}" -v l1="$l1" -v l5="$l5" -v l15="$l15" \
        -v disk="$(df -kP / | awk 'NR==2{print $3, $2}')" '
        /^MemTotal:/     {mt=$2}
        /^MemAvailable:/ {ma=$2}
        /^SwapTotal:/    {st=$2}
        /^SwapFree:/     {sf=$2}
        END {
            split(disk, d, " ")
            g = 1048576
            printf "{\"cpu\":%s,\"temp\":%d,\"memUsed\":%.1f,\"memTotal\":%.1f,\"memPct\":%.0f,", cpu, temp, (mt-ma)/g, mt/g, (mt>0?(mt-ma)*100/mt:0)
            printf "\"swapUsed\":%.1f,\"swapTotal\":%.1f,", (st-sf)/g, st/g
            printf "\"rx\":%d,\"tx\":%d,\"iface\":\"%s\",", rx, tx, dev
            printf "\"diskUsed\":%.1f,\"diskTotal\":%.1f,\"diskPct\":%.0f,", d[1]/g, d[2]/g, (d[2]>0?d[1]*100/d[2]:0)
            printf "\"load\":\"%s / %s / %s\",\"uptime\":%d}\n", l1, l5, l15, up
        }' /proc/meminfo
    n=$((n + 1))
done
