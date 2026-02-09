#!/bin/bash

# Mac Mini Setup Script
# Autonomous system configuration orchestrator

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

# Get repo root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

log_info "Mac Mini Setup Script"
log_info "Repository: $REPO_ROOT"
echo ""

# ====== Phase 1: Prerequisites ======

log_info "Phase 1: Checking Prerequisites"

# Check for Xcode
if ! xcode-select -p &> /dev/null; then
    log_error "Xcode Command Line Tools not found"
    log_info "Install with: xcode-select --install"
    exit 1
else
    log_success "Xcode Command Line Tools: Installed"
fi

# Check for MacPorts
if ! command -v port &> /dev/null; then
    log_error "MacPorts not found"
    log_info "Download from: https://www.macports.org/install.php"
    exit 1
else
    log_success "MacPorts: Installed ($(port version))"
fi

echo ""

# ====== Phase 2: Deploy Configurations ======

log_info "Phase 2: Deploying Configurations"

# yabai
if [ -f "$REPO_ROOT/config/yabai/yabairc" ]; then
    log_info "Deploying yabai config..."
    mkdir -p ~/.config/yabai
    cp "$REPO_ROOT/config/yabai/yabairc" ~/.config/yabai/
    chmod +x ~/.config/yabai/yabairc
    log_success "yabai config deployed"
fi

# skhd
if [ -f "$REPO_ROOT/config/skhd/skhdrc" ]; then
    log_info "Deploying skhd config..."
    mkdir -p ~/.config/skhd
    cp "$REPO_ROOT/config/skhd/skhdrc" ~/.config/skhd/
    log_success "skhd config deployed"
fi

# Alacritty
if [ -f "$REPO_ROOT/config/alacritty/alacritty.toml" ]; then
    log_info "Deploying Alacritty config..."
    mkdir -p ~/.config/alacritty
    cp "$REPO_ROOT/config/alacritty/alacritty.toml" ~/.config/alacritty/
    log_success "Alacritty config deployed"
fi

# Zsh
if [ -f "$REPO_ROOT/config/zsh/zshrc" ]; then
    log_info "Deploying zsh config..."
    cp "$REPO_ROOT/config/zsh/zshrc" ~/.zshrc

    # Deploy modules
    mkdir -p ~/zshrc
    cp "$REPO_ROOT/config/zsh/modules"/*.sh ~/zshrc/ 2>/dev/null || true

    log_success "zsh config deployed"
fi

echo ""

# ====== Phase 3: Install Packages ======

log_info "Phase 3: Installing Packages"

if [ -f "$REPO_ROOT/data/packages/macports.txt" ]; then
    log_info "Reading package list..."

    # Update MacPorts
    log_info "Updating MacPorts..."
    sudo port selfupdate

    # Install packages (simple version - can be enhanced)
    log_info "Installing packages from manifest..."
    log_warning "Package installation requires manual review of data/packages/macports.txt"
    log_info "Run: sudo port install <package> for each package"
else
    log_warning "Package manifest not found: data/packages/macports.txt"
fi

echo ""

# ====== Phase 4: Service Management ======

log_info "Phase 4: Service Management"

# Check if yabai is installed
if command -v yabai &> /dev/null; then
    log_info "Starting yabai..."
    yabai --start-service 2>/dev/null || log_warning "yabai service may already be running"
    log_success "yabai service started"
else
    log_warning "yabai not found - skipping service start"
fi

# Check if skhd is installed
if command -v skhd &> /dev/null; then
    log_info "Starting skhd..."
    skhd --start-service 2>/dev/null || log_warning "skhd service may already be running"
    log_success "skhd service started"
else
    log_warning "skhd not found - skipping service start"
fi

echo ""

# ====== Completion ======

log_success "Setup complete!"
echo ""
log_info "Next steps:"
log_info "  1. Restart your terminal or run: source ~/.zshrc"
log_info "  2. Verify installation: ./scripts/verify.sh"
log_info "  3. Review configuration: config/INDEX.md"
echo ""
log_info "To update system configs from repo: ./scripts/setup.sh"
