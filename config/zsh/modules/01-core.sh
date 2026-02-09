# core.sh - Core environment configuration

# ====== PATH ======

# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Cargo (Rust)
export PATH="$HOME/.cargo/bin:$PATH"

# ====== History ======

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# ====== Environment ======

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Disable macOS zsh sessions
export SHELL_SESSIONS_DISABLE=1
