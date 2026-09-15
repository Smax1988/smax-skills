---
name: sync-plugin-docs
description: Checks whether README.md and plugin/NOTICE.md still match the skill inventory after changes under plugin/skills/, and brings them up to date. Use before committing whenever something under plugin/skills/ or plugin/.claude-plugin/ has changed.
---

# Sync Plugin Docs

`README.md` and `plugin/NOTICE.md` are derived from the skill inventory. Change a
skill without updating them and the documentation is silently wrong: no error, no
warning, just a false statement.

This skill answers **one** question: *does this change need a documentation
update?* Not: *is the documentation up to date?* That difference is the entire
reason it is cheap enough to run before every commit.

Your report is written in German — **including every text you propose** for
`README.md` or `plugin/NOTICE.md`. Both land in German documents and are read by
their author. The instructions you are reading are English; nothing you emit is
(`docs/decisions/0021-skill-texts-english-output-reader-language.md`).

## 1 · Comparison base

```bash
git rev-parse --abbrev-ref HEAD
```

| Situation | Base | Coverage |
|---|---|---|
| Branch other than `main`, with its own commits | `git merge-base main HEAD` | **complete** |
| On `main`, or a branch without own commits | newest commit up to and including `HEAD` that touched `README.md` or `plugin/NOTICE.md` | **partial** |

```bash
# case 1
git merge-base main HEAD
# case 2
git log -1 --format=%H -- README.md plugin/NOTICE.md
```

Both print the full 40-character hash. Abbreviate it before it goes into the
report — the first seven characters, or `git rev-parse --short <sha>`.

Uncommitted changes are included in **both** cases — they are what you are
checking before a commit.

**The first line of the report is fixed text. Write it verbatim, in German:**

```
Basis: merge-base main HEAD = <sha> (Branch-Basis — vollständig)
Basis: <sha> (Sweep seit letzter README/NOTICE-Pflege — unvollständig)
```

Fixed, because the coverage marker is the whole countermeasure to the blind spot
below. A run that paraphrases it — „ungefähr seit dem letzten Commit" — costs
the reader the one thing the line exists to carry, and nobody notices, because
a line is still there.

**The sweep base has a known blind spot.** A cosmetic edit to `README.md` or
`plugin/NOTICE.md` — a typo, a reformat — resets the window and hides everything
before it. This is decided and stays
(`docs/decisions/0020-sweep-baseline-keeps-blind-spot.md`). **Do not
close it.** No state file, no commit marker, no full comparison. The
countermeasure is visibility: the first line of the report names the base *and*
its coverage.

## 2 · Affected skills

```bash
git diff --stat <base> -- plugin/skills/ plugin/.claude-plugin/
git status --porcelain -- plugin/skills/ plugin/.claude-plugin/
```

Nothing? Report the base, its coverage, and „Nichts zu tun." Then stop. Nothing
precedes the base line — no lead-in sentence summarising what you checked.

**Emit that report anyway.** Silence reads as „it did not run", and that
uncertainty is what this skill exists to remove.

Something changed? Then **two** questions are open, not one, and they have
different triggers. The two steps below answer them, in this order. Run both.

### NOTICE first — the trigger is *which file* changed

Not which hunk. Every changed file under `plugin/skills/` gets its bucket looked
up, whatever the diff did inside it. Collect the paths:

```bash
git diff --name-only <base> -- plugin/skills/
git status --porcelain -- plugin/skills/
```

Then one lookup per path. NOTICE lists paths **relative to
`plugin/skills/dev/`**, so strip that prefix first — for a `personal` skill
strip only `plugin/skills/`, because NOTICE keeps that prefix. Search for the
stripped path alongside the section and bucket headings:

```bash
# <stripped> = the path minus plugin/skills/dev/ , e.g. debugging/SKILL.md
grep -n '^## \|^### \|<stripped>' plugin/NOTICE.md
```

**A bucket name alone is not an address.** NOTICE carries one section per
upstream — `## 1 · superpowers`, `## 2 · mattpocock/skills` — and each repeats
the same three bucket headings. The last `###` above the hit gives the bucket,
the last `##` above *that* gives the upstream, and only the pair identifies
where the file sits. Report both: *„NOTICE §2 mattpocock → Substanziell
umgebaut"*. Naming the bucket alone points at two places at once.

**That one bucket, and no other, goes into the report under *Gemeldet*.** Files
you did not change are not your subject, however close their rows sit. Whether
the classification still holds is the user's judgement, so report it and do not
rewrite it (`docs/decisions/0019-write-sourced-present-the-rest.md`).

**A drift number only exists for NOTICE §1.** Those files came in through the
import commit, so:

```bash
git diff --numstat c1e7d9e -- <full path>   # NOTICE §1 files only
```

**No second ref in that command.** `c1e7d9e HEAD` would measure import against
the last commit — and this skill runs *before* the commit, so the very change
you are reporting on sits in the worktree and would be left out. On a borderline
reclassification those are the lines that decide.

**And say what the number measures: drift since the import, not distance from
the upstream.** The import commit already carried the `smax:` adaptations, so
the two differ — NOTICE §1 names both measurements and says the bucket follows
the second one. Never present a `numstat` as though it settled a
reclassification.

**NOTICE §2 files have no import commit at all** — they predate it. There is no
cheap local measurement for them; the comparison needs a clone, and this skill
does not clone. Report the bucket, name the file, and stop there.

No hit at all means no entry exists — the one case `grep` structurally cannot
show you. §5 says what to do with it, and with a deleted skill; read §5 whenever
a changed path is new or gone.

### README second — the trigger is *which hunk* changed

Here, and only here, does the kind of edit decide. Per affected skill, look at
the **frontmatter diff and the body diff separately**:

```bash
git diff <base> -- plugin/skills/<group>/<name>/
```

They feed different sources, and conflating them is how the wrong column moves.
`argument-hint:` and `description:` sit three lines apart and drive two columns
in two different sections.

**The diff covers the whole skill directory, not its `SKILL.md` alone.**
Frontmatter exists in `SKILL.md` and nowhere else, so the split above is
unaffected: everything a satellite file beside it contributes counts as **body**.
And a call is a call wherever in the directory it stands —
`writing-skills/testing-skills-with-subagents.md` carries one. Narrow the command
to `SKILL.md` and a call added next door produces no hunk at all: the file is
still listed under *Betroffen* and still gets its NOTICE bucket, while
Wer-ruft-wen is never checked.

**`plugin/.claude-plugin/` belongs to no skill**, so no per-skill diff reaches
it. It gets its own, and §2 already told you whether there is anything to see:

```bash
git diff <base> -- plugin/.claude-plugin/
```

| Diff hunk | Sources it can touch in `README.md` |
|---|---|
| `name:` | every occurrence of the name |
| `argument-hint:` | §5 column *Argumente* |
| `description:` | §2.1 column „wofür" |
| `disable-model-invocation:` | §5 column *Trigger*; §2.1 / §2.2 membership; §4 *Geht gar nicht per Modell* |
| body — a call added or removed | §5 Wer-ruft-wen; §2.1 / §2.2 membership; §4 *Läuft ohnehin von selbst* |
| body — anything else | **nothing** |
| directory added, deleted or renamed | the directory-based sources, plus `plugin/NOTICE.md` |
| `plugin.json` — `skills[]` | §5 group headings, §6.8 |

**Then read only the sections those sources feed.** Not the whole README.

The second-to-last row is the common case and the reason this skill is cheap
enough to run before every commit: a paragraph rewritten inside a skill body
changes no README fact at all. Reading `README.md` to establish that is the
waste this table exists to prevent. **nothing** in that row means nothing in
`README.md` — it does not retract the NOTICE finding from the step above.

## 3 · The source list

**The question is not „which section does this change touch?" but „where does
this fact come from?"**

Every fact in `README.md` and `plugin/NOTICE.md` either originates **outside**
the document — in a frontmatter field, the directory layout, a call in a skill
body, a git command — or it originates nowhere else and lives in the document
itself. Where it comes from is its **source**, and that settles both things at
once: where you look up the correct value, and whether you may write it. For two
columns the second answer depends on the value itself — see *The verbatim test*
below.

| Fact | Source | Therefore |
|---|---|---|
| A skill's name, at every occurrence | `name:` in the frontmatter | **write** |
| §5 column *Trigger* | `disable-model-invocation:` | **write** |
| §5 column *Argumente* | `argument-hint:` | **write if verbatim**, else **ask** |
| §2.1 column „wofür" | `description:` | **write if verbatim**, else **ask** |
| Whether a row exists in §5 | directory under `plugin/skills/` | **write** |
| Whether §5 holds a group table for a shipped directory, and what it is titled | `plugin/.claude-plugin/plugin.json` | **write** |
| Which §5 table a skill goes in — the `personal` case | directory under `plugin/skills/` | **write** |
| Which §5 table a skill goes in — the three `dev` subdivisions | **none** | **ask** |
| That those three subdivisions exist at all, and what they are called | **none** | **ask** |
| §5 Wer-ruft-wen | calls anywhere in the skill's directory — `SKILL.md` and its satellites | **write** |
| §2.1 membership **and the count** in its intro sentence | calls + `disable-model-invocation:` | **write** |
| §2.2 membership | the same | membership **write**, surrounding sentence **ask** |
| §4 *Läuft ohnehin von selbst*, who belongs | **none** | **ask** |
| §4 *Geht gar nicht per Modell*, who belongs | `disable-model-invocation:` | membership **write**, text **ask** |
| NOTICE: has a file left its bucket? | `git diff --numstat c1e7d9e -- <file>`, §1 only | **report** |
| NOTICE: **which** upstream section and bucket it belongs in | — | **ask** |
| NOTICE §3 *Ohne Upstream-Herkunft*, membership | **none** | **ask** |
| NOTICE §3, which of its two lists a member goes in | `git ls-tree c1e7d9e^` | **write** |
| §3 entry table | **none** | **ask** |
| §1 prose, §4 judgements, the satellite paragraphs, §6.x | **none** | **ask** |

### The verbatim test

Two columns **render** their source value instead of copying it. Which verdict
applies is therefore a property of the data, not a judgement — so look:

```bash
git show <base>:plugin/skills/<group>/<name>/SKILL.md | grep '^argument-hint:'
```

Compare that against what stands in `README.md` **today**.

- **Identical** → the column has been tracking the raw value. Substitute the new
  one silently.
- **Different** → the deviation is the author's, and so is its successor.
  `teach` carries `argument-hint: "What would you like to learn about?"` while §5
  shows `` `[Thema]` ``. That shortening exists nowhere outside the README, and
  no rule derives it. Put old and new side by side.

For §2.1 „wofür" the test comes out *different* nearly every time — the column
holds a German one-liner while several `description:` fields are long English
trigger lists. That is the expected outcome, not a failure of the test.

**A brand-new row has nothing to compare against.** Create the row — that it
exists at all, and the count in the intro sentence, have a source — but put the
*contents* of these two columns up for confirmation. There is nothing to render
from except your own paraphrase, and a paraphrase is authored text.

**Why a test rather than a flat verdict.** Flat **write** would have you paste
`"What would you like to learn about?"` into a narrow table column and call it
derived. Flat **ask** would stop for a question on `md-to-pdf`, whose column has
always held the raw string, where the change is a pure substitution. The test
decides by looking rather than by judging — the same standard every other row of
this table meets.

### Two things about §5 that look like one

**Whether a group table exists has a source; how `dev` is carved up is not.**
`plugin.json` names the shipped directories — today `./skills/dev` and
`./skills/personal`. A new entry there means §5 needs a new heading, and the
heading is named after the directory: substitution.

The three `dev` tables — *Workflow-Kette*, *Denken & Doku*, *Kunden- &
Web-Aufgaben* — appear in `plugin.json` nowhere. That they exist, what they are
called, and which one a new skill belongs in are three README-internal decisions
with no source outside the file. All three are **ask**.

`personal` is the contrast that makes the rule visible: one shipped directory,
one table, membership settled by where the directory sits. **Write.**

### §4 *Läuft ohnehin von selbst* has no source, despite appearances

„Is the skill called?" looks like one and is not — it is necessary, not
sufficient. `commitMessage` is called by `writing-plans` and by
`finishing-a-development-branch`, and is deliberately absent from that list:
the list names skills the chain pulls in *on your behalf*, not every skill with
an incoming call. That distinction is recorded in the README and nowhere else.
Ask.

Only *Geht gar nicht per Modell* follows from frontmatter.

**Why there is no „change type → section" table here.** Such a table would be
this source list applied to today's section layout and cached. Its inputs — §2,
§4, §5 — you read anyway, so it saves almost nothing, and it goes stale with
every reorganisation. The source does not: `argument-hint` feeds the *Argumente*
column no matter which section or line holds it.

## 4 · The traps

Ten places where the obvious reading is wrong.

1. **§2.1 does not list all commands, only the standalone ones.** The repo has
   fifteen commands; §2.1 lists eleven. The criterion is in the section's own intro
   sentence: *„rufen keinen Skill und werden von keinem gerufen"*. The other four
   are chain commands and live in §2.2. **Fourteen is a frontmatter count, not a
   body-wide `grep -rl "disable-model-invocation: true"`** — that pattern also
   matches `writing-plans` and `writing-specs`, which mention the flag in prose
   without carrying it themselves.
2. **A call can appear as a resolved path.** `finishing-a-development-branch`
   dispatches `../code-review/code-reviewer.md` and thereby calls `code-review`
   without ever writing `smax:code-review`
   (`docs/decisions/0017-reviewer-template-as-resolved-path.md`).
   Searching only for `smax:` misses these systematically. Where such a call has
   been recorded, Wer-ruft-wen marks it „(als Pfad)" — but the absence of that
   marker proves nothing, because the rows that are missing it are exactly the
   ones nobody found.
3. **A mention is not a call.** `md-to-pdf` names `smax:handoff` and
   `smax:replicate` as cross-references („dieselbe Regel gilt für…"). A hit on
   `smax:<name>` only proves the name occurs.
4. **Being called does not put a skill into §4 *Läuft ohnehin von selbst*.**
   `commitMessage` is called by two skills and is not in that list. The list
   names what the chain pulls in on the user's behalf; the judgement behind it
   lives in the README. Only *Geht gar nicht per Modell* follows from
   `disable-model-invocation`.
5. **A new call can evict a command from §2.1.** If any skill starts calling a
   standalone command, it stops being standalone: it moves to §2.2 and the count
   in the intro sentence changes — without anyone touching its frontmatter.
6. **NOTICE classifies files, not skills — with two exceptions.**
   `debugging/SKILL.md` sits under *Substanziell umgebaut*,
   `debugging/defense-in-depth.md` under *Unverändert übernommen*. The exceptions
   are NOTICE §3 *Ohne Upstream-Herkunft*, which lists skills, and *Nicht
   übernommen*,
   which is mixed prose — skills, whole directories and files side by side, and
   which exists **once per upstream section**.
7. **Inside NOTICE §3 a different spelling applies**, not the „Pfade relativ zu
   `plugin/skills/dev/`" of the upstream sections: dev skills appear as a bare
   name (`mail-draft`), personal ones with a prefix (`personal/whats-for-lunch`).
8. **Renaming is a token substitution and stays silent — except in the chain
   diagram in §1.1.** Its boxes are aligned by character width; a longer name
   breaks the lines. The substitution is mechanical, the realignment is not.
9. **§5 may contain tables that are none of your business.** The group tables
   list plugin skills from `plugin/skills/<group>/`. Any table whose skills do
   **not** live under `plugin/skills/` sits outside every source in this list —
   the repo-local table is one such. Never add, change or remove a row there.
   **`plugin.json` settles which *directories* are shipped, and nothing beyond
   that.** How `dev` is carved into three tables it does not say, and a table
   whose skills live outside `plugin/skills/` it does not know at all — so the
   number of headings under §5 is not a number `plugin.json` can be counted
   against.
10. **A NOTICE bucket name names two places, not one.** `plugin/NOTICE.md` has
    one section per upstream, and each carries the same three bucket headings.
    „Steht unter *Substanziell umgebaut*" is therefore not an answer — the
    upstream belongs in front of it. The trap is that a `grep` for the heading
    returns two hits and both look right.

**Address the two satellite paragraphs at the end of §5 by their subject, never
by line number** — one names the callers of `domain-modeling`, the other the
`.slnx` condition of `sync-solution-items`. Any insertion above shifts both.

## 5 · NOTICE: files, not skills

`debugging/SKILL.md` sits under *Substanziell umgebaut*,
`debugging/defense-in-depth.md` under *Unverändert übernommen*. Search at skill
level and you will present the wrong bucket every time.

| Section | Bucket | Unit |
|---|---|---|
| NOTICE §1, §2 | *Unverändert übernommen* | file |
| NOTICE §1, §2 | *Übernommen, punktuell ergänzt* | file |
| NOTICE §1, §2 | *Substanziell umgebaut* | file |
| NOTICE §1 | *Eingefrorene Kopie externer Dokumentation* | file (exactly one, as prose) |
| NOTICE §1, §2 | *Nicht übernommen* | mixed, prose |
| NOTICE §3 | *Ohne Upstream-Herkunft* | **skill**, in two prose name lists |

**Every bucket except the last two exists twice** — once under `## 1 ·
superpowers`, once under `## 2 · mattpocock/skills`. An address is the pair, and
the report carries the pair.

**A file changed → check its own bucket, and only its own.**

Mind the spelling before you search: NOTICE §1 and §2 list paths **relative to
`plugin/skills/dev/`**. The file git calls `plugin/skills/dev/debugging/SKILL.md`
stands there as `debugging/SKILL.md`. Strip the prefix, or you will find nothing
and report every changed file as an entry that is missing.

Whether the classification still holds is a judgement: report it, do not rewrite
it.

**A new skill → its entry is missing, and only you can see that.** `grep` cannot:
a name that appears nowhere produces no hit. Report the gap and propose *NOTICE
§3 Ohne Upstream-Herkunft → Danach entstanden* — but a newly vendored upstream
skill does not belong there, so the section is the user's call. **Both upstreams
are candidates**, and a rename at import hides which one: that is how five
`mattpocock` skills sat in NOTICE §3 from its first day until it was corrected,
and why that section carries the warning. Mind the spelling: dev skills bare, personal ones with a `personal/`
prefix.

**A deleted skill → remove every row for its files, and put its name in the
NOTICE §3 *Ohne Upstream-Herkunft* list up for confirmation.** Two facts, two
verdicts, and the source list in §3 above already settled both. That rows exist
for those files comes from the directory layout, and the directory now says the
files are gone: **write**. Membership in NOTICE §3 is **ask** there, and this
section does not overrule it — the name goes under *Zu übernehmen* with `alt:`
and `neu:`, it does not quietly
leave the file. That list is prose, not a table; there is no row to delete, which
is exactly why the case gets missed.

**A rename runs the other way.** The spelling has a source — `name:` in the
frontmatter — so the file rows *and* the name in the prose list are rewritten
silently. Renamed is written, deleted is presented; the difference is not how big
the edit looks, it is whether anything outside the document says what the new
state should be.

## 6 · The safety net

In addition to every source:

```bash
grep -n "<skillname>" README.md plugin/NOTICE.md
```

The source list says where a fact comes from; `grep` finds the places it turns up
where nobody thought to look.

**Search the token that is actually in the documents, not the one you have in
mind.** Two changes move it:

- **A rename.** The new name has no hits yet — the old one carries every single
  one. Search **both**, or the field comes back empty from a change that touches
  a dozen lines.
- **A directory or group change.** The group name carries hits the skill name
  never touches — §5 headings, the paths in `plugin/NOTICE.md`, §6.8. Search it
  **as well**.

**The net has two structural gaps.** Both follow from `grep` counting occurrences
rather than checking statements:

1. **It cannot find what is missing.** A new skill appears nowhere and produces
   no hit. For every place a new skill *must* appear the safety net catches
   nothing — it has to be reached through its source.
2. **It cannot find what is wrong.** A name sitting where it no longer belongs —
   a call that was removed, a classification that has flipped — produces a hit and
   no hint that the hit is stale. That is why Wer-ruft-wen is checked through its
   source and not through `grep`.

Where the output of this search goes is not left to you: wherever an affected
skill exists, `## Report` carries it as the `Sicherheitsnetz:` field, and a
report missing it there is incomplete. The report contract below names the two
cases where the field does not apply.

## 7 · Writing versus asking

Three verdicts, and the source list assigns every fact exactly one:

- **Has a source** → write it silently, list it under *Geschrieben*.
- **No source** → draft it in full, then put old and new side by side under
  *Zu übernehmen* and get a yes. **Never write it silently.**
- **Findable but not derivable** → name it under *Gemeldet* and stop there. No
  draft, because there is nothing to derive one from.

The line is the source, not „table versus prose" and not „can I prove it".
Those two sound right and cannot be decided in the moment; „which file is the
source?" can. Two cases where the other two go wrong:

- The count in §2.1 („Diese **zehn** rufen keinen Skill…") sits in the middle of
  prose and is **written silently** — its source is frontmatter plus calls.
- Which of the three `dev` groups a new skill belongs to sits in a **table** and
  is nevertheless **asked** — that classification exists only in the README.

**The verbatim test is not an exception to this rule but an instance of it.**
For the two rendering columns the source is known; what is open is whether the
column ever carried the raw value. Two strings settle that. You are not judging
whether a change is small enough to slip through — you are looking up a fact,
same as everywhere else in this skill.

No source means the fact lives in the very document you are editing. There is
nothing to look up there, only something to decide, and deciding is the author's
job. `docs/decisions/0019-write-sourced-present-the-rest.md` records
this.

### The *Therefore* column names the report section

Each verdict has a fixed place; **ask** splits by whether the change hands
you the new value. Nothing here is decided by taste:

| *Therefore* says | | Section | Draft in the report | File changes |
|---|---|---|---|---|
| **write** | | *Geschrieben* | — | **yes** |
| **ask** | and the change hands you the new value | *Zu übernehmen* | `alt:` and `neu:` | **no** |
| **ask** | and it does not | *Gemeldet* | **none** | **no** |
| **report** | never hands you one | *Gemeldet* | **none** | **no** |

**write if verbatim**, else **ask** is not a fifth case — the verbatim test picks
one of the rows above before you touch anything.

**The two `ask` rows are the second and third bullet at the top of this section**,
and the question that separates them is a lookup, not a judgement: *does the
change itself tell you what the new value is?*

- A **deleted** skill tells you what §4 *Verdrängt* should say — the section goes.
  You have the value → *Zu übernehmen*, with `alt:` and `neu:`.
- §5 names the proposal for a **missing NOTICE entry** — *Ohne Upstream-Herkunft
  → Danach entstanden*. You have the value → *Zu übernehmen*. That the bucket is
  ultimately the author's call is what the question mark is for, not a reason to
  demote it.
- Which of the three `dev` groups a **new** skill joins: three candidates and no
  rule. Nothing hands you a value → *Gemeldet*.
- A `grep` hit in a paragraph that restates the fact in its own words: you know
  the old wording has become doubtful, not what replaces it → *Gemeldet*.

Filing a finding you *can* draft as *Gemeldet* buries a finished proposal in the
section the author reads as „nothing to decide here". Filing one you *cannot*
draft as *Zu übernehmen* forces you to invent the value, and a guess dressed as a
proposal is worse than the gap.

Two rows of the source list carry **two** verdicts — §2.2 membership and §4
*Geht gar nicht per Modell*, both „membership write, text ask". Those findings
appear **twice**, once per section. The split is the point: the membership is
derivable, the sentence around it is not.

### *Zu übernehmen* means the file does not carry it yet

That is what the section is. The file still shows the old state, the report shows
old and new, the answer decides. A value already standing in the file is not up
for confirmation — it is written, and writing it is the one thing this section
exists to prevent.

**A new row is where this breaks.** The row itself has a source, so you create
it; one or two of its cells have none, so they go up for confirmation. The row
goes in with **those cells empty**. „Sonst ist die Tabelle unvollständig" and
„sonst trifft der Commit auf eine halbe Tabelle" are the same move with two
justifications, and both have it backwards: an empty cell is visibly unfinished
and gets filled, a cell holding your unreviewed draft reads as finished and never
gets looked at again.

`alt:` is not „what stood there before I started". **`alt:` is what stands in the
file at the moment you write the report** — for a cell you left empty,
`alt: (leer)`. If `alt:` and `neu:` come out as the same string, you wrote it.
That is not an entry under *Zu übernehmen*; that is the defect with a question
mark stapled to it.

### Before the report: read what you actually changed

```bash
git diff -U0 HEAD -- README.md plugin/NOTICE.md | grep '^@@'
```

**`HEAD` is not optional.** Without it `git diff` shows the worktree against the
*index*, and anything already staged is invisible. The trigger fires on
`git commit`, so staging is the normal state when this runs: a `README.md` the
user staged before calling you would slip past both checks below, and a `neu:`
value you staged yourself would pass the cell check as if it had never been
written.

*Geschrieben* is what you **claim** to have written. `Geändert:` is what the tree
**says** you wrote. The two are meant to agree, and the entire reason for having
both is the case where they do not.

Every hunk this prints goes into the report's `Geändert:` field, and each one has
exactly one of three fates:

- **Yours, with a verdict** → it has an entry under *Geschrieben*. Nothing to do.
- **Already there when you started** — the user's own uncommitted work → mark it
  `(vorgefunden)` and leave it alone.
- **Neither** → you wrote it without a verdict.

The third case is not a label you attach. **Undo the hunk in the file**, then put
the text under *Zu übernehmen*. „It stands under *Zu übernehmen*, so it is
declared" fixes nothing: the file is still written, and a yes would be confirming
a change that already happened. Then **run the command again** — the field
carries the tree as it stands when the report goes out, not as it stood before
you corrected it.

**A whole hunk is not fine enough.** A new table row is one line carrying two
facts: that the row exists at all (source: the directory — **write**) and what
its cells say (no source — **ask**). Listing that hunk under *Geschrieben* covers
the first and walks the second past the check. So run the other half too:

```bash
git diff HEAD -- README.md plugin/NOTICE.md | grep '^+'
```

**Not one of your `neu:` values may appear in that output.** A `neu:` you can
find in the diff is written, not proposed.

`git diff` is the only witness these two checks accept. Your own account of what
you did is not one: a run that writes a draft and then asks about it anyway
reports the asking accurately and never mentions the writing.

### Red flags — stop

- „The sentence is obviously wrong, I will just fix it."
- „It is only a wording change."
- „I will write it and mention it in the report." — Mentioning is not asking.
- „The user is waiting, a question costs them time."
- „I matched their voice, it fits."
- „I have put the draft in already so the table is not left half-finished."
- „A new row has no old value, so there is nothing I could be overwriting."
- „A *no* just means they replace it."

| Excuse | Reality |
|---|---|
| „Obviously wrong, trivial fix" | That it *is* wrong you can establish. What should stand there instead is a statement in the author's name. That is precisely what you put to them. |
| „I will write it and report it" | A report read after the fact is not consent. The question comes *before* the edit. |
| „A question costs time" | It arises for zero to one item per run. A silently reworded paragraph costs a review in which nobody looks any more. |
| „I matched the author's voice" | Then the error is undiscoverable. That is worse, not better. |
| „It is only one word" | For a rename: correct, that is a token substitution and stays silent. For anything else, „only one word" is the excuse, not the analysis. |
| „The frontmatter says it, so I copied it across" | Two columns *render* their source instead of copying it. Run the verbatim test first. A column that has always shown `` `[Thema]` `` does not want `"What would you like to learn about?"` in it. |
| „No source names this, so I will propose something" | Then propose nothing. *Gemeldet* exists for exactly this: say what you found and where, and let the author supply the value. |
| „The draft is in the file already, otherwise the table is incomplete" / „…otherwise the commit hits a half-finished table" | Then it is written, and the question mark behind it changes nothing: a yes confirms what already stands there. An honest `alt:` and your `neu:` would read identically — that is the tell. Empty cell in the file, draft in the report. |
| „A new row has no old value to leave standing" | `alt: (leer)` is the old value. The cell being empty is exactly the state you are asking permission to change. |
| „A *no* simply means replacing it instead of adding it" | You have thought the consequence through and handed it to the author anyway. Asking first is what makes a *no* cost nothing; asking after turns it into a revert they did not ask for. |
| „The value is uncertain, so *Gemeldet* is the honest place" | *Gemeldet* is for findings with **no** draft. You have one. That is **ask**, and **ask** is *Zu übernehmen*. |

## Report

First line always: the base, how it was determined, and its coverage — verbatim
in one of the two forms from section 1.

The skeleton below is for the case §2 found something. Where §2 found nothing,
its own two-line report — the base line, then „Nichts zu tun." — is already
complete; do not add a `Betroffen` line to it, and no `Sicherheitsnetz:` field
either — there is no affected skill to search for. **`Geändert:` falls away
there too**, for the same reason: you changed nothing, and a field saying so adds
a line to a report whose entire content is that there was nothing to do.

```
Basis: merge-base main HEAD = a1b2c3d (Branch-Basis — vollständig)
Betroffen: <geänderte Dateien unter plugin/, mit Pfad>
Sicherheitsnetz: <gesuchter Name> — README.md <Zeile> <Abschnitt>, <Zeile> <Abschnitt>; plugin/NOTICE.md <Zeile> <Bucket>
Geändert: README.md <Hunk>, <Hunk>; plugin/NOTICE.md <Hunk>

Geschrieben (n)
  1  <Datei> <Stelle> — <was und warum>

Gemeldet (n)
  2  <Datei> <Stelle> — <Befund, ohne Vorschlag>

Zu übernehmen (n)
  3  <Datei> <Stelle>
     alt:  <Text, wie er in diesem Moment in der Datei steht — oder (leer)>
     neu:  <Text>
     → 3 übernehmen? [j/n]
```

**Every entry carries a number, counted straight through all three sections.**
One counter per report: it starts at 1 in the first section that has an entry and
runs on across the section boundaries. An empty section is left out and consumes
no numbers. The figure in parentheses stays what it was — how many entries *this*
section holds; the leading number says which entry it is *in the run*. With
`Geschrieben (3)` and `Zu übernehmen (2)` the numbers therefore go 1-2-3 and then
4-5, and the confirmation line repeats its own: `→ 5 übernehmen? [j/n]`.

The numbers exist so an answer can name its subject — „j für 4, n für 5" instead
of „ja für alle". **Read such an answer strictly by the numbers it names**, and
treat an answer without numbers as covering every open entry only where it says
so („alle", „alles"). Otherwise ask which one is meant; a *Zu übernehmen* entry
taken over on a guess is exactly the silent write this whole skill is built to
prevent.

**After `Betroffen:`, one line per affected skill: `Sicherheitsnetz:`.** More than
one affected skill means more than one such line, in the order of `Betroffen:`.
It carries the output of the safety net (§6):

```bash
grep -n "<skillname>" README.md plugin/NOTICE.md
```

**The numbers in the field come from a final run, after your last edit.** Run the
search earlier as often as you need it to find your way; the field is filled from
the last run and no earlier one. That puts it against the same tree as
`Geändert:`, and only against the same tree are the two readable against each
other. Fill it before the edits and it names lines that have moved since; fill it
from a run partway through and it names lines you were about to change either
way.

**The name you search is the one in the documents.** After a **rename** search
the old name as well as the new — the old one carries every hit. After a
**directory or group change** search the group name too. Both go into the field,
each labelled with the name that produced it (§6).

**Where no skill is affected, the field falls away.** A change confined to
`plugin/.claude-plugin/` is the case: there is no skill name to search for, so a
`Sicherheitsnetz:` line would have to invent its own subject. Write no line
rather than an empty one — but check the group headings in §5 and §6.8 through
their source, because that is what the change touched.

Every line the search printed goes into the field, in the order it printed them,
none left out — and behind each number the section it lands in. The number comes
out of the search, the section out of looking at that line. Neither is guessable,
and that is what the field is for: a report without it is a report from a run
that did not search. The search runs **in addition to** every source in §3, never
instead of one; its two structural gaps are in §6.

**Then read the field you just wrote, hit by hit.** §3 says where the changed
fact belongs. A hit outside that, in a section that states the same fact in its
own words, is a place no source covers → *Gemeldet*, and without a draft: what
should stand there is the author's call. A hit where nothing but the bare name
stands, with nothing of the change reaching it, is uncritical — say so in one
clause and move on. What must not happen is a hit vanishing between this field
and the sections below.

**Then, once, whatever the number of affected skills: `Geändert:`.** It carries
the closing check of §7:

```bash
git diff -U0 HEAD -- README.md plugin/NOTICE.md | grep '^@@'
```

Every hunk header the command printed goes into the field, none left out, each
with its file. `Geändert: —` when it printed nothing, and that is the ordinary
outcome of a run whose findings were all **ask**. Like `Sicherheitsnetz:`, the
field is line numbers you cannot write down without having run the command — and
unlike *Geschrieben*, it is **measured** rather than claimed. The two are meant to
agree: every hunk here has an entry under *Geschrieben*, or the marker
`(vorgefunden)` for the user's own uncommitted work. A hunk that has neither is
one you wrote without a verdict; §7 says to take it back out of the file and put
it under *Zu übernehmen*, and then this field is rewritten from the corrected
tree.

**Three sections, three verdicts** — the same three the source list assigns.
*Geschrieben* is what you already changed. *Zu übernehmen* is what you drafted
and need a yes for. *Gemeldet* is the third kind, and it is not a weaker version
of the second: a finding with **no draft attached** — a `grep` hit at a place no
source names, a NOTICE bucket whose classification may no longer hold, a missing
entry whose replacement no rule names. You name it and stop there. Drafting a
value would be guessing, and a guess dressed as a proposal is worse than the gap.
**§7 fixes which verdict lands in which of the three**; which section a verdict
lands in is not a matter of taste, and the line between the last two is whether
the change hands you a value.

Leave out a section that is empty. Never leave out the first line. Never leave
out `Sicherheitsnetz:` and `Geändert:` **where they apply** — and where they do
not is named above, in two narrow cases: §2 found nothing, and then both fields
fall away; or no skill is affected, and then `Sicherheitsnetz:` alone falls away
while `Geändert:` still reports what you wrote. Outside those two, a missing
field is a run that did not search.

## Never commit

**This skill does not commit.** Not the README, not NOTICE, not anything.

The trigger fires *before* the user's commit, so your edits are carried by it
anyway. A commit of your own cuts their work in half and puts a change into the
history that nobody asked for
(`docs/decisions/0008-confirm-git-actions-outside-branch.md`).

| Excuse | Reality |
|---|---|
| „Just the README, so it does not get lost" | The user commits within the minute. Nothing gets lost. |
| „They typed `/sync-plugin-docs`, that is consent" | Consent to check is not consent to commit. |
| „`git add` is not a commit" | Staging changes the state of a tree that is not yours. Leave it alone. |
