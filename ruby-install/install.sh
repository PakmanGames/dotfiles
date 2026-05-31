#!/usr/bin/env bash
#
# Streamlined rbenv + Ruby installer for Debian/Ubuntu (VM and WSL).
#
# Replaces the old step-1..step-6 files, which couldn't run end to end: the
# PATH/init steps had to be sourced rather than executed, and step 4 was just
# prose telling you to restart the terminal.
#
# Installs ruby-build's build dependencies, clones rbenv + the ruby-build
# plugin, wires rbenv into your shell rc, then installs and activates the
# pinned Ruby. Safe to re-run: apt is idempotent, existing clones are
# fast-forwarded, and an already-installed Ruby is left untouched.
#
# Usage:
#   ruby-install/install.sh                 # install the pinned version below
#   RUBY_VERSION=3.3.6 ruby-install/install.sh
set -euo pipefail

RUBY_VERSION="${RUBY_VERSION:-3.3.4}"
RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
PLUGIN_DIR="$RBENV_ROOT/plugins/ruby-build"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# ruby-build compiles Ruby from source, so it needs a toolchain and the headers
# for OpenSSL, readline, zlib, sqlite3, and libyaml.
log "Installing build dependencies via apt"
sudo apt-get update
sudo apt-get install -y \
  gcc make libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev libyaml-dev

# Clone a repo, or fast-forward it if already present, so re-runs stay clean.
clone_or_update() {
  local url="$1" dir="$2" name="$3"
  if [ -d "$dir/.git" ]; then
    log "Updating $name"
    git -C "$dir" pull --ff-only
  else
    log "Cloning $name"
    git clone "$url" "$dir"
  fi
}

clone_or_update https://github.com/rbenv/rbenv.git      "$RBENV_ROOT" "rbenv"
clone_or_update https://github.com/rbenv/ruby-build.git "$PLUGIN_DIR" "ruby-build plugin"

# Make rbenv usable for the rest of this script (the bin dir is enough to drive
# install/global/rehash; the shell rc wiring below is for future sessions).
export PATH="$RBENV_ROOT/bin:$PATH"

# Wire rbenv into the interactive shell rc, matching the user's shell. Each line
# is added only if absent, so this is safe to run repeatedly.
case "${SHELL:-}" in
  *zsh) RC="$HOME/.zshrc";  INIT='eval "$(rbenv init - zsh)"' ;;
  *)    RC="$HOME/.bashrc"; INIT='eval "$(rbenv init - bash)"' ;;
esac
PATH_LINE='export PATH="$HOME/.rbenv/bin:$PATH"'
add_line() {
  grep -qF "$1" "$RC" 2>/dev/null && return 0
  printf '%s\n' "$1" >> "$RC"
  log "Added to $(basename "$RC"): $1"
}
add_line "$PATH_LINE"
add_line "$INIT"

if rbenv versions --bare | grep -qx "$RUBY_VERSION"; then
  log "Ruby $RUBY_VERSION already installed"
else
  log "Installing Ruby $RUBY_VERSION (this can take several minutes)"
  rbenv install "$RUBY_VERSION"
fi
rbenv global "$RUBY_VERSION"
rbenv rehash

log "Done — $(rbenv exec ruby -v)."
log "Open a new shell (or 'source $RC') to pick up rbenv in this terminal."
