# Decisions get an entry in the project's `CLAUDE.md`

The four read sites from [[0005-decisions-with-four-read-sites]] only take effect
when the skill in question runs — and two of them (`brainstorming`,
`code-review`) are `disable-model-invocation`, so they only run when typed. The
most common case in everyday work, though, is the change made **without any skill
invocation at all**: "do X", "fix Y", a quick refactor. `docs/decisions/` was
never read in any of those. That is precisely how a deliberate deviation gets
taken for an oversight and "repaired".

`smax:domain-modeling` therefore writes a second block into the project's
`CLAUDE.md` — next to the glossary block — as soon as the first Decision exists.
`CLAUDE.md` is the only place that is in context independently of which skill is
running.

**The block carries an access pattern, not content:** `ls docs/decisions/`, judge
by filename, open zero to two files. Plus when to look, when explicitly not
(typos, formatting, obvious bugfixes), and that contradicting a Decision has to
be said out loud rather than happening silently.

**Nothing is imported.** No `@docs/decisions/…`, not even for an index file. An
import pulls content into *every* session — which is the exact failure the block
exists to prevent, and the cost would grow with the directory. As it stands the
block costs a good dozen lines whether the project has three Decisions or three
hundred. The paragraph "never read the whole directory" is the most expensive
part of the block, and the part that has to be brought forward when an older
version is found.

**Known remaining gap:** the check runs inside `domain-modeling` — at start-up and
right after the first Decision. A project that creates Decisions by hand and
never invokes the skill stays unwired. That is the deliberately accepted
remainder: the alternative would be copying the check into every skill.
