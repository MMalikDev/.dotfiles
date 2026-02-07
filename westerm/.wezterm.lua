local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- General
config.color_scheme = 'Dark+'

config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 16
config.line_height = 1.2

config.initial_rows = 25
config.initial_cols = 125

config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
-- config.enable_tab_bar = false

-- Key Bindings
config.keys = {
    {
        key = 'w',
        mods = 'CTRL',
        action = act.CloseCurrentPane { confirm = false},
    },
    {
        key = 'd',
        mods = 'CTRL',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'd',
        mods = 'CTRL|SHIFT',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
}

return config
