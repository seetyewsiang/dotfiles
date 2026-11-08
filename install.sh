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

# A fresh Mac has no git yet: /usr/bin/git is a stub that only offers to
# install the Command Line Tools. Clone with chezmoi's builtin git instead;
# the Homebrew install script installs the Command Line Tools afterwards.
exec "$chezmoi" init --apply --use-builtin-git true seetyewsiang
