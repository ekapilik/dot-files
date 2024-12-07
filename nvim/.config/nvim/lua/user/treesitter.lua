require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "lua", "python", "javascript", "typescript", "html", "css", "bash", "json", "rust"
  },

  auto_install = true,
}
