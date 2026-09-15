# SDD without a task reviewer per task

Superpowers dispatches a task reviewer after *every* task
(`skills/subagent-driven-development/SKILL.md`: "a task review (spec compliance
+ code quality) after each"). Here that reviewer is dropped in the normal case:
the gate is the implementer's self-check plus the controller's inspection of the
report. On a 13-task plan that halves the dispatches — 13 instead of 26.

**What takes its place:** the controller reads the report file — not just the
status line — and checks four things against the brief: coverage of every brief
step, Global Constraints, test evidence with command and output, plus
`git diff --stat` for unexpected files. **Deliberately not the whole diff**:
that is exactly the context cost this design avoids.

**A task reviewer still runs on `DONE_WITH_CONCERNS`** about correctness or
scope. A self-check that ends in doubt is not a passed self-check — and this is
the cheap catch for precisely those tasks most likely to be the bad task 3.
`task-reviewer-prompt.md` and `re-review-prompt.md` are kept for it.

**The price, paid knowingly:** a defect in task 3 only becomes visible in the
final review, by which point tasks 4–13 already build on it. 13 saved dispatches
against later, more expensive discovery. That is why the final review is
reinforced — it is the only fresh-eyes inspection of the code, and it gets the
Global Constraints verbatim, the ledger lines, and explicit responsibility for
cross-task defects.

**The ledger distinguishes `report checked` from `reviewed`**, so that the final
reviewer and a later reader can see what somebody else's eyes actually saw.
