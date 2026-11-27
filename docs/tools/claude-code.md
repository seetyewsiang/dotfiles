# Claude Code

Settings and instructions for Claude Code, shared by the CLI and the
Claude desktop app (`cask "claude"`).

| File | Source in this repo |
| --- | --- |
| `~/.claude/settings.json` | [`home/symlinked/claude/settings.json`](../../home/symlinked/claude/settings.json), via a symlink |
| `~/.claude/CLAUDE.md` | [`home/private_dot_claude/CLAUDE.md`](../../home/private_dot_claude/CLAUDE.md) |
| `~/.claude/skills/commit/SKILL.md` | [`home/private_dot_claude/skills/commit/SKILL.md`](../../home/private_dot_claude/skills/commit/SKILL.md) |

## `settings.json`

Claude Code rewrites this file whenever you change a setting or plugin. Like
[mise](mise.md#why-its-a-symlink), it's a symlink to the file in the repo, so
those changes land in the repo directly, ready to commit.

| Setting | Value | What it does |
| --- | --- | --- |
| `outputStyle` | `Concise` | Short answers that lead with the result. |
| `theme` | `dark` | Dark UI theme. |
| `showThinkingSummaries` | `true` | Shows the full thinking summaries when you expand thinking with Ctrl+O, instead of a collapsed stub. Changes only what you see, not what the model does. |
| `autoCompactEnabled` | `true` | Summarizes older conversation automatically when the context fills up. |
| `switchModelsOnFlag` | `true` | When a safety classifier flags a request, switches to the fallback model and carries on, instead of pausing to ask. In `/config`: "Switch models when a message is flagged". |
| `agentPushNotifEnabled` | `true` | Lets Claude send a push notification to your phone when it judges one worthwhile, such as when a long task finishes. In `/config`: "Push when Claude decides". |
| `inputNeededNotifEnabled` | `true` | Sends a push notification to your phone when a permission prompt or question is waiting. In `/config`: "Push when actions required". |

The two push settings reach your phone through Remote Control; in a local
session they only send while Remote Control is connected. Descriptions are
from the [settings reference](https://code.claude.com/docs/en/settings-reference.md).

**Plugin marketplaces** (`extraKnownMarketplaces`): Anthropic's official
`claude-plugins-official`, `obra/superpowers-marketplace`, and
`vale-cli/agent-tools`.

**Enabled plugins** (`enabledPlugins`), all from `claude-plugins-official`:
`github`, `claude-md-management`, `context7`, `typescript-lsp`,
`claude-code-setup`, `commit-commands`, `plugin-dev`, `hookify`,
`clangd-lsp` and `unity`.

## `CLAUDE.md`

Instructions loaded into every Claude Code session. It has one rule: load
the `commit` skill before making any git commit.

## `commit` skill

How Claude makes commits in any repo:

- Commit only when asked; push only when asked to push.
- Read the diff first, and stage explicit paths, never `git add -A`.
- One topic per commit. Mixed changes in one file are split by staging a
  partial patch.
- Match the repo's existing message style. With no clear style, ask, and
  recommend the [seven rules](https://cbea.ms/git-commit/), the same ones
  as the [Git commit template](git.md#gitmessage-commit-template).

## Not managed

`~/.claude/settings.local.json` and each project's
`.claude/settings.local.json` are personal, per-machine settings. The
[global gitignore](../gitignore.md) keeps the project ones out of repos.
