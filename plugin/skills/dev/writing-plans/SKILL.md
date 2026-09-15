---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. **One commit per task** — those commits live on the feature branch and get squashed into a single commit when the branch lands, so a task-sized commit costs nothing in the target branch's history.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** If working in an isolated worktree, it should have been created via the `smax:using-git-worktrees` skill at execution time.

## Where the plan goes

```
docs/02_Plans/<Slug>/PLAN-<Slug>-DDMMYYYY.md
```

**The topic slug comes from `smax:writing-specs` — take it over unchanged.** Do not re-derive it, do not re-case it, do not "improve" it. It is the single identifier tying the analysis, the spec, the plan and the SQL scripts of one undertaking together. If you were invoked without a spec, pin the slug yourself: PascalCase, one word or a short compound (`TipAllowance`, `InvoiceExport`).

Get the date from `date +%d%m%Y` — never guess it. **The suffix is functional.** `smax:subagent-driven-development` derives its workspace path (`.smax/sdd/<plan-basename>/`) from the plan filename. Without the date, two plans on the same topic share one workspace, and a stale ledger from an abandoned run gets read as current progress — SDD then skips whole task sequences that were never done.

**If the topic folder already exists, say so and ask:**

> "`docs/02_Plans/TipAllowance/` already exists with `PLAN-TipAllowance-12052026.md`. Should I continue that plan or write a new one for today?"

A second version is a different thing from a continuation. The date suffix prevents accidental overwriting; it does not answer this question.

**Never write into `Archive/`, and never read anything under `Archive/` as current project context.** Archiving is manual and deliberately outside every skill.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Database Changes

If the plan needs schema changes, specify **both** scripts as task steps, with the exact path and the complete SQL:

```
docs/03_DbChanges/<Slug>/DDMMYYYY-<Slug>.forward.sql
docs/03_DbChanges/<Slug>/DDMMYYYY-<Slug>.rollback.sql
```

The date is a **prefix** here, not a suffix — that is the existing convention for SQL and stays as it is.

**The date is the day the implementer writes the file, not the day you plan it.** You cannot know it. Specify the naming scheme and instruct the implementer to fill in `date +%d%m%Y` at the moment they create the file.

The scripts are written by the implementer, as steps in a task — that follows the "No Placeholders" rule below rather than undercutting it. You supply the full SQL in the plan; they put it in the file.

## Task Right-Sizing

A task is the smallest unit that carries its own test cycle and is worth a
fresh reviewer's gate. When drawing task boundaries: fold setup,
configuration, scaffolding, and documentation steps into the task whose
deliverable needs them; split only where a reviewer could meaningfully
reject one task while approving its neighbor. Each task ends with an
independently testable deliverable.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

**Erstellt:** DD.MM.YYYY

> **For agentic workers:** REQUIRED SUB-SKILL: Use smax:subagent-driven-development (recommended) or smax:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Spec:** [path to the SPEC or ANALYSIS document this plan implements]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, with exact
values copied verbatim from the spec. Every task's requirements implicitly
include this section.]

- **Terminology is defined in `CONTEXT.md`** (or the contexts listed in
  `CONTEXT-MAP.md`). Names in code, tests, migrations and error messages use
  the canonical term. A deviation is a defect, not a style preference. Names
  listed under `_Avoid_` must not appear. A domain term missing from the
  glossary gets added there — it is not invented in code.
- **`docs/decisions/0002-append-only-ledger.md`** — records are never
  updated in place; a correction is a new counter-entry. Reverting to an
  in-place update is a defect, not a simplification.
- [one line per Decision that binds this work: the file, what it binds, and
  the wrong-but-obvious alternative it rules out]

---
```

The `**Erstellt:**` line is the creation date, redundant with the filename on purpose: the filename does not survive a copy into another system, the line does. Set it once when creating the plan; leave it alone on later revisions.

**The `Global Constraints` block is the highest-leverage part of the plan.** `smax:subagent-driven-development` hands it verbatim to every task reviewer as `[GLOBAL_CONSTRAINTS]`, so the terminology binding above reaches every single review with no further wiring.

<HARD-GATE>
**That leverage cuts both ways: whatever this block names as the authority becomes the authority for every task reviewer in the run.** So it must name `CONTEXT.md`.

If the project has no `CONTEXT.md` and no `CONTEXT-MAP.md`, **stop and create it via `smax:domain-modeling` before writing the plan.** The spec's terms are the input; the glossary is where they belong.

**Never rewrite the terminology bullet to point somewhere else.** These are plan failures, not pragmatic workarounds:

- *"The project has no `CONTEXT.md`; the spec's terminology table is the authority for now."*
- *"Terms are defined in the spec's Ubiquitous Language section."*
- Listing the terms inline in `Global Constraints` instead of naming the file.

Each of them hands every task reviewer, and `code-reviewer.md`'s naming check, a source they do not read — while looking like the constraint is satisfied. And it puts the terminology in two places at once with no authority between them, which is drift by construction.
</HARD-GATE>

### Bind the relevant Decisions here

This block is also the only place a recorded Decision reaches the implementation. **Nothing else in the chain reads `docs/decisions/` on the way to code** — the implementer dispatch carries the glossary, not the decisions, and the task reviewer sees only what this block tells it.

```bash
ls docs/decisions/ 2>/dev/null
```

**The filename is the index.** Judge by title; open only the ones this plan's work could collide with. Then, for each one that binds, write **one line**: the file path, what it binds, and — this is the load-bearing part — **the wrong-but-obvious alternative it rules out.**

That last clause is why the line works. A Decision exists because the obvious path looks better than it is, so an implementer who is told only *"we use an append-only ledger"* may still reach for an in-place update as an optimisation. Told *"reverting to an in-place update is a defect, not a simplification"*, they recognise the temptation when it arrives.

**Keep it to the Decisions this plan can actually violate.** Copying all of them turns the highest-leverage block into noise, and it is re-read by every task reviewer on every task — the cost multiplies by the task count. Two or three lines is a normal number; ten means you are pasting the archive.

**Do not restate the reasoning.** The line names the file; the file holds the why. If a reviewer needs the argument, it opens the file.

If `docs/decisions/` does not exist, skip this silently.

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact function names, parameter
  and return types. A task's implementer sees only their own task; this
  block is how they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

**Step 5 stays.** The task commit is not optional bookkeeping: `smax:subagent-driven-development` builds each reviewer's diff from the task's `BASE..HEAD`, and its ledger records the SHA so an interrupted run can prove what was finished after a compaction. Without a task commit the review range is empty and the ledger has nothing to point at. These commits disappear at landing time, when the branch is squashed.

**Task commits run without asking the user** — they are internal to a disposable branch. Everything that leaves that branch is asked for separately by `smax:finishing-a-development-branch`: the squash commit, the branch deletion, any push, the PR. Do not put confirmation steps for task commits into the plan.

## Every plan ends with the review gate

**After the last task, close the plan with this section — not as a task with steps, but as a completion condition:**

```markdown
## Before Landing

The full range of this branch gets reviewed, not just the last task. Fix
everything under `Issues`; `Recommendations` are advisory.

- Working by hand: type `/smax:code-review`.
- Working as an agent: dispatch a `general-purpose` subagent with the reviewer
  template at `<RESOLVED_TEMPLATE_PATH>`, using the merge-base as BASE and HEAD
  as HEAD. **If that path does not resolve, stop and ask** — the plugin has been
  moved or updated since this plan was written. Do not guess a replacement path,
  and do not skip the review.

Then land via `smax:finishing-a-development-branch`, which re-checks that a
review for this HEAD exists before it offers the merge options.
```

<HARD-GATE>
**Resolve `<RESOLVED_TEMPLATE_PATH>` yourself before writing this block — never
paste the placeholder, and never write a repo-relative path.** The plan lands in
the *target* project, where `skills/dev/code-review/` does not exist. A path
relative to this plugin resolves to nothing there, silently.

You know your own skill directory (it is injected as `Base directory for this
skill:`). The template sits at `../code-review/code-reviewer.md` relative to it.
Resolve that to an absolute path, confirm the file exists, and write the
absolute path into the plan.

**Do not add a fallback search.** An earlier version of this block told the plan
how to hunt for the template under the plugin cache. That cache does not exist
at all when the plugin is served from a local directory — so the safety net was
dead on exactly the machine that writes most of the plans, while looking like
coverage. A path that fails loudly and asks beats a second mechanism that
silently finds nothing.
</HARD-GATE>

**Both forms are needed, and the second is not optional politeness.** `smax:code-review` carries `disable-model-invocation: true`: a human can type `/smax:code-review`, but an agent calling it through the Skill tool gets refused outright. Naming only the skill would hand every agent-executed plan an instruction it cannot follow. The resolved file path is the route that works for both.

This exists because a plan worked through by hand passes no other gate. `smax:subagent-driven-development` dispatches its own final reviewer and `smax:finishing-a-development-branch` carries a blocking gate, but a human reading the plan top to bottom sees neither — unless the plan says so.

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

**4. Claims you can execute, execute.** Wherever the plan asserts how code behaves — *"this test fails without the implementation"*, *"step 3 turns that accident into a guarantee"*, *"the suite catches this"* — write the smallest throwaway script and check. **A wrong reason in a plan is more dangerous than a missing one:** the implementer builds on it, the reviewers read it as context rather than as a claim, and the defect surfaces only when someone mutates the code to see whether any test notices. Delete a guard your plan calls load-bearing and see whether the suite goes red. If it stays green, either the claim or the test set is wrong — fix the plan before anyone builds on it.

Fix any issues inline. If you find a spec requirement with no task, add the task.

## Dispatch the document reviewer

The self-review above is cheap and catches the obvious. It is not the review — **the model that wrote the plan cannot see its own gaps.**

Dispatch a `general-purpose` subagent with the template at [plan-document-reviewer-prompt.md](plan-document-reviewer-prompt.md).

<HARD-GATE>
**One-shot, no name, no follow-up messages.** The reviewer's final message *is* the report — a named agent becomes an addressable teammate that goes idle without reporting and has to be polled.

**A re-review is a fresh dispatch, never the same reviewer.** A re-used one answers from its stale snapshot and re-sends its original findings, so the corrections go unchecked while looking checked.
</HARD-GATE>

- **`Issues`** — fix inline, then dispatch **exactly one** re-review, as a **new** one-shot agent pointed at the file on disk.
- **`Recommendations`** — advisory. They do not block.
- Still `Issues Found` after the re-review? **Stop.** Do not loop. Put the findings and the plan in front of the user and let them decide.
- **Findings citing content the file no longer contains** are stale, not open. Check against the file before fixing or dismissing, and say which you did.

## Mirror into the solution

Before the commit: does `ls *.slnx 2>/dev/null` match at the repo root? Then
invoke `smax:sync-solution-items`. The plan, and any `docs/03_DbChanges/`
scripts you wrote, have to be in the solution **before** the commit below
stages it — otherwise the solution change trails the documents by one commit
and someone has to clean it up. No match: skip **silently**, do not mention it.

## The single commit

**One commit covers the whole design phase.** `smax:writing-specs` deliberately committed nothing — the spec, any `CONTEXT.md` updates, any `docs/decisions/` entries and this plan all sit in the working tree and land together now.

<HARD-GATE>
**Ask before committing. Never commit unasked.** This commit lands documents in the repo's permanent history, so it is the user's call, not yours. Show them what will go in and the message, then wait:

> "Ready to commit the design phase — spec, `CONTEXT.md`, two Decisions and the plan, 5 files. Message:
> `docs(spec): Permalink-Slug aus deutscher Überschrift`
> Commit?"

Wait for a yes. If they want a different message or a different set, do that instead.
</HARD-GATE>

```bash
git add docs/ CONTEXT.md CONTEXT-MAP.md *.slnx 2>/dev/null
git status --short          # confirm nothing unrelated got swept in — show this to the user
git commit -m "<message from smax:commitMessage>"
```

They are one unit of thought: a plan without its spec is unreviewable, a spec without its glossary is unenforceable, and splitting them produces a history where no single commit is a complete, coherent state.

**Check the staged set before committing.** `git add docs/` in a repo with other pending doc work will take that too. If `git status --short` shows anything that did not come out of this design phase, stage by explicit path instead.

**Do not commit before the reviewer has passed.** A committed plan with open `Issues` is a commit you have to amend or follow up.

**Invoked cold**, against an already-committed spec or none at all? Then this commit carries just the plan (plus any glossary work you did along the way). Same rule, smaller set.

## Execution Handoff

After the commit, offer execution choice:

**"Plan saved to `docs/02_Plans/<Slug>/PLAN-<Slug>-DDMMYYYY.md` and committed together with the spec. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task and check its report against the brief, with one fresh-eyes review over the whole branch at the end

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use `smax:subagent-driven-development`
- Fresh subagent per task, report checked against the brief, one whole-branch review at the end

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use `smax:executing-plans`
- Batch execution with checkpoints for review
