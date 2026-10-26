# ─────────────────────────────────────────────────────────────
#  fish · colores Dark Minimal
#  Variables globales: tienen prioridad sobre las universales,
#  así que no hace falta tocar fish_config.
# ─────────────────────────────────────────────────────────────

status is-interactive; or exit

set -g fish_greeting ""

# Sintaxis al escribir
set -g fish_color_normal          d6d3cd
set -g fish_color_command         d9d4c7 --bold
set -g fish_color_keyword         d9d4c7
set -g fish_color_builtin         d9d4c7
set -g fish_color_function        d9d4c7
set -g fish_color_param           b5b1aa
set -g fish_color_option          8f8c87
set -g fish_color_quote           a89a7c
set -g fish_color_redirection     8f8c87
set -g fish_color_end             6e6c69
set -g fish_color_operator        8f8c87
set -g fish_color_escape          a89a7c
set -g fish_color_comment         6e6c69 --italics
set -g fish_color_autosuggestion  4a4845
set -g fish_color_error           a15c5c
set -g fish_color_valid_path      --underline
set -g fish_color_cancel          6e6c69

# Prompt
set -g fish_color_cwd             d9d4c7
set -g fish_color_cwd_root        a15c5c
set -g fish_color_user            8f8c87
set -g fish_color_host            6e6c69
set -g fish_color_host_remote     a89a7c
set -g fish_color_status          a15c5c

# Selección y búsqueda
set -g fish_color_selection       d9d4c7 --background=232327
set -g fish_color_search_match    d9d4c7 --background=232327
set -g fish_color_history_current d9d4c7 --bold

# Menú de autocompletado (TAB)
set -g fish_pager_color_progress               6e6c69
set -g fish_pager_color_prefix                 d9d4c7 --bold
set -g fish_pager_color_completion             d6d3cd
set -g fish_pager_color_description            6e6c69
set -g fish_pager_color_selected_background    --background=232327
set -g fish_pager_color_selected_prefix        d9d4c7 --bold
set -g fish_pager_color_selected_completion    d9d4c7
set -g fish_pager_color_selected_description   8f8c87
