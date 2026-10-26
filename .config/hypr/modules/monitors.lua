-- ─────────── Monitores ───────────

-- Principal: 1080p @180 Hz
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@180",
    position = "0x0",
    scale    = 1,
})

-- Cualquier pantalla extra se coloca a la derecha
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto-right",
    scale    = 1,
})
