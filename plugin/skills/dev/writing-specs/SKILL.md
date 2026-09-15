---
name: writing-specs
description: Use when a design conversation has produced something worth writing down - turns the result of a brainstorming or sharpening session into an ANALYSIS or SPEC document under docs/, gets it reviewed, and hands off to writing-plans
---

# Writing Specs

The shared tail of every design conversation: pick the document type, write it, get it reviewed, get it approved, hand off to planning. `smax:brainstorming`, `smax:sharpen-me` and `smax:sharpen-with-docs` all end here.

**Announce at start:** "I'm using the writing-specs skill to write this up."

## 1. ANALYSIS or SPEC

| Content | Goes to |
|---|---|
| Investigation or assessment of something that exists, with no decision to build | `docs/00_Analysis/` |
| Design of something that is to be built | `docs/01_Specs/` |

**If the caller already named the type, take it — do not re-decide and do not ask again.** `smax:brainstorming`, `smax:sharpen-me` and `smax:sharpen-with-docs` name it in their closing question, and the user already answered it there. Asking twice is noise.

Only apply the table yourself when you were invoked cold — directly by the user, with no entry skill ahead of you. If the material genuinely covers both an assessment *and* a design decision, that is two documents, not one; say so and ask which to write first.

**State the full target path before creating anything**, so a wrong slug or a wrong folder is cheap to correct.

## 2. Pin the topic slug

One PascalCase slug for the whole topic (`TipAllowance`, `InvoiceExport`). **You fix it here and every downstream skill reuses it unchanged** — `smax:writing-plans` builds `docs/02_Plans/<Slug>/` from it, and the SDD workspace path derives from the plan filename. Do not re-derive it later.

```
docs/00_Analysis/<Slug>/ANALYSIS-<Slug>-DDMMYYYY.md
docs/01_Specs/<Slug>/SPEC-<Slug>-DDMMYYYY.md
```

Get the date from `date +%d%m%Y` — never guess it. The suffix is functional, not cosmetic: it keeps a second run from colliding with the first, and it keeps the derived SDD workspace path distinct.

**If the topic folder already exists, say so and ask — never decide in passing:**

> "`docs/01_Specs/TipAllowance/` already exists with `SPEC-TipAllowance-12052026.md`. Should I continue that document or start a new one for today?"

A second version is a different thing from a continuation. The date suffix prevents accidental overwriting; it does not answer this question.

**Never write into `Archive/`, and never read anything under `Archive/` as current project context.** Archiving is manual and deliberately outside every skill.

## 3. Glossary and decisions first — blocking

<HARD-GATE>
Before you write a single line of the document, check what the conversation settled and where it went.

1. **Does the material contain domain terms that were pinned down?** If yes and there is no `CONTEXT.md` (or no `CONTEXT-MAP.md`), **invoke `smax:domain-modeling` now** and get the terms into the glossary. Do not write the document first and move the terms later.
2. **Did the conversation make choices that are hard to reverse, surprising without context, and the result of a real trade-off?** Each one is a file under `docs/decisions/`, written via `smax:domain-modeling`, before the document.

You may write the document only once both are true.
</HARD-GATE>

**Never put the glossary inside the document.** The document's **Ubiquitous Language** section *points at* `CONTEXT.md` (or the contexts named in `CONTEXT-MAP.md`) and lists only the terms this document introduces or sharpens — with their definitions living in the glossary, not here. A terminology table inside a spec is invisible to the code reviewer's naming check, to the plan's `Global Constraints`, to the SDD implementer dispatch and to the `CLAUDE.md` import. Four mechanisms read `CONTEXT.md`; none reads the spec.

Same for decisions: **the document references `docs/decisions/NNNN-<slug>.md`, it does not restate the reasoning.** A spec with six inline `### E<n>` sections is six missing Decision files.

| Rationalization | Reality |
|---|---|
| "I'll note in the spec that `CONTEXT.md` should be created later" | You just wrote a to-do instead of a glossary. Invoke `smax:domain-modeling` and create it. |
| "Only three terms — a table in the spec is enough" | Three terms are enough for the file. The file is short and it is the one thing four tools read. |
| "These are design decisions, they belong in the spec" | Apply the three criteria to each. What passes becomes a Decision file; the spec links to it. |
| "The glossary can be extracted once a second document needs it" | There is no second document. The session ends here. |

## 4. Write the document

Second line of the file is the creation date — redundant with the filename on purpose, because the filename does not survive a copy into another system:

```markdown
# <Title>

**Erstellt:** DD.MM.YYYY
```

Set it when creating the file. Do not touch it on later revisions.

Write clearly and concisely; use the `elements-of-style:writing-clearly-and-concisely` skill if available.

**Then mirror it into the solution.** Does `ls *.slnx 2>/dev/null` match at the
repo root? Then invoke `smax:sync-solution-items` — the document has to appear
in the solution as part of the same change, or nobody working in Visual Studio
will see it. No match: skip **silently** — do not mention it, do not offer it.

## 5. Do not commit yet

**Nothing gets committed in this skill.** The document, the `CONTEXT.md` updates and the `docs/decisions/` entries all stay in the working tree. `smax:writing-plans` makes **one** commit at the end, covering the spec *and* the plan — they are one unit of thought and land as one commit.

Leave the tree dirty and say so at the user gate, so nobody mistakes an uncommitted document for a lost one.

**The one exception:** if the user stops the chain here — declines the plan at the gate in step 8, or says the spec is the whole deliverable — then the work needs a commit, because uncommitted work that nothing downstream will pick up is work waiting to be lost.

**But ask first; never commit unasked.** Name the files and the message and wait for a yes:

> "You're stopping here, so this should be committed or it's only in the working tree — spec, `CONTEXT.md` and one Decision, 3 files. Message: `docs(spec): …`. Commit?"

If they decline, say plainly that the files stay uncommitted and stop.

## 6. Self-review inline

Fresh eyes on what you just wrote:

1. **Placeholders** — "TBD", "TODO", empty sections, vague requirements. Fix them.
2. **Internal consistency** — do sections contradict each other? Does the architecture match the feature descriptions?
3. **Scope** — focused enough for a single implementation plan, or does it need decomposition?
4. **Ambiguity** — could any requirement be read two ways? Pick one and make it explicit.

Cheap, catches the obvious. Fix inline and move on.

## 7. Dispatch the document reviewer

The self-review is not the review. **The model that wrote the document cannot see its own gaps** — that is the whole point of a fresh subagent.

Dispatch a `general-purpose` subagent with the template at [spec-document-reviewer-prompt.md](spec-document-reviewer-prompt.md).

<HARD-GATE>
**Dispatch it one-shot: no name, no follow-up messages.** The reviewer's final message *is* the report — a named agent becomes an addressable teammate that finishes, goes idle **without sending its report**, and has to be chased.

**A re-review is a fresh dispatch — never the same reviewer.** A re-used one answers from its stale snapshot and re-sends its original findings, so the corrections go unchecked while looking checked.
</HARD-GATE>

- **`Issues`** — fix inline, then dispatch **exactly one** re-review, as a **new** one-shot agent pointed at the file on disk.
- **`Recommendations`** — advisory. They do not block.
- Still `Issues Found` after the re-review? **Stop.** Do not loop. Put the findings and the document in front of the user and let them decide.
- **Findings that cite content the file no longer contains** are stale, not open. Verify against the file before you either fix or dismiss them — and say which you did.

## 8. User review gate

Present it as three ways forward, exactly this shape:

> "Spec written to `<path>` and reviewed by a fresh reviewer. Not committed yet — that happens together with the plan, as one commit. Three ways forward:
>
> **1.** Approve — I'll write the implementation plan.
> **2.** Stress-test the premises first — a relentless interview on this spec before we plan.
> **3.** Tell me what to change."

Then wait. The decision is theirs.

**Why option 2 exists.** Everything up to here checks the document along one axis: is it complete, consistent, planable? The self-review, the reviewer subagent and the re-review all ask that. **None of them asks whether the premises are right.** A reviewer finds a broken formula inside the chosen model; it never asks whether the chosen model suits the problem. That question needs the user, and the spec stage is where it is cheapest to answer — nothing is committed and no code exists yet.

Offer it as one option among three, never as a separate question of its own. An offer that appears every single time gets declined reflexively, and then it is trained noise instead of a choice.

**Handling each:**

- **Option 1** → step 9.
- **Option 3** → make the changes, re-run steps 6–7, return to this gate.
- **Option 2** → run the interview, then re-run steps 6–7 and return to this gate. Details below.

### Option 2: sharpening the written spec

Invoke **`smax:sharpen`**, scoped to the spec file, and keep **`smax:domain-modeling`** running alongside it — the same pairing `smax:sharpen-with-docs` is a wrapper for.

**Invoke those two, not `smax:sharpen-with-docs`.** That wrapper carries `disable-model-invocation: true` and cannot be started from another skill; the Skill tool refuses it outright. `smax:sharpen` and `smax:domain-modeling` carry no flag and are reachable. The wrapper also ends by offering to write a document and calling this skill — from here that is a loop with your own caller. Going through `smax:sharpen` avoids it structurally: that skill has no document tail at all.

Then:

1. Interview against the **existing spec**, not against the earlier conversation. The document is the artifact under attack.
2. Fold the results into the spec as you go.
3. Terms or decisions the interview moves go through `smax:domain-modeling` into `CONTEXT.md` and `docs/decisions/` — the tree is still uncommitted, so a sharpening that reaches back into the glossary costs nothing.
4. **Re-run steps 6–7.** A sharpened spec is a different document and has not been reviewed. This is not the "exactly one re-review" budget from step 7 — that budget applies within one review round; a fresh round starts here.
5. Return to this gate.

If they say the spec is the whole deliverable and there will be no plan, commit here per step 5's exception, then stop.

## 9. Hand off

Invoke `smax:writing-plans`. Pass the topic slug, the document path, and the fact that the tree is **uncommitted** — `writing-plans` owns the single commit for spec, glossary, decisions and plan together.

That is the only next skill — do not invoke `frontend-design`, an implementation skill, or anything else from here.
