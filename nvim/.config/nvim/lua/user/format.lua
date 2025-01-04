-- Configure Neoformat to use clang-format for C++ files
vim.g.neoformat_enabled_cpp = { 'clangformat' }

-- Map Ctrl+F to format the current file using Neoformat
vim.api.nvim_set_keymap('n', '<C-f>', ':Neoformat<CR>', { noremap = true, silent = true })

-- Optionally, you can also set up auto-formatting on save for C++ files
vim.cmd([[
  autocmd BufWritePre *.cpp,*.cxx,*.h,*.hpp Neoformat
]])
