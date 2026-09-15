# The domain model introduced as a cross-cutting concern

Superpowers 6.2.0 knows neither `CONTEXT.md` nor glossary, ubiquitous language
or domain modelling — a full-text search across `skills/` returns nothing. This
repo introduces `smax:domain-modeling` as a cross-cutting skill that maintains a
`CONTEXT.md` and wires itself into the project's `CLAUDE.md`.

The skill itself is not this repo's invention: it comes from
`mattpocock/skills` (MIT), where it is a standalone skill. What is decided here
is its role — cross-cutting, called from five places in the chain — and the
`CLAUDE.md` wiring that makes the glossary reach a session that invokes no
skill at all. See `plugin/NOTICE.md` §2 for what was rebuilt.

**Why:** without binding terms, naming drifts apart between spec, plan,
implementation and review — every stage invents its own translation. The
glossary is the one file read by four separate mechanisms: the naming check in
`code-reviewer`, the terminology line in Global Constraints, the `CONTEXT.md`
excerpt in the SDD dispatch, and the `CLAUDE.md` import.

**That is why the glossary trigger is a HARD GATE, not an offer.** The first
end-to-end test ran straight into the soft variant: the condition "if this turns
into real modelling work" was read as "some other time", the terms ended up as a
table inside the spec document, a `CONTEXT.md` never came into being — and all
four attachment points led nowhere. A single resolved term is now enough to fire
it, and a term table in the spec is a reviewer issue.

**Two traps are documented by name**, because both fail silently. An
`@CONTEXT.md` inside `./.claude/CLAUDE.md` points at `.claude/CONTEXT.md` —
imports resolve relative to the importing file, not to the working directory.
And an import inside a code fence is inert, because import parsing skips fences.
Neither reports anything.

See [[0005-decisions-with-four-read-sites]] for the second half of the model.
