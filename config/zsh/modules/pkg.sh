# pkg.sh - Package management shortcuts

# ====== MacPorts ======

# pi - port install
alias pi='sudo port install'

# pu - port uninstall
alias pu='sudo port uninstall'

# ps - port search
alias ps='port search'

# pup - port update and upgrade (like pacman -Syu)
alias pup='sudo port selfupdate && sudo port upgrade outdated'

# pl - port list installed
alias pl='port installed'

# pc - port clean
alias pc='sudo port clean --all installed'

# pr - port reclaim (free disk space)
alias pr='sudo port reclaim'

# ====== Node.js Package Managers ======

if command -v pnpm &> /dev/null; then
    # pn - pnpm shortcut
    alias pn='pnpm'

    # pni - pnpm install
    alias pni='pnpm install'

    # pnr - pnpm run
    alias pnr='pnpm run'

    # pnx - pnpm exec
    alias pnx='pnpm exec'
fi

if command -v bun &> /dev/null; then
    # bi - bun install
    alias bi='bun install'

    # br - bun run
    alias br='bun run'

    # bx - bunx
    alias bx='bunx'
fi

# ====== Cargo (Rust) ======

if command -v cargo &> /dev/null; then
    # ci - cargo install
    alias ci='cargo install'

    # cb - cargo build
    alias cb='cargo build'

    # cr - cargo run
    alias cr='cargo run'

    # ct - cargo test
    alias ct='cargo test'
fi
