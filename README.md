# Mac Mini - Autonomous System Administration

Infrastructure-as-code for Mac mini setup and management.

## What This Is

This repository contains everything needed to transform a fresh Mac mini into an ultra-minimal, CLI-focused, high-performance development machine that mirrors an Arch Linux philosophy.

## Quick Start

### On This Machine (Arch Linux)

```bash
# Push to GitHub
cd /home/neo/agents/admin/macmini
gh repo create macmini --private --source=. --remote=origin
git add .
git commit -m "Initial Mac mini setup repo"
git push -u origin main
```

### On Mac Mini (First Time Setup)

```bash
# Clone the repo
git clone git@github.com:yourusername/macmini.git ~/agents/admin/macmini
cd ~/agents/admin/macmini

# Let Claude Code do the rest
claude

# On first run, Claude will:
# 1. Read CLAUDE.md and macminisetup.md
# 2. Guide you through Xcode/MacPorts installation (prerequisites)
# 3. Execute the entire setup autonomously
# 4. Configure all subsystems
# 5. Verify everything works
```

## What Gets Installed

- **MacPorts** - Package manager (20,000+ packages, builds from source)
- **Claude Code** - AI coding assistant (you!)
- **yabai + skhd** - Tiling window manager + hotkey daemon
- **Alacritty** - GPU-accelerated terminal
- **Modern CLI tools** - ripgrep, fd, bat, eza, fzf, neovim, etc.
- **Development tools** - Xcode, language runtimes as needed
- **Modular zsh** - Clean, organized shell configuration

## Philosophy

### Arch Linux Principles on macOS

| Principle | Implementation |
|-----------|----------------|
| Minimalism | Only install what's needed, remove bloat |
| Automation | One command updates everything |
| Transparency | All configs tracked, package list maintained |
| Control | Build from source (MacPorts = AUR) |
| Speed | Disable animations, optimize performance |

## Repository Structure

```
macmini/
├── CLAUDE.md               # Claude Code's instructions
├── README.md               # This file
├── macminisetup.md         # Complete setup guide
├── config/                 # All configuration files
│   ├── yabai/              # Window manager
│   ├── skhd/               # Hotkeys
│   ├── alacritty/          # Terminal
│   └── zsh/                # Shell
├── scripts/                # Automation scripts
├── data/packages/          # Package manifests
└── docs/                   # Additional documentation
```

## One-Command Updates

```bash
# Update everything (like `sudo pacman -Syu` on Arch)
sudo port selfupdate && sudo port upgrade outdated
```

This updates:
- All CLI tools
- Claude Code
- Language runtimes
- Everything MacPorts manages

## Configuration Management

All configurations are version controlled:
- Edit config on Mac mini
- Changes auto-synced to this repo
- Push to GitHub
- Pull on other machines

**Infrastructure-as-code:** This repo can rebuild the entire system from scratch.

## Key Features

### Window Management
- **yabai** - Tiling window manager (like Hyprland on Arch)
- **skhd** - Keyboard shortcuts (Vim-style navigation)
- Full workspace management

### Shell Configuration
- **Modular zsh** - Organized into `~/zshrc/*.sh` modules
- **Modern tools** - eza, zoxide, fzf integration
- **Consistent** - Same structure as Arch system

### Debloated macOS
- Dock hidden
- Spotlight disabled (use fzf)
- Animations disabled
- Bloatware removed
- Services optimized

## Daily Workflow

```bash
# Update packages
sudo port upgrade outdated

# Edit configs (auto-synced to repo)
nvim ~/.config/yabai/yabairc

# Commit and push changes
git add . && git commit -m "Update config" && git push
```

## Emergency Recovery

If something breaks:
1. All configs are in `config/` directory
2. Package list in `data/packages/macports.txt`
3. Full rebuild instructions in `macminisetup.md`

Clone repo → Run Claude → System restored.

## Integration with Arch System

This Mac mini mirrors the Arch Linux system at `/home/neo/agents/admin/system/`:
- Same package management philosophy
- Same dotfiles approach
- Same modular shell structure
- Same documentation style

**Goal:** Make switching between Arch and Mac mini seamless.

## Support

- **Setup issues:** See `docs/troubleshooting.md`
- **Config questions:** See `config/INDEX.md`
- **Package management:** See `macminisetup.md`

---

**Built for autonomy. Designed for speed. Optimized for developers.**
