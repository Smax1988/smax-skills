# Skills are cold-start capable, even at the price of duplication

Every skill in these chains has to work on its own when it is the first skill
invoked in a fresh session — the session before it may have ended at any point.
Each skill therefore carries the rules it needs itself, even where the same text
was already loaded by a predecessor on the happy path.

**Why:** the happy path is not the normal case. A plan is written today and
executed tomorrow; `smax:subagent-driven-development` is almost always entered
cold. `smax:writing-plans` (lines 24, 317) and `smax:writing-specs` (line 21)
handle the cold start explicitly, and `smax:commitMessage` (line 26) falls back
to `git log` when the plan is missing. `smax:brainstorming` even has an exit
that **never** reaches `writing-specs` ("'No' is a valid outcome"), so that its
gates never take effect on that route.

**The trade-off:** duplicated text costs context on every run that loads both
skills. The alternative — concentrating the rules in the first skill of the
chain and pointing back to them later — saves those tokens and makes every cold
start incomplete, silently and without an error message. That is the more
expensive failure.

**The consequence for trimming:** cross-skill deduplication is forbidden where
the target skill can be entered cold — and practically all of them can. What
stays allowed and welcome: redundancy **within** one file (a flow diagram
retelling the prose beside it), moving reference material into a file one level
down, and shortening justification prose to a subordinate clause — the reason
has to stay wherever the rule stands, or the rule stands there unmotivated (see
[[0007-reviewer-one-shot-and-unnamed]]).

One special case stays permitted: a caller may shorten the *precondition* of a
target skill to a single line when the target skill carries it as a hard gate
itself — it then carries only the condition and the call, not the reasoning.
Handled that way for `smax:sync-solution-items`.

**Distinction from [[0003-writing-specs-as-own-skill]].** There, a sequence
needed three times over was split out into a skill of its own — which sounds
like deduplication, and is. The difference is decisive: the extracted skill gets
*invoked*, so the content still arrives. What is forbidden here is the other
thing: **removing** a rule from skill B because skill A already says it — then it
is missing the moment B is entered cold. Anyone citing 0003 as precedent for
trimming has to check that boundary.
