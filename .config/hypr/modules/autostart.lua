-- ─────────── Autostart ───────────
-- Se ejecuta una sola vez al iniciar sesión (no en cada recarga).

local startup = {
    -- Shell
    "waybar",
    "swaync",
    "qs -c dm-panel",                -- panel desplegable (Quickshell)
    "systemctl --user start hyprpolkitagent",
    "blueman-applet",

    -- Portapapeles
    "wl-paste --type text  --watch cliphist store",
    "wl-paste --type image --watch cliphist store",

    -- Fondo animado (video al azar) + inactividad
    "bash ~/.config/hypr/scripts/dm-videowall.sh",
    "hypridle",

    -- Apps GTK: modo oscuro, mismo cursor e íconos
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'",
    "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'",
    "gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 10'",
    "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'",
    "gsettings set org.gnome.desktop.interface cursor-size 24",
    "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'",
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(startup) do
        hl.exec_cmd(cmd)
    end
end)
