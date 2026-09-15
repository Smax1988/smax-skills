# Skill texts are English, output stays in the reader's language

The text of a `SKILL.md` — instructions, headings, tables, comments — is
**English**. That holds for every new skill and for every existing one that gets
substantial work done on it.

**Why:** a skill is loaded into context in full on every invocation. German prose
runs at roughly 2.8 to 3.2 characters per token, English at about 4 — so the same
content needs roughly **a third more context** in German, every time. For
`sync-plugin-docs` that is ~5,000 tokens instead of ~3,300 per run, and the skill
runs before every commit that touches `plugin/skills/`.

**The boundary that must not slip: output is not instruction.** What a skill
*produces* follows whoever reads it, not this rule:

- `proad-job-report` produces a German work report that ends up on a customer's
  invoice.
- `css-review` and `dsgvo-audit` report to Austrian customers (both live in the
  internal `cnx` plugin since [[0025-company-skills-in-separate-plugin]]).
- `whats-for-lunch` and `find-beer-deals` work in a German-speaking context.
- `domain-modeling` writes German blocks into other projects' `CLAUDE.md` files —
  that is output, not skill text.

The glossary block in the project's `CLAUDE.md` already draws the same boundary
for code: *"Deutsch steht nur in Strings, die ein Mensch am Bildschirm sieht."*
Translating a skill and flipping its output language along with it applies the
rule backwards.

**Who the reader is decides — and it is not always a human.** `handoff` and
`replicate` write documents whose reader is almost always a fresh session, not a
colleague: the handoff exists to be fed back into an agent, the replicate recipe
is machine steps for the same person who ran them. Their document templates are
therefore **English**, decided on 04.08.2026 when the eight German skills were
translated. That is not an exception to the rule above, it is the rule applied:
a German-speaking human reads English fine, an agent pays tokens for German. The
list above stays as it is — those outputs land in front of a customer or in a
German-speaking everyday context, and that is what keeps them German.

**Not governed: the language of other documents.** This decision settles skill
text against output, and its argument is the context paid for anew on every
invocation. Neither reaches a document that is read once, when looked up. What
language `docs/decisions/`, specs, plans or `README.md` carry does not follow
from this — for Decision files that is settled by
[[0023-decision-files-in-english]].

**Where the rule lives — and explicitly where not.** The obvious place would be
`smax:writing-skills`. That does not work here: in this repo skills come into
being and change almost always through the regular route — `brainstorming`,
`writing-specs`, `writing-plans`, SDD — and not through `writing-skills`. A rule
that lives only there is never read in the normal case. Same insight as in
[[0015-decisions-in-project-claude-md]]: it belongs in this Decision and in one
sentence in the project's `CLAUDE.md`, not in a skill that rarely runs.

**Was not part of this decision:** translating the eight then-German skills after
the fact. Together they came to about 3,760 words out of some 35,000 in the repo,
they are never loaded together, and the saving per invocation is in the low
hundreds of tokens — which is why it stood as its own, deliberately low-priority
item in `TODOS.md`. It was done in one pass on 04.08.2026 anyway; the item is
gone.
