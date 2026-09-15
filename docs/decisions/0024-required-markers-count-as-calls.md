# `REQUIRED SUB-SKILL:` and `REQUIRED BACKGROUND:` both count as calls

The glossary defines a *Aufruf* (`Call`) as one skill invoking another — as
`smax:<name>` or as a resolved path into one of its files — and says a bare
mention of the name is not one. Two markers used across this repo sit between
those two poles, and neither the glossary nor
[[0017-reviewer-template-as-resolved-path]] said which side they fall on:

- `**REQUIRED SUB-SKILL:** Use smax:<name>`
- `**REQUIRED BACKGROUND:** You MUST understand smax:<name>`

**Both count.** They put four rows into README §5 *Wer ruft wen* —
`writing-plans` → `subagent-driven-development`, `writing-plans` →
`executing-plans`, `executing-plans` → `finishing-a-development-branch`, and
`writing-skills` → `test-driven-development` — and those rows ship. Without
this file their justification would live only in a scratch directory that does
not survive landing.

## Why `REQUIRED SUB-SKILL:` counts

It is this project's own spelling for a handoff, taught as the good form in
`plugin/skills/dev/writing-skills/SKILL.md:168`. A construct the repo teaches as
the way to hand work to another skill cannot then be read as a mention.

The construct stands in exactly two skills — `executing-plans/SKILL.md:37` and
`writing-plans/SKILL.md:347` and `:351` — three occurrences of the same marker,
each naming a different skill, all three outside any code fence. No property
distinguishes one occurrence from another, so counting one and not the others
was never defensible; the only open question was whether to count all of them
or none.

## Why `REQUIRED BACKGROUND:` counts

README §4 *Läuft ohnehin von selbst* already lists `test-driven-development` as
something the chain pulls in on the user's behalf. To carry it there as wired in
and leave it out of *Wer ruft wen* is the same contradiction stated twice in one
document.

The wording carries it too: *You MUST understand `smax:<name>` before using this
skill* makes the other skill a precondition of this one running. A reader who
follows it loads the other skill — which is what a call does.

## The two markers were decided separately

This is not one blanket rule about bold `REQUIRED` prefixes. The wording of the
two differs in what it asks for — *Use* against *You MUST understand* — and each
was weighed on its own evidence: the first on the repo's own style guidance, the
second on an existing README claim. They came out the same way; they were not
assumed to.

Whoever finds a third such marker decides it on its own merits, not by analogy
to these two.

## Delimitation: the same marker inside the plan template

`plugin/skills/dev/writing-plans/SKILL.md:93` carries `REQUIRED SUB-SKILL:` and
is **not** a call. It sits inside the ```markdown fence spanning lines 88–122 —
the header template `writing-plans` writes into every plan it generates. That is
text the skill emits, not an instruction it follows. A generated plan calling
`subagent-driven-development` says nothing about `writing-plans` calling it.

The line holds under either answer above, which is why it is recorded here rather
than left to be re-derived: the fence is the whole difference, and a survey run
with `grep` alone does not see it.

## What this does not change

A sweep for `REQUIRED BACKGROUND:` across the repo moves no further row. Four
occurrences, all under `writing-skills`: `SKILL.md:169` is a style-guide example
inside backticks, and the three real ones — `SKILL.md:18`, `SKILL.md:194` and
`testing-skills-with-subagents.md:13` — all target `test-driven-development`,
which the row already covers.

The satellite hit is worth noting on its own: a call is a call wherever in the
skill's directory it stands, and `testing-skills-with-subagents.md` is where this
one shows up. That is the same widening `sync-plugin-docs` applies when it diffs
a whole skill directory rather than its `SKILL.md`.

## Consequence for `sync-plugin-docs`

*Wer ruft wen* has calls as its source, so the skill writes that table silently
([[0019-write-sourced-present-the-rest]]). Which text counts as a call therefore
decides what gets written without asking — and a rule that lives only in a
session transcript cannot decide anything. That is the reason this is a Decision
and not a note.
