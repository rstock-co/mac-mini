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
    # Use z directly, don't alias over cd
fi

# ====== fzf (Fuzzy Finder) ======

if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    # MacPorts fzf key bindings and completion
    [ -f /opt/local/share/fzf/shell/key-bindings.zsh ] && source /opt/local/share/fzf/shell/key-bindings.zsh
    [ -f /opt/local/share/fzf/shell/completion.zsh ] && source /opt/local/share/fzf/shell/completion.zsh
    # Fallback for other install methods
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# ====== bat (Better cat) ======

if command -v bat &> /dev/null; then
    # bcat - bat with full formatting
    alias bcat='bat'
    # cat stays as /bin/cat to avoid ANSI issues in pipes
fi

# ====== ripgrep ======

if command -v rg &> /dev/null; then
    export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# ====== Navigation ======

# .. - go up
alias ..='cd ..'
# ... - go up two
alias ...='cd ../..'
# .... - go up three
alias ....='cd ../../..'
