# Our own doc convention instead of `docs/superpowers/plans/`

Superpowers files plans under `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`
and knows no other doc structure (`skills/writing-plans/SKILL.md`, line 18).
This repo wires four numbered directories instead: `docs/00_Analysis/`,
`docs/01_Specs/`, `docs/02_Plans/`, `docs/03_DbChanges/` — each with a
PascalCase topic slug and a date suffix
(`docs/01_Specs/<Slug>/SPEC-<Slug>-DDMMYYYY.md`).

**Why:** the convention already existed in the projects, and a plugin that
brings its own filing locations creates two competing doc trees. The numbering
keeps the phases in reading order; the topic slug keeps analysis, spec and plan
for one topic together.

**The date suffix is functional, not decorative:** it stops a second run from
overwriting the first, and it keeps the SDD workspace path derived from it
unique per run. Anyone who reads it as decoration and removes it breaks
workspace isolation.

**The slug is fixed once, in `smax:writing-specs`**, and carried forward
unchanged by every downstream skill. Deriving it again would be the obvious
wrong alternative — it produces two spellings for the same topic.
