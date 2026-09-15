# Company skills live in a separate plugin; this repo is public

On 15.09.2026 this repo went public, so colleagues can register it as a
marketplace. Everything that carries customer or company data moved out first:
a Jira-to-SPEC sync for one customer project, `css-review` and `dsgvo-audit`,
together with the PreToolUse hook that auto-approves the Jira wrapper, now live in the plugin
`cnx` (marketplace `cnx-skills`, an internal Azure DevOps repository).

**Why a second plugin and not a private branch or a filtered build:** a
marketplace is a whole repository. Anything reachable in it is public, and that
includes the git history. The moved skills hard-wire a customer's Jira host,
project key, vault names and a workspace link; none of that can be redacted
without making the skills useless internally. A separate repository is the only
cut that keeps both sides whole.

**Why the history was restarted instead of filtered:** GitHub keeps
`refs/pull/*` for every pull request, and those refs cannot be deleted. They pin
the old commits, so neither a force push nor `git filter-repo` removes them from
the public view. The repository was recreated with a single root commit; the
old history is archived outside the repo.

**What stayed, and why:**

- `sync-solution-items` stays in `smax`. It is generic (`.slnx` only), and
  `smax:writing-specs`, `smax:writing-plans` and `smax:domain-modeling` call it.
  Moved to `cnx`, those calls would run silently into nothing for everyone
  without the internal plugin — the failure
  [[0016-skills-are-cold-start-capable]] exists to prevent.
- `proad-job-report` and `mail-draft` stay. They name a product and a working
  context, not a customer, and carry no internal endpoints.

**The consequences:**

- **No skill in `smax` may call `cnx:`.** The dependency runs one way at most:
  `cnx` may call `smax:` skills, `smax` never knows `cnx` exists.
- **No customer names, internal hosts, account IDs or company mail addresses
  in this repo** — not in skills, docs, decisions, `TODOS.md` or examples.
  Placeholders or a generic term ("the customer repos") instead. A skill that
  cannot work without such data belongs in `cnx`.
- `README.md` and `plugin/NOTICE.md` list only what ships here; the moved
  skills are documented in the `cnx-skills` README.
