# Quick Start

TLDR for getting the Mac mini set up from this repo.

## Manual Prerequisites (Already Done If You're Reading This in Claude Code)

By the time Claude Code is running, these are already complete:
- Xcode installed and configured
- MacPorts installed and in PATH
- Claude Code installed via MacPorts
- This repo cloned to `~/agents/admin/mac-mini`

## Launch

```bash
cd ~/agents/admin/mac-mini
claude
```

Paste the prompt from `INITIAL_PROMPT.md`. Claude takes over from here.

## What Claude Does Automatically

1. Research macOS Tahoe 26.2 compatibility issues
2. Run `./scripts/setup.sh` (installs remaining packages, deploys all configs)
3. Walk you through AeroSpace installation + Accessibility permissions
4. Run `./scripts/verify.sh` and fix failures
5. Show final verification

## Watch Out For

- **Font mismatch** - If Alacritty shows squares, the Nerd Font name may be wrong
- **MacPorts build failures** - `sudo port clean <pkg> && sudo port install <pkg>`. Check https://trac.macports.org/wiki/TahoeProblems
- **AeroSpace download URL** - If the curl chain fails, download manually from https://github.com/nikitabobko/AeroSpace/releases
- **`apple_docs.py`** - Copy from Arch: `scp arch-box:/home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py ~/tools/`

## After Everything Works

```bash
# Update everything (your new pacman -Syu)
sudo port selfupdate && sudo port upgrade outdated

# Reload AeroSpace after config edits
aerospace reload-config

# Reload shell after zsh edits
source ~/.zshrc
```

## If It All Goes Wrong

```bash
git pull                  # Get latest fixes
./scripts/setup.sh        # Redeploy everything
./scripts/verify.sh       # Check what's broken
```
