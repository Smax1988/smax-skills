# `requesting-` and `receiving-code-review` condensed into one skill

Superpowers separates requesting (`skills/requesting-code-review/`) and
receiving (`skills/receiving-code-review/`) a review into two skills. Here both
are merged into `smax:code-review`; `code-reviewer.md` is taken over almost
verbatim from `requesting-code-review/`.

**Why:** the split produces two skills that are never individually useful —
whoever requests a review also receives it. Two descriptions for one activity
cost trigger sharpness without any caller ever needing just one half.

**Added over upstream: the mutation probe for guards.** A green test run only
evidences a guard once the suite goes red without it. The second SDD test run
found exactly this case — a test pinned only the error class and stayed green,
because the language throws that same type on its own. Only the reviewer's own
initiative caught it; the rubric did not mention it. The probe runs in a scratch
worktree, so the reviewer's read-only rule is untouched.

The same rule applies one stage earlier in
[[0012-execute-plan-claims-not-read]].
