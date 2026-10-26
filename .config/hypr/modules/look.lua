-- ─────────────────────────────────────────────────────────────
--  Apariencia · Dark Minimal v4
-- ─────────────────────────────────────────────────────────────

local c = require("modules.colors")

hl.config({
    general = {
        border_size = 1,
        gaps_in     = 5,
        gaps_out    = 10,

        -- Degradado monocromo: el brillo recorre el borde (borderangle loop)
        col = {
            active_border = {
                colors = { c.accentHi, c.accentLo, c.accentMid, c.accentLo, c.accentHi },
                angle  = 45,
            },
            inactive_border = c.bg3,
        },

        layout                  = "dwindle",
        resize_on_border        = true,
        extend_border_grab_area = 12,
        hover_icon_on_border    = true,
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2.4,          -- esquinas tipo "squircle"

        active_opacity     = 1.0,
        inactive_opacity   = 0.95,
        fullscreen_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.06,
        dim_special  = 0.35,           -- oscurece el fondo con el scratchpad

        blur = {
            enabled            = true,
            size               = 8,
            passes             = 3,
            new_optimizations  = true,
            xray               = false,
            ignore_opacity     = true,
            noise              = 0.012,
            contrast           = 0.92,
            brightness         = 0.82, -- el blur oscurece en vez de lavar
            vibrancy           = 0.08,
            vibrancy_darkness  = 0.4,
            popups             = true,
            popups_ignorealpha = 0.2,
            special            = true,
        },

        shadow = {
            enabled        = true,
            range          = 22,
            render_power   = 3,
            offset         = { 0, 6 },
            color          = c.shadowA,
            color_inactive = c.shadowI,
        },
    },

    group = {
        col = {
            border_active          = c.accentHi,
            border_inactive        = c.bg3,
            border_locked_active   = c.accent,
            border_locked_inactive = c.bg3,
        },
        groupbar = {
            font_family = "JetBrainsMono Nerd Font",
            font_size   = 10,
            height      = 16,
            gradients   = false,
            text_color  = c.fg,
            col = {
                active          = c.bg3,
                inactive        = c.bg1,
                locked_active   = c.bg3,
                locked_inactive = c.bg1,
            },
        },
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
        background_color         = c.bg0,
        font_family              = "JetBrainsMono Nerd Font",

        animate_manual_resizes       = true,
        animate_mouse_windowdragging = true,
        focus_on_activate            = false,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
    },

    cursor = {
        inactive_timeout  = 0,
        hide_on_key_press = false,
    },
})
