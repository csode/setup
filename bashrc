POLYBAR_TARGET=~/personal/dotfiles/polybar
POLYBAR_LINK=~/.config/polybar

[ -L "$POLYBAR_LINK" ] && rm "$POLYBAR_LINK"

ln -s "$POLYBAR_TARGET" "$POLYBAR_LINK"


# Catppuccin Colors (Macchiato)
RESET="\[\e[0m\]"
PURPLE="\[\e[38;5;176m\]"  # Purple for commands
GREEN="\[\e[38;5;142m\]"   # Green for arrow
YELLOW="\[\e[38;5;179m\]"  # Yellow for path
CYAN="\[\e[38;5;110m\]"    # Cyan for Git branch

# Function to get Git branch
parse_git_branch() {
    git branch 2>/dev/null | sed -n 's/* \(.*\)/ (\1)/p'
}

set -o vi

export PS1="${GREEN} ${YELLOW}\w${CYAN}\$(parse_git_branch) ${PURPLE}➜ "

export PS1="${PS1}${RESET}"

export LS_COLORS="di=38;5;109:fi=38;5;250:ln=38;5;110:ex=38;5;176"
export GREP_COLORS="ms=38;5;204:mc=38;5;142:sl=38;5;179"
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind 'set completion-ignore-case on'

bind 'TAB:menu-complete'

complete -o nospace -F _cd cd

shopt -s histappend

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export HISTSIZE=100000
export HISTFILESIZE=200000

export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE="ls:cd:cd -:pwd:exit:clear"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'

alias gpwd='cat ~/Documents/token.md | xclip -selection clipboard  '
alias reload="source ~/.bashrc"

