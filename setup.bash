#!/usr/bin/bash

# Install Neovim and dependencies
sudo apt-get update && sudo apt-get install -y \
  neovim \
  nodejs \
  python3 \
  python3-pip \
  npm \
  stow

# Install Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Stow neovim
# Recursively creates symbolic links to nvim files in ~/ for .config set up
stow -t $HOME nvim/

# nvim install plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall'
