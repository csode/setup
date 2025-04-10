export XCURSOR_THEME="Adwaita"
export XCURSOR_SIZE=20
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export DOOMDIR=~/.config/doom

# Define icons for various parts of the prompt
USER_ICON=""           # User icon
PATH_ICON=""           # Folder icon for path
GIT_ICON=""            # Git branch icon
ARROW_ICON="  ❯"         # Arrow symbol for command input

# Customize colors
RESET="\[\e[0m\]"
DARK_GREEN="\[\e[38;5;22m\]"    # Dark Green for arrow
DARK_ORANGE="\[\e[38;5;166m\]"  # Dark Orange for commands
YELLOW="\[\e[38;5;136m\]"       # Muted Yellow for path
LIGHT_BLUE="\[\e[38;5;39m\]"    # Light Blue for Git branch
GRUVBOX_RED="\[\e[38;5;168m\]"
CYAN="\[\e[36m\]"

# Function to get Git branch
parse_git_branch() {
    git branch 2>/dev/null | sed -n 's/* \(.*\)/ (\1)/p'
}

set -o vi

# Customize prompt with new icons and color scheme
export PS1="${DARK_GREEN}${DARK_ORANGE}\u ${YELLOW}${PATH_ICON} \w${GRUVBOX_RED}\$(parse_git_branch)\n${CYAN}${ARROW_ICON} "
export PS1="${PS1}${RESET}"

# Customize LS_COLORS for darker theme
export LS_COLORS="di=38;5;108:fi=38;5;250:ln=38;5;33:ex=38;5;178"
export LS_COLORS="di=38;5;108:fi=38;5;250:ln=38;5;33:ex=38;5;178:*.md=38;5;81:*.sh=38;5;130"


# Customize GREP_COLORS for dark theme
export GREP_COLORS="ms=38;5;204:mc=38;5;141:sl=38;5;179"
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Enable case-insensitive tab completion
bind 'set completion-ignore-case on'

# Enable menu-complete with Tab
bind 'TAB:menu-complete'

# Custom completion for `cd` command
complete -o nospace -F _cd cd

# Enable history append
shopt -s histappend

# Adjust history settings
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Set history size and ignore duplicate commands
export HISTSIZE=100000
export HISTFILESIZE=200000

# Ignore certain commands in history
export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE="ls:cd:cd -:pwd:exit:clear"
export TERM=xterm-256color
export PATH="$HOME/.emacs.d/bin:$PATH"


# Key bindings for history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Aliases
export LS_COLORS="di=34;1:*.txt=31:*.sh=32"
alias ls='ls --color=auto --indicator-style=classify'
alias ll='ls -lah'
alias la='ls -A'
alias ntutor='nvim +Tutor'

# Custom command for copying token to clipboard
alias gpwd='cat ~/Documents/token.md | xclip -selection clipboard  '
alias reload="source ~/.bashrc"

. "$HOME/.cargo/env"
neofetch
