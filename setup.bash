#!/usr/bin/bash

# Install Neovim and dependencies
sudo apt-get update && sudo apt-get install -y \
  neovim \
  nodejs \
  python3 \
  python3-pip \
  npm \
  stow

pipx install \
  cmake-language-server

# Recursively creates symbolic links to nvim files in ~/ for .config set up
stow -t $HOME nvim/

# Add alias to bashrc
NV_ALIAS="alias nv='nvim'"
if [ $(cat ~/.bashrc | grep "$NV_ALIAS" | wc -l) -eq 0 ]; then
  echo $NV_ALIAS >> ~/.bashrc
  source ~/.bashrc
fi
