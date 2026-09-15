# Executable claims in a plan get executed, not read

A plan contained a factually wrong justification, written in the same session:
task 2 step 2 claimed a test was red without the TypeError guard. Neither the
plan reviewer nor both task reviewers found it — only the final whole-branch
review did, and by mutation testing: guard deleted, suite stayed 7/7 green. The
guard was defended by no test at all.

**Why that is worth a rule of its own:** a wrong reason in a plan is more
dangerous than a missing one. The implementer builds on it, the reviewers read
it as context rather than as a claim, and the defect only surfaces when somebody
mutates the code.

The self-check in `writing-plans` got its own item for this, the plan reviewer
its own line. That is one stage earlier than the final review and the cheapest
place to repair it — the same probe inside the review is described in
[[0009-merge-code-review-skills]].

**Second finding from the same run, same commit:** every named agent sends an
`idle_notification` after its report. The controller answered it four times with
"nothing to do" — four turns burned per run. SDD now ignores idle notices from
agents whose report is already in.
