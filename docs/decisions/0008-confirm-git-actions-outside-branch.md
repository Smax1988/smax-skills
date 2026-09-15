# Git actions outside the feature branch are confirmed first

Superpowers pushes and commits inside its workflows without asking; the only
thing confirmed there is discarding a branch (typing `discard` in
`skills/finishing-a-development-branch/SKILL.md`). Here the rule is: **anything
that changes state outside the throwaway feature branch, or destroys history, is
asked about first.**

Confirmed are the single design commit in `writing-plans` (show the file list
and the message, then wait), the exception commit in `writing-specs` when
aborting at the user gate, and in `finishing-a-development-branch` the squash
commit onto the base branch, `git branch -D`, `git push`, plus opening the PR
**as a separate second question** — agreeing to one action is not agreeing to
the next. On top of that the `.gitignore` commit in `using-git-worktrees`: a
tracked file on the user's own branch that the skill used to commit unasked.

**Not confirmed, and written down explicitly so nobody adds the friction back
in:** task commits in SDD and the commits fixing review-gate findings on the
feature branch. They are review range and ledger recovery on a branch that gets
squashed and deleted anyway — one question per task would take SDD's purpose
away.

**`commitMessage` gets a lock:** the skill produces text and does not commit. It
fires on a casual "commit that", where the message is wanted and the commit
perhaps is not.
