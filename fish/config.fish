if status is-interactive
    # Commands to run in interactive sessions can go here
end
# TAB = accept autosuggestion
bind \t accept-autosuggestion

# SHIFT+TAB = show completions
bind "\e[Z" complete
alias gitter="~/scripts/gitter.sh"
alias cpp="~/scripts/cpp.sh"
alias cgen="~/scripts/c.sh"
alias package="~/scripts/package.sh"
alias dev="cd ~/Programming/"
alias scripts="cd ~/scripts/"
alias setup="cd ~/setup/"
alias thoughts="cd ~/thoughts/"
alias download="cd ~/Downloads/"
alias notes="cd ~/notes/"
alias packages="cd ~/packages/"
# PATH updates
set -Ux PATH $HOME/.emacs.d/bin $PATH
set -Ux PATH $HOME/.config/emacs/bin $PATH
set -Ux PATH $HOME/.nimble/bin $PATH
set -Ux PATH $HOME/.npm-global/bin $PATH
set -Ux PATH $HOME/packages/zig $PATH

# Environment variables
set -Ux DOOMDIR $HOME/.config/doom
set -Ux GCM_CREDENTIAL_STORE cache
set -Ux GIT_TERMINAL_PROMPT 1
set -Ux GIT_ASKPASS git-credential-manager-core
set -Ux NVM_DIR $HOME/.nvm
set -Ux EDITOR nvim

# vi keybindings
fish_vi_key_bindings

# Load NVM
if test -s "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/nvm.sh"
end

if test -s "$NVM_DIR/bash_completion"
    source "$NVM_DIR/bash_completion"
end

# Aliases
alias cpp="$HOME/scripts/cpp.sh"
alias gitter="$HOME/scripts/gitter.sh"
alias ccg="$HOME/scripts/cpp.sh"
alias packages="$HOME/scripts/package.sh"
alias vim="nvim"
alias luamake="/home/csode/packages/lua-language-server/3rd/luamake/luamake"

# zoxide initialization
zoxide init fish | source

# Auto-start tmux if not inside tmux
if command -v tmux > /dev/null
    if not set -q TMUX
        tmux attach-session -t main; or tmux new-session -s main
    end
end
starship init fish | source

