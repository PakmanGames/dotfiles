# Dotfiles

My personal dotfiles and configuration files for various development environments and tools.

## Repository Structure

- `.codex/` - GPT Codex prompts
- `.cursor/` - Cursor rules and commands
- `.obsidian/` - Obsidian config files and plugins
- `obsidian_templates/` - Templates for Obsidian note-taking
- `anki/` - FSRS parameters for my decks
- `freeze/` - Config for freeze and a bash script to try each theme
- `ghostty/` - Config for ghostty my terminal emulator
- `ruby-install/` - rbenv and Ruby installation and config files
- `starship/` - Config for Starship
- `ubuntu-vm/` - Config files for my Ubuntu virtual machine
- `wsl-debian/` - Config files for my Debian WSL environment

### Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/PakmanGames/dotfiles.git
   cd dotfiles
   ```

2. (Optional) Create symbolic links for Git configuration:

   ```bash
   ln -s $(pwd)/.gitconfig ~/.gitconfig
   ```

## Tools

### Freeze

`freeze/` contains all my configurations for the `freeze` command and a shortened version of it.

## Environment-Specific Setup

### WSL Debian

Configuration files for Debian WSL environment are located in the `wsl-debian/` directory.

### Ubuntu VM

Ubuntu virtual machine configurations can be found in the `ubuntu-vm/` directory.

## Notes

- All configurations are personalized for my workflow but can be modified as needed
- Make sure to backup your existing configurations before applying these dotfiles
