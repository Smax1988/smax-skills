---
name: sharpen-me
description: A relentless interview to sharpen a plan or design.
argument-hint: [plan or decision to stress-test]
disable-model-invocation: true
---

Run a `/smax:sharpen` session.

When the interview is done, **decide the document type yourself and name it in the question:**

| The session produced | Type |
|---|---|
| a design for something that is to be built | **SPEC** |
| an assessment or investigation of something that already exists, with no decision to build | **ANALYSIS** |

> "Should I write this up as a **SPEC** document, or is thinking it through enough for now?"

Only ask *which* type when the session genuinely produced both — then say so and let the user pick, or point out it is two documents. Do not ask as a reflex.

**"No" is a valid outcome, not an abort** — this skill is often used purely as a thinking tool. The session ends there with no file. State what was decided in a sentence or two and stop.

**"Yes" → invoke `smax:writing-specs`, passing the type you named.** It owns the path, the filename, the reviewer dispatch, the user gate and the handoff to planning. Do not write the document yourself.
