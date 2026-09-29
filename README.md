# smax — personal skill plugin

> ## ⚠️ EXPERIMENTAL
>
> In use since 2026-07-25. A lot is still changing all the
> time: how skills are cut, how the chains run, path conventions, which steps
> ask and which do not. **Expect breakage between two commits** and do not rely
> on a flow looking tomorrow the way it looks today.
>
> What *has* been deliberately decided is in [`docs/decisions/`](./docs/decisions/)
> — that is the stable core. What is currently open is in
> [`TODOS.md`](./TODOS.md). Everything else is in motion.

My personal Claude Code plugin. Skills under `plugin/skills/dev/` and `plugin/skills/personal/`, distributed through a marketplace of its own: this repo **is** the marketplace, and the plugin lives inside it under `plugin/`.

> Marketplace `smax-skills` · Plugin `smax` · Invocation prefix `/smax:`

Everything outside `plugin/` — `docs/` in particular — is **not** shipped.

## Installation

The repo is public — anyone can add it:

```
/plugin marketplace add https://github.com/Smax1988/smax-skills.git
/plugin install smax@smax-skills
```

Then run `/smax:setup` once per machine. It checks what the skills need that the plugin does not ship — Git, PowerShell 7, Node.js, Python, the Playwright MCP server, and optionally the GitHub CLI and Graphviz — and installs what is missing after you confirm each item. Windows only.

Update with `/plugin marketplace update smax-skills`, then `/reload-plugins`. If you develop on the plugin yourself, use the local source from [§6.2](#62-setting-up-the-dev-machine) instead.

Company- and client-specific skills are deliberately not here: they live in the internal plugin `cnx` (marketplace `cnx-skills`, Azure DevOps). Why: `docs/decisions/0025-company-skills-in-separate-plugin.md`.

---

# 1 · The workflow

## 1.1 From idea to landed branch

```
  Idea                     Draft                  Plan              Implementation      Landing
                                                                                       
  brainstorming ──┐                                                                    
  sharpen-me ─────┼──→ writing-specs ──→ writing-plans ──┬─→ subagent-driven-dev ──┐   
  sharpen-with-docs┘                                     └─→ executing-plans ──────┼──→ finishing-a-
                                                                                   │    development-
       ▲                    ▲                  ▲                                   │    branch
       └────────────────────┴──────────────────┴───────────────────────────────────┘         │
                    domain-modeling  ·  sync-solution-items                                  ↓
                    (cross-cutting, called from everywhere)                         commitMessage
```

You type **one** entry point. The chain pulls in the rest by itself.

Every link can also be **entered on its own**, though — a session can end at any point, and the next day you pick up somewhere in the middle. No skill assumes its predecessor ran in the same session (see `docs/decisions/0016-skills-are-cold-start-capable.md`).

## 1.2 What lands where

Everything under `docs/` belongs in the repo and gets committed. `.smax/` and `.worktrees/` are git-ignored scratch. `C:\Temp` deliberately leaves the project.

| Path | Created by | When |
|---|---|---|
| `docs/00_Analysis/<Slug>/ANALYSIS-<Slug>-DDMMYYYY.md` | `writing-specs` | assessment of something existing, without a build decision |
| `docs/01_Specs/<Slug>/SPEC-<Slug>-DDMMYYYY.md` | `writing-specs` | design for something that will be built |
| `docs/02_Plans/<Slug>/PLAN-<Slug>-DDMMYYYY.md` | `writing-plans` | implementation plan, task by task |
| `docs/03_DbChanges/<Slug>/DDMMYYYY-<Slug>.forward.sql` + `.rollback.sql` | implementer, as a task step | when the plan contains schema changes — here the date is a **prefix**, not a suffix |
| `CONTEXT.md` (repo root) · possibly `CONTEXT-MAP.md` | `domain-modeling` | as soon as the first term is settled — immediately, not at the end of the session |
| `docs/decisions/NNNN-slug.md` | `domain-modeling` | per decision that is hard to reverse + surprising without context + the result of a real trade-off |
| `CLAUDE.md` (project) | `domain-modeling` | two blocks: *Domänensprache* (imports `@CONTEXT.md`) and *Entscheidungen* (teaches the access pattern, imports **nothing**) |
| `.smax/sdd/<plan-basename>/` | `subagent-driven-development` | ledger `progress.md`, `task-N-brief.md`, `task-N-report.md`, review packages. Git-ignored. Deleted by `finishing-a-development-branch`, **only after** the branch has landed |
| `.worktrees/<branch>/` | `using-git-worktrees` | isolated workspace, if no native worktree is available |
| `C:\Temp\HANDOFF-<name>.md` | `handoff` | session handoff — describes a session, not the code, and therefore does not belong in the repo |
| `C:\Temp\REPLICATE-<name>.md` | `replicate` | recipe for this session's system/config changes |
| `C:\Temp\<name>.pdf` | `md-to-pdf` | generated artifact, not source |
| `MISSION.md`, `RESOURCES.md`, `NOTES.md`, `lessons/`, `reference/`, `learning-records/`, `assets/` | `teach` | in the respective learning workspace |

The **PascalCase slug** (`TipAllowance`) is set once in `writing-specs` and carried over unchanged by every downstream skill. The **date suffix** is functional: `subagent-driven-development` derives its workspace path from the plan's file name — without the date, two plans on the same topic share one ledger.

`Archive/` is written by no skill and never read as current context. Archiving is manual work.

## 1.3 What runs on its own — and what asks first

**Without asking:**

- task commits on the feature branch (it gets squashed and deleted anyway)
- entries in `CONTEXT.md` and `docs/decisions/` as soon as something is settled
- additions to the project `CLAUDE.md` — but never silently, what was changed is always stated
- detecting an existing worktree, setup, baseline tests
- dispatching implementer and reviewer subagents
- the *run* of `sync-solution-items` when a `.slnx` sits in the repo root — the calling skill makes the commit, and called directly it does not commit at all

**With asking** — anything that changes state outside the throwaway branch or destroys history (`docs/decisions/0008-confirm-git-actions-outside-branch.md`):

| Action | Where |
|---|---|
| The one design commit for spec + glossary + decisions + plan | end of `writing-plans` |
| Exception commit, when the chain already ends at the spec gate | `writing-specs` |
| Squash commit onto the base branch | `finishing-a-development-branch` |
| `git branch -D <feature>` | same, separate from the commit |
| `git push` | same, separate |
| Opening a pull request | same, **separate once more** from the push |
| Discarding work | same — only against the typed word `discard` |
| Creating a worktree · committing the `.gitignore` line | `using-git-worktrees` |

A yes to one of these actions is not a yes to the next.

## 1.4 The gates

Three places block instead of merely reminding:

- **Glossary gate** (`writing-specs`, `writing-plans`): no document and no plan while pinned terms are missing from `CONTEXT.md`. A terminology table *inside* the spec does not count — four mechanisms read `CONTEXT.md`, none reads the spec.
- **Review gate** (`finishing-a-development-branch`): no branch reaches the merge menu unreviewed. The only accepted evidence is a ledger line `Final review: clean (HEAD <sha7>)` whose SHA matches the current HEAD — not a recollection from the conversation.
- **Document reviewer** (`writing-specs`, `writing-plans`): a fresh subagent proofreads, `Issues` get fixed, exactly **one** re-review, then the human decides.

## 1.5 Decisions — the stable core

`docs/decisions/` records **what deliberately deviates from the obvious path here**. One file `NNNN-slug.md` each, written via `smax:domain-modeling`. Short — one to three sentences are enough; the value lies in *that* something was decided and *why*, not in filled-in sections.

**A decision is only created when all three apply:**

1. **Hard to reverse** — doing it differently later has a noticeable cost
2. **Surprising without context** — a later reader wonders "why on earth like this?"
3. **Result of a real trade-off** — there were alternatives, one was chosen for reasons

If any one is missing, none is created. Otherwise the directory dilutes into a changelog.

**Access is deliberately sparing.** The file name is the index: `ls docs/decisions/`, judge by title, open zero to two files. **Never read the whole directory** — it grows without bound, and loading everything crowds out exactly the context the task needs.

**It is read in four places, at four different moments:**

| Where | When exactly |
|---|---|
| `brainstorming` | step 1 of the checklist — before the first question, before any draft |
| `writing-plans` | when writing the plan header, in the `Global Constraints` block — before the tasks |
| `debugging` | before a mechanical explanation of the cause is accepted — not at the start of the search |
| `code-reviewer.md` | in the dispatched reviewer subagent, while it checks the diff |

The reviewer template is dispatched from **three** directions: a typed `/smax:code-review`, the review gate in `finishing-a-development-branch`, and the whole-branch review at the end of `subagent-driven-development`. The last two run without any action on your part — so the check reaches the code more often than "`code-review` is a command" would suggest.

**The everyday case is covered by none of the four** — "just do X", a quick refactor, no skill involved. For that, `domain-modeling` additionally writes the access pattern into the project `CLAUDE.md`, which is always in context. **Nothing** is imported: the block teaches the access, it does not load content. It also has no fixed trigger, though; it describes situations ("before you decide an architecture or design question", "before you fix something that looks oddly built") that the agent has to recognise by itself. That is the weakest point of the chain — and the one knowingly accepted, because the alternative would be an import that costs context in every session.

**Overruling is allowed, silently ignoring is not.** If a proposal runs against a decision, that is said, with the file name, before it is implemented. If the decision is actually overturned, the old one gets the status `superseded by Decision-NNNN` — nothing is ever deleted. Entries marked `superseded` or `deprecated` are no longer binding.

> **Known gap:** there is **no** check of decisions *against each other*. All four read sites check something else against a decision — draft, diff, code, reviewer objection. Whether two decisions contradict each other goes unnoticed unless both happen to be opened together. That is structural: a complete consistency check would have to read every file, and that is exactly what the access pattern above forbids. Anyone who wants to check consistency does it as a deliberate, rare pass — not as a standing rule.

---

# 2 · The commands

The second half of the plugin. The chain above is the long road from idea to landed branch — alongside it stand commands that each solve **one self-contained task** and have nothing to do with the workflow. Not an add-on: day to day I type them more often than any chain step.

**A command is a skill with `disable-model-invocation: true`** — **only I** can start it, Claude cannot, not even from inside another skill. A plugin cannot ship real slash commands (those only exist under `~/.claude/commands/`), so the flagged skill is the way to get there. Invocation is the same: `/smax:<name>`.

## 2.1 Standalone, outside the chain

These nine call no skill and are called by none. You type the name, done. Arguments are in the tables in §5.

| Command | Purpose |
|---|---|
| `replicate` | this session's system and config changes as a traceable recipe, to reproduce them elsewhere |
| `teach` | learn a topic guided instead of having it built — with mission, glossary and learning records |
| `infographic-page` | explain a topic as a standalone HTML page (dark layout, collapsible sections, one file) |
| `data-model-diagram` | draw a data model as a standalone HTML page — table cards with keys, rigid relationship lines, readable collapsed, with print mode |
| `proad-job-report` | turn a commit into the German work report that ends up on the client's invoice |
| `nano-vs-colors` | set up syntax highlighting for `nano` under Git Bash, or carry it over to another machine |
| `find-beer-deals` | find current beer deals nearby |
| `whats-for-lunch` | summarise today's lunch specials at the regular spots |
| `setup` | check and install what the skills need on this machine (Windows) |

## 2.2 Commands that do not stand alone

`brainstorming`, `code-review`, `sharpen-me` and `sharpen-with-docs` carry the same flag but are links of the workflow — they are in §1. Exactly this subset gives rise to the restriction in [§4 · Not invocable by the model](#not-invocable-by-the-model): a skill cannot invoke a command, even where the chain would have to continue at that point.

`lap-training` and `handoff` carry the flag as well and have not been in §2.1 since the handoff offer at the end of a session: `lap-training` calls `handoff` as a path, so "calls no skill and is called by none" no longer holds for either. They are not links of the workflow in §1.

**Not part of this group: `dispatching-parallel-agents`** — outside any chain, but not a command: Claude may trigger it by itself as soon as several independent tasks are pending.

---

# 3 · Where do I start?

| Situation | Entry point | What follows |
|---|---|---|
| **An idea, but no picture of it yet.** | `/smax:brainstorming` | exploration → `domain-modeling` → `writing-specs` |
| **Plan/decision is set — does it hold?** | `/smax:sharpen-me` | relentless interview, question by question → offer to record it as a SPEC |
| **Same, and the domain should grow along.** | `/smax:sharpen-with-docs` | as above, maintains `CONTEXT.md` and decisions on the side |
| **Pin down a term or record a decision.** | `/smax:domain-modeling` | `CONTEXT.md`, `docs/decisions/NNNN-slug.md`, access pattern in the project `CLAUDE.md` |
| **Spec is done, now build.** | `/smax:writing-plans` | plan → `using-git-worktrees` → SDD or `executing-plans` |
| **Plan is done, work through it.** | `/smax:subagent-driven-development` | one subagent per task, controller checks every report, one whole-branch review at the end |
| **Something is broken.** | `/smax:debugging` | cause before fix → `test-driven-development`, `verification-before-completion` |
| **Done — how does it get in?** | `/smax:finishing-a-development-branch` | review gate, squash landing → `commitMessage` |
| **Just the commit message.** | `/smax:commitMessage` | semantic message; with a body for squash branches |
| **Write or change a skill.** | `/smax:writing-skills` | structure, testing with subagents |
| **Understand something, not build it.** | `/smax:teach` | guided learning with mission, glossary, learning records |
| **Handoff to the next session.** | `/smax:handoff` | self-contained document to `C:\Temp` |
| **Reproduce machine changes.** | `/smax:replicate` | re-apply recipe to `C:\Temp` |
| **Study for the LAP** (Austrian apprenticeship final exam). | `/smax:lap-training` | exam round, progress in `log.md`/`progress.md` → offer to hand the weak spots to `/smax:teach` via `handoff` |

That is the way **into the chain**. The standalone commands come before it in [§2.1](#21-standalone-outside-the-chain) — they have nothing to do with the workflow.

---

# 4 · What I do not call directly

## Not invocable by the model

All **commands** (`disable-model-invocation: true`) can be typed **only by me** — Claude cannot start them by itself, not even from inside another skill. A practical consequence that has bitten three times:

- **`code-review`** is a command. An agent working through a plan cannot invoke it. That is why `writing-plans` additionally writes the **resolved file path** to the reviewer template into every plan (`docs/decisions/0017-reviewer-template-as-resolved-path.md`).

  **That does not mean the review is skipped.** Only the skill wrapper is blocked, not the template `code-reviewer.md`: `finishing-a-development-branch` dispatches it **automatically before the squash**, and `subagent-driven-development` does the same at the end of the branch — both without any action on your part. The path in the plan only covers the remaining case in which a plan is worked through without either of these two skills directing it.
- **`sharpen-with-docs`** is a command. `writing-specs` therefore calls `sharpen` + `domain-modeling` individually, not the wrapper.
- **`handoff`** is a command. At the end of a session `lap-training` offers to hand over the weak spots but cannot start the skill — so it reads `../../dev/handoff/SKILL.md` and follows it. `teach` is the same: the skill prints the invocation, you have to type it.

## Works, but skips a gate

| Skill | What is missing when called directly |
|---|---|
| `writing-specs` | the question *"should this be written down at all?"* — that comes from `brainstorming`/`sharpen-me`. Only useful directly when the thinking has already been done. |
| `writing-plans` | without a spec there are no requirements for the `Global Constraints`. The glossary gate still applies. |
| `finishing-a-development-branch` | without a matching SDD ledger, the review gate fires and reviews the whole branch again. Correct, but expensive. |

## Runs on its own anyway

The chain pulls these in by itself — they never **have** to be typed: `using-git-worktrees`, `domain-modeling`, `sync-solution-items`, `test-driven-development`, `verification-before-completion`.

**"Doesn't have to" does not mean "is pointless".** `domain-modeling` is the case that is both: the chain calls it as a cross-cutting concern (§5); typed directly, it starts a modelling session of its own — pin down terms, build up `CONTEXT.md`, record a decision. For a decision while no draft is in progress, calling it directly is even the only way.

## Superseded

`executing-plans` — `subagent-driven-development` is better in almost every case. The skill says so itself in its first note.

---

# 5 · All skills

Invocation with prefix: `/smax:<name>`. The name comes from the `name:` frontmatter — the group subfolder is purely organisational.

**Trigger:** *Command* = typed only by me · *Skill* = Claude can also trigger it by itself. The difference is explained in [§2](#2--the-commands).

### dev — workflow chain

Mostly derived from **superpowers** and reworked. Which file comes from where and how far it has diverged is in [plugin/NOTICE.md](./plugin/NOTICE.md), per file.

| Skill | Arguments | Trigger |
|---|---|---|
| brainstorming | — | Command |
| writing-specs | — | Skill |
| writing-plans | — | Skill |
| executing-plans | — | Skill |
| subagent-driven-development | — | Skill |
| using-git-worktrees | — | Skill |
| code-review | — | Command |
| finishing-a-development-branch | — | Skill |
| commitMessage | — | Skill |
| debugging | — | Skill |
| test-driven-development | — | Skill |
| verification-before-completion | — | Skill |
| dispatching-parallel-agents | — | Skill |
| writing-skills | — | Skill |

### dev — thinking & docs

`sharpen`, `sharpen-me`, `sharpen-with-docs`, `domain-modeling` and `teach` come from **mattpocock/skills**, the rest is my own. Here too: origin and depth of rework per file in [plugin/NOTICE.md](./plugin/NOTICE.md).

| Skill | Arguments | Trigger |
|---|---|---|
| sharpen | `[plan/decision/idea]` | Skill |
| sharpen-me | `[plan or decision]` | Command |
| sharpen-with-docs | `[plan or decision]` | Command |
| domain-modeling | — | Skill |
| sync-solution-items | — | Skill |
| teach | `[topic]` | Command |
| handoff | `[focus next session]` | Command |
| replicate | `[focus of changes]` | Command |
| infographic-page | `<topic> [focus]` | Command |
| data-model-diagram | `<model source (spec, DDL, schema)> [target path]` | Command |
| md-to-pdf | `<file.md> [more.md ...]` | Skill |
| setup | — | Command |

### dev — client & web tasks

| Skill | Arguments | Trigger |
|---|---|---|
| mail-draft | `[recipient / topic]` | Skill |
| proad-job-report | `[commit ref, default HEAD]` | Command |

### personal

| Skill | Arguments | Trigger |
|---|---|---|
| find-beer-deals | `<beer> [ZIP/town]` | Command |
| whats-for-lunch | — | Command |
| nano-vs-colors | — | Command |
| lap-training | `[minutes] \| simulation \| status` | Command |

### repo-local — this repo only

Lives under `.claude/skills/`, is **not** shipped and is only
available here. Invoked without a prefix.

| Skill | Arguments | Trigger |
|---|---|---|
| sync-plugin-docs | — | Skill |

Why not in the plugin: `docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`.

### Who calls whom

| Skill | Calls |
|---|---|
| `brainstorming` | `domain-modeling`, `writing-specs` |
| `writing-specs` | `domain-modeling`, `sync-solution-items`, `sharpen`, `writing-plans` |
| `writing-plans` | `domain-modeling`, `sync-solution-items`, `code-review` (as path), `commitMessage`, `subagent-driven-development`, `executing-plans` |
| `executing-plans` | `using-git-worktrees`, `subagent-driven-development`, `finishing-a-development-branch` |
| `subagent-driven-development` | `using-git-worktrees`, `code-review` (as path), `finishing-a-development-branch` |
| `finishing-a-development-branch` | `code-review` (as path), `commitMessage` |
| `debugging` | `test-driven-development`, `verification-before-completion`, `domain-modeling` |
| `writing-skills` | `test-driven-development` |
| `sharpen-me` | `sharpen`, `writing-specs` |
| `sharpen-with-docs` | `sharpen`, `domain-modeling`, `writing-specs` |
| `domain-modeling` | `sync-solution-items` |
| `lap-training` | `handoff` (as path) |

`domain-modeling` is the cross-cutting satellite — called by `brainstorming`, `writing-specs`, `writing-plans`, `debugging`, `sharpen-with-docs`. More incoming calls than any other skill.

`sync-solution-items` is the second satellite and applies **only** when there is a `.slnx` in the repo root. The callers check this beforehand and skip it without a word otherwise. In non-.NET projects the step simply does not exist.

---

# 6 · Development

Goal: **edit in the repo, commit, restart Claude, done.** No push, no `/plugin marketplace update`, no symlink.

## 6.1 Marketplace mechanics in four sentences

A *marketplace* is a catalogue (`.claude-plugin/marketplace.json`) and says which plugins exist and where they live. A *plugin* has its own manifest (`plugin/.claude-plugin/plugin.json`) and lists its skill directories. **Marketplace source and plugin source are two different things**: the marketplace source says where the catalogue comes from (GitHub, Git URL, local directory), the plugin source stands *in* the catalogue and here is a relative path (`./plugin`) — so the same repo. The marketplace is registered either via `/plugin marketplace add` or declaratively through `extraKnownMarketplaces` in the settings.

**With a `directory` source the plugin is read in place** — no copy lands under `~/.claude/plugins/cache/`, and the skill header points straight into the repo. The official docs say across the board that plugins are copied into the cache on install; for local sources that is not true (verified on 2026-07-31). The whole dev loop rests on exactly this.

## 6.2 Setting up the dev machine

**Clone the repo:**

```bash
git clone https://github.com/Smax1988/smax-skills.git C:/Projects/smax-skills
```

**Register it as a local marketplace source** in `~/.claude/settings.json` — a machine-specific path, which is why it does **not** belong in the repo:

```json
{
  "extraKnownMarketplaces": {
    "smax-skills": {
      "source": { "source": "directory", "path": "C:/Projects/smax-skills" }
    }
  },
  "enabledPlugins": {
    "smax@smax-skills": true
  }
}
```

No `/plugin install` needed — `enabledPlugins` is enough, Claude Code pulls in the marketplace at startup.

No `autoUpdate` — there is no upstream to pull. Updates happen with `git pull` in the repo. For the same reason `/plugin marketplace update smax-skills` has no effect here.

> If the machine was on the GitHub source before, changing the settings is **not** enough: Claude Code remembers the registration in `~/.claude/plugins/known_marketplaces.json` and the install state in `installed_plugins.json`. Remove both entries for `smax-skills` and `smax@smax-skills` respectively, then restart — they are recreated from the settings. Otherwise the old cache copy keeps running.

## 6.3 The loop

1. Edit `SKILL.md` under `C:\Projects\smax-skills\plugin\skills\…`.
2. Commit.
3. Restart Claude.
4. Invoke `/smax:<skill>`.

**Why restart and not `/reload-plugins`:** Claude Code freezes skill contents **at session start**, not at invocation. A running session does not see later changes to a `SKILL.md`, no matter when the skill is invoked. Forget this and you will take a freshly built fix for ineffective, because it was never loaded.

**Always edit the source** — never a copy under `~/.claude/plugins/cache/`.

**Why commit even though the working tree is read:** technically it is not necessary — with the local source an edit takes effect after the restart even uncommitted. The commit is discipline: it ensures that the version you test is also the one that arrives on the other machines, and it is the way back if a skill behaves oddly after the change.

## 6.4 Which version is running right now?

The question as soon as a change "doesn't work".

**The one proof:** invoke any skill and read the first line of the injected text.

```
Base directory for this skill: C:\Projects\smax-skills\plugin\skills\dev\<skill>
```

If it points into the repo, the local source is running. If it points to `~/.claude/plugins/cache/…`, a cache copy is running — then the setup is wrong, see the box in 6.2. This is the only check that proves rather than guesses, and it works in both modes of operation.

If it comes out unexpectedly, these two narrow it down:

```bash
cat ~/.claude/plugins/known_marketplaces.json       # which source is registered?
ls -d ~/.claude/plugins/cache/smax-skills/smax/*/   # are cache copies still lying around?
```

> **Cache timestamps prove nothing.** On 2026-07-31 a cache copy carried a brand-new timestamp and still contained the version from two days earlier — that cost the diagnosis a round. With a `directory` source nothing should be there anyway; whatever is still there is leftover and can go.

## 6.5 Switching a machine back to non-dev

For computers that should only use the plugin:

```json
{
  "extraKnownMarketplaces": {
    "smax-skills": {
      "source": { "source": "git", "url": "https://github.com/Smax1988/smax-skills.git" },
      "autoUpdate": true
    }
  }
}
```

Then remove the `smax-skills` entry from `known_marketplaces.json` and `smax@smax-skills` from `installed_plugins.json`, and restart — otherwise the local registration stays in place.

With `autoUpdate`, Claude Code fetches new commits automatically after session start (delay up to ~10 min); the **active** session only loads them after `/reload-plugins`. Without `autoUpdate`, manually:

```
/plugin marketplace update smax-skills
/reload-plugins
```

**Versioning:** `version` is deliberately omitted from `plugin.json` → every commit counts as a new version. Only set a `version` field if I want controlled releases.

**Enable/disable without uninstalling:**

```
/plugin disable smax@smax-skills
/plugin enable  smax@smax-skills
```

> Remove an old clone under `~/.claude/skills` — otherwise the skills are there twice (`/handoff` **and** `/smax:handoff`). The same applies to slash commands of the same name under `~/.claude/commands/`: they shadow the plugin skill.

## 6.6 Testing without any installation

Applies to that one session only:

```
claude --plugin-dir C:/Projects/smax-skills
```

## 6.7 Adding a new skill

1. Create `plugin/skills/dev/<name>/SKILL.md` (or `personal/`).
2. Frontmatter:
   ```yaml
   ---
   name: <name>                         # = invocation name, kebab-case
   description: <when/what for>         # triggers only, never summarise the flow
   argument-hint: [optional]            # only if the skill takes parameters
   allowed-tools: Tool, mcp__server__*  # only if it should be restricted
   disable-model-invocation: true       # makes the skill a command
   ---
   ```
3. Commit, restart.

For skills, `allowed-tools` is a **hard restriction**, not an auto-approve list — a skill that writes needs `Write` in the list.

**Never** let the `description` summarise the flow: agents then follow the description instead of the skill text. Trigger conditions only. Details in `writing-skills`.

**Repo-local instead of plugin.** A skill that only makes sense in *this* repo
goes to `.claude/skills/<name>/SKILL.md`. No entry in the plugin manifest,
no marketplace, there after a restart. It does **not** appear in
`plugin/NOTICE.md` — that lists shipped files and their upstream origin,
and neither applies here. Invoked without the `smax:` prefix.

The flip side: **no plugin skill may reference it.** The path exists
in no other repo, and the reference would silently lead nowhere there.

## 6.8 Adding a new group

1. Create the folder `plugin/skills/<group>/`.
2. Add the path to `plugin/.claude-plugin/plugin.json`, otherwise the group is not found:
   ```json
   { "skills": ["./skills/dev", "./skills/personal", "./skills/<group>"] }
   ```
   Paths are relative to the **plugin** root (`plugin/`), not the repo root. The invocation name does not change.

---

# 7 · Background

## Structure

```
.claude-plugin/
└── marketplace.json           # marketplace (name: smax-skills)
plugin/
├── .claude-plugin/
│   └── plugin.json            # plugin manifest (name: smax)
├── NOTICE.md                  # origin of the derived files, one section per upstream
└── skills/
    ├── dev/<skill>/SKILL.md
    └── personal/<skill>/SKILL.md
docs/                          # not shipped
├── 00_Analysis/ 01_Specs/ 02_Plans/ 03_DbChanges/
└── decisions/                 # NNNN-slug.md — why this repo deviates
CLAUDE.md                      # project instructions, always in context
TODOS.md                       # open work, numbered and grouped
```

## Decisions

See [1.5](#15-decisions--the-stable-core) — they belong to the workflow, not to the appendix.

## Origin

**Two upstreams, both MIT.**

The workflow part is derived from **superpowers** (Jesse Vincent) and reworked: references to `smax:`, working directories to `.smax/`, document paths to this repo's `docs/` convention, plus changes in substance.

Five skills come from **mattpocock/skills** (Matt Pocock): `sharpen`, `sharpen-me`, `sharpen-with-docs`, `domain-modeling` and `teach`. The three `sharpen*` were called `grill*` upstream — the rename erased the origin from the file name and kept the second upstream out of the NOTICE from its first day until 2026-08-04.

Everything else is my own. Upstream state, file list, classification and licence text per upstream in [plugin/NOTICE.md](./plugin/NOTICE.md) — the *why* in `docs/decisions/`.

## Multiple machines / two git accounts

Public GitHub repo, separate from the company Azure DevOps (where `cnx-skills` lives), credentials separated per host (GCM account popup on access). Reading needs no account. Pushing is allowed for the private GitHub account and, from the company device, the company GitHub account as a collaborator. No `smax` skill calls a `cnx` skill.

## Line endings

`.gitattributes` enforces LF everywhere — no CRLF/LF churn across machines.

---

*If you change the marketplace or plugin name, update it here and in both manifests (`.claude-plugin/marketplace.json`, `plugin/.claude-plugin/plugin.json`).*
