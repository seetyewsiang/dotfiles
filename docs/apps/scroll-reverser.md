# Scroll Reverser

Reverses the scroll direction separately for the mouse and trackpad
(`cask "scroll-reverser"`), so the trackpad can scroll "naturally" while a
mouse wheel scrolls the classic way.

| File | Source in this repo |
| --- | --- |
| Its settings (`defaults` domain `com.pilotmoon.scroll-reverser`) | [`home/.chezmoiscripts/run_onchange_after_40-macos-defaults.sh`](../../home/.chezmoiscripts/run_onchange_after_40-macos-defaults.sh) |

The app keeps its settings in macOS's preferences system, not a dotfile, so
they're set with `defaults write` from a chezmoi script. The script re-runs
whenever it changes. Apps read these settings at launch, so restart Scroll
Reverser after a change.

## What's set

| Key | Value | What it does |
| --- | --- | --- |
| `InvertScrollingOn` | `true` | Turns reversing on. |
| `ShowDiscreteScrollOptions` | `true` | Shows the extra options for scroll wheels that move in steps. |

Which devices and axes get reversed is left at the app's defaults, which is
why those keys aren't set.

## First run

macOS asks for **Accessibility** permission the first time Scroll Reverser
runs. It can't reverse scrolling without it. Grant it in System Settings →
Privacy & Security → Accessibility.

## Change a setting

To find the key for a setting you changed in the app:

```sh
defaults read com.pilotmoon.scroll-reverser
```

Add a matching `defaults write` line to the script, then `chezmoi apply`.
