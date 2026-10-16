---
name: commit
description: Creates git commits - checks what is changing, splits unrelated changes into separate commits, and writes messages in the repo's style (asking the user when there is none). Use whenever making a git commit, including as one step of a larger task, or when the user asks to commit or to commit and push.
---

# Committing changes

## Before committing

- Commit only when the user asked. Push only when they asked to push.
- Read `git status` and `git diff` (and `git diff --cached`) so you know
  exactly what will be committed.
- Stage explicit paths (`git add <path>...`), not `git add -A` or `git add .`.
  Never stage secrets (`.env`, keys, tokens) or unrelated files.

## One topic per commit

If the changes cover several unrelated topics, make one commit per topic.
When a single file mixes topics, stage only part of it: save the diff to a
patch, trim it, and `git apply --cached` it.

## Message style

1. Run `git log --format='%s%n%b' -15`. If the repo has a consistent style
   (Conventional Commits, ticket prefixes, lowercase subjects, ...), match it.
2. Otherwise - a new repo, or no consistent style - ask the user which
   style to use before committing. Recommend Chris Beams' seven rules
   (https://cbea.ms/git-commit/) unless the project suggests something
   else (e.g. release tooling that expects Conventional Commits):
   1. Separate subject from body with a blank line
   2. Limit the subject line to 50 characters (72 is the hard limit)
   3. Capitalize the subject line
   4. Do not end the subject line with a period
   5. Use the imperative mood: "If applied, this commit will <subject>"
   6. Wrap the body at 72 characters
   7. Use the body to explain what and why, not how

Either way:

- Skip the body only for trivial changes.
- Trailers (`Resolves:`, `See also:`, `Co-Authored-By:` and any other
  attribution your instructions require) go last, after a blank line.
- Pass the message through a heredoc so line breaks survive:
  `git commit -F - <<'EOF'` ... `EOF`.

## After committing

- Check `git status` and `git log -1` to confirm the result.
- Never amend, rebase or force-push commits that are already pushed unless
  the user asks; fix them with a new commit.
- If a pre-commit hook fails, fix the problem and commit again. Do not use
  `--no-verify`.
