# alias-management.sh - Manage and view shell aliases

# ====== Editing ======

# ea - edit aliases
alias ea='nvim ~/zshrc/ && source ~/.zshrc'
# ez - edit main zshrc
alias ez='nvim ~/.zshrc && source ~/.zshrc'

# ====== Reloading ======

# sa - source all
alias sa='source ~/.zshrc'

# ====== Viewing ======

if command -v fzf &> /dev/null; then
    # va - view aliases (fzf)
    alias va='alias | fzf'
    # vh - view hotkeys (AeroSpace config)
    alias vh='/bin/cat ~/.config/aerospace/aerospace.toml | grep "^alt" | fzf'
else
    # va - view aliases (plain)
    alias va='alias | sort'
fi
