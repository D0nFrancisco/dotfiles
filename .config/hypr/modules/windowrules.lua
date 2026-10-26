-- ─────────────────────────────────────────────────────────────
--  Reglas de ventanas y capas
--  Se evalúan de arriba a abajo. Reglas de juegos: gaming.lua
-- ─────────────────────────────────────────────────────────────

-- ── Globales ─────────────────────────────────────────────────
hl.window_rule({
    name           = "no-maximize-requests",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name         = "idle-fullscreen",
    match        = { class = ".*" },
    idle_inhibit = "fullscreen",
})

-- ── Workspaces fijos (silent: no roban el foco) ──────────────
local fixed = {
    { "ws3-steam", "^(steam)$",                     "3 silent" },
    { "ws4-chat",  "^(discord|vesktop|WebCord)$",   "4 silent" },
    { "ws5-music", "^(spotify|Spotify)$",           "5 silent" },
}

for _, r in ipairs(fixed) do
    hl.window_rule({ name = r[1], match = { class = r[2] }, workspace = r[3] })
end

-- ── Utilidades flotantes ─────────────────────────────────────
hl.window_rule({
    name   = "float-utils",
    match  = { class = "^(org\\.pulseaudio\\.pavucontrol|pavucontrol|nm-connection-editor|blueman-manager|\\.blueman-manager-wrapped)$" },
    float  = true,
    center = true,
    size   = { 860, 560 },
})

hl.window_rule({
    name   = "float-dialogs",
    match  = { title = "^(Open File|Open Folder|Save As|Save File|Abrir archivo|Abrir carpeta|Guardar como|Guardar archivo).*$" },
    float  = true,
    center = true,
    size   = { 920, 600 },
})

hl.window_rule({
    name       = "polkit",
    match      = { class = "^(hyprpolkitagent|org\\.hyprland\\.polkitagent)$" },
    float      = true,
    center     = true,
    dim_around = true,
})

hl.window_rule({
    name              = "pip",
    match             = { title = "^(Picture-in-Picture|Picture in picture|Imagen en imagen)$" },
    float             = true,
    pin               = true,
    size              = { 480, 270 },
    keep_aspect_ratio = true,
    no_dim            = true,
})

hl.window_rule({
    name             = "steam-toasts",
    match            = { class = "^(steam)$", title = "^(notificationtoasts.*)$" },
    no_initial_focus = true,
    no_anim          = true,
})

-- ── Capas ────────────────────────────────────────────────────
hl.layer_rule({
    name         = "waybar",
    match        = { namespace = "^(waybar)$" },
    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.2,
    animation    = "slide top",
})

hl.layer_rule({
    name         = "rofi",
    match        = { namespace = "^(rofi)$" },
    blur         = true,
    ignore_alpha = 0.3,
    dim_around   = true,
    animation    = "popin",
})

hl.layer_rule({
    name         = "swaync",
    match        = { namespace = "^(swaync-control-center|swaync-notification-window)$" },
    blur         = true,
    ignore_alpha = 0.3,
    animation    = "slide right",
})

hl.layer_rule({
    name      = "wlogout",
    match     = { namespace = "^(logout_dialog)$" },
    blur      = true,
    animation = "fade",
})

-- Panel desplegable: blur detrás; la animación la hace el propio panel
hl.layer_rule({
    name         = "dm-panel",
    match        = { namespace = "^(dm-panel)$" },
    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.2,
    no_anim      = true,
})

hl.layer_rule({
    name    = "pickers",
    match   = { namespace = "^(selection|hyprpicker)$" },
    no_anim = true,
})
