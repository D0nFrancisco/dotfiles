-- ─────────── Workspaces ───────────
-- 1-5 persistentes: Waybar siempre muestra 1 2 3 4 5
--   1 web · 2 código · 3 juegos · 4 chat · 5 música

local MON = "HDMI-A-1"

for i = 1, 5 do
    hl.workspace_rule({
        workspace  = tostring(i),
        monitor    = MON,
        persistent = true,
        default    = (i == 1),
    })
end

-- Scratchpad (SUPER+S)
hl.workspace_rule({
    workspace = "special:magic",
    gaps_in   = 6,
    gaps_out  = 40,
})
