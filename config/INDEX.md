# Configuration Index

Central registry of all subsystem configurations.

## Window Management

### yabai (Tiling Window Manager)
- **Config:** `config/yabai/yabairc`
- **Location:** `~/.config/yabai/yabairc`
- **Service:** Background service via `yabai --start-service`
- **Restart:** `yabai --restart-service`
- **Logs:** `/tmp/yabai_*.out.log`
- **Docs:** https://github.com/koekeishiya/yabai

**Features:**
- BSP tiling layout
- Vim-style window navigation
- Workspace management
- Window opacity settings

### skhd (Hotkey Daemon)
- **Config:** `config/skhd/skhdrc`
- **Location:** `~/.config/skhd/skhdrc`
- **Service:** Background service via `skhd --start-service`
- **Restart:** `skhd --restart-service`
- **Logs:** `/tmp/skhd_*.out.log`
- **Docs:** https://github.com/koekeishiya/skhd

**Features:**
- Keyboard shortcuts for window management
- Workspace switching
- Application launching
- yabai control bindings

---

## Terminal

### Alacritty
- **Config:** `config/alacritty/alacritty.toml`
- **Location:** `~/.config/alacritty/alacritty.toml`
- **Restart:** Automatic on config change
- **Docs:** https://alacritty.org/config-alacritty.html

**Features:**
- GPU-accelerated rendering
- Minimal UI
- Fast startup
- Highly configurable

---

## Shell

### Zsh (Modular Configuration)
- **Main config:** `config/zsh/zshrc`
- **Location:** `~/.zshrc`
- **Modules:** `config/zsh/modules/*.sh` → `~/zshrc/*.sh`
- **Reload:** `source ~/.zshrc` or restart terminal

**Module Structure:**
- `core.sh` - PATH, environment, history
- `nav.sh` - eza, zoxide, fzf, navigation tools
- `pkg.sh` - Package management shortcuts
- `alias-management.sh` - Alias editing and viewing
- `dotfiles.sh` - Bare git dotfiles alias

---

## Package Management

### MacPorts
- **Config:** `/opt/local/etc/macports/macports.conf`
- **Package list:** `data/packages/macports.txt`
- **Update:** `sudo port selfupdate && sudo port upgrade outdated`
- **Docs:** https://www.macports.org/

**Managed packages tracked in:** `data/packages/macports.txt`

---

## System Settings

### macOS Defaults
- **Dock:** Hidden with delay
- **Animations:** Disabled
- **Spotlight:** Disabled
- **Transparency:** Reduced
- **Key repeat:** Fast (like Arch)

**All settings applied via:** `defaults write` commands in `macminisetup.md`

---

## Development Tools

### Xcode
- **Location:** `/Applications/Xcode.app`
- **Command Line Tools:** `/Library/Developer/CommandLineTools`
- **Required for:** MacPorts, iOS development, building from source

### Claude Code
- **Config:** `~/.claude/settings.json`
- **Binary:** `/opt/local/bin/claude`
- **Updates:** Managed by MacPorts (auto-update disabled)

---

## Dotfiles (Bare Git Method)

- **Repo location:** `~/.dotfiles/` (bare repo)
- **Working tree:** `~/` (home directory)
- **Command:** `dotfiles` alias (not `git`)
- **Tracks:** `.zshrc`, `.config/`, etc.

**Usage:**
```bash
dotfiles status
dotfiles add <file>
dotfiles commit -m "message"
dotfiles push
```

---

## Configuration Workflow

### When You Edit a Config:

1. **Edit on Mac mini:**
   ```bash
   nvim ~/.config/yabai/yabairc
   ```

2. **Sync to repo:**
   ```bash
   cp ~/.config/yabai/yabairc ~/agents/admin/macmini/config/yabai/
   cd ~/agents/admin/macmini
   git add config/yabai/yabairc
   git commit -m "Update yabai config"
   git push
   ```

3. **Deploy on another machine:**
   ```bash
   cd ~/agents/admin/macmini
   git pull
   cp config/yabai/yabairc ~/.config/yabai/
   yabai --restart-service
   ```

---

## Troubleshooting

### Window Manager Not Working
1. Check SIP status: `csrutil status`
2. Check logs: `tail -f /tmp/yabai_*.out.log`
3. Verify service: `ps aux | grep yabai`

### Keybinds Not Working
1. Grant Accessibility permissions: System Settings → Privacy & Security → Accessibility
2. Check logs: `tail -f /tmp/skhd_*.out.log`
3. Verify config syntax: `skhd --check`

### Package Issues
1. Update MacPorts: `sudo port selfupdate`
2. Clean package: `sudo port clean <package>`
3. Rebuild: `sudo port install <package>`

---

**All configs version-controlled. All changes tracked. Full transparency.**
