#!/bin/sh
# Install Homebrew before anything that depends on it (.zprofile, brew bundle).
set -eu

if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
