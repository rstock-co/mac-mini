# alias-management.sh - Manage and view shell aliases

# ====== Alias Editing ======

# ea - edit aliases
alias ea='nvim ~/zshrc/nav.sh && source ~/zshrc/nav.sh'

# ep - edit package aliases
alias ep='nvim ~/zshrc/pkg.sh && source ~/zshrc/pkg.sh'

# ec - edit core config
alias ec='nvim ~/zshrc/core.sh && source ~/zshrc/core.sh'

# ez - edit main zshrc
alias ez='nvim ~/.zshrc && source ~/.zshrc'

# ====== Alias Reloading ======

# sa - source all (reload shell config)
alias sa='source ~/.zshrc'

# ====== Alias Viewing ======

if command -v fzf &> /dev/null; then
    # va - view aliases (interactive fzf)
    alias va='alias | fzf'
else
    # va - view aliases (plain list)
    alias va='alias | sort'
fi

# ====== Configuration Viewing ======

# vh - view hotkeys (skhd config)
alias vh='cat ~/.config/skhd/skhdrc | grep -v "^#" | grep -v "^$" | fzf'

# vy - view yabai config
alias vy='cat ~/.config/yabai/yabairc | grep -v "^#" | grep -v "^$" | fzf'
