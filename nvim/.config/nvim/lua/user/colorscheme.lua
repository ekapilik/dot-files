local status, _ = pcall(vim.cmd, "colorscheme darkplus")
if not status then
  vim.cmd("colorscheme default")
  vim.o.background = "dark"
end

