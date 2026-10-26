-- ─────────── Atajos ───────────

local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "pkill rofi || rofi -show drun"
local powermenu   = "pkill wlogout || wlogout -b 5 -T 400 -B 400 -L 320 -R 320"
local scripts     = "bash ~/.config/hypr/scripts/"

local function key(k) return mainMod .. " + " .. k end
local function run(cmd) return hl.dsp.exec_cmd(cmd) end

-- ── Básicos ──
hl.bind(key("Q"),         run(terminal))
hl.bind(key("C"),         hl.dsp.window.close())
hl.bind(key("M"),         run("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(key("E"),         run(fileManager))
hl.bind(key("V"),         hl.dsp.window.float({ action = "toggle" }))
hl.bind(key("F"),         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(key("SHIFT + F"), hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(key("SHIFT + P"), hl.dsp.window.pin())
hl.bind(key("P"),         hl.dsp.window.pseudo())
hl.bind(key("J"),         hl.dsp.layout("togglesplit"))

-- ── Shell ──
hl.bind(key("R"),         run(menu))
hl.bind(key("TAB"),       run("pkill rofi || rofi -show window"))
hl.bind(key("SHIFT + V"), run("pkill rofi || cliphist list | rofi -dmenu -p '󰅍' -display-columns 2 | cliphist decode | wl-copy"))
hl.bind(key("N"),         run("swaync-client -t -sw"))
hl.bind(key("SHIFT + N"), run("swaync-client -d -sw"))
hl.bind(key("B"),         run("pkill -SIGUSR1 waybar"))
hl.bind(key("W"),         run(scripts .. "wallpaper.sh"))
hl.bind(key("L"),         run("pidof hyprlock || hyprlock"))
hl.bind(key("SHIFT + M"), run(powermenu))
hl.bind(key("A"),         run("qs -c dm-panel ipc call panel toggle"))         -- panel desplegable
hl.bind(key("SHIFT + A"), run("qs -c dm-panel ipc call panel show system"))    -- panel en Sistema

-- ── Foco, mover y redimensionar (flechas) ──
local step = 40
local dirs = {
    left  = { -step, 0 },
    right = {  step, 0 },
    up    = { 0, -step },
    down  = { 0,  step },
}

for dir, d in pairs(dirs) do
    hl.bind(key(dir),            hl.dsp.focus({ direction = dir }))
    hl.bind(key("SHIFT + " .. dir), hl.dsp.window.move({ direction = dir }))
    hl.bind(key("CTRL + " .. dir),  hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }), { repeating = true })
end

-- ── Workspaces 1-10 (tecla 0 = workspace 10) ──
for i = 1, 10 do
    local k = tostring(i % 10)
    hl.bind(key(k),              hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(key("S"),         hl.dsp.workspace.toggle_special("magic"))
hl.bind(key("SHIFT + S"), hl.dsp.window.move({ workspace = "special:magic" }))

-- Rueda del ratón
hl.bind(key("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- ── Ratón: arrastrar y redimensionar ──
hl.bind(key("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- ── Multimedia ──
local media = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  run("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume",  run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      media)
hl.bind("XF86AudioMute",         run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     media)
hl.bind("XF86AudioMicMute",      run("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   media)
hl.bind("XF86MonBrightnessUp",   run("brightnessctl -e4 -n2 set 5%+"),                  media)
hl.bind("XF86MonBrightnessDown", run("brightnessctl -e4 -n2 set 5%-"),                  media)

local locked = { locked = true }
hl.bind("XF86AudioNext",  run("playerctl next"),       locked)
hl.bind("XF86AudioPause", run("playerctl play-pause"), locked)
hl.bind("XF86AudioPlay",  run("playerctl play-pause"), locked)
hl.bind("XF86AudioPrev",  run("playerctl previous"),   locked)

-- ── Herramientas (SUPER + ALT) ──
hl.bind(key("ALT + A"), run(scripts .. "screenshot.sh full"))
hl.bind(key("ALT + S"), run(scripts .. "screenshot.sh region"))
hl.bind(key("ALT + D"), run(scripts .. "screenshot.sh window"))
hl.bind(key("ALT + E"), run("swappy -f \"$(ls -t ~/Pictures/Screenshots/*.png | head -1)\""))
hl.bind(key("ALT + P"), run("pavucontrol"))
hl.bind(key("ALT + Q"), run("easyeffects"))
hl.bind(key("ALT + N"), run("pkill hyprsunset || hyprsunset -t 4500"))
hl.bind(key("ALT + W"), run(scripts .. "dm-videowall.sh"))   -- otro fondo animado
