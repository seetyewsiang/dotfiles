# Visual Studio Code

The editor (`cask "visual-studio-code"`). Its own settings aren't managed
here. What is managed is an **Open in VS Code** Finder Quick Action.

| File | Source in this repo |
| --- | --- |
| `~/Library/Services/Open in VS Code.workflow` | [`home/private_Library/private_Services/private_Open in VS Code.workflow`](../../home/private_Library/private_Services/private_Open%20in%20VS%20Code.workflow) |
| Turning it on | [`home/.chezmoiscripts/run_onchange_after_40-macos-defaults.sh`](../../home/.chezmoiscripts/run_onchange_after_40-macos-defaults.sh) |

## Open in VS Code

Right-click a folder in Finder and choose **Quick Actions → Open in VS
Code** (also under **Services**, and in Finder's preview pane). It opens the
folder in VS Code.

It's an Automator Quick Action that takes folders in Finder and runs:

```sh
open -a "Visual Studio Code" "$@"
```

## Why a script turns it on

macOS registers new Quick Actions switched off, so the action wouldn't
appear in menus after install. The defaults script adds it to
`NSServicesStatus` in the `pbs` domain (the Services settings), enabled for
the right-click menu, Finder preview and Services menu (not the Touch Bar),
then runs `pbs -update` so Finder picks it up.

To edit the action, open the `.workflow` in Automator, save, then bring it
back into the repo with `chezmoi re-add "$HOME/Library/Services/Open in VS Code.workflow"`.
