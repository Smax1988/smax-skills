# teach stays here although a company plugin carries a copy

By company directive, `teach` is to be placed in an internal company plugin as
well; which one was still open on 14.10.2026. It stays in `smax` too. The
duplication is deliberate, not a leftover from an incomplete move.

**Why not move it out:** the private machine has only `smax` installed, not the
company plugin. `lap-training` calls `smax:teach`; with `teach` gone, that
call would run into nothing — [[0016-skills-are-cold-start-capable]] — and
pointing it at the company plugin is ruled out by
[[0025-company-skills-in-separate-plugin]].

**Why the duplication is cheap:** `teach` sets `disable-model-invocation: true`,
which keeps it out of the model's context entirely. Where both plugins are
installed, the visible cost is a second entry in the slash-command menu. There
is no supported way to hide a single skill of an installed plugin
(`skillOverrides` excludes plugin skills), so the second entry is accepted.

**Rules that keep maintenance in one place:**

- **This copy is the master.** The company copy is taken over from here,
  including the one deviation from upstream recorded in `plugin/NOTICE.md`.
  Changes land here first and are then carried over.
- **Both copies stay as close to upstream as they are today.** Maintenance then
  means an upstream sync, done the same way in both places. An own extension in
  either copy makes them diverge, and from that point the maintenance really is
  double — such an extension needs its own decision.

**Rejected alternatives:** a standalone `teach` plugin referenced by both
marketplaces, keeping it only here with the company marketplace pointing at
`smax`, a copy synced by submodule or script, and using the upstream original
on the private machine. The first two do not put `teach` into the company
plugin itself. The submodule or script copy and the upstream original were
turned down without a recorded reason.
