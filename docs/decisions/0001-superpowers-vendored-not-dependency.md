# Superpowers is vendored, not taken as a dependency

The workflow half of this plugin comes from **superpowers 6.2.0** (MIT,
© 2025 Jesse Vincent, commit `eccd4530`). Instead of installing superpowers as a
dependency and placing our own skills next to it, 13 skills were copied into
this repo and adapted while copying. There is no plugin dependency left.

**Why:** the adaptations are not cosmetic — path conventions, glossary wiring,
git rules and half of the SDD mechanics reach deep into the text of the skills
(see [[0002-own-doc-convention-not-superpowers-plans]],
[[0004-domain-model-as-cross-cutting]], [[0006-sdd-without-per-task-reviewer]]).
None of that is expressible as an overlay on top of somebody else's plugin, and
every upstream update would have overwritten the changes.

**The price:** upstream improvements do not arrive on their own. They have to be
pulled across by hand, and by comparing **upstream against upstream**
(`git diff v6.2.0..v<new> -- skills/<name>/`) in a separate clone — not against
the files in this repo, which are deliberately divergent. The anchor point for
that lives in `plugin/NOTICE.md`, because the plugin cache disappears when
superpowers is uninstalled and the starting state cannot be reconstructed from
the system afterwards.

**Implemented in:** `plugin/NOTICE.md` (provenance, derived files, MIT licence
text), commit `c1e7d9e`.
