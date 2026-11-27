# Ghostty

The terminal app (`cask "ghostty"`).

| File | Source in this repo |
| --- | --- |
| `~/.config/ghostty/config.ghostty` | [`home/dot_config/ghostty/config.ghostty`](../../home/dot_config/ghostty/config.ghostty) |

Edit with `chezmoi edit ~/.config/ghostty/config.ghostty`, then
`chezmoi apply`. Press **Cmd+Shift+,** in Ghostty to reload. Ghostty's own
"Open Config" edits the file in your home folder, not the repo; bring such
edits back with `chezmoi re-add ~/.config/ghostty/config.ghostty`.

Every option, with its docs:

```sh
ghostty +show-config --default --docs
```

## Font

```
font-family = RobotoMono Nerd Font Mono
font-size = 12
font-thicken = true
```

- **RobotoMono Nerd Font Mono** is Roboto Mono with
  [Nerd Font](https://www.nerdfonts.com/) icons added (for prompts, file
  listings and editors). It's installed by
  `cask "font-roboto-mono-nerd-font"` in the [Brewfile](../tools/homebrew.md).
  The "Mono" variant squeezes every icon into a single cell, so icons never
  overlap the next character. The other variant, `RobotoMono Nerd Font`,
  draws them wider.
- **Size 12** is one point smaller than Ghostty's default of 13.
- **`font-thicken`** draws strokes heavier (macOS only), which reads better
  on a dark background.

Size and thickening were picked by comparing all four combinations side by
side. No `font-feature` lines are needed: Roboto Mono has no ligatures
(`calt`, `liga` and `dlig` are absent from all its font files), so there's
nothing to turn off.

## Cursor

```
cursor-style = block
shell-integration-features = no-cursor
```

Ghostty's shell integration switches the cursor to a bar at the shell
prompt, whatever `cursor-style` says. `no-cursor` turns off just that
feature, so the cursor stays a block everywhere. The rest stay at
Ghostty's defaults: `title` (window title from the shell) and `path`
(Ghostty's own `bin` folder on PATH) on; `sudo`, `ssh-env` and
`ssh-terminfo` off.
The cursor blinks, which is Ghostty's default.

## Window and keyboard

| Setting | What it does |
| --- | --- |
| `theme = light:GitHub Light Default,dark:GitHub Dark Default` | Follows macOS light/dark mode, with GitHub's color themes. |
| `macos-option-as-alt = true` | Option acts as Alt, so shell shortcuts like Alt+B / Alt+F (word back/forward) work. You can't type Option characters like `©` in Ghostty. |
| `window-save-state = always` | Reopens your windows and tabs from the last session. |

## Check it

```sh
ghostty +validate-config     # errors in the config, if any
ghostty +show-config         # every setting that differs from the default
ghostty +list-fonts | grep -i roboto
```
