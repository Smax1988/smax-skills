# `plugin/NOTICE.md` anchors to the upstreams only, never to this repo's history

On 15.09.2026 the repo was republished with a fresh history. The superpowers
import commit, which `NOTICE.md` and `sync-plugin-docs` both used as a
reference, is not part of it. **Since then no fact in `NOTICE.md` and no source
in `sync-plugin-docs` refers to a commit of this repo.** The only anchors are
the upstream commits in the header tables of NOTICE §1 and §2.

**Why this does not lose anything:**

- **The drift number is gone, not replaced.** `git diff --numstat` against the
  import commit measured drift since the import, never the distance from the
  upstream — the import already carried the `smax:` adaptations. The bucket
  followed the anchor comparison all along. What the skill needs is that a file
  in a bucket changed, and the diff against the comparison base shows that. This
  replaces the sentence in [[0019-write-sourced-present-the-rest]] that says
  leaving a bucket is evidenced by the diff against the import commit.
- **The list *Älter als der Import* in NOTICE §3 is closed.** No skill becomes
  older than the import after the fact, so a new skill of our own always goes
  under *Danach entstanden*. That rule is the source for the write verdict; the
  `git ls-tree` against the parent of the import commit is no longer needed.

**Considered and rejected:**

- *The root commit of the new history as the new reference* — the same failure
  the next time the history is rewritten.
- *Blob hashes per file, recorded at import* — the blobs are missing from the
  public history just like the commit.
- *A frozen snapshot of the imported files in the repo* — another source of
  truth that drifts on its own, the kind [[0020-sweep-baseline-keeps-blind-spot]]
  rejects.
- *The upstream as the comparison base of the skill* — needs a clone, and
  `sync-plugin-docs` does not clone. The anchor comparison stays a manual step
  described in NOTICE.

**For whoever reintroduces a commit hash of this repo into NOTICE or the skill:**
the history is not guaranteed to survive. Datable facts go in as dates.
