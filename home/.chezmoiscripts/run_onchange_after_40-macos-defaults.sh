#!/bin/sh
# Apply app and macOS settings with `defaults write`. Re-runs whenever this
# file changes. Apps read these at launch, so restart a running app to pick
# up a change.
set -eu

# Scroll Reverser: reverse scrolling, and show the extra options for
# scroll wheels with discrete steps. Per-device and per-axis choices are
# left at the app's defaults, which is why they aren't set here.
defaults write com.pilotmoon.scroll-reverser InvertScrollingOn -bool true
defaults write com.pilotmoon.scroll-reverser ShowDiscreteScrollOptions -bool true
