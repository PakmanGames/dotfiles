#!/usr/bin/env bash
#
# Streamlined rbenv + Ruby installer for macOS.
#
# macOS counterpart to install.sh (which targets Debian/Ubuntu via apt + git
# clones). Here rbenv and ruby-build come from Homebrew instead. Ensures the
# Xcode command line tools and Homebrew are present, installs/upgrades
# ruby-build + rbenv, wires rbenv into your shell rc, then installs and
# activates the pinned Ruby.
#
# Safe to re-run: brew install/upgrade are idempotent, the rc lines are added
# only if absent, and an already-installed Ruby is left untouched.
#
# Usage:
#   ruby-install/install-macos.sh                 # install the pinned version below
#   RUBY_VERSION=3.4.6 ruby-install/install-macos.sh
set -euo pipefail

# Pinned to match install.sh. The Odin guide currently uses 3.4.6 — override
# with RUBY_VERSION if you want the newer one.
RUBY_VERSION="${RUBY_VERSION:-3.3.4}"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# Xcode command line tools provide the compiler toolchain ruby-build needs.
# xcode-select -p exits non-zero when they're missing.
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode command line tools — finish the GUI prompt, then re-run this script"
  xcode-select --install || true
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # A fresh install isn't on PATH yet this session; add it from either the
  # Apple-silicon or Intel prefix so the brew calls below work immediately.
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

log "Installing/upgrading ruby-build and rbenv via Homebrew"
brew install ruby-build rbenv
brew upgrade ruby-build

# Wire rbenv into the interactive shell rc, matching the user's shell. Each line
# is added only if absent, so this is safe to run repeatedly.
case "${SHELL:-}" in
  *bash) RC="$HOME/.bashrc"; INIT='eval "$(rbenv init - bash)"' ;;
  *)     RC="$HOME/.zshrc";  INIT='eval "$(rbenv init - zsh)"' ;;
esac
add_line() {
  grep -qF "$1" "$RC" 2>/dev/null && return 0
  printf '%s\n' "$1" >> "$RC"
  log "Added to $(basename "$RC"): $1"
}
add_line "$INIT"

if rbenv versions --bare | grep -qx "$RUBY_VERSION"; then
  log "Ruby $RUBY_VERSION already installed"
else
  log "Installing Ruby $RUBY_VERSION (this can take 10-15 minutes)"
  rbenv install "$RUBY_VERSION" --verbose
fi
rbenv global "$RUBY_VERSION"
rbenv rehash

log "Done — $(rbenv exec ruby -v)."
log "Open a new shell (or 'source $RC') to pick up rbenv in this terminal."
