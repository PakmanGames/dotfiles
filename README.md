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
- `ruby-install/` — rbenv and Ruby installation config
- `starship/` — Config for the [Starship](https://starship.rs) prompt
- `ubuntu-vm/` — Config files for my Ubuntu virtual machine
- `wsl-debian/` — Config files for my Debian WSL environment

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/PakmanGames/dotfiles.git
   cd dotfiles
   ```

2. Install macOS apps and CLI tools via the `Brewfile` (requires [Homebrew](https://brew.sh)):

   ```bash
   brew bundle --file=./Brewfile
   ```

   Some apps (Final Cut Pro, Logic Pro, Goodnotes, etc.) are App Store / Apple-only
   and aren't covered by the `Brewfile` — see `TODO.md` for the full list.

3. Symlink individual configs as needed. There's no install script yet, so each
   tool's config has to be linked manually, e.g.:

   ```bash
   ln -s "$(pwd)/.gitconfig"            ~/.gitconfig
   ln -s "$(pwd)/ghostty"               ~/.config/ghostty
   ln -s "$(pwd)/starship/starship.toml" ~/.config/starship.toml
   ln -s "$(pwd)/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
   ```

   Karabiner gets a file-level symlink rather than a directory-level one because
   Karabiner-Elements writes runtime data (`assets/`, `automatic_backups/`) into
   `~/.config/karabiner/`, which shouldn't live in the repo.

## Notes

- All configurations are personalized for my workflow — back up your existing
  configs before applying these.
- The Obsidian vault tracks settings and user data but ignores re-downloadable
  plugin code (see `.gitignore`).
