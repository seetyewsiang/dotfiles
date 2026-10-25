#!/bin/sh
# Install Homebrew before anything that depends on it (.zprofile, brew bundle).
set -eu

if [ "$(uname -m)" = arm64 ]; then
  brew=/opt/homebrew/bin/brew
else
  brew=/usr/local/bin/brew
fi

if [ ! -x "$brew" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
