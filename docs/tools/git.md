# Git

| File | Source in this repo |
| --- | --- |
| `~/.gitconfig` | [`home/dot_gitconfig`](../../home/dot_gitconfig) |
| `~/.gitmessage` | [`home/dot_gitmessage`](../../home/dot_gitmessage) |
| `~/.config/git/ignore` | [`home/dot_config/git/ignore`](../../home/dot_config/git/ignore) |

Edit with `chezmoi edit ~/.gitconfig` (or the other paths), then
`chezmoi apply`.

## `.gitconfig`

| Setting | What it does |
| --- | --- |
| `user.name`, `user.email` | Author of your commits. The email is GitHub's private `noreply` address, so your real address never appears in commit history. |
| `commit.template = ~/.gitmessage` | `git commit` without `-m` opens the editor pre-filled with the template below. |
| `[filter "lfs"]` | Hooks [Git LFS](https://git-lfs.com/) into Git, so files a repo tracks with LFS are stored outside the repo. Installed by `brew "git-lfs"`. |

`git lfs install` rewrites the `[filter "lfs"]` block. The lines are kept in
the order it writes them, so running it doesn't make `chezmoi status` show
the file as changed.

No `core.editor` is set, so Git uses `vi`.

## `.gitmessage`: commit template

A comment-only template. Git strips `#` lines, so it adds nothing to the
commit; it's a reminder of the commit message rules from
[How to Write a Git Commit Message](https://cbea.ms/git-commit/):

- Subject: imperative, capitalized, no period, 50 characters or less.
- Body after a blank line: what and why, wrapped at 72.
- Trailers (`Resolves: #123`) last.

Claude Code follows the same rules through its `commit` skill (see
[Claude Code](claude-code.md)).

## `~/.config/git/ignore`: global gitignore

Ignores only files that this Mac or its tools create on their own and that
no project would ever commit (`.DS_Store`, Vim swap files, Claude Code and
mise personal files, `.env.local`). The full rationale, and what was
deliberately left out, is in [Global gitignore](../gitignore.md).

## Hooks in this repo

This dotfiles repo has its own pre-commit hook in `.githooks/`, which
regenerates the shell library docs. It's turned on per clone with
`git config core.hooksPath .githooks`, set by the chezmoi script
`run_once_after_50-git-hooks.sh.tmpl`. That's a setting of this repo only,
not of `~/.gitconfig`.
