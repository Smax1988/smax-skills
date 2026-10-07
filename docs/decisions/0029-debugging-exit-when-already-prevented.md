# debugging has an exit for a reported bug the code already prevents

`smax:debugging` gets a section *Exit: The Reported Behavior Is Already
Prevented*, placed between Phase 1 and Phase 2. It applies only when three
things hold: the agent followed the reported path, the behavior did not occur,
and it can point at the code that blocks it. Then the result is a report — the
reproduction, the guard with file and line, what was not checked — and **no
file changes**. Moving the guard, adding a second one "for defense in depth"
and a failing test that reaches past the guard are named explicitly as not a
fix. "No Root Cause" and `defense-in-depth.md` are scoped to behavior that
actually occurs.

**Why:** upstream `systematic-debugging` has no way out of the four phases
except one that still asks for code ("implement appropriate handling"). In a
benchmark task built from a real `/debugging` prompt about a bug the code
already guards against, runs found the guard, often wrote themselves that the
bug is not reproducible, and changed the code anyway. They justified it with
the skill's own words: "fix at source, not at symptom", "defense in depth", a
self-built failing test as "confirming the defect". A result that says "there
is nothing to fix" had no place in the process.

**Why not drop the skill from that task:** the prompt came with `/debugging` in
real use. The skill has to handle that case, not be kept away from it.

**Measured, and not yet effective:** a micro-test on 04.10.2026 (5 runs per
arm, isolated copies of the task) showed no gain. Sonnet left the code alone
with the old and the new text alike (5/5 each). Haiku changed it with both
(old 0/5, new 0/4 valid runs; a fifth had read the task's answer and was
discarded). Haiku decides that "the guard checks the display, not the state"
is the root cause before the exit section ever comes up, or takes the exit and
then reopens it on a code path it only inferred. The section is kept because
it states what was missing and costs nothing where it is not needed.

**Consequence:** a run that finds the reported behavior already prevented ends
after Phase 1 with a report. Restructuring a working guard is a separate
assignment for the human partner. The core rule is unchanged: "can't
reproduce, and I don't know why" is not this exit.
