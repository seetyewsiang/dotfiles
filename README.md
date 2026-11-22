# dotfiles

My macOS setup (Apple Silicon and Intel), managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new Mac

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/seetyewsiang/dotfiles/main/install.sh)"
```

This installs chezmoi to `~/.local/bin` if it is missing, then runs
`chezmoi init --apply seetyewsiang`. chezmoi clones this repo to
`~/.local/share/chezmoi` and applies it. On first apply, chezmoi also:

1. Installs [Homebrew](https://brew.sh/) if it is missing.
2. Installs [mise](https://mise.jdx.dev/) to `~/.local/bin` if it is missing.
3. Runs `brew bundle` on the [Brewfile](home/dot_Brewfile).

Sign in to the App Store before running it, or the `mas` apps will fail to
install.

## What's included

Shell config (zsh), Git, the GitHub CLI, mise, Claude Code settings, a
Finder Quick Action, macOS app settings, and every app in the
[Brewfile](home/dot_Brewfile). Everything chezmoi manages lives in
[`home/`](home).

## Docs

- [Managing the dotfiles](docs/managing-dotfiles.md): sync, add, edit and
  remove dotfiles across your Macs.
- [Global gitignore](docs/gitignore.md): what it ignores and why.

New to chezmoi? Start with its [quick start](https://www.chezmoi.io/quick-start/).
Keep one clone of this repo, at `~/.local/share/chezmoi`, so changes don't
get out of sync.
