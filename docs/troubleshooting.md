# Troubleshooting Guide

## AeroSpace

### Windows not tiling
1. Check Accessibility permissions: System Settings → Privacy & Security → Accessibility → AeroSpace ON
2. Reload config: `aerospace reload-config`
3. Check if running: `pgrep -x AeroSpace`
4. Restart: Quit from menu bar, then `open /Applications/AeroSpace.app`

### Keybinds not working
1. Verify Accessibility permissions are granted
2. Check config syntax: AeroSpace logs errors to stdout
3. Ensure `alt` key is not remapped by another tool

---

## MacPorts

### Command not found
```bash
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> ~/.zshrc
```

### Package build failure
```bash
sudo port clean <package>
sudo port install <package>
```

### Permission errors
Use `sudo` with port commands. Do NOT `chown /opt/local` - that breaks MacPorts.

### Package not found
```bash
sudo port selfupdate
port search <name>
```

---

## Alacritty

### Font not rendering
Install Nerd Font:
```bash
curl -L -o ~/Library/Fonts/MesloLGSNF-Regular.ttf \
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/L/Regular/MesloLGLNerdFont-Regular.ttf"
```

### Config errors
Check Alacritty logs in terminal output. Common issue: using deprecated `[shell]` section instead of `[terminal]`.

---

## Claude Code

### Not found after install
```bash
export PATH="/opt/local/bin:$PATH"
which claude
```

### Auto-update interfering
```bash
mkdir -p ~/.claude
echo '{"disableUpdateCheck": true}' > ~/.claude/settings.json
```

---

## Shell

### Modules not loading
```bash
ls -la ~/zshrc/
# Files should be numbered: 01-core.sh, 02-nav.sh, etc.

# Redeploy from repo
cp ~/agents/admin/mac-mini/config/zsh/modules/*.sh ~/zshrc/
source ~/.zshrc
```

### fzf keybindings not working
MacPorts installs fzf keybindings to `/opt/local/share/fzf/shell/`. Verify the path in `02-nav.sh`.

---

## macOS Tahoe Specific

### Liquid Glass too transparent
System Settings → Accessibility → Display → Reduce Transparency

### Can't delete system apps
News, Stocks, Home, FaceTime are on the signed system volume. Cannot be removed on Tahoe.

### Service management
```bash
# Disable user agent
launchctl bootout gui/$(id -u)/{service-name}
launchctl disable gui/$(id -u)/{service-name}

# Revert: delete /private/var/db/com.apple.xpc.launchd/disabled.plist and reboot
```

---

## Recovery

Rebuild from this repo:
```bash
cd ~/agents/admin/mac-mini
git pull
./scripts/setup.sh
./scripts/verify.sh
```
