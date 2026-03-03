#!/usr/bin/env bash
# quickstart.sh — Install isagellm-control-plane-benchmark
#
# Usage:
#   ./quickstart.sh --standard   Install from PyPI (stable / release mode)
#   ./quickstart.sh --dev        Install editable from local source (dev mode)
#   ./quickstart.sh --help       Show this help message
#
# Modes
#   standard  All dependencies are resolved from PyPI. Use this for
#             reproducible, release-grade environments.
#   dev       Starts with the standard PyPI install, then overlays a local
#             editable install of this repository so that in-tree changes
#             take effect immediately.  Sibling isage-* repos found next to
#             this directory are also installed in editable mode.
#
# Notes
#   • No virtual environment is created; the active Python environment is used.
#   • Each run first removes any previously installed isage* / isagellm*
#     packages so the environment stays consistent.

set -euo pipefail

PACKAGE_PREFIX="isage"
PYPI_PACKAGE="isagellm-control-plane-benchmark"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

usage() {
    awk 'NR>1{if(/^#/){sub(/^# ?/,""); print} else{exit}}' "$0"
    exit 0
}

log()  { echo "[quickstart] $*"; }
warn() { echo "[quickstart] WARNING: $*" >&2; }
die()  { echo "[quickstart] ERROR: $*" >&2; exit 1; }

# Run a pip command and print the full output when it fails.
safe_pip() {
    local tmp
    tmp="$(mktemp)"
    if ! pip "$@" >"$tmp" 2>&1; then
        warn "pip $* failed — full output:"
        cat "$tmp" >&2
        rm -f "$tmp"
        return 1
    fi
    rm -f "$tmp"
}

# ---------------------------------------------------------------------------
# cleanup: uninstall all installed packages whose name starts with $PACKAGE_PREFIX
# ---------------------------------------------------------------------------

cleanup() {
    log "Scanning for installed ${PACKAGE_PREFIX}* packages …"
    local pkgs
    pkgs="$(pip list --format=freeze 2>/dev/null \
            | grep -i "^${PACKAGE_PREFIX}" \
            | sed 's/==.*//' \
            || true)"
    if [ -z "$pkgs" ]; then
        log "No ${PACKAGE_PREFIX}* packages found — skipping cleanup."
        return
    fi
    log "Uninstalling: $(echo "$pkgs" | tr '\n' ' ')"
    # shellcheck disable=SC2086
    safe_pip uninstall -y $pkgs \
        || warn "Some packages could not be uninstalled; continuing anyway."
}

# ---------------------------------------------------------------------------
# standard install — all packages from PyPI
# ---------------------------------------------------------------------------

install_standard() {
    log "Installing ${PYPI_PACKAGE} from PyPI …"
    safe_pip install "${PYPI_PACKAGE}" \
        || die "Standard install failed."
    log "Standard install complete."
}

# ---------------------------------------------------------------------------
# dev install — PyPI first, then local editable overlays
# ---------------------------------------------------------------------------

install_dev() {
    log "Dev mode: installing ${PYPI_PACKAGE} from PyPI first …"
    # Install the package (and its declared dependencies) from PyPI so that
    # all transitive deps are resolved once.
    safe_pip install "${PYPI_PACKAGE}" \
        || die "Initial PyPI install (dev) failed."

    # Overlay this repo as an editable install without re-resolving deps.
    log "Overlaying local editable install (this repo) …"
    safe_pip install -e "${SCRIPT_DIR}" --no-deps \
        || die "Local editable install failed."

    # Optionally overlay sibling isage-* repos that live next to this one.
    local parent_dir
    parent_dir="$(dirname "${SCRIPT_DIR}")"
    for sibling in "${parent_dir}"/isage-* "${parent_dir}"/sagellm-*; do
        [ -d "$sibling" ] || continue
        [ "$sibling" = "$SCRIPT_DIR" ] && continue
        if [ -f "${sibling}/pyproject.toml" ] || [ -f "${sibling}/setup.py" ]; then
            log "Overlaying sibling repo: ${sibling}"
            safe_pip install -e "${sibling}" --no-deps \
                || warn "Could not install ${sibling} in editable mode; skipping."
        fi
    done

    log "Dev install complete."
}

# ---------------------------------------------------------------------------
# entry point
# ---------------------------------------------------------------------------

MODE=""
for arg in "$@"; do
    case "$arg" in
        --standard) MODE="standard" ;;
        --dev)      MODE="dev" ;;
        --help|-h)  usage ;;
        *) die "Unknown argument: $arg  (use --help for usage)" ;;
    esac
done

if [ -z "$MODE" ]; then
    die "No mode specified.  Run with --standard or --dev (use --help for usage)."
fi

log "Mode: ${MODE}"
cleanup

case "$MODE" in
    standard) install_standard ;;
    dev)      install_dev ;;
esac
