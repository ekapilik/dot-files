local mason_ok, mason= pcall(require, 'mason')
if mason_ok then
  mason.setup()
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = {'pyright', 'lua_ls', 'clangd', 'cmake'}
  })
end

local status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  vim.notify("lspconfig not found. Run :PackerSync", vim.log.levels.WARN)
end

if status_ok then
  lspconfig.pyright.setup{}
  
  lspconfig.clangd.setup({
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp"},
    root_dir = require('lspconfig').util.root_pattern("compile_commands.json", ".git"),
  })
  
  lspconfig.cmake.setup{
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
  }
  lspconfig.lua_ls.setup{}
end



-- key bindings
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "rounded",
    width = 80,
    height = 20,
    win_options = {
      winblend = 10
    }
  }
)
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
