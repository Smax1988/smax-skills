# The requirement list lives centrally in the setup skill; `sync-plugin-docs` guards it

The plugin's requirements — programs on `PATH`, MCP servers — are listed in
**one** file inside the setup skill, `plugin/skills/dev/setup/requirements.md`.
Skills do not declare them themselves. Which skills need a requirement is
derived from the skill inventory, so the list is a derived document, and
`sync-plugin-docs` keeps it from drifting the same way it keeps `README.md` and
`plugin/NOTICE.md` from drifting.

**Considered: declaring requirements per skill** (a frontmatter field or a file
next to each `SKILL.md`), with the setup skill collecting them. That would put
the fact next to its cause. It was rejected for three reasons:

- A frontmatter field that Claude Code does not know is dead weight in every
  skill load, and the harness gives no validation for it. A typo would be as
  silent as a missing line in a central list.
- How to check and how to install a requirement belongs to the requirement, not
  to the skill. `node` is needed by three skills. Declared per skill, the
  install command would sit in three places or in a fourth one after all.
- Collecting means the setup skill reads thirty directories on every run to
  build a list that changes a few times a year.

**The price is drift**, and that is why the guard is not optional. The column
*which skills need it* has a source outside the list: the requirement's
**signature** in the skill's directory. `sync-plugin-docs` already runs on every
change under `plugin/skills/`, so the check needs no trigger of its own.

**A signature hit is evidence, not proof.** `npm test` in a TDD example and
`flow-node` in an HTML template contain the same strings as a real requirement.
Following [[0019-write-sourced-present-the-rest]], an added or removed hit is
therefore presented, not written. The only cases written silently are a skill
that is deleted or renamed. Whether a requirement is mandatory or optional for a
skill has no source at all and is always asked.

**Known gap: a new requirement without a signature is invisible.** A skill that
starts calling a program the list does not know yet produces no hit, because
there is nothing to search for. The one partly sourced case is `allowed-tools`
naming an `mcp__<server>__` prefix that the list does not carry, and
`sync-plugin-docs` reports that. Everything else is caught by the author or by
the next fresh machine. This is the same structural gap as the safety net's
"cannot find what is missing".

**One sweep base for all three documents.** On `main`, the sweep base becomes
the newest commit that touched `README.md`, `plugin/NOTICE.md` *or* the
requirement list. That widens the blind spot accepted in
[[0020-sweep-baseline-keeps-blind-spot]]: maintaining the list now also resets
the window for README and NOTICE. A separate base per document would be exact,
but it needs three base lines and three coverage marks in every report, and it
buys that for a case the branch base already covers completely. The branch base
is unchanged.

**The setup skill is excluded from the signature scan.** Its requirement list
contains every signature by construction. Its own requirements are Git Bash,
`powershell.exe`, `winget` and `claude`. They come with Windows or with Claude
Code, or the skill checks them itself, so they are not rows.

**Scope boundary.** The list covers only what `smax` skills need. The
PowerShell SecretStore is required only by `cnx` skills, and its setup belongs
there ([[0025-company-skills-in-separate-plugin]]).
