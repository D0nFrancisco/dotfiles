# ─────────────────────────────────────────────────────────────
#  fish · fastfetch con foto al abrir kitty
#  Solo en kitty (la foto usa su protocolo de imágenes).
# ─────────────────────────────────────────────────────────────

status is-interactive; or exit

function fish_greeting
    if test "$TERM" = xterm-kitty; and command -q fastfetch
        fastfetch
    end
end
