---
name: commitMessage
description: Use when a commit message is needed - generates a semantic commit message from the uncommitted changes in the repository
---

Analyze all uncommitted changes (staged and unstaged) in the current git repository using git diff and git status.

Create a concise, semantic commit message that:
- Starts with a compact first line that immediately shows the core change
- Uses conventional commit format (feat/fix/refactor/docs/chore/etc.)
- Describes WHAT was changed and WHY, not HOW
- Does NOT include any attribution or references to AI/Claude/generated content
- Never includes secrets (API keys, tokens, passwords) or personal data (PII), even if they appear in the diff
- Keeps the first line under 72 characters if possible

Output only the commit message, ready to be used with git commit.

**Do not run the commit.** This skill produces text. Whether and when to commit is the user's decision and needs their explicit OK — and this skill now triggers on a casual "commit that", where the message is wanted and the commit may not be. Show the message and wait.

## Squash commits for a whole branch

A message for a squashed feature branch is a different animal from a message for one change: it is the *only* record of the work once the branch is gone. When the staged content is a `git merge --squash` of a feature branch — `smax:finishing-a-development-branch` Option 1 — write a body as well as a subject.

**Subject:** as above, one line, the outcome of the whole branch. Not a list.

**Body:** one bullet per task from the plan, in plan order, each naming what changed rather than restating the task title. Read the plan under `docs/02_Plans/<Slug>/` if it is available, and the branch's commit subjects (`git log --oneline <base>..<feature>`) otherwise. Close with a `Plan:` line pointing at the plan file, so the squashed commit still leads back to the reasoning.

```
feat(billing): tip allowance per employee and payout period

- Schema: tip_allowance table plus forward/rollback scripts
- Domain: TipAllowance aggregate with period-boundary validation
- API: POST/GET /employees/{id}/tip-allowance
- Payroll export extended by the allowance column

Plan: docs/02_Plans/TipAllowance/PLAN-TipAllowance-26072026.md
```

Skip the body when the branch holds a single logical change — a squash of three commits that all fix one bug does not need a bullet list.
