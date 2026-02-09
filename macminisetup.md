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

## Phase 1: Foundation

### Step 1: Install Xcode

**Required for MacPorts and mobile development.**

Full Xcode is needed if building iOS/iPadOS apps.

1. Open Mac App Store → Search "Xcode" → Install (~15GB)
2. Or download from https://developer.apple.com/download/all/

After installation:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept

# Verify
xcode-select -p
# Should show: /Applications/Xcode.app/Contents/Developer
```

**CLI-only (no mobile dev):** Install Command Line Tools instead (~500MB):
```bash
xcode-select --install
sudo xcodebuild -license accept
```

---

### Step 2: Install MacPorts

Download the `.pkg` installer for **macOS Tahoe** from:
https://www.macports.org/install.php

Run the installer, then:
```bash
# Add MacPorts to PATH
echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Update MacPorts
sudo port selfupdate

# Verify
port version
```

---

### Step 3: Install Core CLI Tools

```bash
sudo port install \
  ripgrep \
  fd \
  bat \
  eza \
  fzf \
  neovim \
  git \
  gh \
  btop \
  zoxide \
  tmux \
  jq \
  wget
```

---

### Step 4: Install Claude Code

```bash
sudo port install claude-code

# Verify
claude --version

# Disable Claude's built-in updater (let MacPorts manage updates)
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'EOF'
{
  "disableUpdateCheck": true
}
EOF
```

Now `sudo port upgrade outdated` updates Claude Code along with everything else.

---

### Step 5: Install Terminal Emulator

```bash
# Install Alacritty via MacPorts (latest version)
sudo port install alacritty

# Deploy config from this repo
mkdir -p ~/.config/alacritty
cp config/alacritty/alacritty.toml ~/.config/alacritty/
```

---

## Phase 2: Window Management

### Step 6: Install AeroSpace

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
4. Also add Alacritty.app

Without Accessibility permissions, AeroSpace cannot manage windows.

---

### Step 7: Configure AeroSpace

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

### Step 8: Start AeroSpace

```bash
open /Applications/AeroSpace.app

# Verify it's running
aerospace list-workspaces --all
```

AeroSpace appears in the menu bar. It starts at login automatically (configured in `aerospace.toml`).

---

## Phase 3: Debloat macOS Tahoe

### Step 9: Hide Dock

```bash
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock no-bouncing -bool true
killall Dock
```

---

### Step 10: Disable Animations

```bash
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
killall Dock
killall Finder
```

---

### Step 11: Reduce Liquid Glass Transparency

macOS Tahoe uses the Liquid Glass design. Tone it down:

```bash
defaults write com.apple.universalaccess reduceTransparency -bool true
defaults write com.apple.universalaccess reduceMotion -bool true
```

Or: System Settings → Accessibility → Display → Reduce Transparency

---

### Step 12: Disable Spotlight (Use fzf Instead)

```bash
sudo mdutil -a -i off
```

Do NOT try to `launchctl unload` the Spotlight daemon - it is SIP-protected on Tahoe.

---

### Step 13: Disable Useless Services

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

### Step 14: Remove Bloatware Apps

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

### Step 15: Finder Settings

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

### Step 16: Deploy Modular Zsh Config

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
- `05-dotfiles.sh` - Bare git dotfiles

---

### Step 17: Install Nerd Font

Required for terminal icons:
```bash
curl -L -o ~/Library/Fonts/MesloLGSNF-Regular.ttf \
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/L/Regular/MesloLGLNerdFont-Regular.ttf"
curl -L -o ~/Library/Fonts/MesloLGSNF-Bold.ttf \
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/L/Bold/MesloLGLNerdFontMono-Bold.ttf"
```

---

## Phase 5: Dotfiles & Git

### Step 18: Set Up SSH Keys

```bash
ssh-keygen -t ed25519 -C "your@email.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
# Add to GitHub: https://github.com/settings/keys
```

---

### Step 19: Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global init.defaultBranch main
```

---

### Step 20: Set Up Bare Git Dotfiles

```bash
git init --bare $HOME/.dotfiles
source ~/.zshrc  # loads dotfiles alias
dotfiles config --local status.showUntrackedFiles no
```

---

## Phase 6: Performance

### Step 21: Energy Settings

```bash
sudo pmset -a sleep 0
sudo pmset -a displaysleep 30
sudo pmset -a powernap 0
```

---

### Step 22: Compile Zsh for Speed

```bash
zcompile ~/.zshrc
for f in ~/zshrc/*.sh; do zcompile "$f"; done
```

---

## Phase 7: Language Runtimes

### Step 23: Install As Needed

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

### Step 24: Additional Dev Tools (Optional)

```bash
sudo port install delta lazygit hyperfine tokei sd
```

---

### Step 25: Final Tweaks

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
