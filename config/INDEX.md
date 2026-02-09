# Configuration Index

Central registry of all subsystem configurations.

## Window Management

### AeroSpace (Tiling Window Manager)
- **Config:** `config/aerospace/aerospace.toml`
- **Location:** `~/.config/aerospace/aerospace.toml`
- **Reload:** `aerospace reload-config`
- **Docs:** https://nikitabobko.github.io/AeroSpace/guide
- **No SIP disable required**

## Terminal

### Alacritty
- **Config:** `config/alacritty/alacritty.toml`
- **Location:** `~/.config/alacritty/alacritty.toml`
- **Reload:** Automatic on save
- **Docs:** https://alacritty.org/config-alacritty.html

## Shell

### Zsh (Modular)
- **Main:** `config/zsh/zshrc` → `~/.zshrc`
- **Modules:** `config/zsh/modules/*.sh` → `~/zshrc/*.sh`
- **Reload:** `source ~/.zshrc`

| Module | Purpose |
|--------|---------|
| `01-core.sh` | PATH, env, history |
| `02-nav.sh` | eza, zoxide, fzf |
| `03-pkg.sh` | MacPorts shortcuts |
| `04-alias-management.sh` | Alias tools |

## Package Management

### MacPorts
- **Package list:** `data/packages/macports.txt`
- **Update:** `sudo port selfupdate && sudo port upgrade outdated`
- **Docs:** https://guide.macports.org/

## Development

### Xcode
- **Location:** `/Applications/Xcode.app`
- **Docs:** Use `/apple-docs` skill

### Claude Code
- **Config:** `~/.claude/settings.json`
- **Binary:** `/opt/local/bin/claude`
- **Updates:** Managed by MacPorts

## Config Management

**No separate dotfiles repo.** This admin repo is the single source of truth.

- **Edit on Mac** → copy back to `config/` → commit → push
- **Redeploy from repo** → `./scripts/setup.sh`
