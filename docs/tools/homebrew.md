# Homebrew

Installs every command-line tool and app on the Mac from one list, the
Brewfile.

| File | Source in this repo |
| --- | --- |
| `~/.Brewfile` | [`home/dot_Brewfile`](../../home/dot_Brewfile) |
| Install script | [`home/.chezmoiscripts/run_once_before_10-install-homebrew.sh`](../../home/.chezmoiscripts/run_once_before_10-install-homebrew.sh) |
| Bundle script | [`home/.chezmoiscripts/run_onchange_after_30-brew-bundle.sh.tmpl`](../../home/.chezmoiscripts/run_onchange_after_30-brew-bundle.sh.tmpl) |
| Xcode script | [`home/.chezmoiscripts/run_onchange_after_60-install-xcode.sh`](../../home/.chezmoiscripts/run_onchange_after_60-install-xcode.sh) |

Edit the list with `chezmoi edit ~/.Brewfile`, then `chezmoi apply`.

## How it gets installed

1. **Homebrew itself.** On the first `chezmoi apply`, the install script
   runs Homebrew's official installer if `brew` is missing. It runs once
   per Mac, before any dotfiles are written, because `.zprofile` and the
   bundle step need `brew`.
2. **Everything in the Brewfile.** The bundle script runs
   `brew bundle --global`, which reads `~/.Brewfile` and installs anything
   listed and missing. It's a `run_onchange_` script with the Brewfile's
   hash in a comment, so chezmoi re-runs it whenever the Brewfile changes,
   and only then.
3. **Xcode.** The Xcode script runs
   `xcodes install 27.2 --select --experimental-unxip`, skipping it if that
   version is already installed. See [Xcode](#xcode) below.

Both scripts pick the Homebrew path by CPU: `/opt/homebrew` on Apple
Silicon, `/usr/local` on Intel. [`.zprofile`](zsh.md) does the same to put
`brew` on your PATH.

`brew bundle` installs but never uninstalls. To remove apps you deleted
from the list, see
[Add or remove an app](../managing-dotfiles.md#add-or-remove-an-app).

## What's in the Brewfile

**Command-line tools (`brew`)**

| Formula | Why |
| --- | --- |
| `aria2` | Multi-connection downloader. xcodes uses it to download Xcode 3-5x faster. |
| `bash` | bash 5. macOS ships bash 3.2, which lacks many newer features. |
| `gawk` | GNU awk. Needed by shdoc (see [mise](mise.md)). |
| `gh` | GitHub CLI. Config: [gh](gh.md). |
| `git-lfs` | Git Large File Storage. Hooked into Git by [`.gitconfig`](git.md). |
| `mas` | Installs the App Store apps below. |
| `xcodes` | Installs and switches between Xcode versions. Used by the [Xcode script](#xcode). |

**Apps (`cask`)**

Apps with settings managed here have their own page:
[Ghostty](../apps/ghostty.md), [Scroll Reverser](../apps/scroll-reverser.md),
[Visual Studio Code](../apps/vscode.md), and the
[Claude](claude-code.md) desktop app shares settings with Claude Code.

The rest are installed with their default settings: BetterDisplay, Beyond
Compare 4, Docker Desktop, Google Chrome, Google Gemini, Proton VPN,
RustDesk, TeamViewer, Unity Hub, UTM and VLC.

`font-roboto-mono-nerd-font` installs the RobotoMono Nerd Font that
[Ghostty](../apps/ghostty.md) uses.

**App Store apps (`mas`)**

Amphetamine, WeChat and WhatsApp. Sign in to the App Store before the first
apply, or these fail to install.

## Xcode

Xcode isn't in the Brewfile: Homebrew can't install it, and the App Store
only offers the latest version. The Xcode script installs a pinned version
with `xcodes` instead:

- `--select` makes it the active Xcode (`xcode-select`), so `xcodebuild`
  and `swift` use it.
- `--experimental-unxip` unpacks the `.xip` archive faster than macOS's
  own tool.

It's interactive: xcodes asks for your Apple ID (Apple requires a sign-in
to download Xcode), and `--select` asks for your password through sudo.
Xcode is installed as `/Applications/Xcode-27.2.0.app`.

To move to a new version, change `version=` in the script and
`chezmoi apply`. The script is a `run_onchange_` script, so the edit makes
it run again. Older versions stay installed; remove one with
`xcodes uninstall <version>`.

## Check it

```sh
brew bundle check --global --verbose   # lists anything missing
xcodes installed                       # installed Xcodes; the active one says (Selected)
```
