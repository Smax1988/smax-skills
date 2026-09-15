# The reviewer template goes into the plan as a resolved path

The `## Before Landing` block that `smax:writing-plans` writes into every plan
names, for the agent case, an **absolute path to `code-reviewer.md`, resolved at
plan-writing time** — neither a repo-relative path nor merely a mention of
`smax:code-review`. If it does not resolve, the skill **asks**.

**Why:** both obvious alternatives fail, and they fail silently.

- A repo-relative path (`skills/dev/code-review/code-reviewer.md`, the original
  state) is relative to *this* plugin repo. The plan, however, lands in the
  target project, where that directory does not exist. The path resolves to
  nothing, the agent finds nothing, the review is skipped — with no error.
- Naming just the skill does not work either: `smax:code-review` carries
  `disable-model-invocation: true`. A human can type `/smax:code-review`; an
  agent gets a refusal from the skill tool. An agent-driven plan would be given
  an instruction it *cannot* follow.

This is the only safeguard for a plan that is worked through by hand:
`smax:subagent-driven-development` dispatches its own final review,
`smax:finishing-a-development-branch` carries a blocking gate — whoever works the
plan line by line passes neither, unless the plan tells them to.

**Why it asks on failure instead of searching:** the path can go stale. When the
plugin is served from a remote source it sits under a version-hashed directory
(`~/.claude/plugins/cache/<marketplace>/<plugin>/<hash>/`) that changes with
every update, and older states stay lying around next to it.

The first version of this decision therefore also wrote a search line into the
plan. That line searched the plugin cache — which does not exist at all for a
local `directory` source. So the net was dead on precisely the machine that
writes most of the plans, and looked like a safeguard while being one. A path
that fails loudly and asks is more reliable than a second mechanism that
silently finds nothing.

**The trade-off:** a machine-specific path in a committed document is ugly and
not portable. It will look like an oversight on reading, and the obvious "fix" is
exactly the state that does not work. The plan is not a portable artefact anyway
— it names repo paths, commit ranges and tools of this environment. A path that
resolves beats a clean one that does not.

Related: [[0016-skills-are-cold-start-capable]] — the same logic one level up,
applied to the plan document instead of the skill.
