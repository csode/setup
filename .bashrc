case $- in
    *i*) ;;
    *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Enable shell vi editing mode
set -o vi

# Use lesspipe if available
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set Debian chroot if available
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Red color for username only
RED='\[\e[31m\]'
RESET='\[\e[0m\]'

# Prompt: pop@username:/cwd$
PS1='pop@'"${RED}\u${RESET}"':\w\$ '

# Notification alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load custom aliases if available
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Bash completion if not in POSIX mode
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Load Rust env if installed
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# In Emacs shell fallback
if [ -n "$EMACS" ]; then
    export CLICOLOR=0
    export GREP_OPTIONS='--color=never'
    export PS1='pop@\u:\w\$ '
fi

# Initialize Starship prompt
eval "$(starship init bash)"
