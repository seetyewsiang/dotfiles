# Managing the dotfiles

How to sync, add, edit and remove dotfiles across your Macs.

Every change follows the same path: make it on one Mac, push it to
GitHub, then pull it on the others.

All commands work from any folder. `chezmoi git -- <args>` runs git inside
the repo (`~/.local/share/chezmoi`), so you don't need to `cd` there.

- [Sync this Mac](#sync-this-mac)
- [Add a dotfile](#add-a-dotfile)
- [Edit a dotfile](#edit-a-dotfile)
- [Remove a dotfile](#remove-a-dotfile)
- [Keep a change a tool made](#keep-a-change-a-tool-made)
- [Add or remove an app](#add-or-remove-an-app)
- [Fix a conflict when pulling](#fix-a-conflict-when-pulling)

## Sync this Mac

Do this before you change anything, and whenever you've pushed from
another Mac.

1. Check for new commits on GitHub:

   ```sh
   chezmoi git -- fetch
   chezmoi git -- status -sb
   ```

   `behind 2` means GitHub has 2 commits you don't have. `ahead 1` means
   you have 1 commit you haven't pushed.

2. Check for files changed on this Mac since the last apply:

   ```sh
   chezmoi status
   ```

   If a line starts with `MM`, a file was changed outside chezmoi. Follow
   [Keep a change a tool made](#keep-a-change-a-tool-made) for that file
   before you go on, or step 4 will ask whether to overwrite it.

3. Preview what will change in your home folder:

   ```sh
   chezmoi git -- pull --rebase --autostash
   chezmoi diff
   ```

   `+` lines will be added and `-` lines removed.

4. Apply:

   ```sh
   chezmoi apply
   ```

Once you're used to it, `chezmoi update` does steps 3 and 4 in one go,
without the preview.

## Add a dotfile

**On this Mac**

1. [Sync this Mac](#sync-this-mac).
2. Add the file:

   ```sh
   chezmoi add ~/.config/foo/config
   ```

   This copies it into the repo, under `home/`. The file in your home
   folder doesn't change.

3. Check what was added, and make sure there are no passwords or tokens
   in it:

   ```sh
   chezmoi git -- status
   chezmoi git -- diff
   ```

4. Commit and push:

   ```sh
   chezmoi git -- add home/dot_config/foo/config
   chezmoi git -- commit -m "Add foo config"
   chezmoi git -- push
   ```

**On your other Macs**

1. [Sync](#sync-this-mac). The file is created in the home folder.

## Edit a dotfile

**On this Mac**

1. [Sync this Mac](#sync-this-mac).
2. Edit the repo's copy, not the file in your home folder:

   ```sh
   chezmoi edit ~/.zshrc
   ```

   You can also open the repo in VS Code and edit the file under `home/`.
   An edit made straight to `~/.zshrc` is never saved, and the next apply
   can undo it.

3. Preview and apply:

   ```sh
   chezmoi diff
   chezmoi apply
   ```

4. Commit and push:

   ```sh
   chezmoi git -- add home/dot_zshrc
   chezmoi git -- commit -m "Add ll alias"
   chezmoi git -- push
   ```

**On your other Macs**

1. [Sync](#sync-this-mac).

## Remove a dotfile

**On this Mac**

1. [Sync this Mac](#sync-this-mac).
2. Pick one:
   - To stop managing the file, but keep it on this Mac:

     ```sh
     chezmoi forget ~/.config/foo/config
     ```

   - To delete it from both the repo and this Mac:

     ```sh
     chezmoi destroy ~/.config/foo/config
     ```

3. Commit and push:

   ```sh
   chezmoi git -- status
   chezmoi git -- add home/dot_config/foo/config
   chezmoi git -- commit -m "Stop managing foo config"
   chezmoi git -- push
   ```

**On your other Macs**

1. [Sync](#sync-this-mac). chezmoi stops managing the file, but doesn't
   delete it.
2. If you want it gone, delete it by hand.

## Keep a change a tool made

Some tools rewrite their own config files, so they change on this Mac
without going through chezmoi. `chezmoi status` shows these as `MM`. The
usual ones here:

| File                         | Changed by                                       |
| ---------------------------- | ------------------------------------------------ |
| `~/.claude/settings.json`    | Claude Code, when you change a setting or plugin |
| `~/.config/mise/config.toml` | `mise use -g`                                    |
| `~/.gitconfig`               | `git lfs install`                                |

1. See what differs:

   ```sh
   chezmoi diff ~/.claude/settings.json
   ```

   `-` lines exist only on this Mac. Applying would remove them.

2. Pick one:
   - **Keep this Mac's version:** `chezmoi re-add ~/.claude/settings.json`
   - **Keep the repo's version:** `chezmoi apply --force ~/.claude/settings.json`
   - **Keep parts of both:** run `chezmoi edit ~/.claude/settings.json`,
     copy in the `-` lines you want, and save. Run `chezmoi diff` on the
     file again until it shows nothing you'd lose, then
     `chezmoi apply ~/.claude/settings.json`.

3. If the repo changed, commit and push it, as in
   [Edit a dotfile](#edit-a-dotfile) step 4.

## Add or remove an app

Apps are listed in `home/dot_Brewfile`. Applying installs anything that's
listed and missing.

**On this Mac**

1. [Sync this Mac](#sync-this-mac).
2. Run `chezmoi edit ~/.Brewfile`, then add or delete a line:
   - `brew "name"` for a command-line tool
   - `cask "name"` for an app
   - `mas "Name", id: 123` for an App Store app (`mas search <name>`
     shows the id)
3. Run `chezmoi apply`. This installs new apps. It doesn't uninstall
   removed ones.
4. To uninstall removed apps, run `brew bundle cleanup --global` to see
   the list, then `brew bundle cleanup --global --force`.
5. Commit and push:

   ```sh
   chezmoi git -- add home/dot_Brewfile
   chezmoi git -- commit -m "Add RustDesk"
   chezmoi git -- push
   ```

**On your other Macs**

1. [Sync](#sync-this-mac). New apps are installed.
2. For removed apps, repeat step 4.

## Fix a conflict when pulling

If you committed on two Macs before syncing, `chezmoi git -- pull`
or `chezmoi update` can stop with a conflict.

1. Open the repo:

   ```sh
   chezmoi cd
   ```

2. Run `git status` to see the conflicting files. Edit each one to keep
   the lines you want, and delete the `<<<<<<<`, `=======` and `>>>>>>>`
   markers.
3. Finish the pull, then apply:

   ```sh
   git add <file>
   git rebase --continue
   exit
   chezmoi apply
   ```

4. Push:

   ```sh
   chezmoi git -- push
   ```
