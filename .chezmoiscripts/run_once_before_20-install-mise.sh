#!/bin/sh
# Install mise to ~/.local/bin before dotfiles that depend on it are applied.
set -eu

if [ ! -x "$HOME/.local/bin/mise" ] && ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi
