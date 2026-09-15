---
name: proad-job-report
description: Turns the last commit into a German work report for PROAD that shows up on the customer's invoice
argument-hint: [commit ref, defaults to HEAD]
disable-model-invocation: true
---

Write a work report from the last commit. Base it on the commit message and, where it helps, on the question you were originally asked (prompt).

If a commit ref was passed as an argument (**$ARGUMENTS**), use it instead of `HEAD`.

**The report is written in German**, in nominal style (*Nominalstil*) where possible, and as short as possible.
Write it so the customer the work was done for understands what it is about, while it also stays clear internally what was done.
This work report appears on the customer's invoice.

**No internal details go out.** The report goes to the customer: no file paths, no branch or ticket names, no credentials, no third-party names from the diff.
