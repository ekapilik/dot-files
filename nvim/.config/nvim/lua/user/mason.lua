require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {'pyright', 'lua_ls', 'clangd', 'cmake'}
})

local lspconfig = require('lspconfig')

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
