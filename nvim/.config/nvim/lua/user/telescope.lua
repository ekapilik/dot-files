-- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#usage
vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<space>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<space>lg", ":Telescope live_grep<CR>")

local telescope = require('telescope')

-- Add default config
telescope.setup({
  defaults = {
     hidden = true,
     file_ignore_patterns = { "%.git/" }
  }, 
  extensions = {
    file_browser = {
      hidden = true,
      --path = "%:p:h",
      grouped = false,
    }
  }
})

telescope.load_extension('file_browser')


-- Key Mappings for development

-- Open References
vim.keymap.set(
  "n",
  "gr",
  '<cmd>lua require("telescope.builtin").lsp_references()<CR>',
  { desc = "Telescope see references", noremap = true, silent = true })

-- Go to Definition
vim.keymap.set(
  "n",
  "gd",
  '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>',
  { desc = "LSP go to definition", noremap = true, silent = true})

