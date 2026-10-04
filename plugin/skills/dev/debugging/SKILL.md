---
name: debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- Manager wants it fixed NOW (systematic is faster than thrashing)

## The Four Phases

You MUST complete each phase before proceeding to the next.

There is one exit: if Phase 1 shows the reported behavior is already
prevented, the process ends after Phase 1. See the exit section right after it.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - They often contain the exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess
   - If the data shows code that blocks the reported path → see *Exit: The
     Reported Behavior Is Already Prevented* below

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

5. **Trace Data Flow**

   **WHEN error is deep in call stack:**

   See `root-cause-tracing.md` in this directory for the complete backward tracing technique.

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Exit: The Reported Behavior Is Already Prevented

**Take this exit only when all three hold:**
- You followed the path the report describes — the steps a user or caller
  can actually take.
- The reported behavior did not occur.
- You can point at the code that stops it: file, line, and why it blocks
  that path.

"Can't reproduce, and I don't know why" is not this exit — gather more data.

When all three hold, that is a result, not an incomplete investigation.
Phases 2–4 do not apply: there is no defect to fix.

**Report, change nothing:**
1. The reproduction you attempted and what happened.
2. The guard: file, line, and why it blocks the reported path.
3. What you could not check — other entry points, a version or environment
   you don't have.

Then stop. No file changes.

**None of these is a fix:**
- Moving the guard "to where it belongs" — from display to state, from
  caller to callee.
- Adding a second guard "for defense in depth".
- A failing test that reaches past the guard — calling an internal function
  directly, setting state by hand. It shows the internals don't guard
  themselves. It does not show the reported bug exists.

If you think the guard sits in the wrong place or is too weak, say so in the
report. Restructuring working code is a separate assignment, and your human
partner decides whether it happens.

If another path a user can actually take does produce the behavior, that is a
reproduction — continue with Phase 2.

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - If implementing pattern, read reference implementation COMPLETELY
   - Don't skim - read every line
   - Understand the pattern fully before applying

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - What settings, config, environment?
   - What assumptions does it make?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use the `smax:test-driven-development` skill for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?
   - Use the `smax:verification-before-completion` skill before claiming success

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If ≥ 3: STOP and question the architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes**

   This is NOT a failed hypothesis - this is a wrong architecture.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**
- **Each fix reveals new problem in different place**

**ALL of these mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question the architecture (see Phase 4.5)

## your human partner's Signals You're Doing It Wrong

**Watch for these redirections:**
- "Is that not happening?" - You assumed without verifying
- "Will it show us...?" - You should have added evidence gathering
- "Stop guessing" - You're proposing fixes without understanding
- "Ultra-think this" - Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) - Your approach isn't working

**When you see these:** STOP. Return to Phase 1.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |
| "It doesn't reproduce, but the guard could be bypassed — I'll harden it" | No defect, no fix. Report the guard. Hardening is a new assignment. |
| "The guard checks the display, it should check the state" | Maybe. Say so in the report. Moving a working guard is not debugging. |
| "The guard sits at the symptom, fix at source" | There is no symptom. "Fix at source" applies to a defect that occurs. |
| "My test fails, so the defect is confirmed" | Only if the test takes the reported path. A test that reaches past the guard confirms nothing. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## When Process Reveals "No Root Cause"

This section is for behavior that does occur. If it doesn't occur because the
code already prevents it, take the exit after Phase 1 instead — nothing here
applies.

If systematic investigation reveals issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## When the Root Cause Is a Word

Some bugs are not logic errors. Two parts of the system used the same word for
different things — or two words for the same thing — and the mismatch became a
defect: a field read from the wrong object, a status compared against the wrong
enum, a boundary drawn where the code assumed there was none.

**When that is the root cause, the fix is not complete until the language is fixed too.**
Patching the call site leaves the ambiguity in place, ready to produce the next
bug at the next call site.

- **The term is missing from the glossary** → add it to `CONTEXT.md`, with the
  wrong variant under `_Avoid_`. Use `smax:domain-modeling` for the format.
- **Two concepts were sharing one name** → give each its own canonical name and
  record both. Then rename in code, don't just fix the one broken read.
- **The boundary between two concepts turned out to be somewhere else than
  assumed** → that is a Decision, not a glossary entry. Record why.

The signal to watch for: while tracing, you catch yourself asking "wait — does
`account` mean the customer here or the login?" That question *is* the finding.

## When the Root Cause Is a Broken Decision

Before you accept a mechanical explanation, check whether the code is violating
something the project decided on purpose:

```bash
ls docs/decisions/ 2>/dev/null
```

**The filename is the index.** Judge by title, open only what touches the area
you are tracing — zero to two files. Skip silently if the directory does not
exist.

A Decision records a deliberate deviation from the obvious path. So the classic
shape of this bug is: someone (often an agent) saw the deviation, took it for an
oversight, and "fixed" it back to the obvious path. The symptom appears
somewhere else entirely, days later.

**If the code contradicts a Decision, that contradiction is the root cause** —
not the crash you were chasing. Two consequences:

- **Fix the code to match the Decision**, not the symptom. Patching the symptom
  leaves the violation in place to produce the next one.
- **Or overturn the Decision explicitly** — if the investigation shows the
  Decision itself is wrong, that is a real finding. Take it to your human
  partner, and on their agreement record a new Decision that supersedes the old
  one via `smax:domain-modeling`. Never just leave the code winning silently
  against a written decision; the next reader has no way to tell which is
  current.

**Watch for the inverse too.** If your own fix would deviate from the obvious
path in a way a future reader would find surprising, and reversing it later
would be expensive — that fix is a Decision. Record it. Otherwise someone
"fixes" it back and you debug this again in six months.

## Supporting Techniques

These techniques are part of systematic debugging and available in this directory:

- **`root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
- **`defense-in-depth.md`** - Add validation at multiple layers after finding root cause
- **`condition-based-waiting.md`** - Replace arbitrary timeouts with condition polling
