#!/usr/bin/env bash
#
# Universal macOS setup for a fresh MacBook.
#
# Bootstraps the build toolchain (Xcode command line tools + Homebrew), then
# installs every app and CLI tool declared in the repo's Brewfile in one shot:
# brews, casks, npm globals, and — if you opt in at the prompt — VS Code
# extensions (those also sync automatically when you sign in to VS Code).
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

# Ask a yes/no question and return 0 for yes, 1 for no. $2 is the default answer
# ("y" or "n") used when the user just presses Enter. Non-interactive runs (no
# TTY on stdin, e.g. piped) skip the prompt and take the default, so the script
# stays automatable.
confirm() {
  local prompt="$1" default="${2:-n}" reply hint="[y/N]"
  [ "$default" = "y" ] && hint="[Y/n]"
  if [ ! -t 0 ]; then
    [ "$default" = "y" ]
    return
  fi
  read -r -p "$(printf '\033[1;34m==>\033[0m %s %s ' "$prompt" "$hint")" reply
  case "${reply:-$default}" in
    [yY] | [yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

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
  # Don't let one flaky download (e.g. a dropped Microsoft CDN transfer) abort
  # the whole run under `set -e`. brew bundle is idempotent, so re-running picks
  # up whatever failed; let later main() steps proceed in the meantime.
  local hint="Some Brewfile entries failed (likely network) — re-run to retry"
  if confirm "Install VS Code extensions? (they also sync when you sign in to VS Code)" "n"; then
    brew bundle --file="$BREWFILE" || log "$hint"
  else
    log "Skipping VS Code extensions"
    # `brew bundle install` has no per-type skip for VS Code, so feed it the
    # Brewfile over stdin (--file=-) with the `vscode` entries stripped out.
    grep -v '^vscode ' "$BREWFILE" | brew bundle --file=- || log "$hint"
  fi
}

# Hand off to the standalone rbenv + Ruby installer. It's idempotent and does
# its own Homebrew/Xcode checks, so re-running is cheap, but compiling a fresh
# Ruby costs 10-15 minutes — hence the opt-in prompt. Run as a child process so
# its `set -e`/early `exit` can't abort this script; a failure here shouldn't
# undo the apps already installed above.
install_ruby() {
  if ! confirm "Set up Ruby via rbenv now? (downloads and compiles Ruby, ~10-15 min)" "n"; then
    log "Skipping Ruby setup — run ruby-install/install-macos.sh later if you want it"
    return 0
  fi
  "$REPO_ROOT/ruby-install/install-macos.sh" || log "Ruby setup failed — re-run ruby-install/install-macos.sh to retry"
}

main() {
  ensure_xcode_clt
  ensure_homebrew
  install_apps
  install_ruby
  # Future steps (config symlinks, mas, macOS defaults) slot in here.
  log "Done — apps and tools installed."
}

main "$@"
