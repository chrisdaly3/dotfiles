#!/bin/bash
# Install oh-my-zsh and the custom plugins dot_zshrc loads. Skips anything already there.
# Cloned directly (not via the oh-my-zsh installer) so it doesn't overwrite ~/.zshrc.
set -euo pipefail

ZSH="$HOME/.oh-my-zsh"
PLUGINS="$ZSH/custom/plugins"

clone() {
  [[ -d $2 ]] && return
  echo "==> Cloning $1"
  git clone --quiet --depth=1 "$1" "$2"
}

clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
clone https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGINS/zsh-autosuggestions"
clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$PLUGINS/fast-syntax-highlighting"
