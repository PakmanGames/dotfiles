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

## Smaller follow-ups

Discrete, low-risk wins. Each one is a single config file or a few-line edit.

- [ ] **Track and symlink `.zshrc`.** Live file at `~/.zshrc` is three lines
      today (`rbenv init`, `GPG_TTY`, `starship init`). Move it into the repo
      and add a `link_config "$REPO_ROOT/.zshrc" "$HOME/.zshrc"` call to
      `install_symlinks()`. Good place to add: PATH additions, history options
      (`HIST_IGNORE_DUPS`, `SHARE_HISTORY`), `pyenv init`, useful aliases.
- [ ] **Flesh out `.gitconfig`.** Current file only sets `user`, `init`,
      `color`, `pull.rebase = false`, and `core.editor`. Worth adding:
  - Aliases: `co`, `ci`, `st`, `br`, `last`, `lg` (oneline graph).
  - `push.autoSetupRemote = true` — auto-track upstream on first push.
  - `rerere.enabled = true` — remember conflict resolutions.
  - `fetch.prune = true` — drop stale remote-tracking branches.
  - `core.excludesfile = ~/.gitignore_global` (pairs with the next item).
  - `commit.gpgsign = true` + `user.signingkey` — README's GPG section claims
    these are set, but they aren't in the tracked file yet.
  - Decide on `pull.rebase`: currently `false`; rebase is usually the better
    default for a solo workflow.
- [ ] **Add `.gitignore_global`.** OS / editor noise that doesn't belong in
      every repo's `.gitignore`: `.DS_Store`, `*.swp`, `Thumbs.db`, `.idea/`,
      `.vscode/` (if you prefer per-user). Wire via `core.excludesfile` above.
- [ ] **Decide on `.gitconfig` symlinking from `install.sh`.** It's currently
      excluded on purpose (README says "not done by install.sh") because the
      GPG `user.signingkey` is per-machine. Either:
      (a) symlink it and accept that the first commit on a new Mac will fail
          until `signingkey` is updated, or
      (b) keep it manual and add a one-line reminder at the end of
          `install.sh` so it isn't silently missed.
- [ ] **Track Claude Code config.** `~/.claude/settings.json`, custom hooks,
      and any skills you actually use day-to-day. Skip transcripts and
      project-scoped state.
- [ ] **Track VS Code + Cursor user settings.** `settings.json`,
      `keybindings.json`, and `snippets/` for each. VS Code lives at
      `~/Library/Application Support/Code/User/`; Cursor at
      `~/Library/Application Support/Cursor/User/`. Extensions are already
      covered by the `Brewfile`, so this is just the user prefs.
- [ ] **Track `~/.config/gh/config.yml` aliases (only).** The host file in
      that dir holds an OAuth token — don't track that one. A small aliases
      file is fine.

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
