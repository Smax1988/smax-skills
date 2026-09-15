# Spec Document Reviewer Prompt Template

Use this template when dispatching a spec document reviewer subagent.

**Purpose:** Verify the spec is complete, consistent, and ready for implementation planning.

**Dispatch after:** The document is written to `docs/00_Analysis/<Slug>/` or `docs/01_Specs/<Slug>/`.

**Dispatch as a one-shot subagent with no name.** The report is the agent's final message. A named agent becomes an addressable teammate whose report never arrives as a return value. A re-review uses a **fresh** agent, never this one again.

```
Subagent (general-purpose):
  description: "Review spec document"
  prompt: |
    You are a spec document reviewer. Verify this spec is complete and ready for planning.

    **Spec to review:** [SPEC_FILE_PATH]

    **Read the file from disk now, before judging anything.** Do not review
    from memory or from any earlier reading — quote line numbers as they are
    in the file you just read. If you are asked to re-check after fixes,
    read the file again first; the content will have changed.

    **Your final message is the report.** Nothing else reaches the
    controller — not intermediate notes, not free-text output along the way.
    Put the complete report in your last message and end there.

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Completeness | TODOs, placeholders, "TBD", incomplete sections |
    | Consistency | Internal contradictions, conflicting requirements |
    | Clarity | Requirements ambiguous enough to cause someone to build the wrong thing |
    | Scope | Focused enough for a single plan — not covering multiple independent subsystems |
    | YAGNI | Unrequested features, over-engineering |
    | Domain language | Terms used in a sense that conflicts with `CONTEXT.md` (or the contexts in `CONTEXT-MAP.md`); domain terms introduced without a glossary entry. |
    | Glossary placement | **This is an issue, not a nitpick.** Does the document define domain terms inline instead of pointing at `CONTEXT.md`? Does `CONTEXT.md` exist at all — and if not, does the document merely *note* that it should be created later? Both mean the glossary is invisible to the code reviewer, the plan's Global Constraints, the implementer dispatch and the `CLAUDE.md` import. |
    | Decisions placement | Sections restating the reasoning behind choices that are hard to reverse, surprising without context, and the result of a real trade-off — those belong in `docs/decisions/` with the document linking to them. Several inline `### E<n>`-style sections are that many missing Decision files. |

    ## Calibration

    **Only flag issues that would cause real problems during implementation planning.**
    A missing section, a contradiction, or a requirement so ambiguous it could be
    interpreted two different ways — those are issues. Minor wording improvements,
    stylistic preferences, and "sections less detailed than others" are not.

    Approve unless there are serious gaps that would lead to a flawed plan.

    ## Output Format

    ## Spec Review

    **Status:** Approved | Issues Found

    **Issues (if any):**
    - [Section X]: [specific issue] - [why it matters for planning]

    **Recommendations (advisory, do not block approval):**
    - [suggestions for improvement]
```

**Reviewer returns:** Status, Issues (if any), Recommendations
