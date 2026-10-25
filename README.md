# dotfiles

My macOS setup (Apple Silicon and Intel), managed with [chezmoi](https://www.chezmoi.io/).

## Install on a new Mac

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/seetyewsiang/dotfiles/main/install.sh)"
```

This installs chezmoi to `~/.local/bin`, clones this repo and applies it. On
first apply, chezmoi also:

1. Installs [Homebrew](https://brew.sh/) if it is missing.
2. Installs [mise](https://mise.jdx.dev/) to `~/.local/bin` if it is missing.
3. Runs `brew bundle` on the [Brewfile](Brewfile).

Sign in to the App Store before running it, or the `mas` apps will fail to
install.

## What's included

| Source                 | Installed as             | Purpose                                    |
| ---------------------- | ------------------------ | ------------------------------------------ |
| `dot_zprofile`         | `~/.zprofile`            | Homebrew env, `~/.local/bin` on `PATH`     |
| `dot_zshrc`            | `~/.zshrc`               | mise activation, Unity CLI env             |
| `dot_gitconfig`        | `~/.gitconfig`           | Git identity, commit template              |
| `dot_gitmessage`       | `~/.gitmessage`          | Commit template ([seven rules][beams])     |
| `dot_config/gh/`       | `~/.config/gh/`          | GitHub CLI config                          |
| `dot_config/git/`      | `~/.config/git/`         | Global gitignore                           |
| `dot_config/mise/`     | `~/.config/mise/`        | Default tool versions (Node LTS)           |
| `private_dot_claude/`  | `~/.claude/`             | Claude Code settings and `CLAUDE.md`       |
| `Brewfile`             | not copied               | CLI tools, casks and App Store apps        |
| `install.sh`           | not copied               | Bootstrap script                           |

The `private_` prefix makes chezmoi create the file or directory with owner-only
permissions.

[beams]: https://cbea.ms/git-commit/

## Day-to-day

```sh
chezmoi edit ~/.zshrc   # edit the source copy of a dotfile
chezmoi diff            # preview what apply would change
chezmoi apply           # write changes to $HOME
chezmoi update          # pull from GitHub and apply
chezmoi cd              # open a shell in this repo
```

To add or remove an app, edit the [Brewfile](Brewfile) and run `chezmoi apply`.
The bundle script embeds the Brewfile's hash, so it re-runs whenever the
Brewfile changes. Removing a line does not uninstall the app; run
`brew bundle cleanup --file=Brewfile` to see what would be removed, then add
`--force` to remove it.
