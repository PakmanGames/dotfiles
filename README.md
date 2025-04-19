# Dotfiles

My personal dotfiles and configuration files for various development environments and tools.

## Repository Structure

- `obsidian_templates/` - Templates for Obsidian note-taking
- `.obsidian/` - Obsidian config files and plugins
- `wsl-debian/` - Config files for my Debian WSL environment
- `ubuntu-vm/` - Config files for my Ubuntu virtual machine
- `ruby-install/` - rbenv and Ruby installation and config files


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

## Environment-Specific Setup

### WSL Debian
Configuration files for Debian WSL environment are located in the `wsl-debian/` directory.

### Ubuntu VM
Ubuntu virtual machine configurations can be found in the `ubuntu-vm/` directory.

## Notes
- All configurations are personalized for my workflow but can be modified as needed
- Make sure to backup your existing configurations before applying these dotfiles
