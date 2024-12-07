-- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#usage
vim.keymap.set("n", "<space>f", ":Telescope file_browser<CR>")

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

-- Automatically open Telescope file_browser if no file is specified
local function open_file_browser()
  local args = vim.fn.argv() -- Get command-line arguments
  if vim.fn.argc() == 0 and vim.bo.filetype == "" then
    -- Ensure Telescope is loaded
    local has_telescope, telescope = pcall(telescope.extensions.file_browser.file_browser)
    if not has_file_browser then
	print("Telescope File Browser extension is not loaded.")
    end
  end
end

-- Run the function after the UI is loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = open_file_browser
})

