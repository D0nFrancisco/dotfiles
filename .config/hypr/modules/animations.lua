-- ─────────────────────────────────────────────────────────────
--  Animaciones · fluidas, rebote mínimo
--  speed en decisegundos (1 = 100 ms)
-- ─────────────────────────────────────────────────────────────

hl.config({ animations = { enabled = true } })

-- Curvas
local function bezier(name, x0, y0, x1, y1)
    hl.curve(name, { type = "bezier", points = { { x0, y0 }, { x1, y1 } } })
end

bezier("dmGlide",  0.22, 1.00, 0.36, 1.00)   -- ease-out quint: movimiento principal
bezier("dmSoft",   0.34, 1.06, 0.64, 1.00)   -- overshoot de 6 %: apertura elegante
bezier("dmExit",   0.55, 0.00, 0.85, 0.35)   -- ease-in: salidas rápidas y limpias
bezier("dmFade",   0.33, 0.00, 0.20, 1.00)
bezier("dmLinear", 0.00, 0.00, 1.00, 1.00)

-- { leaf, speed, curva, estilo? }
local anims = {
    -- Ventanas
    { "windowsIn",        4.5, "dmSoft",   "popin 86%" },
    { "windowsOut",       2.8, "dmExit",   "popin 90%" },
    { "windowsMove",      4.0, "dmGlide",  "slide" },

    -- Fundidos
    { "fadeIn",           3.0, "dmFade" },
    { "fadeOut",          2.4, "dmFade" },
    { "fadeSwitch",       3.0, "dmFade" },
    { "fadeShadow",       3.0, "dmFade" },
    { "fadeDim",          3.5, "dmFade" },

    -- Borde: cambio de color + giro continuo (10 s por vuelta).
    -- gaming.lua lo pasa a "once" con ventanas en pantalla completa.
    { "border",           4.0, "dmGlide" },
    { "borderangle",      100, "dmLinear", "loop" },

    -- Capas (waybar, rofi, swaync y wlogout tienen estilo propio en windowrules.lua)
    { "layersIn",         3.5, "dmSoft",   "popin" },
    { "layersOut",        2.2, "dmExit",   "fade" },
    { "fadeLayersIn",     3.0, "dmFade" },
    { "fadeLayersOut",    2.2, "dmFade" },

    -- Workspaces
    { "workspaces",       4.5, "dmGlide",  "slidefade 14%" },
    { "specialWorkspace", 4.0, "dmSoft",   "slidefadevert 18%" },
}

for _, a in ipairs(anims) do
    hl.animation({ leaf = a[1], enabled = true, speed = a[2], bezier = a[3], style = a[4] })
end
