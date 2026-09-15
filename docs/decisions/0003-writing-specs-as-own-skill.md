# `writing-specs` split out into a skill of its own

In superpowers, writing and reviewing the spec document are steps 6–9 of
`skills/brainstorming/SKILL.md`. Here they have become a standalone skill,
`smax:writing-specs`, with three entry points feeding into it: `brainstorming`,
`sharpen-me` and `sharpen-with-docs`.

**Why:** the tail was needed three times over and existed only once. Without the
split, the two sharpen entry points would have had to either duplicate the
document part or call `brainstorming` along with its whole exploration phase.

**Consequence:** the calling skill names the document type (ANALYSIS or SPEC) in
its own closing question; `writing-specs` takes it from there and only decides
for itself when invoked cold. Asking twice was the observed failure, not a
theoretical one.

`writing-specs/spec-document-reviewer-prompt.md` comes from
`skills/brainstorming/spec-document-reviewer-prompt.md` and is taken over almost
verbatim — the skill around it is newly written.
