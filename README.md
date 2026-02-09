# Mac Mini - Autonomous System Administration

Infrastructure-as-code for Mac mini running macOS Tahoe 26.

## Quick Start

### Push from Arch
```bash
cd /home/neo/agents/admin/macmini
gh repo create macmini --private --source=. --remote=origin --push
```

### On Mac Mini
```bash
git clone git@github.com:yourusername/macmini.git ~/agents/admin/macmini
cd ~/agents/admin/macmini
claude  # Claude reads CLAUDE.md and sets up everything
```

## What Gets Installed

- **MacPorts** - Package manager (20,000+ packages)
- **AeroSpace** - i3-like tiling window manager (no SIP disable)
- **Claude Code** - AI coding assistant
- **Alacritty** - GPU-accelerated terminal
- **CLI tools** - ripgrep, fd, bat, eza, fzf, neovim, zoxide, tmux, etc.

## One-Command Updates

```bash
sudo port selfupdate && sudo port upgrade outdated
```

## Architecture

```
macmini/
├── CLAUDE.md                       # Agent instructions
├── macminisetup.md                 # 25-step setup guide
├── config/                         # All configs (version controlled)
│   ├── aerospace/aerospace.toml    # Window manager
│   ├── alacritty/alacritty.toml    # Terminal
│   └── zsh/                        # Shell (modular)
├── scripts/
│   ├── setup.sh                    # Deploy configs + install packages
│   └── verify.sh                   # Verify installation
├── data/packages/macports.txt      # Package manifest
├── .claude/skills/
│   ├── docs/                       # Tool documentation reference
│   └── apple-docs/                 # Apple developer docs fetcher
└── docs/troubleshooting.md         # Common fixes
```

## Rebuild from Scratch

```bash
git clone <this-repo> ~/agents/admin/macmini
cd ~/agents/admin/macmini
./scripts/setup.sh
./scripts/verify.sh
```
