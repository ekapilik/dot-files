--require('nvim-treesitter.configs').setup {
--  ensure_installed = {
--    "lua", "python", "javascript", "typescript", "html", "css", "bash", "json", "rust"
--  },
--  auto_install = true,
--}

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("treesitter not found. Run :PackerSync", vim.log.levels.WARN)
end

if status_ok then
  configs.setup {
    ensure_installed = {
      "lua", "python", "javascript", "typescript", "html", "css", "bash", "json", "rust"
    },
    auto_install = true,
  }
end
