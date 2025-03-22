# Dotfiles Setup Guide

This guide explains how to set up your dotfiles, including **i3**, **Kitty**, and **Neovim**, along with the necessary prerequisites.

---

## **Prerequisites**
Ensure your system has the required packages installed:

### **Essential Packages**
```sh
sudo apt update && sudo apt install -y \
    i3 \
    i3-gaps \
    kitty \
    picom \
    neovim \
    fzf \
    ripgrep \
    tmux \
    bash \
    git \
    curl \
    wget \
    unzip \
    fonts-firacode
```

### **Nerd Fonts** (Required for icons in Neovim & i3)
```sh
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
fc-cache -fv
```

---

## **Cloning and Applying Dotfiles**

### **1. Clone Your Dotfiles Repository**
```sh
git clone <your-dotfiles-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

### **2. Symlink Configuration Files**
```sh
ln -sf ~/.dotfiles/i3 ~/.config/i3
ln -sf ~/.dotfiles/kitty ~/.config/kitty
ln -sf ~/.dotfiles/nvim ~/.config/nvim  # See Neovim README for setup details
ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/bashrc ~/.bashrc
```
---

## **Setting Up Synth Shell (Bash Enhancements)**
[Synth Shell](https://github.com/andresgongora/synth-shell) provides a better Bash experience.

### **1. Install Synth Shell**
```sh
git clone https://github.com/andresgongora/synth-shell.git ~/.synth-shell
cd ~/.synth-shell
./setup.sh
```

### **2. Apply Synth Shell to Bash**
Ensure your `~/.bashrc` includes:
```sh
source ~/.synth-shell/synth-shell.sh
```
Then reload Bash:
```sh
source ~/.bashrc
```

---

## **Final Steps**
Restart your system or log out and log back in to apply all changes. Enjoy your setup! 🚀


