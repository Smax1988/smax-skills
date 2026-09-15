# Decision files are written in English — filenames and bodies

Files under `docs/decisions/` carry an English slug and English prose. The
numbers stay; only the language changes. This file is the first one written that
way and the precedent for the rest.

**Why.** Two reasons, and the second is the one that decides it.

The weaker one is consistency: `CLAUDE.md` commits this project to English code
— identifiers, types, filenames, comments — and a Decision is closer to a rule
the tooling consumes than to a document somebody reads front to back.

The one that actually decides it is **who follows the pointer.** Skill texts are
English ([[0021-skill-texts-english-output-reader-language]]) and they cite Decisions
by filename, spelled out rather than linked, because skills have to work from a
cold start ([[0016-skills-are-cold-start-capable]]). A reader — human or model —
walking from an English skill text into a German argument changes language in
the middle of one thought, and the filename it just read was German too. Making
the target English closes that seam.

**[[0021-skill-texts-english-output-reader-language]] does not settle this, in either
direction.** Its argument is context cost: a skill text is loaded in full on
every invocation, and German runs roughly a third more tokens for the same
content. A Decision is read once, by whoever follows a citation — the cost
argument does not reach it. Its boundary clause, *output is not instruction*,
does not reach it either: a Decision is neither of those. `0021` is silent here.
This file fills the gap; it overrides nothing.

## What stays German

`CONTEXT.md`, `TODOS.md`, `README.md`, and the documents under `docs/01_Specs/`
and `docs/02_Plans/`.

**The line is looked-up versus read-through.** A Decision is consulted: someone
arrives from a citation, reads one file, and leaves. A spec or a plan is worked
through from the top, in the language the work is discussed in. Moving those to
English would buy nothing and cost the vocabulary the design conversations
actually use.

The glossary is the hinge that makes the split work: every canonical German term
in `CONTEXT.md` carries its English code name in backticks, so an English
Decision has a settled word for every concept a German spec names
([[0022-english-terms-stay-english]] decides which form each term
takes).

## The existing files were pulled across in one sweep

Twenty-two Decisions carried German slugs and German prose, and every citation of
them — in skill texts, in specs and plans — moved with the name. Rename,
translation and citations ran as **one pass**, so that no file ever stood there
with an English name and a German body.

The timing was the constrained part. `PLAN-SyncPluginDocs` cites seven Decisions
by filename in its `Global Constraints`, and
`smax:subagent-driven-development` hands that block verbatim to every task
reviewer — renaming while the plan is being executed would point all of them at
files that no longer exist. The sweep therefore ran *before* execution, with the
plan's own citations pulled across in the same pass, rather than after: there is
no later window that is any safer, only a later one.

Numbers are unchanged. `0001` got one substantive correction along the way — its
slug said "not a dependency", its heading said "not wired in as a plugin"; the
heading now follows the slug, since the argument runs on the dependency
throughout.

## Where the rule has to live

Not here. A Decision in this repo binds this repo; the rule has to hold wherever
`smax:domain-modeling` writes a Decision, which is every repo the plugin reaches.
It therefore belongs in `plugin/skills/dev/domain-modeling/DECISION-FORMAT.md`,
spelled out rather than as a pointer back to this file — that skill has to work
without reading anything here ([[0016-skills-are-cold-start-capable]]).

This file holds the reasoning, because this is where the plugin is developed.

## It exports an English convention into German repos, and that is intended

The rule ships with the plugin, so it reaches the customer repos —
repos whose specs, plans and README are German throughout. Their Decisions will
be English anyway.

That is the same line `CLAUDE.md` already draws for code: identifiers, types,
filenames and comments are English, German only in strings a human reads off a
screen. A Decision is on the identifier side of that line, not the string side.
Writing it down here matters because the alternative looks so reasonable from
inside such a repo — "everything else in `docs/` is German, so this should be
too" — that the next run would quietly turn it back.

The rule holds for Decisions written **from now on**. Renaming what those repos
already have is a separate job per repo, decided there, not implied here.
