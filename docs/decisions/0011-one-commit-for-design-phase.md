# One commit for the whole design phase

`smax:writing-specs` commits nothing. The spec, the `CONTEXT.md` changes, the
`docs/decisions/` entries and the plan all stay in the working tree and land as
**one** commit at the end of `smax:writing-plans`.

**Why:** they are one unit of thought. A plan without its spec is not
reviewable, a spec without its glossary is not enforceable, and splitting them
produces a history in which no single commit is a complete, coherent state. As a
side effect, a sharpening session that reaches back into the glossary afterwards
costs nothing — the tree is still dirty.

**The one exception:** if the user aborts at the user gate, or the spec is the
entire result, `writing-specs` commits there — unversioned work that nothing
downstream will pick up is work on its way to being lost. That commit is asked
about first too, see [[0008-confirm-git-actions-outside-branch]].

**Known edge:** in a repo with other doc work open, `git add docs/` pulls that in
as well. The skill therefore says to check what is staged before committing and,
in doubt, to stage by explicit path.
