#!/usr/bin/env zsh

# remember to run chmod +x ./generate_examples.zsh so it is executable

mkdir -p examples
xargs -I{} -n1 freeze \
  -c "$HOME/.config/freeze/custom.json" \
  --language java \
  --theme "{}" \
  -o "examples/{}.png" \
  Runner.java < words.txt