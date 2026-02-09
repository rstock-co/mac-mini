#!/bin/bash

# Mac Mini Verification Script

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0
WARNINGS=0

check_command() {
    local cmd=$1
    local name=$2
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗${NC} $name: not found"
        FAILED=$((FAILED + 1))
    fi
}

check_file() {
    local file=$1
    local name=$2
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $name"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗${NC} $name: $file missing"
        FAILED=$((FAILED + 1))
    fi
}

check_process() {
    local process=$1
    local name=$2
    if pgrep -x "$process" > /dev/null; then
        echo -e "${GREEN}✓${NC} $name: running"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}⚠${NC} $name: not running"
        WARNINGS=$((WARNINGS + 1))
    fi
}

echo -e "${BLUE}Mac Mini System Verification${NC}"
echo "================================"
echo ""

echo -e "${BLUE}Prerequisites:${NC}"
if xcode-select -p &> /dev/null; then
    echo -e "${GREEN}✓${NC} Xcode: $(xcode-select -p)"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗${NC} Xcode: not installed"
    FAILED=$((FAILED + 1))
fi
check_command port "MacPorts"
echo ""

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

echo -e "${BLUE}Window Management:${NC}"
check_process AeroSpace "AeroSpace"
echo ""

echo -e "${BLUE}Configuration Files:${NC}"
check_file ~/.config/aerospace/aerospace.toml "AeroSpace config"
check_file ~/.zshrc "zsh config"
echo ""

echo -e "${BLUE}Claude Code:${NC}"
if check_command claude "Claude Code"; then
    echo "  $(claude --version 2>&1 | head -1)"
fi
echo ""

echo "================================"
echo -e "  ${GREEN}Passed:${NC}   $PASSED"
echo -e "  ${RED}Failed:${NC}   $FAILED"
echo -e "  ${YELLOW}Warnings:${NC} $WARNINGS"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All critical checks passed.${NC}"
else
    echo -e "${RED}Some checks failed. Run ./scripts/setup.sh to fix.${NC}"
    exit 1
fi
