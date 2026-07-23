local wezterm = require 'wezterm'
local M = {}

local POLL_INTERVAL = 60  -- seconds between script invocations
local CYCLE_INTERVAL = 5  -- seconds between view rotations
local SCRIPT = os.getenv('HOME') .. '/.config/wezterm/claude_burn_rate.py'

local last_run = 0
local cycle_start = 0
local cached_status = ''
local cached_data = {}

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

local function build_status(data, view_index)
  local views = {
    {key = 'hour',  label = '/h', lo = 2,   hi = 8},
    {key = 'day',   label = '/d', lo = 10,  hi = 40},
    {key = 'week',  label = '/w', lo = 50,  hi = 200},
    {key = 'month', label = '/m', lo = 100, hi = 500},
  }
  local view = views[view_index]
  local bucket = data[view.key] or {}
  return ' ' .. fmt_window(bucket, view.label, view.lo, view.hi) .. ' '
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
    cached_data = data
  end
end

function M.apply_to_config(_config)
  wezterm.on('update-status', function(window, _pane)
    local now = os.time()
    if now - last_run >= POLL_INTERVAL then
      last_run = now
      refresh()
      cycle_start = now
    end

    local elapsed = now - cycle_start
    local view_index = (math.floor(elapsed / CYCLE_INTERVAL) % 4) + 1

    cached_status = build_status(cached_data, view_index)
    window:set_right_status(cached_status)
  end)
end

return M
