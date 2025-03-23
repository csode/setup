#!/bin/bash

set -e

if [ "$1" != "install" ]; then
    echo "Skipping installation. Run with 'install' argument to proceed."
    exit 0
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unsupported distribution"
    exit 1
fi

install_deps() {
    case "$DISTRO" in
        ubuntu|debian|pop)
            sudo apt update && sudo apt install -y dconf i3 ibus kitty neofetch nvim polybar build-essential git cmake ninja-build pkg-config libx11-dev libxft-dev libxinerama-dev
            ;;
        arch|manjaro)
            sudo pacman -Syu --noconfirm base-devel git cmake ninja xorg-x11proto-devel libx11 libxft libxinerama dconf i3 ibus kitty neofetch nvim polybar;
            ;;
        fedora)
            sudo dnf install -y @development-tools git cmake ninja-build pkg-config libX11-devel libXft-devel libXinerama-devel dconf i3 ibus kitty neofetch nvim polybar;
            ;;
        *)
            echo "Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}
build_clangd() {
    echo "Building clangd from source..."
    mkdir -p ~/build/clangd
    cd ~/build/clangd
    git clone https://github.com/llvm/llvm-project.git
    cd llvm-project
    mkdir -p build && cd build
    cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_BUILD_TYPE=Release
    ninja clangd
    sudo ninja install
}

install_deps
build_clangd

echo "Installation complete."

