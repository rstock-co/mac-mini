# Mac Mini Setup Guide
## Arch Linux → macOS Parity

Transform macOS into an ultra-minimal, CLI-focused powerhouse.

**Package Manager:** MacPorts (not Homebrew)
- **Why MacPorts:** More mature, better architecture, 20,000+ packages vs Homebrew's 4,000
- **Builds from source** like AUR (more Arch-like)
- **Faster and lighter** than Ruby-based Homebrew
- **More reliable** for serious development work

**Prerequisites:**
- Xcode or Command Line Tools (required for building from source)
- For iOS/mobile development: Full Xcode installation required
- Time: 2-3 hours for full setup (including Xcode download)

---

## Phase 1: Foundation

### Step 1: Install MacPorts
**Download the package installer for your macOS version:**
- Visit: https://www.macports.org/install.php
- Download the `.pkg` file for your macOS version
- Run the installer

**After installation, update MacPorts:**
```bash
sudo port selfupdate
```

**Add MacPorts to PATH:**
```bash
echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Why:** MacPorts = More like Arch. 20,000+ packages, builds from source, mature and reliable.

---

### Step 1.5: Install Xcode or Command Line Tools

**MacPorts builds from source (like AUR) and requires build tools.**

#### Option A: Command Line Tools Only (Minimal - ~500MB)
**Choose this if:** You only need CLI tools, servers, backend dev (no mobile apps)

```bash
# Install Command Line Tools
xcode-select --install

# Accept license
sudo xcodebuild -license accept

# Set path
sudo xcode-select --switch /Library/Developer/CommandLineTools

# Verify
xcode-select -p
# Should show: /Library/Developer/CommandLineTools
```

#### Option B: Full Xcode (Required for Mobile Dev - ~15GB)
**Choose this if:** You're building iOS/iPadOS apps, using SwiftUI, or need Xcode IDE

**Method 1: Mac App Store (Easier)**
1. Open Mac App Store
2. Search "Xcode"
3. Click Install (15GB download, 30-60 min)

**Method 2: Direct Download (Faster)**
1. Visit: https://developer.apple.com/download/all/
2. Download latest Xcode `.xip` file
3. Double-click to extract
4. Move `Xcode.app` to `/Applications/`

**After installation:**
```bash
# Set Xcode path
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Accept license
sudo xcodebuild -license accept

# Verify
xcode-select -p
# Should show: /Applications/Xcode.app/Contents/Developer

# Install additional components (iOS simulators, etc.)
# Open Xcode → Settings → Platforms → Download iOS/iPadOS simulators
```

**Why:** Without build tools, MacPorts can't compile packages. Command Line Tools = minimal. Full Xcode = iOS development + all build tools.

---

### Step 2: Install Core CLI Tools
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
  wget \
  curl

# Note: Some packages may have slightly different names
# Search if needed: port search <name>
```

**Why:** Port your modern CLI stack from Arch. No `cat`, no `ls`, no `grep`.

---

### Step 2.5: Install Claude Code

```bash
# Install Claude Code via MacPorts
sudo port install claude-code

# Verify installation
claude --version

# Disable Claude's built-in updater (let MacPorts manage updates)
mkdir -p ~/.claude
echo '{"disableUpdateCheck": true}' > ~/.claude/settings.json
```

**Why:** Claude Code is available in MacPorts. By disabling auto-updates, `sudo port upgrade outdated` will update Claude Code along with all your other packages - just like `sudo pacman -Syu` on Arch.

---

### Step 3: Install Terminal Emulator
**Option 1: Download Alacritty binary (Recommended)**
```bash
# Download from GitHub releases
curl -L https://github.com/alacritty/alacritty/releases/download/v0.13.1/Alacritty-v0.13.1.dmg -o /tmp/alacritty.dmg

# Mount and copy to Applications
hdiutil attach /tmp/alacritty.dmg
cp -r /Volumes/Alacritty/Alacritty.app /Applications/
hdiutil detach /Volumes/Alacritty
```

**Option 2: Build from MacPorts**
```bash
sudo port install alacritty
```

**Copy your Alacritty config from Arch:**
```bash
mkdir -p ~/.config/alacritty
scp arch-box:~/.config/alacritty/alacritty.toml ~/.config/alacritty/
```

---

## Phase 2: Window Management

### Step 4: Build yabai from Source (Tiling Window Manager)
```bash
# Install build dependencies
sudo port install cmake

# Clone and build yabai
cd /tmp
git clone https://github.com/koekeishiya/yabai
cd yabai
make install

# Move binary to path
sudo cp bin/yabai /usr/local/bin/

# Verify installation
yabai --version
```

**Why:** Closest thing to Hyprland on macOS. Full tiling WM. Building from source = Arch way.

---

### Step 5: Build skhd from Source (Hotkey Daemon)
```bash
# Clone and build skhd
cd /tmp
git clone https://github.com/koekeishiya/skhd
cd skhd
make install

# Move binary to path
sudo cp bin/skhd /usr/local/bin/

# Verify installation
skhd --version
```

**Why:** Your keybind system. Like Hyprland's `bind =` but for macOS.

---

### Step 6: Disable System Integrity Protection (Partial)
**Required for full yabai features.**

1. **Reboot into Recovery Mode:**
   - Apple Silicon: Hold power button → "Options" → Recovery
   - Intel: Hold Cmd+R during boot

2. **Open Terminal in Recovery:**
   ```bash
   csrutil enable --without fs --without debug --without nvram
   ```

3. **Reboot normally**

**Why:** Allows yabai to inject into Dock and WindowServer for true tiling.

---

### Step 7: Configure yabai
```bash
mkdir -p ~/.config/yabai
nvim ~/.config/yabai/yabairc
```

**Basic config:**
```bash
#!/usr/bin/env sh

# Tiling mode
yabai -m config layout bsp

# Padding and gaps
yabai -m config top_padding    10
yabai -m config bottom_padding 10
yabai -m config left_padding   10
yabai -m config right_padding  10
yabai -m config window_gap     10

# Mouse settings
yabai -m config mouse_follows_focus off
yabai -m config focus_follows_mouse off

# Window modifications
yabai -m config window_shadow float
yabai -m config window_opacity on
yabai -m config active_window_opacity 1.0
yabai -m config normal_window_opacity 0.9

# Ignore system apps
yabai -m rule --add app="^System Settings$" manage=off
yabai -m rule --add app="^Calculator$" manage=off
```

Make executable:
```bash
chmod +x ~/.config/yabai/yabairc
```

---

### Step 8: Configure skhd
```bash
mkdir -p ~/.config/skhd
nvim ~/.config/skhd/skhdrc
```

**Port your Hyprland keybinds:**
```bash
# Terminal
cmd - return : /Applications/Alacritty.app/Contents/MacOS/alacritty

# Window focus (vim-style)
cmd - h : yabai -m window --focus west
cmd - j : yabai -m window --focus south
cmd - k : yabai -m window --focus north
cmd - l : yabai -m window --focus east

# Move windows
shift + cmd - h : yabai -m window --warp west
shift + cmd - j : yabai -m window --warp south
shift + cmd - k : yabai -m window --warp north
shift + cmd - l : yabai -m window --warp east

# Workspaces (desktops)
cmd - 1 : yabai -m space --focus 1
cmd - 2 : yabai -m space --focus 2
cmd - 3 : yabai -m space --focus 3
cmd - 4 : yabai -m space --focus 4

# Move window to workspace
shift + cmd - 1 : yabai -m window --space 1
shift + cmd - 2 : yabai -m window --space 2
shift + cmd - 3 : yabai -m window --space 3
shift + cmd - 4 : yabai -m window --space 4

# Toggle window float
cmd - t : yabai -m window --toggle float

# Restart yabai
ctrl + cmd - r : yabai --restart-service

# Close window
cmd - q : yabai -m window --close
```

---

### Step 9: Start yabai and skhd Services
```bash
# Start yabai
yabai --start-service

# Start skhd
skhd --start-service

# Verify they're running
ps aux | grep -E 'yabai|skhd' | grep -v grep

# Or check if they respond
yabai -m query --windows
```

---

## Phase 3: Debloat macOS

### Step 10: Hide/Disable Dock
```bash
# Hide dock with massive delay (essentially invisible)
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock no-bouncing -bool true
killall Dock
```

---

### Step 11: Disable Animations
```bash
# System-wide animation disable
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
```

---

### Step 12: Disable Spotlight (Use fzf Instead)
```bash
sudo mdutil -a -i off
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
```

---

### Step 13: Disable Useless Services
```bash
# Time Machine
sudo tmutil disable

# Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Handoff
defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool no
defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool no

# AirDrop
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true
```

---

### Step 14: Remove Bloatware Apps
```bash
# Delete default Apple apps (requires SIP partially disabled)
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iMovie.app
sudo rm -rf /Applications/Keynote.app
sudo rm -rf /Applications/Numbers.app
sudo rm -rf /Applications/Pages.app
sudo rm -rf /Applications/News.app
sudo rm -rf /Applications/Stocks.app
sudo rm -rf /Applications/Home.app
sudo rm -rf /Applications/FaceTime.app

# Clear cache
sudo rm -rf ~/Library/Caches/*
```

---

### Step 15: Finder Settings (Minimal UI)
```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable desktop icons (you don't need them)
defaults write com.apple.finder CreateDesktop -bool false

killall Finder
```

---

## Phase 4: Shell Configuration

### Step 16: Set Up Modular Zsh Config
```bash
mkdir -p ~/zshrc
```

Create `~/.zshrc`:
```bash
# Load all modules from ~/zshrc/
for config_file in ~/zshrc/*.sh; do
  source "$config_file"
done
```

---

### Step 17: Create Core Module
```bash
nvim ~/zshrc/core.sh
```

**Content:**
```bash
# core.sh - Path, environment, history

# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Environment
export EDITOR="nvim"
export VISUAL="nvim"
```

---

### Step 18: Create Navigation Module
```bash
nvim ~/zshrc/nav.sh
```

**Content:**
```bash
# nav.sh - Modern navigation tools

# eza aliases
alias ls='eza -a --color=always'
alias ll='eza -al --color=always'
alias lt='eza -aT --color=always'

# zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd='z'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

---

### Step 19: Create Alias Management Module
```bash
nvim ~/zshrc/alias-management.sh
```

**Content:**
```bash
# alias-management.sh - Edit and reload aliases

# ea - edit aliases
alias ea='nvim ~/zshrc/nav.sh && source ~/zshrc/nav.sh'

# sa - source all modules
alias sa='source ~/.zshrc'

# va - view aliases (requires fzf)
alias va='alias | fzf'
```

---

## Phase 5: Dotfiles

### Step 20: Set Up Bare Git Dotfiles
```bash
# Initialize bare repo
git init --bare $HOME/.dotfiles

# Create dotfiles alias
echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/zshrc/dotfiles.sh

# Configure repo
dotfiles config --local status.showUntrackedFiles no

# Add remote (if you have existing dotfiles)
# dotfiles remote add origin git@github.com:yourusername/dotfiles.git
# dotfiles pull
```

Source the new module:
```bash
source ~/.zshrc
```

---

## Phase 6: Performance

### Step 21: Disable Transparency and Visual Effects
```bash
# Reduce transparency
defaults write com.apple.universalaccess reduceTransparency -bool true

# Disable motion
defaults write com.apple.universalaccess reduceMotion -bool true

# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -bool true
```

---

### Step 22: Optimize Energy Settings
```bash
# Disable sleep (desktop replacement mode)
sudo pmset -a sleep 0
sudo pmset -a disksleep 0
sudo pmset -a displaysleep 30

# Disable Power Nap
sudo pmset -a powernap 0
```

---

### Step 23: Compile Zsh for Speed
```bash
# Compile your zshrc for faster startup
zcompile ~/.zshrc
zcompile ~/zshrc/core.sh
zcompile ~/zshrc/nav.sh
zcompile ~/zshrc/alias-management.sh
```

---

## Phase 7: Additional Tools

### Step 24: Install Language Tools (Optional)
```bash
# Node.js
sudo port install nodejs20 npm10

# pnpm and bun (install via npm/cargo)
npm install -g pnpm
cargo install bun  # After installing Rust

# Python
sudo port install python312
sudo port select --set python python312

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Go
sudo port install go
```

---

### Step 25: Final System Tweaks
```bash
# Disable "Are you sure you want to open?" dialogs
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Fast key repeat (like Arch)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Screenshot to ~/Screenshots instead of Desktop
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Restart to apply all changes
sudo shutdown -r now
```

---

## Verification Checklist

After reboot, verify everything works:

```bash
# Check Xcode/Command Line Tools
xcode-select -p
xcodebuild -version  # If using full Xcode

# Check MacPorts
port version

# Check installed packages
port installed

# Check Claude Code
claude --version
claude doctor

# Check yabai
ps aux | grep yabai | grep -v grep
yabai --version

# Check skhd
ps aux | grep skhd | grep -v grep
skhd --version

# Test keybinds
# Cmd+Return should open Alacritty
# Cmd+H/J/K/L should switch window focus

# Check CLI tools
rg --version
fd --version
eza --version
bat --version

# Check dotfiles
dotfiles status
```

---

## Maintenance Commands

```bash
# Update MacPorts and all packages
sudo port selfupdate
sudo port upgrade outdated

# Restart window manager
yabai --restart-service
skhd --restart-service

# Reload shell
source ~/.zshrc

# Check running services
ps aux | grep -E 'yabai|skhd' | grep -v grep

# List installed packages
port installed

# Search for packages
port search <query>

# Clean old package versions
sudo port clean --all installed
```

---

## MacPorts Quick Reference

```bash
# Package Management
sudo port install <package>         # Install package
sudo port uninstall <package>       # Remove package
sudo port install <package> +variant  # Install with variant
port search <query>                 # Search for packages
port info <package>                 # Show package info
port contents <package>             # List installed files
port deps <package>                 # Show dependencies

# Updates
sudo port selfupdate                # Update ports tree
sudo port upgrade outdated          # Upgrade all packages
sudo port upgrade <package>         # Upgrade specific package

# Cleanup
sudo port clean --all <package>     # Clean build files
sudo port uninstall inactive        # Remove old versions
sudo port reclaim                   # Free disk space

# Information
port installed                      # List installed packages
port outdated                       # List packages with updates
port variants <package>             # Show available variants
port echo active                    # List active packages

# Troubleshooting
port diagnose                       # Check for problems
port notes <package>                # Show post-install notes
port log <package>                  # View build logs
```

**Variants** (like USE flags in Gentoo):
```bash
# Example: Install Python with specific features
sudo port install python312 +readline +sqlite

# List available variants
port variants python312
```

---

## Key Differences from Arch

| Feature | Arch | macOS |
|---------|------|-------|
| Package manager | pacman/paru | MacPorts (port) |
| Build from source | AUR | MacPorts (default) |
| Package count | ~13,000 official | ~20,000 ports |
| Window manager | Hyprland (Wayland) | yabai (built from source) |
| Service manager | systemctl | launchctl |
| System bloat | Minimal | Unavoidable kernel bloat |
| Customization | Unlimited | Limited by SIP |
| Rolling updates | Yes | Annual major versions |

---

## Troubleshooting

**yabai not tiling windows:**
- Verify SIP is partially disabled: `csrutil status`
- Check logs: `tail -f /tmp/yabai_*.out.log`
- Ensure yabai is running: `ps aux | grep yabai | grep -v grep`
- Rebuild from source if needed: `cd /tmp/yabai && git pull && make install`

**skhd keybinds not working:**
- Grant Accessibility permissions: System Settings → Privacy & Security → Accessibility
- Restart skhd: `skhd --restart-service`
- Check config syntax: `skhd --check`
- View logs: `tail -f /tmp/skhd_*.out.log`

**MacPorts permission errors:**
- Fix ownership: `sudo chown -R $(whoami) /opt/local`
- Reinstall MacPorts if needed

**Package not found:**
- Update ports tree: `sudo port selfupdate`
- Search for package: `port search <name>`
- Check variants: `port variants <package>`

**Build failures:**
- Clean and retry: `sudo port clean <package> && sudo port install <package>`
- Check dependencies: `port deps <package>`

**Package only available in Homebrew:**
- You can run MacPorts + Homebrew side-by-side if needed
- MacPorts uses `/opt/local`, Homebrew uses `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
- Prefer MacPorts when available; use Homebrew as fallback
- Keep MacPorts first in PATH: `export PATH="/opt/local/bin:/opt/homebrew/bin:$PATH"`

---

## Next Steps

1. **Port your existing dotfiles** from Arch using the bare git method
2. **Create workspace-specific configs** in `~/zshrc/` for each project
3. **Set up SSH keys** for GitHub: `ssh-keygen -t ed25519`
4. **Configure git**: `git config --global user.name` and `user.email`
5. **Install project-specific tools** via MacPorts as needed: `sudo port install <package>`
6. **Explore available packages**: Browse https://ports.macports.org/

---

**You now have a CLI-focused, minimal-bloat Mac mini that operates like Arch Linux.**
