# dotfiles

My macOS setup (Apple Silicon and Intel), managed with
[chezmoi](https://www.chezmoi.io/): shell config (zsh), Git, the GitHub CLI,
mise, Claude Code settings, a Finder Quick Action, macOS app settings, and
every app in the [Brewfile](home/dot_Brewfile).

## Install

Sign in to the App Store first, then:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/seetyewsiang/dotfiles/main/install.sh)"
```

## Layout

| Path | What's in it |
| --- | --- |
| [`home/`](home) | Everything chezmoi manages, in chezmoi's source format |
| [`docs/`](docs) | How it's set up and how to manage it |
| [`tools/`](tools) | Scripts for working on the repo itself |
| [`.githooks/`](.githooks) | Git hooks for this repo |
| [`install.sh`](install.sh) | The bootstrap script the install command runs |

## Docs

See [docs/](docs/README.md).
