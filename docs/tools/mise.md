# mise

Installs and switches language runtimes and small developer tools.

| File | Source in this repo |
| --- | --- |
| `~/.config/mise/config.toml` | [`home/symlinked/mise/config.toml`](../../home/symlinked/mise/config.toml), via a symlink |
| Install script | [`home/.chezmoiscripts/run_once_before_20-install-mise.sh`](../../home/.chezmoiscripts/run_once_before_20-install-mise.sh) |

## Why it's a symlink

`mise use -g node@22` rewrites `~/.config/mise/config.toml` itself. A normal
chezmoi copy would then differ from the repo after every such command.
Instead, [`symlink_config.toml.tmpl`](../../home/dot_config/mise/symlink_config.toml.tmpl)
makes `~/.config/mise/config.toml` a symlink to the file in the repo, so a
change mise makes lands in the repo straight away, ready to commit. No
`chezmoi apply` or `re-add` is needed. Just edit the file (or run
`mise use -g`) and commit.

## Install

On the first `chezmoi apply`, the install script runs the official
installer (`curl https://mise.run | sh`) if mise is missing. It installs to
`~/.local/bin/mise`. [`.zshrc`](zsh.md) activates it.

After changing the config, run `mise install` to install anything new.

## Tools

| Tool | Version | Why |
| --- | --- | --- |
| `node` | `lts` | Node.js, newest long-term-support release. |
| `python` | `3.14` | Python 3.14. |
| `http:shdoc` | `1.4` | Generates Markdown docs from shell comments, for the [shell function library](../../home/dot_config/shell/lib/README.md). |

### shdoc

shdoc isn't in mise's registry and has no release builds; it's a single
gawk script. So it uses mise's `http` backend, downloading the script for
tag `v1.4` from the shdoc repo.

Two catches, both handled in the config:

- **It needs gawk.** gawk comes from [Homebrew](homebrew.md)
  (`brew "gawk"`), not mise, since it's a plain system tool.
- **Its first line hardcodes `/usr/bin/gawk`**, which macOS doesn't have.
  The `postinstall` command rewrites it to `#!/usr/bin/env -S gawk -E`, so it
  uses the gawk on your PATH. It runs again on every reinstall.

## Check it

```sh
mise ls          # what's installed and where each version comes from
mise doctor      # problems with the setup
```
