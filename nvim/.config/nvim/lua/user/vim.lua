vim.o.number = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.g.mapleader = " "

-- Add column line at 80 characters
vim.api.nvim_create_augroup("C_Cpp_Settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "C_Cpp_Settings",
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    vim.opt_local.colorcolumn = "81"
    vim.opt_local.textwidth = 80
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#D3D3D3" })
  end,
})
