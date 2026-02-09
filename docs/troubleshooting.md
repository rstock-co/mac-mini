# Troubleshooting Guide

Common issues and solutions for Mac mini setup.

---

## Installation Issues

### Xcode Command Line Tools Not Found

**Problem:** `xcode-select: error: command line tools are not installed`

**Solution:**
```bash
xcode-select --install
# Wait for installation to complete
sudo xcodebuild -license accept
```

### MacPorts Command Not Found

**Problem:** `port: command not found`

**Solution:**
```bash
# Add MacPorts to PATH
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Make it permanent
echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### MacPorts Build Failures

**Problem:** Package fails to build

**Solution:**
```bash
# Clean and retry
sudo port clean <package>
sudo port install <package>

# If still fails, check logs
port log <package>

# Update MacPorts
sudo port selfupdate
```

---

## Window Management Issues

### yabai Not Tiling Windows

**Problem:** Windows not tiling, yabai appears broken

**Solutions:**

1. **Check SIP status:**
   ```bash
   csrutil status
   # Should show: enabled with some features disabled
   ```

2. **Disable SIP partially (if needed):**
   - Reboot into Recovery Mode (Cmd+R)
   - Open Terminal
   - Run: `csrutil enable --without fs --without debug --without nvram`
   - Reboot

3. **Check yabai logs:**
   ```bash
   tail -f /tmp/yabai_*.out.log
   ```

4. **Restart yabai:**
   ```bash
   yabai --restart-service
   ```

5. **Verify config:**
   ```bash
   cat ~/.config/yabai/yabairc
   chmod +x ~/.config/yabai/yabairc
   ```

### skhd Keybinds Not Working

**Problem:** Keyboard shortcuts don't work

**Solutions:**

1. **Grant Accessibility permissions:**
   - System Settings → Privacy & Security → Accessibility
   - Add Terminal.app or Alacritty.app
   - Toggle it off and on

2. **Check skhd logs:**
   ```bash
   tail -f /tmp/skhd_*.out.log
   ```

3. **Verify config syntax:**
   ```bash
   skhd --check
   ```

4. **Restart skhd:**
   ```bash
   skhd --restart-service
   ```

### Services Not Starting

**Problem:** yabai/skhd won't start

**Solution:**
```bash
# Check if already running
ps aux | grep -E 'yabai|skhd' | grep -v grep

# Kill existing processes
killall yabai
killall skhd

# Start fresh
yabai --start-service
skhd --start-service

# Check status
ps aux | grep yabai | grep -v grep
ps aux | grep skhd | grep -v grep
```

---

## Configuration Issues

### Config Changes Not Applied

**Problem:** Edited config but no changes

**Solution:**
```bash
# For yabai
yabai --restart-service

# For skhd
skhd --restart-service

# For zsh
source ~/.zshrc

# For Alacritty (auto-reloads on save)
# Just save the file
```

### Configs Not Found

**Problem:** Apps can't find their configs

**Solution:**
```bash
# Re-deploy from repo
cd ~/agents/admin/macmini
./scripts/setup.sh

# Or manually copy
cp config/yabai/yabairc ~/.config/yabai/
cp config/skhd/skhdrc ~/.config/skhd/
cp config/alacritty/alacritty.toml ~/.config/alacritty/
cp config/zsh/zshrc ~/.zshrc
cp config/zsh/modules/*.sh ~/zshrc/
```

---

## Package Management Issues

### Package Not Found

**Problem:** `Error: Port <package> not found`

**Solution:**
```bash
# Update ports tree
sudo port selfupdate

# Search for package
port search <name>

# Check package name spelling
port list | grep <name>
```

### Permission Errors

**Problem:** `Error: You do not have permission`

**Solution:**
```bash
# Fix MacPorts ownership
sudo chown -R $(whoami) /opt/local

# Or use sudo
sudo port install <package>
```

### Slow Package Installation

**Problem:** MacPorts building from source is slow

**Solution:**
```bash
# Install binary if available
sudo port install <package> +universal

# Or wait - building from source is the Arch way
# Check progress: tail -f /opt/local/var/macports/logs/...
```

---

## Shell Issues

### Zsh Module Not Loading

**Problem:** Aliases or functions not available

**Solution:**
```bash
# Check modules exist
ls -la ~/zshrc/

# Re-deploy modules
cp ~/agents/admin/macmini/config/zsh/modules/*.sh ~/zshrc/

# Reload shell
source ~/.zshrc

# Debug: Check for errors
zsh -x ~/.zshrc
```

### Command Not Found After Install

**Problem:** Installed package but command not found

**Solution:**
```bash
# Check if binary exists
port contents <package> | grep bin

# Add to PATH if needed
export PATH="/opt/local/bin:$PATH"

# Make permanent
echo 'export PATH="/opt/local/bin:$PATH"' >> ~/.zshrc
```

---

## Claude Code Issues

### Claude Code Not Found

**Problem:** `claude: command not found`

**Solution:**
```bash
# Install via MacPorts
sudo port install claude-code

# Verify installation
which claude
claude --version

# If installed but not found, check PATH
export PATH="/opt/local/bin:$PATH"
```

### Claude Code Auto-Update Interfering

**Problem:** Claude keeps updating itself instead of using MacPorts

**Solution:**
```bash
# Disable Claude's auto-updater
mkdir -p ~/.claude
echo '{"disableUpdateCheck": true}' > ~/.claude/settings.json

# Verify
cat ~/.claude/settings.json
```

---

## Performance Issues

### System Feels Slow

**Solutions:**

1. **Disable animations:**
   ```bash
   defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
   defaults write com.apple.dock expose-animation-duration -float 0
   killall Dock
   ```

2. **Disable Spotlight:**
   ```bash
   sudo mdutil -a -i off
   ```

3. **Check running processes:**
   ```bash
   btop
   # or
   top
   ```

### High CPU Usage

**Problem:** System running hot

**Solution:**
```bash
# Check what's using CPU
btop

# Common culprits:
# - Spotlight indexing (mdworker)
# - Time Machine backups
# - Background app updates

# Disable Spotlight
sudo mdutil -a -i off

# Disable Time Machine
sudo tmutil disable
```

---

## Network Issues

### Can't Download Packages

**Problem:** MacPorts can't download

**Solution:**
```bash
# Check internet connection
ping google.com

# Try different mirror
sudo port selfupdate

# Check firewall settings
```

---

## Recovery

### Complete System Reset

If everything is broken, rebuild from this repo:

```bash
cd ~/agents/admin/macmini
git pull
./scripts/setup.sh
./scripts/verify.sh
```

### Config Restore

```bash
# Restore all configs
cd ~/agents/admin/macmini
cp -r config/yabai/* ~/.config/yabai/
cp -r config/skhd/* ~/.config/skhd/
cp -r config/alacritty/* ~/.config/alacritty/
cp config/zsh/zshrc ~/.zshrc
cp config/zsh/modules/*.sh ~/zshrc/

# Restart services
yabai --restart-service
skhd --restart-service
source ~/.zshrc
```

---

## Getting Help

1. **Check logs:**
   - yabai: `/tmp/yabai_*.out.log`
   - skhd: `/tmp/skhd_*.out.log`
   - MacPorts: `/opt/local/var/macports/logs/`

2. **Verify installation:**
   ```bash
   ./scripts/verify.sh
   ```

3. **Review config:**
   ```bash
   cat config/INDEX.md
   ```

4. **Check documentation:**
   - yabai: https://github.com/koekeishiya/yabai/wiki
   - skhd: https://github.com/koekeishiya/skhd
   - MacPorts: https://www.macports.org/
