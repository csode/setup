#!/bin/bash

echo "This will remove all Neovim plugins and related files."
read -p "Are you sure? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 1
fi

timestamp=$(date +"%Y%m%d_%H%M%S")

# Bcup config
mkdir -p ~/.nvim_backups
cp -r ~/.config/nvim ~/.nvim_backups/nvim_config_$timestamp 2>/dev/null
cp -r ~/.local/share/nvim ~/.nvim_backups/nvim_share_$timestamp 2>/dev/null
cp -r ~/.local/state/nvim ~/.nvim_backups/nvim_state_$timestamp 2>/dev/null
cp -r ~/.cache/nvim ~/.nvim_backups/nvim_cache_$timestamp 2>/dev/null

# Remove plugin-related directories
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

echo " All Neovim plugin files removed."
echo " Backup saved in ~/.nvim_backups/"

