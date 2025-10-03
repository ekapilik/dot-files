-- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#usage
vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<space>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<space>lg", ":Telescope live_grep<CR>")

local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  vim.notify("Telescope not found. Run :PackerSync", vim.log.levels.WARN)
end

if status_ok then
  -- Load extensions
  telescope.load_extension('file_browser')

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
      },
      media_files = {
        filetypes = {"png"},
        find_cmd = "rg"
      }
    }
  })
end


------------ Key Mappings for development ------------

-- Go to definition (Telescope)
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "LSP Go to Definition" })

-- References (Telescope)
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "LSP See References" })

-- Implementations (Telescope)
vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, { desc = "LSP See Implementations" })

-- Symbol rename
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })

-- Diagnostics (Telescope)
vim.keymap.set("n", "<leader>e", require("telescope.builtin").diagnostics, { desc = "Project Diagnostics" })

-- Diagnostics (Vanilla)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

------------ Key Mappings for Git ------------
-- Git-specific bindings
vim.api.nvim_set_keymap('n', '<leader>gf', '<cmd>lua require("telescope.builtin").git_files()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_branches()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', '<cmd>lua require("telescope.builtin").git_status()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gC', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', { noremap = true, silent = true })
