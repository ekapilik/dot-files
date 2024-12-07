#!/usr/bin/bash

# Install Neovim and dependencies
sudo apt-get update && sudo apt-get install -y \
  neovim \
  nodejs \
  python3 \
  python3-pip \
  npm \
  stow

# Recursively creates symbolic links to nvim files in ~/ for .config set up
stow -t $HOME nvim/

# nvim install plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall'
