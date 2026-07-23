vim.g.neoformat_enabled_c = { 'clangformat' }
vim.g.neoformat_enabled_cpp = { 'clangformat' }
vim.g.neoformat_enabled_rust = { 'rustfmt' }

vim.api.nvim_set_keymap('n', '<C-f>', ':Neoformat<CR>', { noremap = true, silent = true })

vim.cmd([[
  autocmd BufWritePre *.c,*.cpp,*.cxx,*.h,*.hpp Neoformat
  autocmd BufWritePre *.rs Neoformat
]])
