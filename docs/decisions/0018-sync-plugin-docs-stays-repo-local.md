# `sync-plugin-docs` stays repo-local, against the earlier ruling

The skill that reconciles `README.md` and `plugin/NOTICE.md` against the skill
inventory lives under `.claude/skills/sync-plugin-docs/` — that is, **not** in
the plugin. `TODOS.md` 2.1 had ruled the opposite ("Plugin-Skill — er soll in
*jedem* Repo gleich funktionieren, also nicht repo-lokal. Ursprünglich als
`.claude/skills/…` gedacht, verworfen."). That ruling is hereby reversed.

**Why:** the plugin variant hangs on `TODOS.md` 1.1 — as long as the doc
structure differs per repo, a plugin skill would have to master every variant
separately. The core of the skill is the **source list**: which fact in the
derived document comes from which source outside it. In *this* repo that list
can be drawn up, because it is settled what the README documents — namely
skills, whose frontmatter, directories and calls supply the sources.

**The trade-off — the blocker is driven around, not resolved.** 1.1 remains a
blocker for the plugin variant, and the way there is not a file move. Only the
**frame** transfers: choice of comparison base, the `grep` safety net against
one's own incomplete source list, the boundary from
[[0019-write-sourced-present-the-rest]], and "no document present → skip
silently". The source list itself is repo-specific: here the README documents
skills, in the customer repos it documents an application — those are
different facts with different sources. The plugin version would have to obtain
the source list from the repo (by convention, a config file, or derived per run).
That is the expensive job, and it still sits behind 1.1.

**The consequence: no plugin skill may point at `.claude/skills/…`** — that path
does not exist in any other repo, and the reference would run silently into
nothing. Calling it from `finishing-a-development-branch` or any other link in
the chain is therefore ruled out until plugin integration, not merely postponed.

**The trigger works around that lock in two ways**, both of which need no
reference:

- A block in the project's `CLAUDE.md`, for the same reason as in
  [[0015-decisions-in-project-claude-md]]: the everyday case is the skill change
  made *without* any skill invocation.
- A `PreToolUse` hook on `Bash(git commit *)`. It stops at the commit and names
  the reason — mechanically, rather than as context that can be skimmed past.

A hook may eventually come from the plugin as well: it *names* the skill instead
of referencing it, and runs into nothing rather than into an error when the
target repo does not have it. That is the only wiring that does not violate the
lock above.

## Addendum: permanent, not postponed

The text above lists the plugin version as expensive but in principle still open
— "still sits behind 1.1". That no longer holds. **Skills that reconcile derived
documents stay repo-local**, as a rule and not as an interim state.

**Why that is a clarification and not a tightening:** what was expensive was
never the file, it was the source list — and that is repo-specific, because it
describes *what* the given repo documents. A plugin version would have to obtain
it from the target repo and would then be a frame whose only load-bearing part
still comes into being by hand, per repo. The saving would be a few dozen lines
of frame, paid for with an indirection that wants configuring in every repo.

**The consequence for `TODOS.md`:** entry 2.1 is done and struck without
replacement — no follow-up entry "lift it into the plugin" comes into being. A
rejected path belongs here, not in the open work. Entry 1.1 therefore no longer
blocks anything in this chain.

**Remaining gap:** the skill watches `plugin/skills/`, not itself. Adding itself
to the README is manual work. That is intended — the alternative would be a
second source list for a single event.
