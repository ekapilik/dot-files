local wezterm = require 'wezterm'
local M = {}

local POLL_INTERVAL = 60  -- seconds between script invocations
local SCRIPT = os.getenv('HOME') .. '/.config/wezterm/claude_burn_rate.py'

local last_run = 0
local cached_status = ''

local function fmt_tokens(n)
  if n >= 1000000 then
    return string.format('%.1fM', n / 1000000)
  elseif n >= 1000 then
    return string.format('%.1fK', n / 1000)
  else
    return tostring(n)
  end
end

-- ANSI helpers (same approach as the quota plugin)
local function fg(color, text)
  return '\27[38;2;' .. color .. 'm' .. text .. '\27[0m'
end

local function fmt_window(b, label, lo, hi)
  local cost_val = b.cost or 0
  local inp = (b.input or 0) + (b.cache_write or 0) + (b.cache_read or 0)
  local out = b.output or 0

  local cost_str = string.format('$%.2f%s', cost_val, label)
  local cost_colored
  if cost_val < lo then
    cost_colored = fg('80;200;120', cost_str)
  elseif cost_val < hi then
    cost_colored = fg('220;180;80', cost_str)
  else
    cost_colored = fg('220;80;80', cost_str)
  end

  local tokens_str = fg('150;150;150', '↑' .. fmt_tokens(inp) .. ' ↓' .. fmt_tokens(out))
  return cost_colored .. ' ' .. tokens_str
end

local function build_status(data)
  local h = data.hour or {}
  local d = data.day  or {}
  local sep = fg('80;80;80', ' | ')
  return ' ' .. fmt_window(h, '/h', 2, 8) .. sep .. fmt_window(d, '/d', 10, 40) .. ' '
end

local function refresh()
  local ok, success, stdout, _stderr = pcall(
    wezterm.run_child_process, { 'python3', SCRIPT }
  )
  if not ok or not success then
    return
  end
  if type(stdout) ~= 'string' or stdout == '' then
    return
  end
  local data = wezterm.json_parse(stdout)
  if data then
    cached_status = build_status(data)
  end
end

function M.apply_to_config(_config)
  wezterm.on('update-status', function(window, _pane)
    local now = os.time()
    if now - last_run >= POLL_INTERVAL then
      last_run = now
      refresh()
    end
    -- window_tint owns set_left_status; we own set_right_status
    window:set_right_status(cached_status)
  end)
end

return M
