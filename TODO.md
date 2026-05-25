# Dotfiles — Remaining Tasks

Running list of follow-up work. See `README.md` for current setup instructions.

## To do

- [ ] **Document every app/tool so someone copying this config knows what each does.**
      Add short descriptions for each `brew`, `cask`, and `vscode` entry in the
      `Brewfile` (e.g. a table in `README.md` or a `docs/apps.md`), plus a line on
      what each top-level config dir is for (`ghostty/`, `karabiner/`, `starship/`,
      `.obsidian/`, etc.).
- [ ] **Reproduce App Store / Apple-only apps.** They can't be installed as casks
      (see list below). Optionally add the `mas` CLI (`brew "mas"` + `mas "<id>"`
      entries) to capture the ones that live in the Mac App Store.
- [ ] **Refresh `README.md`** — the structure list is missing `karabiner/`, and
      `.cursor/` now also contains `skills/` (not just rules and commands).
- [ ] **Add an install mechanism** (e.g. GNU Stow, `dotbot`, or an `install.sh`)
      so the configs deploy with symlinks instead of one manual `ln` per tool.
- [ ] **(Optional) Shrink `.git` history.** Untracking the Obsidian plugin code
      removed it going forward, but the old blobs (~49M) still live in history.
      A `git filter-repo` pass would shrink clone size (destructive — rewrites history).

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
