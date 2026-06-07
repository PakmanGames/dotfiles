# Dotfiles — Remaining Tasks

Running list of follow-up work. See `README.md` for current setup instructions.

## To do

- [ ] **Document every app/tool so someone copying this config knows what each does.**
      Add short descriptions for each `brew`, `cask`, and `vscode` entry in the
      `Brewfile` (e.g. a table in `README.md` or a `docs/apps.md`), plus a line on
      what each top-level config dir is for (`ghostty/`, `karabiner/`, `starship/`,
      `.obsidian/`, etc.).
- [ ] **Extend `install.sh` with the remaining setup steps.** `install.sh` (repo
      root) already bootstraps Xcode command line tools + Homebrew, then runs
      `brew bundle` to install all brews, casks, VS Code extensions, and npm
      globals. Fold the rest in next, as separate incremental commits:
  - [x] **Config symlinks** — `install_symlinks()` links `ghostty/`,
        `starship/starship.toml`, `karabiner/karabiner.json`, and
        `freeze/custom.json` into `~/.config`, backing up any existing real file
        and skipping when the correct symlink already exists. karabiner and
        freeze stay file-level links (their dirs hold runtime/non-config data).
        `.gitconfig` was intentionally excluded; `README.md` block updated to
        match.
  - [ ] **Mac App Store apps via `mas`** — `brew "mas"` is now in the `Brewfile`.
        Still to do: capture IDs with `mas list` on the real machine and add the
        `mas "<name>", id:` entries for the App Store apps listed below.
  - [x] **Ruby (rbenv)** — call `ruby-install/install-macos.sh` from `install.sh`
        so rbenv + the pinned Ruby are set up in the same run. *(opt-in prompt;
        runs as a child process so a failure won't abort the rest of setup.)*
  - [ ] **macOS defaults** — apply chosen system preferences via `defaults write`
        (key repeat rate, Dock autohide, Finder show extensions, tap-to-click,
        screenshot location, etc.); decide the exact set when we build it.

## Apps installed but NOT available via Homebrew

These were present on the machine when the `Brewfile` was generated but have no
Homebrew cask, so they must be installed manually. Most are Mac App Store or Apple
first-party apps.

### Apple (App Store / system — no cask)
- Final Cut Pro
- Logic Pro
- MainStage
- Motion
- Compressor
- GarageBand
- iMovie
- Keynote
- Safari (system app)
- Xcode (Mac App Store)

### Other Mac App Store-only
- Goodnotes
- Toggl Track
- Dropover
- Hand Mirror
- okular

### Enterprise / standalone installers (no cask)
- ZoomVDI
- ZoomVDIUninstaller

> Tip: the App Store entries above could be made reproducible with the `mas` CLI
> once their App Store IDs are captured.
