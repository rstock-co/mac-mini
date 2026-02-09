# pkg.sh - Package management shortcuts

# ====== MacPorts ======

# pi - port install
alias pi='sudo port install'
# pu - port uninstall
alias pu='sudo port uninstall'
# psearch - port search (not ps, that shadows /bin/ps)
alias psearch='port search'
# pup - port update and upgrade (like pacman -Syu)
alias pup='sudo port selfupdate && sudo port upgrade outdated'
# pl - port list installed
alias pl='port installed'
# pclean - port clean
alias pclean='sudo port clean --all installed'
# preclaim - port reclaim (free disk space)
alias preclaim='sudo port reclaim'

# ====== Node.js ======

if command -v pnpm &> /dev/null; then
    # pn - pnpm
    alias pn='pnpm'
    # pni - pnpm install
    alias pni='pnpm install'
    # pnr - pnpm run
    alias pnr='pnpm run'
fi

if command -v bun &> /dev/null; then
    # bi - bun install
    alias bi='bun install'
    # br - bun run
    alias br='bun run'
fi
