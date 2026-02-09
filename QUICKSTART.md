# Quick Start

TLDR for getting the Mac mini set up from this repo.

## Prerequisites (Do These Manually First)

1. **Install Xcode** from the Mac App Store (~15GB, needed for MacPorts + mobile dev)
2. **Install MacPorts** from https://www.macports.org/install.php (download the Tahoe `.pkg`)
3. **Restart terminal** after both installs

Verify before proceeding:
```bash
xcode-select -p          # Should show Xcode path
port version              # Should show MacPorts version
```

If `port` is not found: `export PATH="/opt/local/bin:/opt/local/sbin:$PATH"`

## Phase 1: Test Package Manager

Try a few packages first to make sure MacPorts builds work on your Tahoe version:
```bash
sudo port selfupdate
sudo port install ripgrep fd bat eza
```

If these build and install cleanly, MacPorts is good to go.

## Phase 2: Run Setup Script

```bash
cd ~/agents/admin/macmini
./scripts/setup.sh
```

This installs all packages from `data/packages/macports.txt` and deploys all configs.

## Phase 3: Install AeroSpace

This is separate because it's a GitHub download, not a MacPorts package:
```bash
curl -L -o /tmp/aerospace.zip \
  "$(curl -s https://api.github.com/repos/nikitabobko/AeroSpace/releases/latest \
  | grep browser_download_url | grep zip | cut -d'"' -f4)"
cd /tmp && unzip -o aerospace.zip
cp -r AeroSpace.app /Applications/
xattr -d com.apple.quarantine /Applications/AeroSpace.app
open /Applications/AeroSpace.app
```

**IMPORTANT:** Grant Accessibility permissions when prompted, or manually:
System Settings → Privacy & Security → Accessibility → AeroSpace ON

## Phase 4: Verify

```bash
./scripts/verify.sh
```

Fix anything red. Green = good. Yellow = optional.

## Watch Out For

- **Font mismatch** - If Alacritty shows squares instead of icons, the Nerd Font name may be wrong. Open Alacritty, check what font name it expects vs what's installed in `~/Library/Fonts/`
- **`claude-code` port** - This is a newer MacPorts addition. If it fails, fall back to `npm install -g @anthropic-ai/claude-code`
- **MacPorts build failures** - Run `sudo port clean <pkg> && sudo port install <pkg>`. Check https://trac.macports.org/wiki/TahoeProblems for known issues
- **AeroSpace download URL** - If the curl chain fails, just download the zip manually from https://github.com/nikitabobko/AeroSpace/releases
- **`apple_docs.py`** - The skill references a script on the Arch box. Copy it to the Mac: `scp arch-box:/home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py ~/tools/`

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

Claude Code is right there on the Mac to help fix issues in real time. That's the whole point.
