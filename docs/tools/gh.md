# GitHub CLI (gh)

| File | Source in this repo |
| --- | --- |
| `~/.config/gh/config.yml` | [`home/dot_config/gh/private_config.yml`](../../home/dot_config/gh/private_config.yml) |

Edit with `chezmoi edit ~/.config/gh/config.yml`, then `chezmoi apply`.
Or change a setting with `gh config set <key> <value>`; that edits the file
in your home folder, so bring it back into the repo with
`chezmoi re-add ~/.config/gh/config.yml`.

## What's set

Everything is gh's default except these:

| Setting | Value | Why |
| --- | --- | --- |
| `git_protocol` | `https` | `gh repo clone` and other gh commands that run Git use HTTPS URLs rather than SSH. |
| `aliases.co` | `pr checkout` | `gh co 123` checks out pull request 123. |

`editor`, `pager` and `browser` are blank, so gh uses `$EDITOR`, `$PAGER`
and the system default browser.

## Not managed: your login

`gh auth login` stores your token in `~/.config/gh/hosts.yml` (or the macOS
keychain). That file is deliberately not in this repo. Log in once on each
Mac:

```sh
gh auth login
```

The `private_` prefix on the source file makes chezmoi write
`config.yml` readable only by you (mode 600), as gh does itself.
