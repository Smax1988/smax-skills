---
name: replicate
description: Reproducible doc recipe of the system/config changes made in this session, for replaying them on other machines
argument-hint: [focus of the changes]
disable-model-invocation: true
---

Produce a precise, self-contained doc recipe that makes the system, environment and configuration changes made in THIS session reproducible identically on another machine.

Not an executable setup script — plain, traceable documentation with exact re-apply commands to run by hand.

## Target path & arguments

- The target directory is **`C:\Temp`** — regardless of the current working directory. The recipe describes machine and environment changes, not the project; it has no business in a repo or a commit.
- If `C:\Temp` does not exist, create it first: `New-Item -ItemType Directory -Force C:\Temp` (PowerShell).
- Write to `C:\Temp\REPLICATE-<shortName>.md`.
- `<shortName>` names the topic of the captured changes:
  - **Derivation:** from `$ARGUMENTS` (focus) if one was passed — otherwise from the common topic of the captured changes.
  - **Form:** short (1–3 words), kebab-case, ASCII, no umlauts or spaces (e.g. `REPLICATE-powershell-profile.md`, `REPLICATE-git-config.md`, `REPLICATE-node-toolchain.md`).
  - **Collision:** if the file already exists, fall back to `-2`, `-3` … at the end of the name instead of overwriting.
- If arguments were passed (`$ARGUMENTS`): treat them as a description of what the next session will focus on, and cut the document accordingly (which changes take the foreground, level of detail, relevant sections).

## Scope

- Capture **only the changes made in this session** — reconstructed from the conversation history (files edited, commands run, values set).
- No broad system scan, no pre-existing configuration that was not touched in this session.
- Typical places affected (only if changed in this session): shell profiles (`$PROFILE`, `~/.bashrc`, `~/.bash_profile`, `~/.profile`), editor config (`~/.config/nano/nanorc`), `PATH` and other environment variables, installed tools/packages, registry entries, git config, other dotfiles and app configs.

## Document structure

Write the document in this fixed structure:

```
# Replicate: <topic> — session changes (<YYYY-MM-DD>)

## Summary
One to three sentences: what was changed on the system/environment in this session, and what for.

## Prerequisites
What has to exist on the target machine for the steps to work (shell, tool versions, permissions). Only if relevant.

## Changes
One numbered section per change, in a sensible order (dependencies first):

### N. <short title>
- **What & why:** the concrete change and its purpose.
- **Where:** the file/variable/registry path affected (absolute).
- **New state:** exact new file content, or a diff of the changed lines (in a code block).
- **Re-apply:** exact commands to apply it on the target machine — in the matching shell (PowerShell for `$PROFILE`/PATH/registry, Bash for `~/.bashrc`/nano etc.). Mark the shell per block.
- **Machine-specific:** mark the spots that have to be adjusted per machine (user name, drive letter, absolute paths, host name).
- **Verification:** one command/check that confirms the change took effect.

## Order & dependencies
Only if changes depend on each other: a brief listing.
```

## Principles (binding)

- **Reproducible & precise** — concrete paths, exact commands, exact content/diff. No vague descriptions.
- **Self-contained** — applicable on the target machine without access to this session.
- **Never sensitive data in the clear** — no tokens, passwords, API keys, private keys or personal data (PII) in the document. Mark them as placeholders (`<YOUR_TOKEN>`) and note under "Machine-specific", or in a remark, what has to be filled in.
- **Separate portable from machine-specific** — mark machine-dependent values clearly instead of carrying them over verbatim.
- **Mind idempotency** — where possible, phrase and document re-apply commands so that applying them again does no harm; otherwise note a check-before-apply in the verification or re-apply part.
- **Invent nothing** — record only what was actually changed in this session. Mark anything uncertain explicitly as "unconfirmed".

## Closing

After writing: confirm with the target path and a one-line summary of the captured changes in the terminal.
