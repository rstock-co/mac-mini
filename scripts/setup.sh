#!/bin/bash

# Mac Mini Setup Script - Deploy configs and install packages

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is for macOS only"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

log_info "Mac Mini Setup - Repository: $REPO_ROOT"
echo ""

# ====== Prerequisites ======

log_info "Checking prerequisites..."

if ! xcode-select -p &> /dev/null; then
    log_error "Xcode Command Line Tools not found. Run: xcode-select --install"
    exit 1
fi
log_success "Xcode: $(xcode-select -p)"

if ! command -v port &> /dev/null; then
    log_error "MacPorts not found. Download from: https://www.macports.org/install.php"
    exit 1
fi
log_success "MacPorts: $(port version)"

echo ""

# ====== Install Packages ======

log_info "Installing packages from manifest..."

if [ -f "$REPO_ROOT/data/packages/macports.txt" ]; then
    sudo port selfupdate

    while IFS= read -r line; do
        # Skip comments and blank lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue

        pkg="$line"
        if port installed "$pkg" 2>/dev/null | grep -q "$pkg"; then
            log_success "$pkg (already installed)"
        else
            log_info "Installing $pkg..."
            if sudo port install "$pkg"; then
                log_success "$pkg installed"
            else
                log_warning "Failed to install $pkg"
            fi
        fi
    done < "$REPO_ROOT/data/packages/macports.txt"
else
    log_warning "Package manifest not found"
fi

echo ""

# ====== Install/Update AeroSpace (GitHub Release) ======

log_info "Checking AeroSpace..."

AEROSPACE_INSTALL_DIR="/Applications"
AEROSPACE_CLI_DIR="$HOME/bin"
mkdir -p "$AEROSPACE_CLI_DIR"

# Get installed version
INSTALLED_VERSION=""
if [ -d "$AEROSPACE_INSTALL_DIR/AeroSpace.app" ] && [ -f "$AEROSPACE_CLI_DIR/aerospace" ]; then
    INSTALLED_VERSION=$("$AEROSPACE_CLI_DIR/aerospace" --version 2>/dev/null | head -1 | awk '{print $NF}' | sed 's/-.*//')
fi

# Get latest release from GitHub
LATEST_JSON=$(curl -sf https://api.github.com/repos/nikitabobko/AeroSpace/releases/latest)
if [ -z "$LATEST_JSON" ]; then
    log_warning "Could not fetch AeroSpace releases from GitHub"
else
    LATEST_VERSION=$(echo "$LATEST_JSON" | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/' | sed 's/-.*//')
    LATEST_TAG=$(echo "$LATEST_JSON" | grep '"tag_name"' | sed 's/.*"\(.*\)".*/\1/')
    ZIP_URL=$(echo "$LATEST_JSON" | grep '"browser_download_url"' | grep '\.zip"' | head -1 | sed 's/.*"\(http[^"]*\)".*/\1/')

    if [ "$INSTALLED_VERSION" = "$LATEST_VERSION" ]; then
        log_success "AeroSpace $INSTALLED_VERSION (up to date)"
    else
        if [ -n "$INSTALLED_VERSION" ]; then
            log_info "Updating AeroSpace $INSTALLED_VERSION -> $LATEST_VERSION..."
        else
            log_info "Installing AeroSpace $LATEST_VERSION..."
        fi

        TMPDIR=$(mktemp -d)
        if curl -sL -o "$TMPDIR/aerospace.zip" "$ZIP_URL"; then
            unzip -qo "$TMPDIR/aerospace.zip" -d "$TMPDIR"

            # Find extracted directory (name varies by release)
            EXTRACTED=$(find "$TMPDIR" -maxdepth 1 -type d -name "AeroSpace*" | head -1)

            if [ -n "$EXTRACTED" ]; then
                # Kill running instance before replacing
                killall AeroSpace 2>/dev/null
                sleep 1

                # Install app bundle and CLI
                cp -r "$EXTRACTED/AeroSpace.app" "$AEROSPACE_INSTALL_DIR/"
                xattr -d com.apple.quarantine "$AEROSPACE_INSTALL_DIR/AeroSpace.app" 2>/dev/null
                cp "$EXTRACTED/bin/aerospace" "$AEROSPACE_CLI_DIR/"
                chmod +x "$AEROSPACE_CLI_DIR/aerospace"

                log_success "AeroSpace $LATEST_VERSION installed"
            else
                log_warning "AeroSpace zip extraction failed"
            fi
        else
            log_warning "AeroSpace download failed"
        fi
        rm -rf "$TMPDIR"
    fi
fi

echo ""

# ====== Deploy Configs ======

log_info "Deploying configurations..."

# AeroSpace
if [ -f "$REPO_ROOT/config/aerospace/aerospace.toml" ]; then
    mkdir -p ~/.config/aerospace
    cp "$REPO_ROOT/config/aerospace/aerospace.toml" ~/.config/aerospace/
    log_success "AeroSpace config deployed"
fi

# Zsh
if [ -f "$REPO_ROOT/config/zsh/zshrc" ]; then
    cp "$REPO_ROOT/config/zsh/zshrc" ~/.zshrc
    mkdir -p ~/zshrc

    # Remove old unnumbered modules
    rm -f ~/zshrc/core.sh ~/zshrc/nav.sh ~/zshrc/pkg.sh ~/zshrc/alias-management.sh ~/zshrc/dotfiles.sh

    cp "$REPO_ROOT/config/zsh/modules"/*.sh ~/zshrc/
    log_success "Zsh config deployed"
fi

echo ""

# ====== Services ======

log_info "Checking services..."

if [ -d "/Applications/AeroSpace.app" ]; then
    if pgrep -x AeroSpace > /dev/null; then
        "$HOME/bin/aerospace" reload-config 2>/dev/null
        log_success "AeroSpace running (config reloaded)"
    else
        open /Applications/AeroSpace.app
        log_success "AeroSpace started"
    fi
else
    log_warning "AeroSpace not installed in /Applications/"
fi

echo ""
log_success "Setup complete!"
log_info "Restart terminal or run: source ~/.zshrc"
log_info "Verify: ./scripts/verify.sh"
