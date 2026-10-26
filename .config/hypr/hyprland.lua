-- ─────────────────────────────────────────────────────────────
--  HYPRLAND · Dark Minimal v4 · CachyOS (Lua, Hyprland ≥ 0.56)
-- ─────────────────────────────────────────────────────────────
-- Solo carga módulos de ~/.config/hypr/modules/.
-- Cada require() es un ámbito aislado: un error en un módulo no
-- detiene a los demás. colors.lua devuelve la paleta como tabla.
-- Los .conf antiguos siguen en conf/ como respaldo (no se cargan).

require("modules.monitors")
require("modules.env")
require("modules.autostart")
require("modules.look")
require("modules.animations")
require("modules.input")
require("modules.workspaces")
require("modules.windowrules")
require("modules.gaming")        -- después de windowrules: sus reglas ganan
require("modules.keybinds")
