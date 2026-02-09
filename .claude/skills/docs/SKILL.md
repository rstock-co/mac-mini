---
name: docs
description: |
  Reference documentation for key Mac mini tools. Provides llms.txt URLs, official docs, and GitHub repos for AeroSpace, Alacritty, MacPorts, and CLI tools. Use when configuring or troubleshooting any installed tool.
---

# Documentation Reference

Quick access to official docs for all key tools on this Mac mini.

## When to Use

- Configuring AeroSpace, Alacritty, or MacPorts
- Troubleshooting a tool
- Looking up command syntax or config options
- Need authoritative reference (not memory)

---

## AeroSpace (Window Manager)

**llms.txt:** Not available

**Official Docs:**
- Guide: https://nikitabobko.github.io/AeroSpace/guide
- Commands: https://nikitabobko.github.io/AeroSpace/commands
- Config: https://nikitabobko.github.io/AeroSpace/guide#default-config

**GitHub:** https://github.com/nikitabobko/AeroSpace

**Context7 ID:** `/nikitabobko/aerospace` (88 code snippets)

**How to fetch docs:**
```
WebFetch(
  url: "https://nikitabobko.github.io/AeroSpace/guide",
  prompt: "Extract the configuration reference"
)
```

**Key config location:** `~/.config/aerospace/aerospace.toml`

---

## Alacritty (Terminal)

**llms.txt:** Not available

**Official Docs:**
- Config reference: https://alacritty.org/config-alacritty.html
- Changelog: https://github.com/alacritty/alacritty/blob/master/CHANGELOG.md

**GitHub:** https://github.com/alacritty/alacritty

**How to fetch docs:**
```
WebFetch(
  url: "https://alacritty.org/config-alacritty.html",
  prompt: "Extract the complete configuration reference"
)
```

**Key config location:** `~/.config/alacritty/alacritty.toml`

**IMPORTANT:** As of Alacritty 0.14+, `[shell]` is deprecated. Use `[terminal]` section instead.

---

## MacPorts (Package Manager)

**llms.txt:** Not available

**Official Docs:**
- Guide: https://guide.macports.org/
- Port search: https://ports.macports.org/
- Tahoe issues: https://trac.macports.org/wiki/TahoeProblems

**GitHub:** https://github.com/macports/macports-ports

**Quick Reference:**
```bash
sudo port install <pkg>         # Install
sudo port uninstall <pkg>       # Remove
sudo port selfupdate            # Update ports tree
sudo port upgrade outdated      # Upgrade all
port search <query>             # Search
port installed                  # List installed
port variants <pkg>             # Show build options
port contents <pkg>             # List installed files
sudo port clean --all <pkg>     # Clean build files
sudo port reclaim               # Free disk space
```

---

## CLI Tools Quick Reference

### ripgrep
- GitHub: https://github.com/BurntSushi/ripgrep
- Docs: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md

### fd
- GitHub: https://github.com/sharkdp/fd
- Usage: `fd --help`

### bat
- GitHub: https://github.com/sharkdp/bat
- Usage: `bat --help`

### eza
- GitHub: https://github.com/eza-community/eza
- Docs: https://eza.rocks

### fzf
- GitHub: https://github.com/junegunn/fzf
- Wiki: https://github.com/junegunn/fzf/wiki

### zoxide
- GitHub: https://github.com/ajeetdsouza/zoxide
- Usage: `z --help`

### neovim
- Docs: https://neovim.io/doc/
- GitHub: https://github.com/neovim/neovim

### tmux
- GitHub: https://github.com/tmux/tmux
- Wiki: https://github.com/tmux/tmux/wiki

### btop
- GitHub: https://github.com/aristocratos/btop

### gh (GitHub CLI)
- Docs: https://cli.github.com/manual/
- GitHub: https://github.com/cli/cli

### delta (git diffs)
- GitHub: https://github.com/dandavison/delta

### lazygit
- GitHub: https://github.com/jesseduffield/lazygit

---

## How to Use This Skill

1. Identify what tool you need docs for
2. Use WebFetch with the URL above to get current docs
3. For AeroSpace config questions, use Context7: `/nikitabobko/aerospace`
4. For Apple/Xcode docs, use the `/apple-docs` skill instead
