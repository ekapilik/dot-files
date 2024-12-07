local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP and completion
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Fuzzy finding
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-treesitter/nvim-treesitter'

  -- Utility
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'

  -- File explorer
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {'pyright', 'lua_ls', 'clangd'}
})

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
lspconfig.clangd.setup{}


-- Telescope config

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
      path = "%:p:h",
      grouped = true,
      depth = false,
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

