# Freeze configs

Refer to [Freeze Repo](https://github.com/charmbracelet/freeze) for the usage docs on the `freeze` command.

Main configuration file is the `custom.json` file.

## Picking a Theme

I wrote a `zsh` script `generate_examples.zsh` if you are having trouble picking a theme for your freeze.

Remember to run the following so it is executable:

```bash
chmod +x ./generate_examples.zsh
```

It will generate an `examples/` folder with png of all the themes to help you choose.

## fre

Usage and examples:

```bash
fre filename.extension # Generates a filename.png file in light mode (default)
fre filename.extension -d # Generates a filename.png file in dark mode
fre filename.extension -o newfile # Generates a newfile.png in light mode
```

There is a `fre` file, add it to your `~/bin/` directory (for mac) and add the following line to your `~/.zshrc` (mac only)

```bash
export PATH="$HOME/bin:$PATH"
```
