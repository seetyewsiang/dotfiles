# Global gitignore

What goes in `~/.config/git/ignore`, what stays out, and why.

The source is [`home/dot_config/git/ignore`](../home/dot_config/git/ignore).
Edit it with `chezmoi edit ~/.config/git/ignore`, then `chezmoi apply`.

## Where Git looks

Git reads `$XDG_CONFIG_HOME/git/ignore`, or `~/.config/git/ignore` when
`XDG_CONFIG_HOME` is unset. No configuration is needed. Note the file name:
`ignore`, not `gitignore` or `.gitignore`.

Don't set `core.excludesFile` in `.gitconfig`. Setting it replaces this
default path instead of adding to it, so a GUI client that sets it (Sourcetree
sets `~/.gitignore_global`, for example) silently turns this file off. To
check, run:

```sh
git config --global core.excludesFile   # should print nothing
```

## The rule

A pattern belongs here only if both are true:

1. **This Mac, or a tool on it, creates the file without being asked.**
   Finder writes `.DS_Store`; Claude Code writes `.claude/settings.local.json`.
2. **No project would ever want it committed.** Not "I usually don't commit
   it": never, in anyone's repo.

Everything else goes in each repo's own `.gitignore`.

The reason for being strict is that global rules are invisible. Collaborators
and CI don't have them, and Git doesn't warn when `git add .` or `git add -A`
skips an ignored file. A broad global pattern ends up keeping a file out of a
repo that needed it, and the first sign is a build failing on someone else's
machine. A missing pattern costs almost nothing: the file shows up in
`git status` and you deal with it.

## How ignore rules behave

- **They only affect untracked files.** Files already committed are never
  hidden. Ignoring a tracked file takes `git rm --cached <file>` first.
- **Precedence**, highest first: the repo's `.gitignore` files (the one
  nearest the file wins), then `.git/info/exclude`, then this file. A repo can
  re-include something this file ignores with a `!pattern` line, but few
  repos will think to.
- **Anchoring.** A pattern with no slash (`.DS_Store`) matches at any depth. A
  pattern with a slash at the start or in the middle (`.claude/worktrees/`) is
  matched against the repo root only. `**/` matches any depth.
- **Excluded directories can't be partly re-included.** Git doesn't look
  inside an ignored directory, so `!dir/file` has no effect after `dir/`.

## What's in the file

| Pattern | Created by | Why it's global |
| ------- | ---------- | --------------- |
| `.DS_Store` | Finder, in every folder you open | Pure UI state (icon positions, view mode). Never wanted in a repo. |
| `._*` | macOS, for extended attributes on non-APFS drives, and in archives made on a Mac | Metadata sidecars; meaningless anywhere else. |
| `.AppleDouble` | macOS, on network shares | Same as `._*`, as a folder. |
| `.*.sw[op]` | Vim swap files (`.main.c.swp`) | No `core.editor` is set, so Git opens vi. A crashed session leaves swap files beside the file being edited. The leading dot keeps legitimate `*.swp` files tracked. |
| `*.orig` | `git mergetool` backups (on by default, `mergetool.keepBackup`) | Leftovers from resolving a conflict. |
| `*.rej` | `git apply --reject` and `patch` | Hunks that failed to apply. Temporary by definition. |
| `**/.claude/settings.local.json` | Claude Code ("don't ask again" approvals) | Personal and can contain secrets typed into an approved command. See [Claude Code](#claude-code-edits-this-file). |
| `CLAUDE.local.md` | You, for personal Claude Code notes in a project | The local-scope counterpart of a shared `CLAUDE.md`. |
| `.claude/worktrees/` | `claude --worktree` | Whole checkouts. Without this they appear as untracked files in the main checkout. |
| `mise.local.toml`, `.mise.local.toml`, `mise.*.local.toml`, `.mise.*.local.toml` | mise (`mise use --env local`) | mise documents these as personal overrides that should never be committed, and suggests a global ignore. |
| `.env.local`, `.env.*.local` | You, for personal env overrides | Vite, Next.js and others treat the `.local` variants as never committed. |

## Left out on purpose

These turn up in popular global templates but break the rule above.

| Pattern | Why it's not here |
| ------- | ----------------- |
| `.vscode/`, `*.code-workspace` | Many repos commit `settings.json`, `extensions.json`, `launch.json` or a workspace file on purpose. Ignoring the folder globally means a new shared file is silently skipped. Decide per repo. |
| `.idea/`, `*.iml` | Same reasoning, and no JetBrains IDE is installed here. If one is added, ignore only personal files such as `.idea/workspace.xml`, or decide per repo. |
| `*.sublime-project` | Meant to be shared. (`*.sublime-workspace` is the personal one, but Sublime isn't installed.) |
| `.env` | Some projects commit `.env` as shared defaults and ignore only `.env.local`. Keep `.env` in each repo's `.gitignore`, which also protects collaborators who have no global ignore. |
| `*.patch`, `*.diff` | Real projects commit patches: patch-package's `patches/`, vcpkg ports, Homebrew, distro packaging. A global rule makes `git add -A` drop them. |
| `*.bak`, `*~` | Nothing on this Mac creates them (Vim's `backup` is off by default), and some repos keep `.bak` fixtures. Add them if a tool starts producing them. |
| `.ignore` | Ignore file for ripgrep, fd and ag. Projects often commit it. |
| `Thumbs.db`, `Desktop.ini`, `.directory` | Windows and Linux files. This file only applies to this Mac, so it only needs what this Mac creates. Repos that take contributions from Windows should list them themselves. |
| `.Spotlight-V100`, `.Trashes`, `.fseventsd` | Created only at the root of a volume, which is never a repo root here. |
| `Icon\r` | Custom folder icons. The pattern needs literal carriage-return characters, which editors and diffs easily mangle, and custom folder icons inside repos are rare. |
| `node_modules/`, `dist/`, `build/`, `__pycache__/`, `Library/` (Unity) | Project output. Every collaborator needs the same rule, so it goes in the repo's `.gitignore`. |

## Claude Code edits this file

The first time Claude Code writes `.claude/settings.local.json` in a repo
that doesn't already ignore it, it appends `**/.claude/settings.local.json` to
the global excludes file, which is this file. Because chezmoi manages the
file, that append would show up as drift: `chezmoi status` reports
`~/.config/git/ignore` as modified, and the next `chezmoi apply` reverts it.

The line is in the source copy, word for word, so Claude Code finds the file
already ignored and doesn't touch it. Keep the line as is.

If `chezmoi status` ever shows this file as modified, see what changed and
pull it into the repo if it's worth keeping:

```sh
chezmoi diff ~/.config/git/ignore
chezmoi re-add ~/.config/git/ignore   # copy the live file into the source
```

## Adding a pattern

1. Check it against [the rule](#the-rule). If any project could want the file
   committed, add it to that project's `.gitignore` instead, or to
   `.git/info/exclude` for one checkout of a repo you don't control.
2. Make it as narrow as possible: anchor it, or match the tool's exact file
   name rather than a broad extension.
3. Add it with a comment saying which tool creates it, and add a row to the
   table above.
4. Run `chezmoi apply`, then test it in any repo:

   ```sh
   git check-ignore -v --no-index path/to/file   # prints the matching line
   ```

## When a file won't add

`git add` of an explicit path refuses ignored files with a hint. `git add .`
skips them without saying anything. To find the rule responsible:

```sh
git check-ignore -v path/to/file   # which file and line ignores it
git status --ignored               # list everything currently ignored
git add -f path/to/file            # add it anyway
```

## References

- [gitignore documentation](https://git-scm.com/docs/gitignore)
- [Claude Code settings: local settings and git excludes](https://code.claude.com/docs/en/configuration)
- [Claude Code worktrees](https://code.claude.com/docs/en/worktrees)
- [mise FAQ: keeping personal configuration out of Git](https://mise.jdx.dev/faq.html)
