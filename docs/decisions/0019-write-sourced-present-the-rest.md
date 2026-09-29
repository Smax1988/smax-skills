# `sync-plugin-docs` writes silently what has a source — the rest gets presented

**The criterion is the source: does the fact have one outside the derived
document?** Frontmatter, directory structure, a call in a skill body, a git
command — then the skill writes without asking. If there is none, the fact is at
home in the very document being edited; then the skill does draft the wording,
but **never writes silently** — it puts old and new side by side and takes a
confirmation.

**Why not "verifiable" as the criterion, and not "table versus prose".** Both
sound right and are undecidable in the individual case. "Which file is the
source?" is decidable: either you look it up, or you find there is nothing to
look up. Two borderline cases where the other two criteria turn the wrong way:

- The number in README §2.1 ("These **eight** call no skill…") sits in the
  middle of prose and is **written silently** — its source is frontmatter and
  calls.
- Which of the three `dev` groups a new skill belongs to sits in a **table** and
  is **presented** anyway — that classification exists only in the README itself.

**What has no source:** the choice of `dev` group, the entry-point table in §3,
the judgements in §4, the satellite paragraphs, §6.x, and in `plugin/NOTICE.md`
the question of *which* bucket a file belongs in. That it has left its bucket, by
contrast, is evidenced — `git diff --numstat` against the import commit says so.
*(Superseded: the import commit is gone; that a file in a bucket changed is now
evidenced by the diff against the comparison base —
[[0026-notice-anchors-upstream-not-own-history]].)*

**The failure mode this is built against** is silently written prose: plausibly
worded, in the author's voice, and unnoticeable while skimming a supposedly
mechanical diff. A fact without a source is a statement made in the author's
name — there is nothing there to look up, only something to decide, and deciding
is the author's business.

**And it prevents error amplification.** The skill takes the rules by which it
writes the README from the README. Where a source exists that is harmless: if the
document says something other than the source, the source is right. Where none
exists, it could only perpetuate an existing error — a misfiled skill would stay
misfiled, and the next one would be filed after that example. That is exactly why
it asks there instead of writing.

**Both edges were rejected.** *Only reporting the sourceless* ("§4 no longer
fits") is half the job: the skill knows what changed and still leaves the user to
do the wording. *Writing everything silently* saves the question and buys the
failure mode above. The confirmation is the price for avoiding both, and it comes
up rarely: what has a source moves on every change; the sourceless only on a new
skill, a deleted skill, or a flipped classification. A typical run has zero or one
such point.
