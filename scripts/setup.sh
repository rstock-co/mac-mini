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

# ====== Deploy Configs ======

log_info "Deploying configurations..."

# AeroSpace
if [ -f "$REPO_ROOT/config/aerospace/aerospace.toml" ]; then
    mkdir -p ~/.config/aerospace
    cp "$REPO_ROOT/config/aerospace/aerospace.toml" ~/.config/aerospace/
    log_success "AeroSpace config deployed"
fi

# Alacritty
if [ -f "$REPO_ROOT/config/alacritty/alacritty.toml" ]; then
    mkdir -p ~/.config/alacritty
    cp "$REPO_ROOT/config/alacritty/alacritty.toml" ~/.config/alacritty/
    log_success "Alacritty config deployed"
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
        aerospace reload-config 2>/dev/null
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
