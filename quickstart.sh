#!/usr/bin/env bash
# quickstart.sh — sagellm-control-plane-benchmark dev environment setup
#
# Usage:
#   ./quickstart.sh               # dev mode (default): hooks + .[dev]  (includes [full])
#   ./quickstart.sh --full        # optional backends only: .[full]
#   ./quickstart.sh --standard    # core deps only: no extras
#   ./quickstart.sh --yes         # non-interactive (assume yes)
#   ./quickstart.sh --doctor      # diagnose environment issues

set -e

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

EXTRAS="[dev]"; DOCTOR=false; YES=false
for arg in "$@"; do
    case "$arg" in
        --doctor)   DOCTOR=true ;;
        --standard) EXTRAS="" ;;
        --full)     EXTRAS="[full]" ;;
        --dev)      EXTRAS="[dev]" ;;
        --yes|-y)   YES=true ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  sagellm-control-plane-benchmark — Quick Start${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$DOCTOR" = true ]; then
    echo -e "${YELLOW}Python:${NC} $(python3 --version 2>/dev/null || echo 'NOT FOUND')"
    echo -e "${YELLOW}Conda env:${NC} ${CONDA_DEFAULT_ENV:-none}"
    echo -e "${YELLOW}Venv:${NC} ${VIRTUAL_ENV:-none}"
    exit 0
fi

[ -n "$VIRTUAL_ENV" ] && echo -e "${RED}  ✗ Detected venv: $VIRTUAL_ENV — use Conda instead.${NC}" && exit 1

echo -e "${YELLOW}${BOLD}Step 1/3: Python environment${NC}"
python3 -c "import sys; exit(0 if sys.version_info >= (3,10) else 1)" || { echo "Python 3.10+ required"; exit 1; }
echo -e "  ${GREEN}✓ Python OK${NC}"; echo ""

echo -e "${YELLOW}${BOLD}Step 2/3: Git hooks${NC}"
if [ -d "$PROJECT_ROOT/hooks" ]; then
    for hook_src in "$PROJECT_ROOT/hooks"/*; do
        hook_name=$(basename "$hook_src")
        cp "$hook_src" "$PROJECT_ROOT/.git/hooks/$hook_name" && chmod +x "$PROJECT_ROOT/.git/hooks/$hook_name"
        echo -e "  ${GREEN}✓ $hook_name${NC}"
    done
else
    echo -e "${YELLOW}⚠  hooks/ not found — skipping${NC}"
fi
echo ""

echo -e "${YELLOW}${BOLD}Step 3/3: Installing package${NC}"
[ -n "$EXTRAS" ] && pip install -e ".$EXTRAS" || pip install -e .
echo -e "${GREEN}✓ Done!${NC}"
