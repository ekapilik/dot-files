-- theme
local status, _ = pcall(vim.cmd, "colorscheme tokyonight-storm")
if not status then
  vim.cmd("colorscheme default")
end

-- statusline
local lualine_ok, lualine = pcall(require, 'lualine')
if lualine_ok then
  lualine.setup {
    options = {
      theme = 'tokyonight-storm'
    }
  }
end

