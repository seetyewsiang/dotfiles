#!/bin/sh
# Install Xcode with xcodes (from the Brewfile) and make it the selected
# Xcode. Re-runs when this file changes, so bump the version here to upgrade.
# Interactive: xcodes asks for your Apple ID, and sudo for --select.
set -eu

version=27.2

if [ "$(uname -m)" = arm64 ]; then
  prefix=/opt/homebrew
else
  prefix=/usr/local
fi
# Puts xcodes and aria2 (which xcodes uses for faster downloads) on PATH.
eval "$("$prefix/bin/brew" shellenv)"

if xcodes installed "$version" >/dev/null 2>&1; then
  echo "Xcode $version is already installed."
  exit 0
fi

xcodes install "$version" --select --experimental-unxip
