#!/bin/bash

# Dotfiles Installation Script
# ----------------------------

set -e

# ┌─────────────────────────────────┐
# │ COLOR AND FORMATTING DEFINITIONS │
# └─────────────────────────────────┘
RESET='\033[0m' 
BOLD='\033[1m' 
ITALIC='\033[3m'
UNDERLINE='\033[4m'

GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'

# ┌──────────────────┐
# │ GLOBAL VARIABLES │
# └──────────────────┘
REPO_DIR="$(pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config"
BUILD_DIR="$HOME/build"
INSTALL_METHOD=""
DISTRO=""
PACKAGE_MANAGER=""

# ┌─────────────────────┐
# │ LOGGING AND DISPLAY │
# └─────────────────────┘
print_banner() {
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║                 DOTFILES INSTALLER                       ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

print_section() {
    echo
    echo -e "${BOLD}${MAGENTA}┌─ $1 ${"─"$(( 50 - ${#1} ))}┐${RESET}"
    echo
}

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

# ┌─────────────────────┐
# │ UTILITY FUNCTIONS   │
# └─────────────────────┘
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID

        # Detect package manager
        if command -v apt >/dev/null 2>&1; then
            PACKAGE_MANAGER="apt"
        elif command -v dnf >/dev/null 2>&1; then
            PACKAGE_MANAGER="dnf"
        elif command -v pacman >/dev/null 2>&1; then
            PACKAGE_MANAGER="pacman"
        elif command -v zypper >/dev/null 2>&1; then
            PACKAGE_MANAGER="zypper"
        else
            warning "Could not detect package manager"
        fi

        log "Detected distribution: ${CYAN}$DISTRO${RESET} (Package manager: ${CYAN}$PACKAGE_MANAGER${RESET})"
    else
        warning "Could not detect Linux distribution. Some features may not work properly."
    fi
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

ask_yes_no() {
    local prompt=$1
    local default=${2:-n}
    
    local yn_prompt="[y/N]"
    if [ "$default" = "y" ]; then
        yn_prompt="[Y/n]"
    fi
    
    read -p "$prompt $yn_prompt " -n 1 -r REPLY
    echo
    
    if [ -z "$REPLY" ]; then
        REPLY=$default
    fi
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

install_packages() {
    print_section "SYSTEM DEPENDENCIES"
    
    log "Installing required system packages..."
    
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt update
            sudo apt install -y build-essential git pkg-config libx11-dev libxft-dev \
                libxinerama-dev dconf-cli wget curl unzip ninja-build gettext \
                libtool libtool-bin autoconf automake cmake g++ pkg-config \
                i3 ibus kitty neofetch emacs virt-manager libvirt-daemon-system \
                qemu-kvm virtinst bridge-utils qemu virt-viewer spice-client-gtk
            ;;
        pacman)
            sudo pacman -Syu --noconfirm base-devel git cmake ninja \
                libx11 libxft libxinerama dconf i3 ibus kitty neofetch \
                polybar emacs qemu libvirt virt-manager virt-viewer spice-gtk \
                ebtables dnsmasq bridge-utils openbsd-netcat
            ;;
        dnf)
            sudo dnf install -y @development-tools git cmake ninja-build pkg-config \
                libX11-devel libXft-devel libXinerama-devel dconf-cli \
                i3 ibus kitty neofetch polybar emacs virt-manager libvirt \
                qemu-kvm virt-viewer spice-gtk
            ;;
        zypper)
            sudo zypper install -y git cmake ninja dconf-tools \
                libX11-devel libXft-devel libXinerama-devel \
                i3 kitty neofetch emacs-nox virt-manager libvirt qemu-kvm \
                virt-viewer spice-gtk
            ;;
        *)
            warning "Unsupported package manager. You may need to install dependencies manually."
            if ask_yes_no "Would you like to continue without installing dependencies?"; then
                return 0
            else
                error "Installation aborted."
            fi
            ;;
    esac
    
    # Enable and start libvirtd service
    if command -v systemctl >/dev/null 2>&1; then
        log "Enabling and starting libvirtd service..."
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
        
        # Add current user to libvirt group
        if getent group libvirt >/dev/null; then
            log "Adding user to libvirt group..."
            sudo usermod -aG libvirt $USER
        fi
    fi
    
    success "System packages installed successfully!"
}

# ┌──────────────────────────┐
# │ DOTFILES INSTALLATION    │
# └──────────────────────────┘
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
    print_section "CONFIGURATION FILES"
    
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

    # zsh (if exists)
    if [ -f "$REPO_DIR/.zshrc" ]; then
        install_file "$REPO_DIR/.zshrc" "$HOME/.zshrc"
    fi

    # picom (always copy)
    if [ -f "$REPO_DIR/picom.conf" ]; then
        log "Copying picom.conf: ${MAGENTA}$REPO_DIR/picom.conf${RESET} → ${CYAN}$CONFIG_DIR/picom.conf${RESET}"
        cp "$REPO_DIR/picom.conf" "$CONFIG_DIR/picom.conf"
    fi

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
    print_section "OPTIONAL COMPONENTS"
    
    log "Checking for optional components..."
    
    if [ -d "$REPO_DIR/fonts" ]; then
        if ask_yes_no "Do you want to install custom fonts?"; then
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

# ┌──────────────────────────┐
# │ FLATPAK INSTALLATION     │
# └──────────────────────────┘
install_flatpak() {
    print_section "FLATPAK SETUP"
    
    log "Checking for Flatpak..."
    
    if ! command -v flatpak >/dev/null 2>&1; then
        if ask_yes_no "Flatpak is not installed. Do you want to install it?"; then
            log "Installing Flatpak using $PACKAGE_MANAGER..."
            case "$PACKAGE_MANAGER" in
                apt)
                    sudo apt update && sudo apt install -y flatpak gnome-software-plugin-flatpak
                    ;;
                dnf)
                    sudo dnf install -y flatpak
                    ;;
                pacman)
                    sudo pacman -S --noconfirm flatpak
                    ;;
                zypper)
                    sudo zypper install -y flatpak
                    ;;
                *)
                    warning "Couldn't identify package manager. Please install Flatpak manually."
                    return 1
                    ;;
            esac
        else
            return 0
        fi
    else
        log "Flatpak is already installed."
    fi
    
    # Add Flathub repository
    if ask_yes_no "Do you want to add the Flathub repository?"; then
        log "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        success "Flathub repository added successfully!"
        
        # Install Brave browser
        if ask_yes_no "Do you want to install Brave browser from Flatpak?"; then
            log "Installing Brave browser..."
            flatpak install flathub com.brave.Browser -y
            success "Brave browser installed successfully!"
        fi
    fi
    
    return 0
}

# ┌──────────────────────────┐
# │ ZSH SETUP                │
# └──────────────────────────┘
setup_zsh() {
    print_section "ZSH SETUP"
    
    log "Checking for ZSH..."
    
    if ! command -v zsh >/dev/null 2>&1; then
        if ask_yes_no "ZSH is not installed. Do you want to install it?"; then
            log "Installing ZSH using $PACKAGE_MANAGER..."
            case "$PACKAGE_MANAGER" in
                apt)
                    sudo apt update && sudo apt install -y zsh
                    ;;
                dnf)
                    sudo dnf install -y zsh
                    ;;
                pacman)
                    sudo pacman -S --noconfirm zsh
                    ;;
                zypper)
                    sudo zypper install -y zsh
                    ;;
                *)
                    warning "Couldn't identify package manager. Please install ZSH manually."
                    return 1
                    ;;
            esac
        else
            return 0
        fi
    else
        log "ZSH is already installed."
    fi
    
    # Set ZSH as default shell
    if ask_yes_no "Do you want to set ZSH as your default shell?"; then
        log "Setting ZSH as default shell..."
        chsh -s $(which zsh)
        success "ZSH set as default shell! This will take effect on next login."
    fi
    
    # Install Oh My ZSH
    if ask_yes_no "Do you want to install Oh My ZSH?"; then
        log "Installing Oh My ZSH..."
        if [ -d "$HOME/.oh-my-zsh" ]; then
            log "Oh My ZSH is already installed, backing up..."
            backup_file "$HOME/.oh-my-zsh"
            rm -rf "$HOME/.oh-my-zsh"
        fi
        
        # Save current shell to variable for safe return
        CURRENT_SHELL=$(ps -p $$ | awk 'NR==2 {print $4}')
        
        # Use curl or wget to install Oh My ZSH
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        elif command -v wget >/dev/null 2>&1; then
            sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        else
            warning "Neither curl nor wget is installed. Please install Oh My ZSH manually."
            return 1
        fi
        
        success "Oh My ZSH installed successfully!"
        
        # If we had a custom .zshrc in our dotfiles, restore it over Oh My ZSH's default
        if [ -f "$REPO_DIR/.zshrc" ]; then
            log "Restoring custom .zshrc from dotfiles..."
            install_file "$REPO_DIR/.zshrc" "$HOME/.zshrc"
        fi
    fi
    
    return 0
}

# ┌──────────────────────────┐
# │ DOOM EMACS INSTALLATION  │
# └──────────────────────────┘
install_doom_emacs() {
    print_section "DOOM EMACS SETUP"
    
    if ! command -v emacs >/dev/null 2>&1; then
        warning "Emacs is not installed. Please install Emacs first."
        return 1
    fi
    
    if ask_yes_no "Do you want to install Doom Emacs?"; then
        log "Installing Doom Emacs..."
        
        # Backup existing config if it exists
        if [ -d "$HOME/.emacs.d" ]; then
            log "Backing up existing Emacs configuration..."
            backup_file "$HOME/.emacs.d"
            rm -rf "$HOME/.emacs.d"
        fi
        
        # Clone Doom Emacs
        log "Cloning Doom Emacs repository..."
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
        
        # Install Doom Emacs
        log "Installing Doom Emacs..."
        ~/.emacs.d/bin/doom install
        
        # Check if we have custom doom config in dotfiles
        if [ -d "$REPO_DIR/.doom.d" ]; then
            log "Found custom Doom configuration in dotfiles..."
            install_file "$REPO_DIR/.doom.d" "$HOME/.doom.d"
            
            # Sync Doom Emacs with custom config
            log "Syncing Doom Emacs with custom configuration..."
            ~/.emacs.d/bin/doom sync
        fi
        
        success "Doom Emacs installed successfully!"
    else
        log "Skipping Doom Emacs installation."
    fi
}

# ┌──────────────────────────┐
# │ SOURCE BUILD FUNCTIONS   │
# └──────────────────────────┘

build_cmake_from_source() {
    print_section "CMAKE SOURCE BUILD"
    
    if ask_yes_no "Do you want to build CMake from source?"; then
        log "Building CMake from source..."
        
        # Create build directory if it doesn't exist
        mkdir -p "$BUILD_DIR/cmake"
        cd "$BUILD_DIR/cmake"
        
        # Download latest CMake source
        if [ ! -d "cmake" ]; then
            log "Cloning CMake repository..."
            git clone https://github.com/Kitware/CMake.git cmake
        else
            log "Updating CMake repository..."
            cd cmake
            git pull
            cd ..
        fi
        
        cd cmake
        
        # Build and install CMake
        log "Configuring CMake build..."
        ./bootstrap --prefix=/usr/local
        
        log "Building CMake (this may take a while)..."
        make -j$(nproc)
        
        log "Installing CMake..."
        sudo make install
        
        # Verify installation
        cmake_version=$(cmake --version | head -n1)
        success "CMake built and installed successfully: ${CYAN}$cmake_version${RESET}"
        
        # Return to original directory
        cd "$REPO_DIR"
    else
        log "Skipping CMake source build."
    fi
}

build_neovim_from_source() {
    print_section "NEOVIM SOURCE BUILD"
    
    if ask_yes_no "Do you want to build Neovim from source?"; then
        log "Building Neovim from source..."
        
        # Create build directory if it doesn't exist
        mkdir -p "$BUILD_DIR/neovim"
        cd "$BUILD_DIR/neovim"
        
        # Download latest Neovim source
        if [ ! -d "neovim" ]; then
            log "Cloning Neovim repository..."
            git clone https://github.com/neovim/neovim.git neovim
        else
            log "Updating Neovim repository..."
            cd neovim
            git pull
            cd ..
        fi
        
        cd neovim
        
        # Build and install Neovim
        log "Building Neovim (this may take a while)..."
        make CMAKE_BUILD_TYPE=Release -j$(nproc)
        
        log "Installing Neovim..."
        sudo make install
        
        # Verify installation
        nvim_version=$(nvim --version | head -n1)
        success "Neovim built and installed successfully: ${CYAN}$nvim_version${RESET}"
        
        # Return to original directory
        cd "$REPO_DIR"
    else
        log "Skipping Neovim source build."
    fi
}

build_clangd_from_source() {
    print_section "CLANGD SOURCE BUILD"
    
    if ask_yes_no "Do you want to build clangd from source?"; then
        log "Building clangd from source..."
        
        # Create build directory if it doesn't exist
        mkdir -p "$BUILD_DIR/clangd"
        cd "$BUILD_DIR/clangd"
        
        # Download LLVM source
        if [ ! -d "llvm-project" ]; then
            log "Cloning LLVM repository..."
            git clone https://github.com/llvm/llvm-project.git
        else
            log "Updating LLVM repository..."
            cd llvm-project
            git pull
            cd ..
        fi
        
        cd llvm-project
        mkdir -p build && cd build
        
        # Build and install clangd
        log "Configuring clangd build..."
        cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_BUILD_TYPE=Release
        
        log "Building clangd (this may take a while)..."
        ninja clangd
        
        log "Installing clangd..."
        sudo ninja install
        
        # Verify installation
        if command -v clangd >/dev/null 2>&1; then
            clangd_version=$(clangd --version | head -n1)
            success "clangd built and installed successfully: ${CYAN}$clangd_version${RESET}"
        else
            warning "clangd was built but may not be in your PATH."
        fi
        
        # Return to original directory
        cd "$REPO_DIR"
    else
        log "Skipping clangd source build."
    fi
}

# ┌──────────────────────────┐
# │ MAIN ENTRY POINT         │
# └──────────────────────────┘
main() {
    print_banner
    log "Starting dotfiles installation process"
    
    detect_distro
    verify_repo
    
    # Ask if the user wants to install packages
    if ask_yes_no "Do you want to install required system packages?"; then
        install_packages
    fi
    
    ask_install_method
    install_configs
    install_optional_components
    
    # Added features
    install_flatpak
    setup_zsh
    install_doom_emacs
    
    # Source builds
    build_cmake_from_source
    build_neovim_from_source
    build_clangd_from_source
    
    print_section "INSTALLATION COMPLETE"
    
    # Final message
    if [ -d "$BACKUP_DIR" ]; then
        success "Installation complete! Backups of your previous configuration files were created in:"
        echo -e "  ${CYAN}$BACKUP_DIR${RESET}"
    else
        success "Installation complete! No existing configuration files were overwritten."
    fi
    
    echo
    echo -e "${BOLD}${GREEN}┌───────────────────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${GREEN}│  All done! Your system is now configured!      │${RESET}"
    echo -e "${BOLD}${GREEN}└───────────────────────────────────────────────┘${RESET}"
    echo
    
    log "You may need to reload your terminal or log out and back in for all changes to take effect."
    
    if [[ $(ps -p $$ | awk 'NR==2 {print $4}') != "zsh" && -n "$(which zsh 2>/dev/null)" ]]; then
        log "To start using ZSH right now, run: ${CYAN}zsh${RESET}"
    fi
}

main
