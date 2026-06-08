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

### GPG commit signing

`.gitconfig` signs every commit and tag (`commit.gpgsign = true`) using the key
in `user.signingkey`. That key lives in your GPG keyring, **not** in this repo —
so each Mac needs its own key. `gnupg` and `pinentry-mac` come from the
`Brewfile`; the rest is a one-time setup. These steps generate a fresh key on
the machine (no exporting/importing from another Mac).

1. Generate a key — pick `ECC (sign and encrypt)` → `Curve 25519`, and use your
   git email so commits verify:

   ```bash
   gpg --full-generate-key
   ```

2. Point gpg-agent at the macOS GUI passphrase prompt:

   ```bash
   mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
   echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
   gpgconf --kill gpg-agent
   ```

3. Export `GPG_TTY` in your shell rc so CLI passphrase prompts work:

   ```bash
   echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
   ```

4. Update `user.signingkey` to the new key's ID. Because `~/.gitconfig` is
   symlinked to this repo, `git config --global` edits the repo file in place —
   commit and push so the tracked config matches the key you actually use:

   ```bash
   gpg --list-secret-keys --keyid-format=long   # copy the 16-char ID after "ed25519/"
   git config --global user.signingkey <NEW_KEY_ID>
   ```

5. Add the **public** key to GitHub (Settings → SSH and GPG keys → New GPG key):

   ```bash
   gpg --armor --export <NEW_KEY_ID> | pbcopy
   ```

6. Verify — you should see `Good signature`:

   ```bash
   git commit --allow-empty -m "test signing" && git log --show-signature -1
   ```

> Each new key produces a new ID, so the `user.signingkey` committed here only
> matches the Mac it was last set on. When you set up another machine, repeat
> step 4 (and re-add its public key to GitHub) — or use a `[includeIf]` per-host
> config if you want several machines tracked at once.

## Notes

- All configurations are personalized for my workflow — back up your existing
  configs before applying these.
- The Obsidian vault tracks settings and user data but ignores re-downloadable
  plugin code (see `.gitignore`).
