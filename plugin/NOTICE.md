# NOTICE

Parts of this plugin are derived from two projects: **superpowers** (Jesse
Vincent) and **mattpocock/skills** (Matt Pocock). Both MIT.

One section per upstream — header table, anchor, file list, licence text.
Whatever comes from neither is in [§3](#3--no-upstream-origin).

**This file says *what* deviates — the *why* is in
[`docs/decisions/`](../docs/decisions/).** Anyone facing a conflict at the next
upstream sync who wants to know whether the deviation was intentional reads up
there before merging it away.

> **A rename at import erases the origin.** The five files from §2 were called
> `grilling`, `grill-me` and `grill-with-docs` upstream; here they are called
> `sharpen*`. That removed the only trace that could have been read off the
> file name, and the second upstream was missing from this file from its first
> day (import on 2026-07-26) until 2026-08-04.
> `domain-modeling` and `teach` keep their upstream names — there the origin
> was visible all along. Whoever renames something at import in future records
> it here **in the same session**.

---

## 1 · superpowers

| | |
|---|---|
| Project | superpowers |
| Author | Jesse Vincent |
| Repository | <https://github.com/obra/superpowers> |
| Version | 6.2.0 |
| Commit | `3dcbd5c4b48e02263fbf4a3c01e3fe4f81d584d9` (tag `v6.2.0`, 2026-07-23) |
| Licence | MIT |

The commit is the anchor for a later upstream comparison. It is recorded here
because the plugin cache disappears when `superpowers` is uninstalled, and the
starting point can no longer be reconstructed from the system itself after
that. The comparison is upstream against upstream
(`git diff v6.2.0..v7.0.0 -- skills/<name>/`) in a separate clone, not against
the files of this repo — those have deliberately diverged.

The files taken over were adapted **already while copying**: skill references
switched to the prefix `smax:`, working directories from `.superpowers/` to
`.smax/`, document paths to this repo's doc convention (`docs/00_Analysis/`,
`docs/01_Specs/`, `docs/02_Plans/`, `docs/03_DbChanges/`), plus additions and
cuts in substance.

Paths relative to `plugin/skills/dev/`. Three tiers, by remaining upstream
share.

> **Measured against the anchor, not against this repo's own history.** The
> files already carried the adaptations above at import — a diff against a
> state of this repo therefore never measures the distance to upstream, and the
> history of this repo is not guaranteed anyway
> ([`0026`](../docs/decisions/0026-notice-anchors-upstream-not-own-history.md)).
> Only the comparison against the anchor gives the distance:
>
> ```bash
> git clone --filter=blob:none https://github.com/obra/superpowers.git /tmp/sp
> git -C /tmp/sp checkout 3dcbd5c
> diff --strip-trailing-cr /tmp/sp/skills/<upstream-path> plugin/skills/dev/<file>
> ```
>
> `--strip-trailing-cr` because `.gitattributes` enforces LF here and the clone
> checks out CRLF under Windows — without the flag `diff` reports every line as
> changed. **The tier follows from this comparison** —
> `brainstorming/SKILL.md` stands at 45−/81+ against v6.2.0.

> **The most common reason for drift** in files originally taken over
> verbatim: the four read sites for `docs/decisions/` (`0005`) and the glossary
> gate on `CONTEXT.md` were fitted in afterwards — into files that otherwise
> stayed untouched. At an upstream sync the conflicts will very likely sit
> exactly at these insertions.

### Taken over unchanged

Not a line changed since the import, as of publication on 2026-09-15. This
cannot be verified against the anchor, because the import already carried the
adaptations above. If one of these files changes, `sync-plugin-docs` reports it.

| File | Upstream origin |
|---|---|
| `writing-skills/testing-skills-with-subagents.md` | `skills/writing-skills/testing-skills-with-subagents.md` |
| `writing-skills/persuasion-principles.md` | `skills/writing-skills/persuasion-principles.md` |
| `writing-skills/graphviz-conventions.dot` | `skills/writing-skills/graphviz-conventions.dot` |
| `writing-skills/render-graphs.js` | `skills/writing-skills/render-graphs.js` |
| `test-driven-development/SKILL.md` | `skills/test-driven-development/SKILL.md` |
| `test-driven-development/writing-good-tests.md` | `skills/test-driven-development/writing-good-tests.md` |
| `verification-before-completion/SKILL.md` | `skills/verification-before-completion/SKILL.md` |
| `debugging/root-cause-tracing.md` | `skills/systematic-debugging/root-cause-tracing.md` |
| `debugging/defense-in-depth.md` | `skills/systematic-debugging/defense-in-depth.md` |
| `debugging/condition-based-waiting.md` | `skills/systematic-debugging/condition-based-waiting.md` |
| `debugging/condition-based-waiting-example.ts` | `skills/systematic-debugging/condition-based-waiting-example.ts` |
| `debugging/find-polluter.sh` | `skills/systematic-debugging/find-polluter.sh` |
| `brainstorming/visual-companion.md` | `skills/brainstorming/visual-companion.md` |
| `brainstorming/scripts/server.cjs` | `skills/brainstorming/scripts/server.cjs` |
| `brainstorming/scripts/helper.js` | `skills/brainstorming/scripts/helper.js` |
| `brainstorming/scripts/frame-template.html` | `skills/brainstorming/scripts/frame-template.html` |
| `brainstorming/scripts/start-server.sh` | `skills/brainstorming/scripts/start-server.sh` |
| `brainstorming/scripts/stop-server.sh` | `skills/brainstorming/scripts/stop-server.sh` |
| `subagent-driven-development/task-reviewer-prompt.md` | `skills/subagent-driven-development/task-reviewer-prompt.md` |
| `subagent-driven-development/re-review-prompt.md` | `skills/subagent-driven-development/re-review-prompt.md` |
| `subagent-driven-development/scripts/sdd-workspace` | `skills/subagent-driven-development/scripts/sdd-workspace` |
| `subagent-driven-development/scripts/task-brief` | `skills/subagent-driven-development/scripts/task-brief` |
| `subagent-driven-development/scripts/review-package` | `skills/subagent-driven-development/scripts/review-package` |

### Taken over, selectively extended

Upstream text at the core, locally confined insertions.

| File | Upstream origin | Addition |
|---|---|---|
| `using-git-worktrees/SKILL.md` | `skills/using-git-worktrees/SKILL.md` | The `.gitignore` line is confirmed and committed **before** the worktree is created — otherwise the whole tree lands in the repo (`0008`) |
| `executing-plans/SKILL.md` | `skills/executing-plans/SKILL.md` | Superseded note in favour of `subagent-driven-development`; cold-start case added: the plan is found rather than assumed (`0016`) |
| `writing-plans/plan-document-reviewer-prompt.md` | `skills/writing-plans/plan-document-reviewer-prompt.md` | Read from disk instead of from memory; the last message *is* the report; executable plan claims are executed (`0012`); terminology authority is checked |
| `writing-specs/spec-document-reviewer-prompt.md` | `skills/brainstorming/spec-document-reviewer-prompt.md` | One-shot without a name (`0007`); read from disk; glossary and decision **placement** are checked, not just the content |

### Substantially rebuilt

| File | Upstream origin | Kind of rework |
|---|---|---|
| `code-review/SKILL.md` | `skills/requesting-code-review/SKILL.md` + `skills/receiving-code-review/SKILL.md` | Two skills condensed into one (`0009`) |
| `code-review/code-reviewer.md` | `skills/requesting-code-review/code-reviewer.md` | Decision check in the reviewer (`0005`); English identifiers against the glossary; **mutation probe for guards** — a green test run only proves a guard once the suite turns red without it (`0009`) |
| `writing-plans/SKILL.md` | `skills/writing-plans/SKILL.md` | Glossary gate on `CONTEXT.md`; binding of the relevant decisions in the `Global Constraints` block; `## Before Landing` as the close of every plan, with a resolved path to the reviewer template (`0017`). Roughly a third of the file is own text |
| `brainstorming/SKILL.md` | `skills/brainstorming/SKILL.md` | Decision read site as step 1, before any draft (`0005`); glossary HARD-GATE with rationalisation table; document type SPEC/ANALYSIS is named instead of asked; spec steps 6–9 are out and live in `writing-specs`. 45−/81+ against v6.2.0 |
| `debugging/SKILL.md` | `skills/systematic-debugging/SKILL.md` | New section *"When the Root Cause Is a Broken Decision"*: if the code contradicts a decision, that contradiction **is** the cause — not the crash one was chasing (`0005`) |
| `finishing-a-development-branch/SKILL.md` | `skills/finishing-a-development-branch/SKILL.md` | Boiled down, review gate and squash landing added |
| `writing-specs/SKILL.md` | Extract from `skills/brainstorming/SKILL.md` (steps 6–9) | Rewritten as a standalone skill (`0003`) |
| `subagent-driven-development/SKILL.md` | `skills/subagent-driven-development/SKILL.md` | Per-task task reviewer removed: the gate is the implementer's self-check plus the controller's report check. A task reviewer only on `DONE_WITH_CONCERNS` about correctness or scope. Fix loop switched to controller verification, final review strengthened, ledger keeps the workspace until landing (`0006`, `0014`) |
| `subagent-driven-development/implementer-prompt.md` | `skills/subagent-driven-development/implementer-prompt.md` | `CONTEXT.md` excerpt in the dispatch; the self-check is now the primary gate and tightened accordingly |
| `writing-skills/SKILL.md` + `writing-skills/authoring-reference.md` | `skills/writing-skills/SKILL.md` | Split: discipline (TDD cycle, Iron Law, bulletproofing, match-the-form) stays in `SKILL.md`, reference material (structure, naming, file layout, flowchart rules, testing approach per skill type) moves one level down to `authoring-reference.md`. Token budgets adjusted to workflow skills; ban on cross-skill deduplication added |
| `dispatching-parallel-agents/SKILL.md` | `skills/dispatching-parallel-agents/SKILL.md` | Session narrative and duplicate "When NOT to use" block removed |

### Frozen copy of external documentation

`writing-skills/anthropic-best-practices.md` is a frozen copy of public
Anthropic documentation on Agent Skills, taken over via superpowers. It is not
synchronised with its source and may therefore lag behind the current
Anthropic docs.

### Not taken over

`using-superpowers` including its SessionStart hook, `commands/`, `tests/`,
`agents/`, the platform manifests (`.codex-plugin`, `.cursor-plugin`,
`.opencode`, `.pi`, `gemini-extension.json`), the development artifacts
`CREATION-LOG.md`, `test-pressure-*.md`, `test-academic.md` and
`writing-skills/examples/CLAUDE_MD_TESTING.md`.

### MIT License — superpowers

Copyright (c) 2025 Jesse Vincent

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 2 · mattpocock/skills

| | |
|---|---|
| Project | mattpocock/skills |
| Author | Matt Pocock |
| Repository | <https://github.com/mattpocock/skills> |
| Version | 1.2.0 (`.claude-plugin/plugin.json`) |
| Commit | `2ab958093e83e0ec752e6c1c5932da465bf23e0c` (2026-07-28) |
| Licence | MIT |

**This anchor is set, not reconstructed.** Unlike superpowers there is no
import commit here: all five skills enter their current path together in a
move commit ("Plugin nach `plugin/` verschieben", 2026-07-26). The first commit
of this repo is from 2026-07-24, the upstream is older (first commit
2026-02-03) — so the actual starting point can be settled neither from the
history nor from the dates. The commit above is a **reference point for the
future**, not a claim about past origin: all classifications below are measured
against it, on 2026-08-04.

```bash
git clone --filter=blob:none https://github.com/mattpocock/skills.git /tmp/mp
git -C /tmp/mp checkout 2ab9580
diff --strip-trailing-cr /tmp/mp/skills/<upstream-path> plugin/skills/dev/<file>
```

`--strip-trailing-cr` for the same reason as with superpowers.

Paths relative to `plugin/skills/dev/`, upstream paths relative to the repo root.
The same three tiers as in §1.

### Taken over unchanged

Byte-identical with the anchor.

| File | Upstream origin |
|---|---|
| `teach/SKILL.md` | `skills/productivity/teach/SKILL.md` |
| `teach/GLOSSARY-FORMAT.md` | `skills/productivity/teach/GLOSSARY-FORMAT.md` |
| `teach/MISSION-FORMAT.md` | `skills/productivity/teach/MISSION-FORMAT.md` |
| `teach/RESOURCES-FORMAT.md` | `skills/productivity/teach/RESOURCES-FORMAT.md` |

### Taken over, selectively extended

| File | Upstream origin | Addition |
|---|---|---|
| `teach/LEARNING-RECORD-FORMAT.md` | `skills/productivity/teach/LEARNING-RECORD-FORMAT.md` | One line: "the teaching equivalent of ADRs" → "of Decisions", so the comparison points at the local term |
| `sharpen/SKILL.md` | `skills/productivity/grilling/SKILL.md` | Frontmatter only: renamed `grilling` → `sharpen`, `description` updated, `argument-hint` added. **The body text is verbatim upstream** — exactly this rename obscured the origin |

### Substantially rebuilt

| File | Upstream origin | Kind of rework |
|---|---|---|
| `sharpen-me/SKILL.md` | `skills/productivity/grill-me/SKILL.md` | Upstream is one sentence ("Run a `/grilling` session"). Here the skill decides the document type SPEC/ANALYSIS itself and names it in the question, "no" is explicitly a valid outcome, and a "yes" hands over to `smax:writing-specs` instead of writing the document itself |
| `sharpen-with-docs/SKILL.md` | `skills/engineering/grill-with-docs/SKILL.md` | Like `sharpen-me`, plus: no secrets and no PII in `CONTEXT.md` or decisions, and terms are written as soon as they are settled — not at the end of the session and not as a table in the spec. Upstream this skill is a standalone entry point; here `writing-specs` calls `sharpen` + `domain-modeling` individually instead, because a command cannot be started from inside a skill (README §4) |
| `domain-modeling/SKILL.md` | `skills/engineering/domain-modeling/SKILL.md` | ADR → Decision throughout, `docs/adr/` → `docs/decisions/`. Two new sections wire glossary and decisions into the project `CLAUDE.md` (`0015`), the second with a HARD-GATE against any import of the directory. Plus the PII rule, the language rule for decisions (`0023`) and the call to `smax:sync-solution-items` after every new decision. 8−/165+ |
| `domain-modeling/CONTEXT-FORMAT.md` | `skills/engineering/domain-modeling/CONTEXT-FORMAT.md` | Section *Terms that aren't English*: every non-English term carries its English code name in its entry, without exception — product names and legal terms included. Plus three sentences at the top on what `CONTEXT.md` achieves in the first place |
| `domain-modeling/DECISION-FORMAT.md` | `skills/engineering/domain-modeling/ADR-FORMAT.md` | Renamed ADR → Decision. New section *Language*: file name and body are English, regardless of the language of the project and the conversation (`0023`) |

### Not taken over

All other skills of the upstream, the platform manifests, `scripts/`, `docs/`
and the `agents/openai.yaml` that sits next to each of the five skills upstream.

**`handoff` is not from here** — the name suggests it, upstream has
`skills/productivity/handoff`, and every later reader will ask the question.
The skill is entirely self-written (confirmed on 2026-08-01), and the
comparison supports that: the repo search across several git repos (depth 6,
`node_modules` skipped), the fixed six-part document template, the hard-coded
`C:\Temp` with its `-2`/`-3` collision scheme and the block *Principles
(binding)* have no counterpart upstream; conversely, its section *Suggested
Skills* is missing here. All they share is the name, the shape of the
frontmatter, "temp directory instead of workspace", PII redaction and
"argument = focus of the next session". It is therefore listed in
[§3](#3--no-upstream-origin).

### MIT License — mattpocock/skills

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 3 · No upstream origin

Own skills — not even to be looked at when syncing with §1 and §2.

**Older than the import:** `commitMessage`, `handoff`, `replicate`,
`infographic-page`, `personal/find-beer-deals`, `personal/nano-vs-colors`.

**Created afterwards:** `data-model-diagram`, `mail-draft`, `md-to-pdf`,
`proad-job-report`, `setup`, `sync-solution-items`, `personal/whats-for-lunch`,
`personal/lap-training`.

**The first list is closed.** No skill becomes older than the import after the
fact — a new own skill always goes under *Created afterwards*.
The split was drawn against the history before publication, which is no longer
part of this repo
([`0026`](../docs/decisions/0026-notice-anchors-upstream-not-own-history.md)).

**What the split proves and what it does not.** It says when a skill was
created — nothing more. "Older than the superpowers import" meant *no upstream*
in the first version of this file, and that is exactly how §2 was missed from
the start: the five Pocock skills are older than the import as well.
Whoever adds a skill here checks it **against both upstreams**, not against the
history.
