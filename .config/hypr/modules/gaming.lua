-- ─────────────────────────────────────────────────────────────
--  Juegos y pantalla completa · latencia mínima
--  - tearing en juegos a pantalla completa (immediate)
--  - direct scanout automático
--  - el borde deja de girar con una ventana en pantalla completa
--    (antes lo hacía dm-fullscreen.sh; ahora son eventos nativos)
-- ─────────────────────────────────────────────────────────────

hl.config({
    general = { allow_tearing = true },
    render  = { direct_scanout = 2 },   -- 2 = solo contenido tipo juego
})

hl.window_rule({
    name         = "games",
    match        = { class = "^(steam_app_\\d+|gamescope|cs2|Minecraft.*|org\\.prismlauncher\\.PrismLauncher)$" },
    immediate    = true,
    no_blur      = true,
    no_shadow    = true,
    no_dim       = true,
    idle_inhibit = "focus",
})

-- ── Borde giratorio: "loop" normal, "once" en pantalla completa ──
-- "loop" obliga a renderizar a 180 Hz todo el tiempo; en juegos sobra.
local state

local function syncBorder()
    local ws   = hl.get_active_workspace()
    local want = (ws and ws.has_fullscreen) and "once" or "loop"
    if want == state then return end

    hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "dmLinear", style = want })
    state = want
end

for _, ev in ipairs({
    "window.fullscreen",
    "window.open",
    "window.close",
    "window.destroy",
    "workspace.active",
    "monitor.focused",
    "config.reloaded",
}) do
    hl.on(ev, syncBorder)
end
