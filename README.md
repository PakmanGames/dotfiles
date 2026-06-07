# Dotfiles

My personal dotfiles and configuration files for various development environments and tools.

See [`TODO.md`](TODO.md) for outstanding work (per-app docs, install script, App Store apps, etc.).

## Repository Structure

- `Brewfile` — Homebrew bundle of brews, casks, VS Code extensions, and npm globals
- `.gitconfig` — Git user/config
- `.codex/` — GPT Codex prompts
- `.cursor/` — Cursor rules, commands, prompts, and skills
- `.obsidian/` — Obsidian config and plugin settings (plugin code is gitignored)
- `obsidian_templates/` — Templates for Obsidian note-taking
- `anki/` — FSRS parameters for my Anki decks
- `freeze/` — Config for [freeze](https://github.com/charmbracelet/freeze) plus a script to preview every theme
- `ghostty/` — Config for the Ghostty terminal emulator
- `karabiner/` — Karabiner-Elements key remapping config (macOS)
- `ruby-install/` — one-shot rbenv + Ruby installers: `install.sh` (Debian/Ubuntu, VM/WSL) and `install-macos.sh` (macOS, via Homebrew)
- `starship/` — Config for the [Starship](https://starship.rs) prompt
- `ubuntu-vm/` — Config files for my Ubuntu virtual machine
- `wsl-debian/` — Config files for my Debian WSL environment

## Setup

### Quick start (fresh Mac)

`./install.sh` bootstraps a clean Mac end to end: it installs the Xcode command
line tools and Homebrew if they're missing, installs everything in the
`Brewfile` (brews, casks, npm globals, and — if you opt in — VS Code
extensions), symlinks the configs into `~/.config` (backing up anything it would
replace), and optionally sets up Ruby via rbenv. It's safe to re-run — every
step no-ops once its work is done.

You only need to get the repo onto the machine first.

**Literally clean Mac (no git yet).** macOS always ships `curl`, so download a
tarball without needing git — `install.sh` installs the rest, git included:

```bash
cd ~
curl -L https://github.com/PakmanGames/dotfiles/archive/refs/heads/main.tar.gz | tar xz
cd dotfiles-main
./install.sh
```

On the first run with no Xcode command line tools present, the script kicks off
their GUI installer and exits. Finish that prompt, then run `./install.sh` again
to continue.

**If you already have git** (or want a clone you can pull/push):

```bash
git clone https://github.com/PakmanGames/dotfiles.git
cd dotfiles
./install.sh
```

> On a clean Mac, `git` is a stub that triggers the Xcode command line tools
> install the first time you run it — finish that GUI prompt and the clone will
> proceed.

### Manual setup

Prefer to run the steps yourself? The installer is just a wrapper around these.

1. Install [Homebrew](https://brew.sh), then install macOS apps and CLI tools
   via the `Brewfile`:

   ```bash
   brew bundle --file=./Brewfile
   ```

   Some apps (Final Cut Pro, Logic Pro, Goodnotes, etc.) are App Store / Apple-only
   and aren't covered by the `Brewfile` — see `TODO.md` for the full list.

2. Symlink your configs into place:

   ```bash
   ln -s "$(pwd)/ghostty"                  ~/.config/ghostty
   ln -s "$(pwd)/starship/starship.toml"   ~/.config/starship.toml
   ln -s "$(pwd)/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
   ln -s "$(pwd)/freeze/custom.json"       ~/.config/freeze/custom.json
   ln -s "$(pwd)/.gitconfig"               ~/.gitconfig   # not done by install.sh
   ```

   karabiner and freeze get file-level symlinks rather than directory-level ones
   because their parent dirs accumulate runtime/non-config data that shouldn't
   live in the repo (Karabiner-Elements writes `assets/` + `automatic_backups/`
   into `~/.config/karabiner/`; `freeze/` also holds preview scripts and
   examples). `.gitconfig` is left out of `install.sh` on purpose — link it
   manually if you want it.

## Notes

- All configurations are personalized for my workflow — back up your existing
  configs before applying these.
- The Obsidian vault tracks settings and user data but ignores re-downloadable
  plugin code (see `.gitignore`).
