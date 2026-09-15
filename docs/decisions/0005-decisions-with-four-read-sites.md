# `docs/decisions/` gets four read sites

Decisions were written in seven places and read in none — a pure write-only
archive. That left the claim in `DECISION-FORMAT.md` ("These stop the next
engineer from 'fixing' something that was deliberate") without effect: the next
engineer is usually an agent, and that agent had never opened the files.
Superpowers does not know the concept at all.

Four read sites, all following the same pattern — `ls docs/decisions/`, judge by
title, open zero to two files, skip silently when the directory is missing:

- **`brainstorming` step 1** — Decisions as constraint and starting point. If a
  design contradicts one, that is said *before* the proposal. Overturning is
  allowed; overturning silently is not.
- **`code-review/code-reviewer.md`** — if the diff contradicts a Decision, that
  is at least `Important`, naming the file. The one site with teeth.
  `superseded`/`deprecated` does not bind.
- **`debugging`** — if the code violates a Decision, that *is* the root cause,
  not the observed symptom. The classic sequence is somebody mistaking the
  deliberate deviation for an oversight.
- **`writing-plans` Global Constraints** — one line per binding Decision, along
  with the wrong-but-obvious alternative it rules out.

**The filename is the index** — that is what the `NNNN-slug` scheme is for. All
four sites judge by title and open only what applies; a directory holding 40
Decisions costs one `ls`, not context.

**Global Constraints is the most effective lever**, because
`task-reviewer-prompt.md` hands that block verbatim to every task reviewer — and
it is the only route by which a Decision reaches the implementation at all.

**The `implementer-prompt` is deliberately left out:** it already carries the
`CONTEXT.md` excerpt, and Decisions there would cost context again per task. The
binding arrives through the task text.

**Addendum:** all four sites presuppose that the skill in question is running.
For work without any skill invocation a fifth route was added later, see
[[0015-decisions-in-project-claude-md]].
