#!/bin/bash

# Dotfiles Installation Script

set -e

# Colors
RESET='\033[0m' 
BOLD='\033[1m' 

GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'

REPO_DIR="$(pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config"
INSTALL_METHOD=""

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

backup_file() {
    local file=$1
    local backup_path="$BACKUP_DIR/$(basename "$file")"

    if [ -e "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        
        if [ -d "$file" ]; then
            log "Backing up directory: ${MAGENTA}$file${RESET} → ${CYAN}$backup_path${RESET}"
            cp -R "$file" "$backup_path"
        else
            log "Backing up file: ${MAGENTA}$file${RESET} → ${CYAN}$backup_path${RESET}"
            cp "$file" "$backup_path"
        fi
    fi
}

remove_symlink() {
    local target=$1
    if [ -L "$target" ]; then
        log "Removing existing symlink: ${MAGENTA}$target${RESET}"
        rm "$target"
    fi
}

verify_repo() {
    if [ ! -f "$REPO_DIR/install.sh" ]; then
        warning "This script should be run from inside your dotfiles repository."
        read -p "Continue anyway? [y/N] " -n 1 -r CONTINUE
        echo
        if [[ ! $CONTINUE =~ ^[Yy]$ ]]; then
            error "Installation aborted."
        fi
    fi
    
    log "Installing dotfiles from: ${CYAN}$REPO_DIR${RESET}"
}

ask_install_method() {
    echo -e "${BOLD}${MAGENTA}Please choose how you want to install the dotfiles:${RESET}"
    echo -e "  ${BOLD}1)${RESET} ${CYAN}Create symbolic links${RESET} (recommended, easier to update)"
    echo -e "  ${BOLD}2)${RESET} ${CYAN}Copy files${RESET} (works better in some environments)"
    
    while [ -z "$INSTALL_METHOD" ]; do
        read -p "Enter your choice [1/2]: " choice
        case $choice in
            1)
                INSTALL_METHOD="symlink"
                ;;
            2)
                INSTALL_METHOD="copy"
                ;;
            *)
                warning "Invalid choice. Please enter ${BOLD}1${RESET} or ${BOLD}2${RESET}."
                ;;
        esac
    done
    
    log "Selected installation method: ${BOLD}${MAGENTA}${INSTALL_METHOD}${RESET}"
}
install_file() {
    local src=$1
    local dest=$2
    
    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        backup_file "$dest"
        log "Removing existing file: ${MAGENTA}$dest${RESET}"
        rm -rf "$dest"
    fi

    # Install the new file
    if [ "$INSTALL_METHOD" = "symlink" ]; then
        log "Creating symlink: ${MAGENTA}$dest${RESET} → ${CYAN}$src${RESET}"
        ln -sf "$src" "$dest"
    else
        log "Copying file: ${MAGENTA}$src${RESET} → ${CYAN}$dest${RESET}"
        cp -R "$src" "$dest"
    fi
}

install_configs() {
    log "Installing configuration files..."
    
    mkdir -p "$CONFIG_DIR"
    
    # vim
    install_file "$REPO_DIR/.vimrc" "$HOME/.vimrc"
    install_file "$REPO_DIR/.vim" "$HOME/.vim"
    
    # neovim
    install_file "$REPO_DIR/nvim" "$CONFIG_DIR/nvim"
    
    # tmux
    install_file "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf"
    
    # kitty
    install_file "$REPO_DIR/kitty" "$CONFIG_DIR/kitty"

    # i3
    install_file "$REPO_DIR/i3" "$CONFIG_DIR/i3"

    # picom (always copy)
    log "Copying picom.conf: ${MAGENTA}$REPO_DIR/picom.conf${RESET} → ${CYAN}$CONFIG_DIR/picom.conf${RESET}"
    cp "$REPO_DIR/picom.conf" "$CONFIG_DIR/picom.conf"

    log "Checking for additional configurations..."
    
    if [ -d "$REPO_DIR/config" ]; then
        for config_dir in "$REPO_DIR/config"/*; do
            if [ -d "$config_dir" ]; then
                config_name=$(basename "$config_dir")
                install_file "$config_dir" "$CONFIG_DIR/$config_name"
            fi
        done
    fi
    
    success "Configuration files installed successfully!"
}

install_optional_components() {
    log "Checking for optional components..."
    
    if [ -d "$REPO_DIR/fonts" ]; then
        read -p "Do you want to install custom fonts? [y/N] " -n 1 -r INSTALL_FONTS
        echo
        if [[ $INSTALL_FONTS =~ ^[Yy]$ ]]; then
            mkdir -p "$HOME/.local/share/fonts"
            log "Installing fonts to ${CYAN}~/.local/share/fonts${RESET}"
            cp -r "$REPO_DIR/fonts/"* "$HOME/.local/share/fonts/"
            log "Refreshing font cache..."
            if command -v fc-cache >/dev/null 2>&1; then
                fc-cache -f
            else
                warning "fc-cache not found. You may need to refresh your font cache manually."
            fi
        fi
    fi
}

main() {
    log "Starting dotfiles installation"
    
    verify_repo
    ask_install_method
    install_configs
    install_optional_components
    
    # Final message
    if [ -d "$BACKUP_DIR" ]; then
        success "Installation complete! Backups of your previous configuration files were created in ${CYAN}$BACKUP_DIR${RESET}"
    else
        success "Installation complete! No existing configuration files were overwritten."
    fi
    
    log "You may need to reload your terminal or log out and back in for all changes to take effect."
}

main

