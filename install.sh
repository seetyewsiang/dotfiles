#!/bin/sh
# Bootstrap a new machine: install chezmoi, then pull and apply these dotfiles.
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/seetyewsiang/dotfiles/main/install.sh)"

set -eu

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# A fresh Mac has no git yet: /usr/bin/git is a stub that only offers to
# install the Command Line Tools. Clone with chezmoi's builtin git instead;
# the Homebrew install script installs the Command Line Tools afterwards.
exec "$chezmoi" init --apply --use-builtin-git true seetyewsiang
