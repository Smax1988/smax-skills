# The sweep baseline keeps its blind spot — it gets named, not repaired

When `sync-plugin-docs` runs on `main`, the comparison base is the most recent
commit that touched `README.md` or `plugin/NOTICE.md`. That base has a known
silent fault, and it stays: **a purely cosmetic change to either document — a
typo, formatting — resets the window and hides every bit of staleness before
it.** Exactly the failure case `TODOS.md` 2.1.6 criticises about the git
timestamp.

**Why it is done that way anyway:** the alternative would be to check the state
of the documents by content instead of by modification date — that is, the full
reconciliation 2.1.6 rejects as too expensive (482 lines of README plus 30
`SKILL.md`, on every skill change). A marker in the commit or a state file would
be a third source of truth that drifts on its own.

**The countermeasure is visibility, not correctness.** The first line of the
report names both the base *and* the rule, so it is apparent how much a run could
cover. A run on a feature branch uses `git merge-base main HEAD` and is not
affected — which is an argument for doing skill work on a branch, and the report
makes the difference visible rather than concealing it.

**For whoever "repairs" this later:** the blind spot is neither sloppiness nor an
open item. Closing it means paying for the full reconciliation or introducing a
fourth file — both were examined and rejected. The remaining cheap improvement,
should it ever be needed, is the second rare sweep from 2.1.6
(`git log <last-README-commit>..HEAD -- plugin/skills/`) as a separate,
explicitly typed run — not as a replacement for the base rule.
