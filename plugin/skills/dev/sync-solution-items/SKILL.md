---
name: sync-solution-items
description: Mirror files under docs/ into the Solution Items of a .slnx solution. Use after creating, renaming or deleting files under docs/ in a repository whose root holds a .slnx - typically at the end of writing-specs, writing-plans or domain-modeling.
---

# Sync Solution Items

A document that exists on disk but not in the solution is invisible to everyone
working in Visual Studio. This skill closes that gap mechanically.

## Precondition — check before anything else

<HARD-GATE>
This skill applies **only** to a repository whose root holds a `.slnx`.

```bash
ls *.slnx 2>/dev/null
```

No match — no .NET solution, or a classic `.sln` — and there is nothing to
mirror. Say so in one line and stop. Do not run the script, do not offer
alternatives, do not "fix" the repo into having a solution.
</HARD-GATE>

Classic `.sln` is deliberately unsupported: it stores solution folders as
GUID-keyed project stanzas, and rewriting those mechanically risks corrupting a
file the whole team builds from. The script detects it and exits without
touching anything.

## Run it

```powershell
& "<skill-dir>\scripts\sync-solution-items.ps1"
```

`<skill-dir>` is the directory of this `SKILL.md`. The script defaults to the
git top level of the working directory; pass `-RepoRoot` for a different repo,
`-SolutionPath` when the root holds more than one `.slnx`, and `-DryRun` to see
the changes without writing them.

## What it does

- Adds a `<File>` entry for every file under `docs/` the solution does not list,
  creating the `<Folder>` chain it needs.
- Removes entries whose file no longer exists — a renamed document otherwise
  leaves a dead entry that breaks the solution view.
- **Skips whatever git ignores.** Build artefacts and generated intermediates
  live under `docs/` too — `__pycache__/`, a generator's `tables.json` — and
  listing them shows every developer a file that is not in the repo. `git
  check-ignore` is asked rather than re-implementing the matching, so nested
  ignore files and negations are honoured. Outside a git repo the filter is
  skipped, not guessed at.
- **Skips `00_Archive/`.** Archived material is deliberately out of the
  solution. An archive entry that is already listed and still exists on disk is
  left alone; the exclusion governs what gets added, not what gets kept.
- **Skips names starting with `_` or `.`**, checked over every path segment
  below `docs/`: `docs/_generator/` takes its whole contents with it however
  the files inside are named, and `docs/.gitignore` never appears. Tooling and
  generated scaffolding are not documents; the solution is for what people
  read and edit.
- Skips Office lock files (`~$*`) and OS junk (`Thumbs.db`, `.DS_Store`,
  `desktop.ini`) — these appear under `docs/` and are not documents.
- Preserves the file's existing line endings, BOM and indentation, so the diff
  is only the entries that actually changed.

Re-running is safe: with nothing to do it reports so and exits without writing.

## Report and commit

Repeat the script's summary line to the user — added, removed, folders created.
Silence here reads as "nothing happened", which is exactly the failure this
skill exists to prevent.

**The `.slnx` change belongs in the same commit as the documents that caused
it.** A commit that adds a spec and leaves the solution untouched is a commit
that has to be followed by a fix-up. When the calling skill stages `docs/`, make
sure the solution file is staged with it.

**Called directly, with no calling skill, you do not commit.** Report what
changed and leave the `.slnx` in the working tree for the user to stage with
whatever else they are committing. Committing here on your own initiative
would put a change into the repo's history that nobody asked for.
