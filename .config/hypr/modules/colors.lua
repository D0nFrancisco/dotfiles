-- ─────────────────────────────────────────────────────────────
--  Paleta · Dark Minimal (fija)
--  Uso en otros módulos:  local c = require("modules.colors")
-- ─────────────────────────────────────────────────────────────

return {
    -- Fondos: negro mate → carbón
    bg0       = "rgb(0a0a0b)",
    bg1       = "rgb(111113)",
    bg2       = "rgb(18181b)",
    bg3       = "rgb(232327)",

    -- Texto
    fg        = "rgb(d6d3cd)",
    muted     = "rgb(6e6c69)",

    -- Acento único (blanco cálido) y alerta
    accent    = "rgb(d9d4c7)",
    alert     = "rgb(a15c5c)",

    -- Variantes con alfa del acento (borde giratorio)
    accentHi  = "rgba(d9d4c7ee)",
    accentMid = "rgba(d9d4c766)",
    accentLo  = "rgba(d9d4c714)",

    -- Sombras
    shadowA   = "rgba(000000b3)",
    shadowI   = "rgba(00000059)",
}
