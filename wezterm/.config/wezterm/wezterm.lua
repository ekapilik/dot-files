local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================================
-- WSL: default into Ubuntu-24.04
-- ============================================================
--config.wsl_domains = {
--  {
--    name = 'WSL:Ubuntu-24.04',
--    distribution = 'Ubuntu-24.04',
--    username = 'eric',
--    default_cwd = '/home/eric',
--    default_prog = { '/usr/bin/zsh', '-l' },
--  },
--}
--config.default_domain = 'WSL:Ubuntu-24.04'
config.default_prog = { '/usr/bin/zsh', '-l' }

-- OpenGL avoids the wp_linux_drm_syncobj_surface_v1 protocol error that wgpu/WebGpu
-- triggers against Ubuntu 26.04's compositor (Mutter advertises explicit DRM sync;
-- WezTerm 20240203's wgpu impl sends a malformed request → EPROTO crash).
-- EGL/OpenGL bypasses that protocol entirely.
config.front_end = 'OpenGL'

-- ============================================================
-- Appearance
-- ============================================================
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
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

-- kanagawa.wz bakes in input_selector_label_*/launcher_label_* palette keys
-- that only exist on nightly WezTerm builds; strip them on stable so they
-- don't spam "not a valid Palette field" errors on every launch.
for _, name in ipairs { 'Kanagawa Wave', 'Kanagawa Dragon', 'Kanagawa Lotus' } do
  local scheme = config.color_schemes[name]
  if scheme then
    scheme.input_selector_label_bg = nil
    scheme.input_selector_label_fg = nil
    scheme.launcher_label_bg = nil
    scheme.launcher_label_fg = nil
  end
end

-- Rosé Pine: registers "Rose Pine", "Rose Pine Moon", "Rose Pine Dawn"
-- (https://github.com/neapsix/wezterm). Registered by name in color_schemes
-- rather than assigned to config.colors directly, since a plain color_scheme
-- name takes precedence over config.colors and would otherwise be ignored.
local rose_pine = wezterm.plugin.require 'https://github.com/neapsix/wezterm'
config.color_schemes = config.color_schemes or {}
config.color_schemes['Rose Pine'] = rose_pine.main.colors()
config.color_schemes['Rose Pine Moon'] = rose_pine.moon.colors()
config.color_schemes['Rose Pine Dawn'] = rose_pine.dawn.colors()

config.color_scheme = 'AtomOneLight'

-- ============================================================
-- Theme rotator: Super+Shift+N/P cycle themes, +R random, +D default.
-- Vendored inline rather than loading
-- https://github.com/koh-sh/wezterm-theme-rotator directly: upstream also
-- hooks the status bar to show the current theme, which fights
-- wezterm-quota-limit for the right status bar (both overwrite
-- set_right_status on every refresh tick). This trimmed version keeps
-- only the keybindings + toast notifications so quota owns the status
-- bar outright. It still cycles WezTerm's built-in schemes only, not the
-- custom ones registered above.
-- ============================================================
do
  local builtin_themes = {}
  for name, _ in pairs(wezterm.color.get_builtin_schemes()) do
    table.insert(builtin_themes, name)
  end
  table.sort(builtin_themes)

  local default_theme = config.color_scheme
  local current_index = 1
  for i, name in ipairs(builtin_themes) do
    if name == default_theme then
      current_index = i
      break
    end
  end

  local function find_index(theme_name)
    for i, name in ipairs(builtin_themes) do
      if name == theme_name then
        return i
      end
    end
    return 1
  end

  local function apply_theme(window, new_index, operation_name)
    current_index = new_index
    local theme_name = builtin_themes[current_index]
    window:set_config_overrides { color_scheme = theme_name }
    window:toast_notification('WezTerm Theme', operation_name .. ': ' .. theme_name, nil, 4000)
  end

  config.keys = config.keys or {}

  table.insert(config.keys, {
    key = 'n',
    mods = 'SUPER|SHIFT',
    action = wezterm.action_callback(function(window)
      apply_theme(window, (current_index % #builtin_themes) + 1, 'Next theme')
    end),
  })
  table.insert(config.keys, {
    key = 'p',
    mods = 'SUPER|SHIFT',
    action = wezterm.action_callback(function(window)
      local new_index = current_index - 1
      if new_index < 1 then
        new_index = #builtin_themes
      end
      apply_theme(window, new_index, 'Previous theme')
    end),
  })
  table.insert(config.keys, {
    key = 'r',
    mods = 'SUPER|SHIFT',
    action = wezterm.action_callback(function(window)
      math.randomseed(os.time())
      local new_index = current_index
      while new_index == current_index do
        new_index = math.random(1, #builtin_themes)
      end
      apply_theme(window, new_index, 'Random theme')
    end),
  })
  table.insert(config.keys, {
    key = 'd',
    mods = 'SUPER|SHIFT',
    action = wezterm.action_callback(function(window)
      apply_theme(window, find_index(default_theme), 'Default theme')
    end),
  })
end

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

-- Ctrl+Shift+R: prompt to rename the current tab
table.insert(config.keys, {
  key = 'r',
  mods = 'CTRL|SHIFT',
  action = wezterm.action.PromptInputLine {
    description = 'Rename tab',
    action = wezterm.action_callback(function(window, _, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  },
})

return config
