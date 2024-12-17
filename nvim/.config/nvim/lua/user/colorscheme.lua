-- theme
local status, _ = pcall(vim.cmd, "colorscheme darkplus")
if not status then
  vim.cmd("colorscheme default")
  vim.o.background = "dark"
end

-- statusline
local lualine_ok, lualine = pcall(require, 'lualine')
if lualine_ok then
  lualine.setup {
    options = {
      theme = 'codedark'
    }
  }
end

