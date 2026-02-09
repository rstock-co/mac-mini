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

# History options
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt HIST_VERIFY            # Show command before executing from history

# ====== Environment Variables ======

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R"

# Colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ====== macOS Specific ======

# Disable macOS zsh sessions
export SHELL_SESSIONS_DISABLE=1
