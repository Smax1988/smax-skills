# Reviewers are dispatched one-shot and unnamed

Superpowers says "dispatch a general-purpose subagent" and leaves the transport
open. With agent teams enabled, a *named* agent is a plausible choice — and the
wrong one. All five dispatch sites and all three templates now prescribe:
reviewers strictly one-shot and without a `name`, their final text **is** the
report.

**The finding the rule comes from** (second test run, evidenced from both
transcripts): run 1 used four agent calls without a `name` and worked. Run 2
used a named `spec-reviewer` — which thereby became an addressable teammate,
went idle twice without sending its report, and had to be chased. The re-review
went to that same agent via `SendMessage`; it answered out of its own snapshot
and resent its first report, with line numbers from before the corrections. That
burned the one permitted re-review on a word-for-word repetition — the
corrections were never independently checked, but looked as if they had been.

**Three rules follow:** every re-review is a fresh agent with a fresh diff, never
a message to the old one. Templates read the file from disk, not from memory.
And findings quoting content the file no longer has count as stale, not as open.

**Implementers stay explicitly named and addressable**, because fix rounds 1–3
continue that very agent. Only reviewers are one-shot — unifying the two breaks
the fix loop.
