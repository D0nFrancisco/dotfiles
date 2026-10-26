-- ─────────── Variables de entorno ───────────

-- Cursor negro mate (paquete: bibata-cursor-theme-bin)
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Wayland nativo
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")          -- Dolphin y apps Qt: tema Dark Minimal
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
