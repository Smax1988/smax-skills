---
name: code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
disable-model-invocation: true
---

# Code Review

Dispatch a reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context — never your session's history. Reviewing the diff inline burns the context window you need to keep driving the work.

**Core principle:** Review early, review often.

## Process

**1. Pin the range.** `BASE_SHA` is the last reviewed commit (or `origin/<base-branch>`, or a merge-base); `HEAD_SHA` is `git rev-parse HEAD`. Verify both resolve and the diff is non-empty before dispatching — a bad ref must fail here, not inside the subagent.

**2. Dispatch a `general-purpose` subagent** with the template at [code-reviewer.md](code-reviewer.md), filling `[DESCRIPTION]`, `[PLAN_OR_REQUIREMENTS]`, `[BASE_SHA]`, `[HEAD_SHA]`.

**One-shot, no name, no follow-up messages** — the reviewer's final message *is* the report. Naming the agent makes it an addressable teammate that goes idle without reporting and has to be polled. If you need a second pass after fixes, dispatch a **fresh** reviewer over the fix range; a re-used one answers from its stale snapshot of the code.

**3. Act on feedback** — see below.

## Act on feedback

Code review requires technical evaluation, not emotional performance. **Verify before implementing. Ask before assuming.**

Read the whole review without reacting. **If any item is unclear, stop and ask before implementing anything** — items are often related, and partial understanding produces the wrong fix.

Then, per item: restate the requirement, check it against codebase reality, and decide whether it is technically sound *for this codebase*. Fix in this order — Critical, then Important, then simple Minor fixes; test each individually. Note the rest.

**Push back when the reviewer is wrong** — the suggestion breaks existing behaviour, the reviewer lacks context, it violates YAGNI (grep: is the code even called?), it's wrong for this stack, or it contradicts an architectural decision your partner already made. Use technical reasoning and point at working tests or code. If you can't verify a claim, say so: *"I can't verify this without X — investigate, ask, or proceed?"* If pushing back feels uncomfortable, name that tension and raise the issue anyway.

**When feedback is correct:** state the fix (`"Fixed — validated ISO format in search.ts:25"`) or just fix it. Never *"You're absolutely right!"*, *"Great point!"*, or any gratitude expression — actions speak, and the code shows you heard it. If you pushed back and were wrong, say so factually in one sentence and move on; no apology, no defence of the pushback.

When replying to inline comments on GitHub, reply in the thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## Red Flags

**Never:** skip review because "it's simple" · ignore Critical issues · proceed with unfixed Important issues · argue with valid technical feedback · agree performatively before verifying.
