# Mac Mini Agent

Autonomous macOS Tahoe system administration and configuration management.

---

## System Context

**OS:** macOS Tahoe 26.2+ (Apple Silicon)
**Package Manager:** MacPorts (`sudo port install`)
**Window Manager:** AeroSpace (i3-like, no SIP disable needed)
**Terminal:** Apple Terminal
**Shell:** Zsh (modular, `~/zshrc/*.sh`)

**Load on startup:**
- `@macminisetup.md` - Setup blueprint
- `@config/INDEX.md` - Config registry

---

## On First Run

Xcode, MacPorts, and Claude Code are already installed (you wouldn't be running otherwise).

Read `macminisetup.md` and execute the automated setup:
1. Run `scripts/setup.sh` (installs remaining packages, deploys configs)
2. Install AeroSpace from GitHub releases
3. Grant Accessibility permissions
4. Start AeroSpace
5. Run `scripts/verify.sh`

---

## Skills

### `/docs` - Tool Documentation
Reference docs for AeroSpace, MacPorts, CLI tools.

### `/apple-docs` - Apple Developer Documentation
Fetches official Apple docs using `apple_docs.py` tool.
```bash
python /home/neo/dev/apps/spoke/tools/apple-docs/apple_docs.py <framework>/<class> -o /tmp/docs/
```

---

## Package Management

```bash
sudo port install <pkg>                          # Install
sudo port selfupdate && sudo port upgrade outdated  # Update all
port installed                                    # List installed
```

Package manifest: `data/packages/macports.txt`

---

## Configuration

All configs in `config/` directory. Deploy with `./scripts/setup.sh`.

| Subsystem | Config | Location |
|-----------|--------|----------|
| AeroSpace | `config/aerospace/aerospace.toml` | `~/.config/aerospace/` |
| Zsh | `config/zsh/` | `~/.zshrc` + `~/zshrc/` |

---

## Shell Aliases

Every alias has a mnemonic comment:
```bash
# pi - port install
alias pi='sudo port install'
```

Modules load in numbered order (`01-core.sh` first).

---

## Config Management

**No separate dotfiles repo.** This admin repo is the single source of truth.

```bash
# After editing a config on the Mac:
cp ~/.config/aerospace/aerospace.toml config/aerospace/
git add . && git commit -m "Update config" && git push

# Redeploy all configs from repo:
./scripts/setup.sh
```

---

## Apple Terminal

Configure via AppleScript (`osascript -e`). No dotfile — settings live in `defaults`.

```bash
# Read current font size / name / profile
osascript -e 'tell application "Terminal" to get the font size of the default settings'
osascript -e 'tell application "Terminal" to get the font name of the default settings'
osascript -e 'tell application "Terminal" to get the name of the default settings'

# Set font size (applies to default profile)
osascript -e 'tell application "Terminal" to set the font size of the default settings to 21'

# Set font (use PostScript name, e.g. MesloLGLNFM-Bold, MesloLGLNFM-Regular)
osascript -e 'tell application "Terminal" to set the font name of the default settings to "MesloLGLNFM-Bold"'
```

To apply to a specific profile by name, replace `default settings` with `settings set "ProfileName"`.

---

## Critical Rules

1. **NO TIME ESTIMATES** - Just execute
2. **TEST BEFORE PRESENTING** - Verify everything works
3. **ZERO-BS** - Working solutions, no placeholders
4. **Use MacPorts** - Not Homebrew
5. **Use AeroSpace** - Not yabai (broken on Tahoe)
6. **Apple docs** - Use `/apple-docs` skill for any Apple API questions

---

## Git Workflow

Always SSH remotes:
```bash
git remote set-url origin git@github.com:<user>/<repo>.git
```
