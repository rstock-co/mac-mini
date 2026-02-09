# Mac Mini Setup Guide
## Arch Linux → macOS Tahoe Parity

Transform macOS into an ultra-minimal, CLI-focused powerhouse.

**Target OS:** macOS Tahoe 26.2+ (Apple Silicon)

**Package Manager:** MacPorts (not Homebrew)
- 20,000+ packages, builds from source like AUR
- One command updates everything: `sudo port selfupdate && sudo port upgrade outdated`

**Window Manager:** AeroSpace (not yabai)
- i3-like tiling WM that actually works on Tahoe
- No SIP disable required
- Built-in keybinds (no skhd needed)
- TOML config (dotfiles-friendly)

---

## Manual Prerequisites (Complete Before Running Claude Code)

These are done by hand before Claude Code can run on the machine.

### 1. Install Xcode

Full Xcode for mobile dev, or Command Line Tools for CLI-only:
```bash
# Full Xcode: Mac App Store → "Xcode" → Install (~15GB)
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept

# OR CLI-only (~500MB):
xcode-select --install
sudo xcodebuild -license accept
```

### 2. Install MacPorts

Download the Tahoe `.pkg` from https://www.macports.org/install.php
```bash
echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc
sudo port selfupdate
```

### 3. Install Claude Code
```bash
sudo port install claude-code
mkdir -p ~/.claude
echo '{"disableUpdateCheck": true}' > ~/.claude/settings.json
```

### 4. Clone This Repo and Launch Claude
```bash
mkdir -p ~/agents/admin
git clone git@github.com:yourusername/mac-mini.git ~/agents/admin/mac-mini
cd ~/agents/admin/mac-mini
claude
```

Paste the prompt from `INITIAL_PROMPT.md`. **Everything below is automated by Claude.**

---

## Phase 1: Foundation (Automated)

### Step 1: Install Remaining CLI Tools

`setup.sh` installs everything from `data/packages/macports.txt`:
```bash
./scripts/setup.sh
```

---

## Phase 2: Window Management

### Step 3: Install AeroSpace

AeroSpace is an i3-like tiling WM. No SIP disable needed.

**Download from GitHub Releases:**
```bash
# Download latest release
curl -L -o /tmp/aerospace.zip \
  "$(curl -s https://api.github.com/repos/nikitabobko/AeroSpace/releases/latest \
  | grep browser_download_url | grep zip | cut -d'"' -f4)"

# Extract and install
cd /tmp && unzip -o aerospace.zip
cp -r AeroSpace.app /Applications/

# Remove quarantine flag (not Apple-notarized)
xattr -d com.apple.quarantine /Applications/AeroSpace.app
```

**Grant Accessibility Permissions (REQUIRED):**
1. System Settings → Privacy & Security → Accessibility
2. Click "+" and add AeroSpace.app
3. Toggle it ON
4. Also add Terminal.app

Without Accessibility permissions, AeroSpace cannot manage windows.

---

### Step 4: Configure AeroSpace

```bash
mkdir -p ~/.config/aerospace
cp config/aerospace/aerospace.toml ~/.config/aerospace/
```

Key design choices in the config:
- `alt` as modifier (avoids conflict with macOS `cmd` shortcuts)
- Vim-style `h/j/k/l` navigation
- Workspaces 1-6 on `alt-1` through `alt-6`
- Resize mode via `alt-r`
- Auto-float for System Settings, Calculator, Simulator

---

### Step 5: Start AeroSpace

```bash
open /Applications/AeroSpace.app

# Verify it's running
aerospace list-workspaces --all
```

AeroSpace appears in the menu bar. It starts at login automatically (configured in `aerospace.toml`).

---

## Phase 3: Debloat macOS Tahoe

### Step 6: Hide Dock

```bash
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock no-bouncing -bool true
killall Dock
```

---

### Step 7: Disable Animations

```bash
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
killall Dock
killall Finder
```

---

### Step 8: Reduce Liquid Glass Transparency

macOS Tahoe uses the Liquid Glass design. Tone it down:

```bash
defaults write com.apple.universalaccess reduceTransparency -bool true
defaults write com.apple.universalaccess reduceMotion -bool true
```

Or: System Settings → Accessibility → Display → Reduce Transparency

---

### Step 9: Disable Spotlight (Use fzf Instead)

```bash
sudo mdutil -a -i off
```

Do NOT try to `launchctl unload` the Spotlight daemon - it is SIP-protected on Tahoe.

---

### Step 10: Disable Useless Services

```bash
# Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Handoff
defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool no
defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool no

# AirDrop
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

# Time Machine
sudo tmutil disable
```

---

### Step 11: Remove Bloatware Apps

**App Store apps (safe to delete):**
```bash
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iMovie.app
sudo rm -rf /Applications/Keynote.app
sudo rm -rf /Applications/Numbers.app
sudo rm -rf /Applications/Pages.app
```

System apps (News, Stocks, Home, FaceTime) are on the signed system volume and **cannot be deleted** on Tahoe. Leave them.

---

### Step 12: Finder Settings

```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder CreateDesktop -bool false
killall Finder
```

---

## Phase 4: Shell Configuration

### Step 13: Deploy Modular Zsh Config

```bash
mkdir -p ~/zshrc
cp config/zsh/zshrc ~/.zshrc
cp config/zsh/modules/*.sh ~/zshrc/
source ~/.zshrc
```

Modules load in numbered order:
- `01-core.sh` - PATH, env, history
- `02-nav.sh` - eza, zoxide, fzf, bat
- `03-pkg.sh` - MacPorts shortcuts
- `04-alias-management.sh` - Alias editing/viewing

---

### Step 14: Install Nerd Font

Required for terminal icons:
```bash
curl -L -o ~/Library/Fonts/MesloLGSNF-Regular.ttf \
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/L/Regular/MesloLGLNerdFont-Regular.ttf"
curl -L -o ~/Library/Fonts/MesloLGSNF-Bold.ttf \
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/L/Bold/MesloLGLNerdFontMono-Bold.ttf"
```

---

## Phase 5: Dotfiles & Git

### Step 15: Set Up SSH Keys

```bash
ssh-keygen -t ed25519 -C "your@email.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
# Add to GitHub: https://github.com/settings/keys
```

---

### Step 16: Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global init.defaultBranch main
```

---

### Step 17: Config Management

**No separate dotfiles repo needed.** This admin repo IS your config manager.

Edit → copy back → commit:
```bash
# Example: you edit AeroSpace config on the Mac
nvim ~/.config/aerospace/aerospace.toml

# Sync back to repo
cp ~/.config/aerospace/aerospace.toml ~/agents/admin/mac-mini/config/aerospace/
cd ~/agents/admin/mac-mini
git add config/aerospace/aerospace.toml
git commit -m "Update AeroSpace config"
git push
```

To redeploy all configs from repo:
```bash
./scripts/setup.sh
```

---

## Phase 6: Performance

### Step 18: Energy Settings

```bash
sudo pmset -a sleep 0
sudo pmset -a displaysleep 30
sudo pmset -a powernap 0
```

---

### Step 19: Compile Zsh for Speed

```bash
zcompile ~/.zshrc
for f in ~/zshrc/*.sh; do zcompile "$f"; done
```

---

## Phase 7: Language Runtimes

### Step 20: Install As Needed

```bash
# Node.js
sudo port install nodejs20 npm10
npm install -g pnpm

# Bun
curl -fsSL https://bun.sh/install | bash

# Python
sudo port install python312
sudo port select --set python python312

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Go
sudo port install go
```

---

### Step 21: Additional Dev Tools (Optional)

```bash
sudo port install delta lazygit hyperfine tokei sd
```

---

### Step 22: Final Tweaks

```bash
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Restart to apply
sudo shutdown -r now
```

---

## Verification

```bash
./scripts/verify.sh
```

---

## Maintenance

```bash
# Update everything (like pacman -Syu)
sudo port selfupdate && sudo port upgrade outdated

# Reload AeroSpace config
aerospace reload-config

# Reload shell
source ~/.zshrc
```

---

## Key Differences from Arch

| Feature | Arch | macOS Tahoe |
|---------|------|-------------|
| Package manager | pacman/paru | MacPorts |
| Window manager | Hyprland | AeroSpace |
| Hotkeys | Hyprland built-in | AeroSpace built-in |
| Service manager | systemctl | launchctl |
| SIP | N/A | Leave enabled |
| Transparency | None | Liquid Glass (reduce it) |
