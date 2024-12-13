-- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#usage
vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<space>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<space>lg", ":Telescope live_grep<CR>")

local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  vim.notify("Telescope not found. Run :PackerSync", vim.log.levels.WARN)
end

if status_ok then
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
end


------------ Key Mappings for development ------------

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


------------ Key Mappings for Git ------------
-- Git-specific bindings
vim.api.nvim_set_keymap('n', '<leader>gf', '<cmd>lua require("telescope.builtin").git_files()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_branches()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', '<cmd>lua require("telescope.builtin").git_status()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gC', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', { noremap = true, silent = true })
