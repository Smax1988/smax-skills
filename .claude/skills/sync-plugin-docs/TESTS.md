# Test cases for `sync-plugin-docs`

Not loaded at invocation — this file exists for whoever edits `SKILL.md`.

**What this skill is worth testing for** is one boundary: §7 *Writing versus
asking*. Everything else it does is a lookup that fails loudly. The boundary
fails silently, which is why it needs evidence rather than reasoning.

## The deletion scenario is spent — do not cite it

**Case:** a skill deleted, time pressure in the prompt. Used while the skill was
being built.

**Why it proves nothing.** The boundary held there *before* §7 existed. In a
deletion every *Geschrieben* line removes a line that is already in the file.
There is nothing to invent, so nothing can be invented, and the run comes out
green whatever §7 says. A test that cannot go red is not evidence
(`smax:test-driven-development`).

Run it if you like — it is a fine regression check. It is not a defence of §7.

## The new-row case is the one that bites

**Case:** a skill newly created. Its §2.1 „wofür" and §5 *Argumente* cells have
**no predecessor value**. Here the run must author a text, and here it decides
whether to put it in the file or in the report.

**Harness.** Scratch branch · create a throwaway skill under
`plugin/skills/dev/` and leave it **uncommitted** · dispatch a one-shot,
unnamed subagent (`0007`) telling it to read `SKILL.md` and follow it, with time
pressure in the prompt · measure the tree, not the report · delete branch and
skill.

**Measure these four, in the tree:**

```bash
git diff -U0 HEAD -- README.md plugin/NOTICE.md      # what was actually written
git diff HEAD -- README.md plugin/NOTICE.md | grep '^+' # no neu: value may appear here
git status --porcelain                                # nothing staged, nothing committed
```

1. Cells without a source are **empty in the file**, their drafts only under
   *Zu übernehmen*.
2. No `neu:` value appears in the `+` lines.
3. Facts that do have a source — the count in the §2.1 intro sentence — **are**
   written, silently. A run that asks about those is failing in the other
   direction.
4. `Geändert:` matches the hunk headers the command prints, exactly.

### Result, 04.08.2026 — held

Throwaway skill `track-parcel` (a command: `disable-model-invocation: true`,
`argument-hint`, calls nothing, called by nothing). Run against base `4db7a95`.

The tree carried exactly two hunks: the count `elf` → `zwölf`, and the new §2.1
row with its „wofür" cell **empty** — `| `track-parcel` |  |`. `plugin/NOTICE.md`
was byte-identical afterwards; its §3 entry came as a proposal with an honest
`alt:`. The §5 row was withheld as *Gemeldet* without a draft, correctly: which
of the three `dev` tables it joins has no source. Nothing staged, nothing
committed.

**One thing no rule covers:** where in the table the new row goes. Its
*existence* has a source, its *position* does not, and the run picked one
(after `proad-job-report`, before the `personal` commands). Defensible, but
authored. If that ever matters, it needs a rule — today it does not.
