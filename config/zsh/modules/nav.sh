# nav.sh - Navigation and modern CLI tools

# ====== eza (Modern ls) ======

if command -v eza &> /dev/null; then
    # ls - list files
    alias ls='eza -a --color=always --group-directories-first'

    # ll - long list
    alias ll='eza -al --color=always --group-directories-first'

    # lt - tree view
    alias lt='eza -aT --color=always --group-directories-first'

    # la - list with git status
    alias la='eza -al --git --color=always --group-directories-first'
fi

# ====== zoxide (Smart cd) ======

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    # z - smart cd
    alias cd='z'
fi

# ====== fzf (Fuzzy Finder) ======

if command -v fzf &> /dev/null; then
    # fzf configuration
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

    # Use fd for fzf if available
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    # Load fzf key bindings and completion
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# ====== bat (Better cat) ======

if command -v bat &> /dev/null; then
    # cat - view files with syntax highlighting
    alias cat='bat --style=plain'

    # bcat - bat with line numbers
    alias bcat='bat'
fi

# ====== ripgrep ======

if command -v rg &> /dev/null; then
    # Default ripgrep config
    export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# ====== Navigation Shortcuts ======

# .. - go up one directory
alias ..='cd ..'

# ... - go up two directories
alias ...='cd ../..'

# .... - go up three directories
alias ....='cd ../../..'

# -- - go to previous directory
alias -- -='cd -'
