-- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#usage
vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<space>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<space>lg", ":Telescope live_grep<CR>")

local telescope = require("telescope")

telescope.setup({
  defaults = {
    hidden = true,
    file_ignore_patterns = { "%.git/" },
  },
  extensions = {
    file_browser = {
      hidden = true,
      grouped = false,
    },
  },
})

telescope.load_extension("file_browser")


------------ Key Mappings for development ------------

-- Go to definition: use native vim.lsp (telescope lsp_definitions broke in nvim 0.12-dev)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Go to Definition" })

-- References (Telescope)
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "LSP See References" })

-- Implementations (Telescope)
vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, { desc = "LSP See Implementations" })

-- Symbols
vim.keymap.set("n", "<leader>ss", require("telescope.builtin").lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

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
