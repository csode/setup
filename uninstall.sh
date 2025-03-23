#!/bin/bash

# Dotfiles Uninstallation Script

set -e

# Colors
RESET='\033[0m' 
BOLD='\033[1m' 
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'

BACKUP_DIR=$(ls -td "$HOME"/.dotfiles_backup_* 2>/dev/null | head -n 1)

log() {
    echo -e "${BOLD}${BLUE}INFO:${RESET} $1"
}

success() {
    echo -e "${BOLD}${GREEN}SUCCESS:${RESET} $1"
}

warning() {
    echo -e "${BOLD}${YELLOW}WARNING:${RESET} $1"
}

error() {
    echo -e "${BOLD}${RED}ERROR:${RESET} $1"
    exit 1
}

remove_symlink() {
    local target=$1
    if [ -L "$target" ]; then
        log "Removing symlink: ${MAGENTA}$target${RESET}"
        rm "$target"
    fi
}

restore_backup() {
    local file=$1
    local backup_file="$BACKUP_DIR/$(basename "$file")"

    if [ -e "$backup_file" ]; then
        log "Restoring backup: ${CYAN}$backup_file${RESET} → ${MAGENTA}$file${RESET}"
        
        if [ -d "$file" ] || [ -L "$file" ]; then
            log "Removing existing: ${MAGENTA}$file${RESET}"
            rm -rf "$file"
        fi

        mv "$backup_file" "$file"
    fi
}

uninstall_dotfiles() {
    log "Starting dotfiles uninstallation"

    if [ -n "$BACKUP_DIR" ]; then
        log "Backup found at: ${CYAN}$BACKUP_DIR${RESET}"
    else
        warning "No backup found! Removing only symlinks."
    fi

    # Remove all symlinks
    remove_symlink "$HOME/.vimrc"
    remove_symlink "$HOME/.vim"
    remove_symlink "$HOME/.config/nvim"
    remove_symlink "$HOME/.tmux.conf"
    remove_symlink "$HOME/.config/kitty"
    remove_symlink "$HOME/.config/i3"

    # Restore from backup if available
    if [ -n "$BACKUP_DIR" ]; then
        restore_backup "$HOME/.vimrc"
        restore_backup "$HOME/.vim"
        restore_backup "$HOME/.config/nvim"
        restore_backup "$HOME/.tmux.conf"
        restore_backup "$HOME/.config/kitty"
        restore_backup "$HOME/.config/i3"

        success "Restored all backed-up configurations."
    fi

    success "Dotfiles uninstallation complete!"
}

uninstall_dotfiles

