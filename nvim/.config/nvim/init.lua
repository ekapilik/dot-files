-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader must be set before lazy so plugin keymaps use the right leader
vim.g.mapleader = " "

-- Load plugins via lazy.nvim
require("lazy").setup(require("plugins"))

-- Load user config modules
require "user.lsp"
require "user.cmp"
require "user.treesitter"
require "user.colorscheme"
require "user.format"
require "user.vim"
require "user.telescope"
require "user.octo"
