---
name: domain-modeling
description: Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs to maintain the domain model.
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design. This is the *active* discipline — challenging terms, inventing edge-case scenarios, and writing the glossary and decisions down the moment they crystallise. (Merely *reading* `CONTEXT.md` for vocabulary is not this skill — that's a one-line habit any skill can do. This skill is for when you're changing the model, not just consuming it.)

## File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── decisions/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── decisions/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/decisions/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/decisions/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/decisions/` exists, create it when the first Decision is needed.

## A glossary nobody reads is decoration

A `CONTEXT.md` that isn't loaded into the session has no effect on the names that end up in the code. Wiring it in is part of this skill's job, not the user's homework.

**Run this check at two points:**

1. **When this skill starts.**
2. **Immediately after lazily creating a new `CONTEXT.md`.** Without this second pass every freshly created glossary stays unwired forever — and that is the common case, because the file only comes into existence once the first term is settled.

**The check:**

1. Is there a glossary — `CONTEXT.md`, or `CONTEXT-MAP.md`?
2. Is it referenced from the project's `CLAUDE.md`? Look in **both** `./CLAUDE.md` and `./.claude/CLAUDE.md`.
3. If not, add what's missing and **say what you changed.** Never edit `CLAUDE.md` silently — it's committed and team-shared.

**The block to add** — write its *content* into `CLAUDE.md`, not the surrounding code fence. Import parsing skips fenced code blocks and code spans, so an `@CONTEXT.md` that lands inside a fence is inert, and silently so.

```markdown
## Domänensprache

Die verbindlichen Begriffe dieses Projekts stehen in @CONTEXT.md.

**Verwende sie.** Im Gespräch genauso wie in Code, Bezeichnern, Commits und
Dokumentation. Wenn du etwas erklärst oder beschreibst, nimm den kanonischen
Namen, nicht ein Synonym.

**Code ist englisch.** Ausnahmslos: Bezeichner, Typen, Funktionen, Dateinamen,
Kommentare. Deutsch steht nur in Strings, die ein Mensch am Bildschirm sieht.
Ist ein kanonischer Begriff deutsch, nennt sein Glossar-Eintrag den englischen
Code-Namen in Backticks — nimm den, nicht deine eigene Übersetzung. Frage ich
„wie heißt X im Code?", steht die Antwort dort.

**Fehlt ein Code-Name, entscheiden wir einen.** Kein Begriff ist ausgenommen,
auch Produktnamen und Rechtsbegriffe nicht. Gibt es kein offensichtliches
englisches Wort, schlag mir zwei oder drei vor und trag das Gewählte ins
Glossar ein — nicht das deutsche Wort stehen lassen, nicht still selbst
übersetzen.

**Verstehe meine.** Die unter `_Avoid_` gelisteten Varianten meinen denselben
Begriff — übersetze still und antworte kanonisch. Korrigiere mich nicht bei
jeder Nennung; das gehört in eine Modellierungs-Sitzung, nicht in die
alltägliche Arbeit.

**Frag bei Unbekanntem.** Benutze ich einen Begriff, der weder kanonisch noch
unter `_Avoid_` steht, rate nicht. Sag, dass er im Glossar fehlt, und frag
nach — entweder fehlt ein Eintrag, oder wir reden von etwas Neuem.
```

The paragraphs cover cases that are easy to collapse into one: **output** (speak canonically), **code** (the canonical term is a concept, not automatically a spelling), **missing code name** (decide, don't improvise), **input** (resolve the user's synonyms silently), and **gap** (don't guess). "Verstehe meine" is the deliberate boundary against this skill itself — challenging every term is right *during* a modelling session and unbearable in everyday work. The `_Avoid_` list is a translation table, not a ban list.

"Code ist englisch" exists because the first paragraph, alone, produces `AuftragsRepository` in a German-speaking project. Without it the two commitments — *use the canonical name* and *write English code* — collide, and the model resolves the collision by inventing a translation per call site. The glossary's code name is what keeps that mapping single-valued, which is also what lets it answer "wie heißt X im Code?" — the question the user will actually ask.

The fourth paragraph closes the escape hatch. Left open, "no English equivalent exists" becomes the standing excuse for every product name and legal term, and the German identifier survives under a rationale. There is always a name; sometimes it has to be chosen rather than looked up, and choosing it is a two-minute conversation, not a blocker.

### The import path depends on where `CLAUDE.md` lives

**`@` imports resolve relative to the file containing the import, not to the working directory.** The glossary sits at the repo root, so:

| `CLAUDE.md` location | Import to write |
|---|---|
| `./CLAUDE.md` | `@CONTEXT.md` |
| `./.claude/CLAUDE.md` | `@../CONTEXT.md` |

Writing `@CONTEXT.md` into `./.claude/CLAUDE.md` points at `.claude/CONTEXT.md`, a file that does not exist. **Nothing reports this** — the import simply resolves to nothing, and the glossary looks wired while being invisible. That is the exact failure this whole check exists to prevent, so get the prefix right.

`@../CONTEXT.md` from `.claude/` resolves inside the working directory, so it does not count as an external import and triggers no approval dialog.

**When creating a `CLAUDE.md` from scratch, create `./CLAUDE.md`, not `./.claude/CLAUDE.md`** — the root file is re-read from disk and re-injected after `/compact`, which is the property the whole binding depends on, and its import needs no path prefix that a later move would break.

**Edge cases you must handle:**

- **No `CLAUDE.md` at all** → create `./CLAUDE.md` with the block and say so.
- **`CONTEXT-MAP.md` exists** → import **only the map**, not each individual `CONTEXT.md`. The map is small and names the paths; single glossaries get read on demand. Importing all of them blows out the context window. Adjust the first line to `Die verbindlichen Begriffe dieses Projekts stehen in @CONTEXT-MAP.md und den dort genannten Kontexten.` — with the same `../` prefix rule if `CLAUDE.md` sits in `.claude/`.
- **A reference already exists but is written differently** (`@./CONTEXT.md`, an absolute path, a different heading) → check for *a reference*, not an exact string match. Matching exactly produces duplicate imports.
- **A reference exists but resolves nowhere** — most often `@CONTEXT.md` in `./.claude/CLAUDE.md`. Treat that as broken, not present: fix the path. Verify by resolving it yourself against the directory of the file it sits in.
- **Import present, commitment paragraphs missing** → add only the paragraphs.
- **Block present, but without "Code ist englisch"** → an older version of this block. Add the missing paragraph; leave the rest alone.
- **`` `@CONTEXT.md` `` inside backticks is not an import.** It's inert code formatting. Treat it as absent when checking, and never write it that way.

The import makes the glossary *known*; the paragraphs make it *effective*. Both are context, not enforcement. The only hard gate lives in `smax:code-review`, whose reviewer checks naming against `CONTEXT.md` and blocks — and that only touches code, never conversation.

## A Decision nobody reads is archaeology

`docs/decisions/` has four read points inside skills: `smax:brainstorming` step 1, the reviewer in `smax:code-review`, the root-cause check in `smax:debugging`, and the Global Constraints block in `smax:writing-plans`. All four require that skill to be running, and two of them are user-only. **The everyday case — a change made without invoking any skill — reads nothing.** That is precisely how a deliberate deviation gets "fixed" back to the obvious path.

The project's `CLAUDE.md` is the only place that is in context no matter which skill runs. So the Decisions get a block there too.

**Run this check at two points:**

1. **When this skill starts** — same pass as the glossary check above.
2. **Immediately after creating the first Decision.** The directory comes into being lazily; that is the moment the block becomes necessary, and the moment it is easiest to forget.

**The check:**

1. Does `docs/decisions/` exist and hold at least one file? If not, there is nothing to wire — skip silently. Do not add the block in advance.
2. Is `docs/decisions/` referenced from `./CLAUDE.md` or `./.claude/CLAUDE.md`? Check for *a* reference, not for an exact string match.
3. If not, add the block below and **say what you changed.** Never edit `CLAUDE.md` silently — it is committed and team-shared.

<HARD-GATE>
**Never import the Decisions.** No `@docs/decisions/0001-….md`, no imported index file, not "just the important ones". An import pulls content into *every* session, which is the exact failure this block exists to prevent — and the directory grows without bound, so the cost grows with it.

The block teaches an **access pattern**, not content: `ls` first, judge by filename, open at most one or two. Its cost is a fixed dozen lines whether the project has three Decisions or three hundred.
</HARD-GATE>

Because there is no import, the `@`-path trap from the glossary section does not apply here — `docs/decisions/` is relative to the repo root and reads the same from either `CLAUDE.md` location.

**The block to add** — again the *content*, not the surrounding fence:

```markdown
## Entscheidungen

Unter `docs/decisions/` stehen die Entscheidungen, die dieses Projekt bereits
getroffen hat — je eine Datei `NNNN-slug.md`. Sie halten fest, was hier
absichtlich vom naheliegenden Weg abweicht.

**Der Dateiname ist der Index.** Sieh mit `ls docs/decisions/` nach, was es
gibt, urteile nach dem Titel und öffne nur, was zur aktuellen Aufgabe passt —
in aller Regel keine bis zwei Dateien.

**Lies nie das ganze Verzeichnis.** Es wächst unbegrenzt. Alles zu laden
verbrennt Kontext für Entscheidungen, die mit der Aufgabe nichts zu tun
haben, und verdrängt das, was tatsächlich gebraucht wird.

**Wann nachsehen:** bevor du eine Architektur- oder Designfrage entscheidest;
bevor du etwas „reparierst", das merkwürdig gebaut aussieht; wenn dich der
Aufbau einer Stelle überrascht, die du gerade änderst. Nicht bei Tippfehlern,
Formatierung oder offensichtlichen Bugfixes — dort ist schon der `ls` reine
Reibung.

**Widersprich nie still.** Läuft dein Vorschlag einer Entscheidung zuwider,
sag das mit Dateinamen, bevor du ihn umsetzt. Eine Entscheidung umzuwerfen
ist ein legitimes Ergebnis; sie zu übergehen nicht. Einträge mit Status
`superseded` oder `deprecated` binden nicht mehr.
```

**Edge cases:**

- **A reference exists but is written differently** (a sentence naming `docs/decisions/`, a different heading) → treat it as present. Matching exactly produces a duplicate block.
- **Block present, but without "Lies nie das ganze Verzeichnis"** → an older version. Add the missing paragraph; leave the rest alone. That paragraph is the one carrying the cost control.
- **No `CLAUDE.md` at all** → create `./CLAUDE.md`, not `./.claude/CLAUDE.md`, for the same reason as the glossary: the root file is re-read from disk after `/compact`.
- **Decisions live under a context directory** (`src/ordering/docs/decisions/`, per `CONTEXT-MAP.md`) → name that path in the block instead of the root one.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` should be totally devoid of implementation details. Do not treat `CONTEXT.md` as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

Never write secrets — API keys, passwords, tokens — or personal data (PII) into `CONTEXT.md` or a Decision. Both are committed and shared; if a decision hinges on such a value, name it and leave a placeholder (`<API_KEY>`).

### Offer Decisions sparingly

Only offer to create a Decision when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the Decision. Use the format in [DECISION-FORMAT.md](./DECISION-FORMAT.md).

**Filename and prose are English**, whatever language the conversation runs in — so the name you propose is English too, not a translation applied afterwards. [DECISION-FORMAT.md](./DECISION-FORMAT.md) carries the rule and the reasoning.

**Was this the project's first Decision?** Then run the `CLAUDE.md` check from *A Decision nobody reads is archaeology* right now. The directory was created lazily a moment ago, so nothing has wired it up yet — and a Decision that no session knows to look for is a file that gets written once and read never.

### Mirror new Decisions into the solution

A Decision file lands under `docs/decisions/`, which in a .NET repo is carried
as Solution Items. After writing one: does `ls *.slnx 2>/dev/null` match at the
repo root? Then invoke `smax:sync-solution-items`. Decisions are the files most
likely to be missed — created one at a time, often as a side effect of another
skill, and nobody goes looking for them in the solution afterwards. No match:
skip **silently**, do not mention it.