require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {'pyright', 'lua_ls', 'clangd'}
})

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
lspconfig.clangd.setup{}
lspconfig.lua_ls.setup{}
