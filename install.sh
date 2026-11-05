#!/bin/sh
# Bootstrap a new machine: install chezmoi, then pull and apply these dotfiles.
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/seetyewsiang/dotfiles/main/install.sh)"
set -eu

bin_dir="$HOME/.local/bin"

if command -v chezmoi >/dev/null 2>&1; then
  chezmoi=$(command -v chezmoi)
else
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir"
  chezmoi="$bin_dir/chezmoi"
fi

exec "$chezmoi" init --apply seetyewsiang
