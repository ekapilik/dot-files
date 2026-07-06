local ts = require("nvim-treesitter")

ts.install({
  "c", "cpp", "lua", "python", "javascript", "typescript",
  "html", "css", "bash", "json", "rust",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c", "cpp", "lua", "python", "javascript", "typescript",
    "html", "css", "bash", "json", "rust",
  },
  callback = function()
    vim.treesitter.start()
  end,
})

require('nvim-treesitter.install').prefer_git = true
