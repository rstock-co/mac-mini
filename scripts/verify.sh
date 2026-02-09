#!/bin/bash

# Mac Mini Verification Script
# Verify all components are installed and configured correctly

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

check_command() {
    local cmd=$1
    local name=$2
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name: Installed ($(command -v $cmd))"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $name: Not found"
        ((FAILED++))
        return 1
    fi
}

check_file() {
    local file=$1
    local name=$2
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $name: $file"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $name: $file not found"
        ((FAILED++))
        return 1
    fi
}

check_process() {
    local process=$1
    local name=$2
    if pgrep -x "$process" > /dev/null; then
        echo -e "${GREEN}✓${NC} $name: Running (PID: $(pgrep -x $process))"
        ((PASSED++))
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $name: Not running"
        ((WARNINGS++))
        return 1
    fi
}

echo -e "${BLUE}Mac Mini System Verification${NC}"
echo "================================"
echo ""

# ====== Prerequisites ======
echo -e "${BLUE}Prerequisites:${NC}"
xcode-select -p &> /dev/null && echo -e "${GREEN}✓${NC} Xcode: $(xcode-select -p)" && ((PASSED++)) || (echo -e "${RED}✗${NC} Xcode: Not installed" && ((FAILED++)))
check_command port "MacPorts"
echo ""

# ====== Core Tools ======
echo -e "${BLUE}Core CLI Tools:${NC}"
check_command rg "ripgrep"
check_command fd "fd"
check_command bat "bat"
check_command eza "eza"
check_command fzf "fzf"
check_command nvim "neovim"
check_command git "git"
check_command gh "GitHub CLI"
check_command btop "btop"
check_command zoxide "zoxide"
check_command tmux "tmux"
echo ""

# ====== Window Management ======
echo -e "${BLUE}Window Management:${NC}"
check_command yabai "yabai"
check_command skhd "skhd"
check_process yabai "yabai service"
check_process skhd "skhd service"
echo ""

# ====== Configurations ======
echo -e "${BLUE}Configuration Files:${NC}"
check_file ~/.config/yabai/yabairc "yabai config"
check_file ~/.config/skhd/skhdrc "skhd config"
check_file ~/.config/alacritty/alacritty.toml "Alacritty config"
check_file ~/.zshrc "zsh config"
echo ""

# ====== Claude Code ======
echo -e "${BLUE}Claude Code:${NC}"
if check_command claude "Claude Code"; then
    claude --version 2>/dev/null && echo -e "  Version: $(claude --version 2>&1 | head -1)" || true
fi
echo ""

# ====== Summary ======
echo "================================"
echo -e "${BLUE}Verification Summary:${NC}"
echo -e "  ${GREEN}Passed:${NC}   $PASSED"
echo -e "  ${RED}Failed:${NC}   $FAILED"
echo -e "  ${YELLOW}Warnings:${NC} $WARNINGS"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Review the output above.${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  - Missing packages: sudo port install <package>"
    echo "  - Missing configs: ./scripts/setup.sh"
    echo "  - Service issues: See docs/troubleshooting.md"
    exit 1
fi
