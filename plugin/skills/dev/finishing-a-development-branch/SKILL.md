---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work
---

# Finishing a Development Branch

**Core principle:** Verify tests → Detect environment → Confirm base → **Review gate** → Present options → Execute → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

<HARD-GATE>
**Everything in this skill that changes state outside the feature branch, or destroys history, is asked first.** Named individually where it happens, and here as the list:

| Action | Ask |
|---|---|
| The squash commit onto the base branch | **yes** |
| `git branch -D <feature-branch>` | **yes** |
| `git push` | **yes** |
| Creating the pull request | **yes**, separately from the push |
| Discarding the work | **yes** — the typed word `discard` |
| Committing review-gate fixes onto the feature branch | no — that branch is disposable and gets squashed away |

Show what the action will do — the message, the file count, what becomes unrecoverable — then wait. A yes to one of these is not a yes to the next one.
</HARD-GATE>

## Step 1: Verify Tests

Run the project's full test suite (`npm test` / `cargo test` / `pytest` / `go test ./...`). **If tests fail**, report the failures and stop — the menu comes after a green suite.

## Step 2: Detect Environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# Capture now, while still inside the workspace — Step 6 changes directory
# before cleanup (Step 7) needs this value
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

| State | Menu | Cleanup |
|-------|------|---------|
| `GIT_DIR == GIT_COMMON` (normal repo) | Standard 3 options | No worktree to clean up |
| `GIT_DIR != GIT_COMMON`, named branch | Standard 3 options | Provenance-based (Step 7) |
| `GIT_DIR != GIT_COMMON`, detached HEAD | Reduced 2 options (no merge) | Externally managed — leave in place |

## Step 3: Determine Base Branch

The base branch is whatever this work forked from — usually named in the plan, the conversation, or the branch's upstream. If it is not already known, ask: *"This branch split from `<your best guess>` — is that correct?"* Confirm before merging: merging into the wrong base is expensive to undo.

## Step 4: The Review Gate — blocking

**No branch reaches the menu unreviewed.** This is the one place every route passes through: `smax:subagent-driven-development`, `smax:executing-plans`, and a plan worked through by hand all end up here.

```bash
HEAD_SHA=$(git rev-parse --short HEAD)
```

**Has this exact HEAD already been reviewed clean?** The evidence must be a written record, not a recollection from the conversation:

- An SDD ledger line `Final review: clean (HEAD <sha7>)` whose SHA equals `HEAD_SHA`.
- Nothing else counts. "I reviewed it a moment ago" is not evidence — a single commit since then invalidates it, and after a compaction you cannot tell.

**Find the ledger; do not assume you know its path.** This skill is routinely
entered cold — the branch was finished in a session that has since ended — and
then you do not know the plan slug the workspace is named after:

```bash
head -1 .smax/sdd/*/progress.md 2>/dev/null   # each ledger names its plan file
```

Pick the ledger whose plan file is the work on this branch. **Record its
directory as `SDD_WORKSPACE`** — Step 7 deletes exactly that directory and
nothing else. Several plans may have workspaces here; the others belong to
other work.

Then check that ledger for `Final review: clean (HEAD <sha7>)` with `<sha7>`
equal to `HEAD_SHA`. A `clean` line from a *different* plan, or from an
earlier HEAD of this one, proves nothing — match the SHA, not just the
presence of the line.

No `.smax/sdd/` at all, or no ledger belonging to this branch: it was not
built by SDD, or was built in a run that never finished. There is no
`SDD_WORKSPACE`, Step 7 has nothing to remove, and the review below runs.

**If the SHAs match:** report *"HEAD `<sha7>` was already reviewed clean by the final SDD reviewer — skipping the gate."* Go to Step 5.

**Otherwise:** dispatch a `general-purpose` subagent with [../code-review/code-reviewer.md](../code-review/code-reviewer.md) over the branch's full range (`BASE_SHA` = merge-base with the base branch, `HEAD_SHA` = HEAD). **One-shot, no name** — the reviewer's final message is the report; a named agent becomes an addressable teammate that goes idle without reporting. Fix everything under `Issues`; `Recommendations` are advisory and do not block. Commit the fixes, then re-run Step 1 — the fixes are code and the suite must be green on the tree you are about to integrate.

Only then does the menu appear.

## Step 5: Present Options

**Normal repo and named-branch worktree — exactly these 3 options:**

```
Implementation complete. What would you like to do?

1. Squash-merge into <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)

Which option?
```

**Detached HEAD — exactly these 2 options:**

```
Implementation complete. You're on a detached HEAD (externally managed workspace).

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)

Which option?
```

Present the menu exactly as written. Discarding the work happens only when your human partner explicitly asks for it (see below). Wait for their answer; the integration decision is theirs.

## Step 6: Execute Choice

### Option 1: Squash-Merge Locally

One commit lands in the base branch. The task commits served their purpose — review ranges and ledger recovery — and stay behind on the feature branch, which then goes away.

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"

git switch <base-branch>
git pull
git merge --squash <feature-branch>   # stages the result, does NOT commit

<test command>                        # test BEFORE committing
```

**Test in the staged state, before the commit.** `--squash` builds index and working tree without creating a commit, so a red suite is undone with `git reset --hard` and the base branch is clean again — no revert commit, and the feature branch is untouched and still holds every task commit. Commit first and you have to unpick it afterwards.

Green? Get the message from `smax:commitMessage` — then **ask before committing:**

> "Suite green on the squashed result. This lands one commit on `main`:
> `feat(billing): tip allowance per employee and payout period`
> `git diff --cached --stat`: 14 files, +612/−38.
> Commit?"

Wait for a yes. This is the commit that puts the work in the base branch's permanent history — it is the user's call. On a no: leave it staged, or `git reset --hard` if they say to drop it.

```bash
git commit -m "<message from smax:commitMessage>"
```

Then clean up the worktree (Step 7) and **ask before deleting the branch:**

> "Committed as `<sha7>`. Deleting `<feature-branch>` now discards its 9 task commits — the content is in `main`, the individual steps are not recoverable afterwards. Delete it?"

```bash
git branch -D <feature-branch>
```

On a no, leave the branch and say so. It costs nothing to keep and can be deleted later; a deleted branch's task commits are gone.

**`-D` is required here, and it is not carelessness.** A squash produces an ordinary commit with one parent, not a merge commit with a second parent pointing at the feature branch. Git therefore sees the branch as unmerged and `git branch -d` refuses it. The content *is* in the base branch — you just tested it there. Do not "fix" this back to `-d`.

### Option 2: Push and Create PR

**Ask before pushing.** A push publishes: it leaves the machine, other people and CI see it, and it cannot be silently taken back.

> "Pushing `<feature-branch>` to `origin` — 9 commits, and it becomes visible to anyone with access to the remote. Push?"

Wait for a yes. Then:

```bash
git push -u origin <feature-branch>
# From a detached HEAD, name the new branch on the remote:
# git push origin HEAD:refs/heads/<new-branch>
```

**Creating the pull request is a second, separate question** — a PR notifies reviewers and starts CI. Ask again before opening it, and report the URL afterwards.

Create the pull/merge request against `<base-branch>` with the forge's tooling — its CLI if available, or the creation URL most forges print on push — following the repo's PR template and conventions, and report the URL.

Keep the worktree — your human partner iterates on PR feedback there. This route also keeps the individual task commits until the forge squashes them, which is the escape hatch when a bisectable history matters more than a clean one.

### Option 3: Keep As-Is

Report: *"Keeping branch `<name>`. Worktree preserved at `<path>`."*

### If your human partner asks to discard the work

Only in response to an explicit request. Show what dies (branch, commit list, worktree path) and require the exact word `discard`. On that confirmation: `cd` to `MAIN_ROOT`, clean up the worktree (Step 7), then `git branch -D <feature-branch>`.

## Step 7: Cleanup Workspace

**Runs for Option 1 and confirmed discards.** Options 2 and 3 always preserve the worktree. Both callers have already changed directory to the main repo root — worktree removal must run from outside the worktree — and use the values captured in Step 2.

- **`GIT_DIR == GIT_COMMON`:** normal repo, nothing to clean up.
- **`WORKTREE_PATH` under `.worktrees/` or `worktrees/`:** we created it, we remove it — `git worktree remove "$WORKTREE_PATH"` then `git worktree prune`.
- **Otherwise:** the host environment owns this workspace — leave it. If your platform provides a workspace-exit tool, use it.

**Also remove this plan's SDD workspace** — `rm -rf "$SDD_WORKSPACE"`, the directory you identified in Step 4 — but only here, after the branch is gone. `smax:subagent-driven-development` deliberately leaves it behind so the gate in Step 4 could read its ledger; now that the branch has landed, git history is the record and a leftover ledger is a hazard: a later run against the same plan file would read `Task 1..N: complete` and skip work that no longer exists.

<HARD-GATE>
**Delete only the path Step 4 identified. Never derive it here, never guess a plan slug, never widen the glob.** If Step 4 found no ledger for this branch, there is nothing to delete — skip this and say so. This is an `rm -rf` against a directory whose siblings hold other plans' ledgers, and a wrong guess destroys another run's recovery map. When you cannot name the directory from Step 4, you do not delete anything.
</HARD-GATE>

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Tests passed earlier this session" / "The failure after the squash is probably flaky" | A green run only proves the tree it ran on, and a red one stops everything. Run the suite on the tree you are about to integrate; on red, `git reset --hard` the base branch — the feature branch is untouched. |
| "I reviewed this myself, the gate is redundant" | The gate wants a written record with a matching HEAD SHA. Your recollection survives neither one more commit nor a compaction. |
| "The change is two lines, skip the review" | The gate does not scale with diff size. If it feels heavy for trivial fixes, don't route trivial fixes through this skill at all — that's the right answer, not weakening the gate. |
| "SDD reviewed it, so the gate can be skipped" | Only if the ledger's `Final review: clean (HEAD <sha7>)` matches the current HEAD. One commit later it does not. |
| "They obviously want it merged" | Integration is your human partner's decision. Present the menu and wait. |
| "They seem done with this feature — I'll offer to discard it" | The menu is complete as written. Discard happens only when your human partner asks for it in so many words. |
| "'Yeah, get rid of it' counts as confirmation" | Only the typed word `discard` authorizes deletion. |
| "I'll commit the squash and then run the tests" | Test in the staged state. A red suite after committing costs you a revert; before committing it costs you one `git reset --hard`. |
| "`git branch -d` failed, something went wrong" | Expected after a squash — no merge commit, so Git sees the branch as unmerged. Use `-D`. |
| "The PR is up, so the worktree is clutter now" | PR feedback gets fixed in that worktree. It stays until the work lands. |
| "This other worktree looks stale — I'll clean it too" | Clean up only worktrees under `.worktrees/` or `worktrees/`. Everything else belongs to the host. |
| "The base branch is obviously main" | Confirm the fork point or ask. Merging into the wrong base is expensive to undo. |
| "The push was rejected — force-push will fix it" | A rejected push means the remote moved. Investigate; force-push only on your human partner's explicit request. |
