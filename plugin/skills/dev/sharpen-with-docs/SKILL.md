---
name: sharpen-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (Decisions and glossary) as we go.
argument-hint: [plan or decision to stress-test]
disable-model-invocation: true
---

Run a `/smax:sharpen` session, using the `/smax:domain-modeling` skill.

Never write secrets (API keys, passwords, tokens) or personal data (PII) into the generated `CONTEXT.md` or Decisions — they are committed and shared; use placeholders instead.

**Write terms down as they settle, not at the end.** One settled term is enough to create `CONTEXT.md`; one choice that is hard to reverse, surprising without context and the result of a real trade-off is enough to create a Decision. Never park them for a document you have not written yet, and never let a terminology table end up inside the spec instead of in `CONTEXT.md` — four downstream mechanisms read that file and nothing reads the spec.

When the interview is done, **decide the document type yourself and name it in the question:**

| The session produced | Type |
|---|---|
| a design for something that is to be built | **SPEC** |
| an assessment or investigation of something that already exists, with no decision to build | **ANALYSIS** |

> "Should I write this up as a **SPEC** document, or is thinking it through enough for now?"

Only ask *which* type when the session genuinely produced both — then say so and let the user pick, or point out it is two documents. Do not ask as a reflex.

**"No" is a valid outcome, not an abort.** The session ends there without a spec — the glossary and Decision entries written during the interview stay, they are the point of this variant. State what was decided in a sentence or two and stop.

**"Yes" → invoke `smax:writing-specs`, passing the type you named.** It owns the path, the filename, the reviewer dispatch, the user gate and the handoff to planning. Do not write the document yourself.
