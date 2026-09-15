---
name: handoff
description: Creates a session handoff document so the work can be continued in a new session, on another machine, or by a colleague
argument-hint: [focus for the next session]
disable-model-invocation: true
---

Produce a precise, self-contained handoff document that lets a fresh session (another machine, a new Claude chat, a colleague) continue this session's work without asking back.

## Target path & arguments

- The target directory is **`C:\Temp`** — regardless of the current working directory. The handoff does not belong in the project: it describes a session, not the code, and has no business in a repo or a commit.
- If `C:\Temp` does not exist, create it first: `New-Item -ItemType Directory -Force C:\Temp` (PowerShell).
- Write to `C:\Temp\HANDOFF-<shortName>.md`.
- `<shortName>` names the topic of the work and is the file-name form of the `<short title>` in the document heading:
  - **Derivation:** from `$ARGUMENTS` (focus) if one was passed — otherwise from the overarching goal or the topic of this session.
  - **Form:** short (1–3 words), kebab-case, ASCII, no umlauts or spaces (e.g. `HANDOFF-plugin-autoupdate.md`, `HANDOFF-auth-refactor.md`, `HANDOFF-invoice-import.md`).
  - **Collision:** if the file already exists, fall back to `-2`, `-3` … at the end of the name instead of overwriting.
- If arguments were passed (`$ARGUMENTS`): treat them as a description of what the next session will focus on, and cut the document accordingly (emphasis, level of detail, relevant sections).

## Step 1 — Capture the repo state

There can be no repo, one, or several in the workspace (at different depths).

- Find all repos down to depth 6 without searching heavy directories:
  `find . -maxdepth 6 \( -name node_modules -o -name .git -prune -o -type d -name .git -print \) 2>/dev/null`
  (Pragmatically: use a search that skips `node_modules` and lists `.git` directories; the parent directory of each `.git` is a repo root.)
- Capture separately for **every** repo found: current branch, `git status -s`, `git diff --stat`, the last ~10 commits (`git log --oneline -10`).
- No repo found → skip this part and rely solely on this session's conversation context.

## Step 2 — Write the handoff document

Write the document in this fixed structure:

```
# Handoff — <short title> (<YYYY-MM-DD>)

## Assignment / goal
The overarching goal and what is concretely being worked on in this session.

## Current state
Done / open — as bullet points.

## Next step
The ONE concrete next step, phrased precisely as an imperative (what, where, how).

## Decisions & context
Decisions made and why, constraints, dead ends and blockers.

## Environment & files
Relevant paths, changed files, required tools and access.
One subsection per repo found, with the repo path as the heading:
branch, uncommitted changes (status -s), diff --stat, last commits.

## Resuming
One sentence: what the next person should do first.
```

## Principles (binding)

- **Precision over completeness** — no filler. Name concrete files, commands and paths. Tasks as imperatives.
- **Self-contained** — understandable without access to this session or this chat log.
- **Honest state** — name open points, failures and blockers plainly, do not gloss over them.
- **Invent nothing** — record only what is actually known. Mark gaps in knowledge explicitly as "unknown".
- **Redact sensitive data** — no API keys, passwords, tokens or personal data (PII) in the document; mark them as placeholders.

## Closing

After writing: confirm with the target path and a one-line summary of the handoff in the terminal.
