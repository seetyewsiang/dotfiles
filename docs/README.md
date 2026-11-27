# Docs

## Setting up a new Mac

Sign in to the App Store first, or the `mas` apps will fail to install.
Then run the install command from the [README](../README.md#install).

It installs chezmoi to `~/.local/bin` if it is missing, then runs
`chezmoi init --apply seetyewsiang`. chezmoi clones the repo to
`~/.local/share/chezmoi` and applies it. On first apply, chezmoi also:

1. Installs [Homebrew](https://brew.sh/) if it is missing.
2. Installs [mise](https://mise.jdx.dev/) to `~/.local/bin` if it is missing.
3. Runs `brew bundle` on the [Brewfile](../home/dot_Brewfile).
4. Installs Xcode with `xcodes`, which asks for your Apple ID
   ([details](tools/homebrew.md#xcode)).

Keep one clone of the repo, at `~/.local/share/chezmoi`, so changes don't
get out of sync. New to chezmoi? Start with its
[quick start](https://www.chezmoi.io/quick-start/).

## Guides

- [Managing the dotfiles](managing-dotfiles.md): sync, add, edit and
  remove dotfiles across your Macs.
- [Global gitignore](gitignore.md): what it ignores and why.

## Tools and apps

How each one is configured, and why.

| Command-line tools | Apps |
| --- | --- |
| [Homebrew](tools/homebrew.md): the Brewfile and how it's installed | [Ghostty](apps/ghostty.md): font, cursor, theme |
| [zsh](tools/zsh.md): `.zprofile` and `.zshrc` | [Scroll Reverser](apps/scroll-reverser.md): scroll direction |
| [Git](tools/git.md): `.gitconfig`, commit template, gitignore | [Visual Studio Code](apps/vscode.md): the Open in VS Code Quick Action |
| [GitHub CLI](tools/gh.md): `gh` settings and login | |
| [mise](tools/mise.md): node, python, shdoc | |
| [Claude Code](tools/claude-code.md): settings, plugins, commit skill | |
