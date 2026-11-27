# zsh

The login shell. Two files set it up.

| File | Source in this repo | Runs |
| --- | --- | --- |
| `~/.zprofile` | [`home/dot_zprofile`](../../home/dot_zprofile) | Once, when a login shell starts (every new Terminal or Ghostty window on macOS) |
| `~/.zshrc` | [`home/dot_zshrc`](../../home/dot_zshrc) | In every interactive shell |

Edit with `chezmoi edit ~/.zshrc` (or `~/.zprofile`), then `chezmoi apply`
and open a new window.

## `.zprofile`: PATH

- **Homebrew.** Runs `brew shellenv`, which puts Homebrew's `bin` and
  `sbin` folders on PATH, adds its zsh completions folder
  (`share/zsh/site-functions`) to `fpath`, and sets its `HOMEBREW_*`
  variables. It picks `/opt/homebrew` on Apple Silicon and `/usr/local` on
  Intel.
- **`~/.local/bin`.** Added to the front of PATH. chezmoi and mise are
  installed there.

PATH goes here rather than in `.zshrc` so it's set once per login, not
again in every nested shell.

## `.zshrc`: interactive shell

| Line | What it does |
| --- | --- |
| `autoload -Uz compinit` + `compinit` | Turns on zsh's tab completion, including the completions Homebrew's tools install (`gh`, `ghostty`, `brew` and others), which `.zprofile` put on `fpath`. |
| `setopt INTERACTIVE_COMMENTS` | Lets you paste commands that contain `# comments` at the prompt, as bash allows. zsh errors on them otherwise. |
| `eval "$(mise activate zsh)"` | Puts the tools from [mise](mise.md) (node, python, shdoc) on PATH, and switches versions when you `cd` into a project with its own `mise.toml`. |
| `. ~/.unity/env` | Loads the Unity CLI's environment, if Unity has created that file. |

## Related

- [Shell function library](../../home/dot_config/shell/lib/README.md) in
  `~/.config/shell/lib`: reference functions from the pure sh/bash
  bibles, with sh, bash and zsh versions. Deliberately not sourced here.
- [Ghostty](../apps/ghostty.md) turns off one shell integration feature
  (the bar cursor at the prompt).
