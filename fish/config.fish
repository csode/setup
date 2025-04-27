if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_vi_key_bindings
starship init fish | source
# TAB = accept autosuggestion
bind \t accept-autosuggestion

# SHIFT+TAB = show completions
bind "\e[Z" complete
alias gitter="~/scripts/gitter.sh"
