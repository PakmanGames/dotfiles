#!/usr/bin/env bash
#
# Universal macOS setup for a fresh MacBook.
#
# Bootstraps the build toolchain (Xcode command line tools + Homebrew), then
# installs every app and CLI tool declared in the repo's Brewfile in one shot:
# brews, casks, VS Code extensions, and npm globals.
#
# Built to grow. Later setup steps (config symlinks, Mac App Store apps via mas,
# Ruby via ruby-install/install-macos.sh, macOS defaults) hang off the same
# main() runner as additional idempotent functions.
#
# Safe to re-run: the Xcode/Homebrew checks no-op when already present, and
# brew bundle skips anything already installed.
#
# Usage:
#   ./install.sh
set -euo pipefail

# Resolve the repo root from this script's own location so it works regardless
# of the caller's current directory.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_ROOT/Brewfile"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# Xcode command line tools provide the compiler toolchain Homebrew and many
# formulae build against. xcode-select -p exits non-zero when they're missing;
# the installer is a GUI prompt that can't be scripted to completion, so we bail
# and ask the user to re-run once it finishes.
ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi
  log "Installing Xcode command line tools — finish the GUI prompt, then re-run this script"
  xcode-select --install || true
  exit 1
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # A fresh install isn't on PATH yet this session; load it from either the
  # Apple-silicon or Intel prefix so the brew calls below work immediately.
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# brew bundle installs taps, brews, casks, VS Code extensions, and npm globals
# from the Brewfile. Already-installed entries are skipped, so this is the
# idempotent workhorse of the setup.
install_apps() {
  log "Installing apps and tools from Brewfile"
  brew bundle --file="$BREWFILE"
}

main() {
  ensure_xcode_clt
  ensure_homebrew
  install_apps
  # Future steps (config symlinks, mas, Ruby, macOS defaults) slot in here.
  log "Done — apps and tools installed."
}

main "$@"
