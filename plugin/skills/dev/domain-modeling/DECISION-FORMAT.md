# Decision Format

Decisions live in `docs/decisions/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc.

Create the `docs/decisions/` directory lazily — only when the first Decision is needed.

## Language

**The slug and the prose are English.** Both, in every project — including
projects whose specs, plans and README are written in another language, and
including projects where the conversation that produced the Decision was held
in another language.

Two reasons. A Decision is closer to a rule the tooling consumes than to a
document somebody reads front to back, and skill texts are English and cite
Decisions by filename — a reader walking from an English skill text into a
non-English argument changes language in the middle of one thought.

**The slug is the index**, so it has to survive being read on its own: translate
the title, then drop filler words, but keep whatever contrast carries the
meaning. `0007-reviewer-one-shot-and-unnamed` still says what it decided;
`0007-reviewer-dispatch` does not.

**This does not touch the project's other documents.** Specs, plans, README and
glossary stay in whatever language the work is discussed in. If the project
keeps a glossary with English code names next to its terms, use the code name in
the Decision text — not your own translation of the term, and not a third name.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

That's it. A Decision can be a single paragraph. The value is in recording *that* a decision was made and *why* — not in filling out sections.

## Optional sections

Only include these when they add genuine value. Most Decisions won't need them.

- **Status** frontmatter (`proposed | accepted | deprecated | superseded by Decision-NNNN`) — useful when decisions are revisited
- **Considered Options** — only when the rejected alternatives are worth remembering
- **Consequences** — only when non-obvious downstream effects need to be called out

## Numbering

Scan `docs/decisions/` for the highest existing number and increment by one.

## When to offer a Decision

All three of these must be true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it — you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."

### What qualifies

- **Architectural shape.** "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth provider, deployment target. Not every library — just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "We're using manual SQL instead of an ORM because X." Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code.** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **Rejected alternatives when the rejection is non-obvious.** If you considered GraphQL and picked REST for subtle reasons, record it — otherwise someone will suggest GraphQL again in six months.
