local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================================
-- WSL: default into Ubuntu-24.04
-- ============================================================
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu-24.04',
    distribution = 'Ubuntu-24.04',
    username = 'eric',
    default_cwd = '/home/eric',
    default_prog = { '/usr/bin/zsh', '-l' },
  },
}
config.default_domain = 'WSL:Ubuntu-24.04'

-- ============================================================
-- Appearance
-- ============================================================
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 12.0

-- Windows Acrylic blur
config.window_background_opacity = 0.9
config.win32_system_backdrop = 'Acrylic'

-- Tab bar
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- ============================================================
-- Themes
-- ============================================================
-- Kanagawa: registers "Kanagawa Wave", "Kanagawa Dragon", "Kanagawa Lotus"
-- into config.color_schemes (https://github.com/sravioli/kanagawa.wz)
local kanagawa = wezterm.plugin.require 'https://github.com/sravioli/kanagawa.wz'
kanagawa.register(config)

-- Rosé Pine: registers "Rose Pine", "Rose Pine Moon", "Rose Pine Dawn"
-- (https://github.com/neapsix/wezterm). Registered by name in color_schemes
-- rather than assigned to config.colors directly, since a plain color_scheme
-- name takes precedence over config.colors and would otherwise be ignored.
local rose_pine = wezterm.plugin.require 'https://github.com/neapsix/wezterm'
config.color_schemes = config.color_schemes or {}
config.color_schemes['Rose Pine'] = rose_pine.main.colors()
config.color_schemes['Rose Pine Moon'] = rose_pine.moon.colors()
config.color_schemes['Rose Pine Dawn'] = rose_pine.dawn.colors()

config.color_scheme = 'Kanagawa Wave'

-- ============================================================
-- Theme rotator: Super+Shift+N/P cycle themes, +R random, +D default
-- (https://github.com/koh-sh/wezterm-theme-rotator). Note: it cycles
-- WezTerm's built-in schemes only, not the custom ones registered above.
-- ============================================================
local theme_rotator = wezterm.plugin.require 'https://github.com/koh-sh/wezterm-theme-rotator'
theme_rotator.apply_to_config(config)

-- ============================================================
-- Window tint: project-aware window/tab-bar coloring based on git root
-- (https://github.com/willytop8/Wezterm-Window-Tint)
-- ============================================================
local window_tint = wezterm.plugin.require 'https://github.com/willytop8/Wezterm-Window-Tint'
window_tint.apply_to_config(config, {
  show_badge = true,
  set_retro_tab_bar = true,
})

-- ============================================================
-- Claude usage quota in the right status bar
-- (https://github.com/EdenGibson/wezterm-quota-limit)
-- ============================================================
local quota = wezterm.plugin.require 'https://github.com/EdenGibson/wezterm-quota-limit'
quota.apply_to_config(config)

return config
