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
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 12.0

-- Windows Acrylic blur
config.window_background_opacity = 0.9
config.win32_system_backdrop = 'Acrylic'

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.colors = {
  tab_bar = {
    background = '#1e1e2e',
    active_tab = {
      bg_color = '#313244',
      fg_color = '#cdd6f4',
    },
    inactive_tab = {
      bg_color = '#1e1e2e',
      fg_color = '#6c7086',
    },
    inactive_tab_hover = {
      bg_color = '#313244',
      fg_color = '#cdd6f4',
    },
    new_tab = {
      bg_color = '#1e1e2e',
      fg_color = '#6c7086',
    },
    new_tab_hover = {
      bg_color = '#313244',
      fg_color = '#cdd6f4',
    },
  },
}

return config
