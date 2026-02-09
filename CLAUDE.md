# Mac Mini Agent

Autonomous macOS Tahoe system administration and configuration management.

---

## System Context

**OS:** macOS Tahoe 26.2+ (Apple Silicon)
**Package Manager:** MacPorts (`sudo port install`)
**Window Manager:** AeroSpace (i3-like, no SIP disable needed)
**Terminal:** Alacritty
**Shell:** Zsh (modular, `~/zshrc/*.sh`)

**Load on startup:**
- `@macminisetup.md` - Setup blueprint
- `@config/INDEX.md` - Config registry

---

## On First Run

Read `macminisetup.md` and execute the setup autonomously:
1. Check prerequisites (Xcode, MacPorts)
2. Install packages from `data/packages/macports.txt`
3. Deploy configs from `config/`
4. Start AeroSpace
5. Run `scripts/verify.sh`

---

## Skills

### `/docs` - Tool Documentation
Reference docs for AeroSpace, Alacritty, MacPorts, CLI tools.

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
| Alacritty | `config/alacritty/alacritty.toml` | `~/.config/alacritty/` |
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

## Dotfiles (Bare Git)

```bash
dotfiles status
dotfiles add <file>
dotfiles commit -m "message"
dotfiles push
```

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
