# SDD keeps its workspace until the work lands

Superpowers deletes the plan's workspace as soon as the final review is clean
("Final review clean: delete this plan's workspace" in the flow graph of
`skills/subagent-driven-development/SKILL.md`). Here it stays; the cleanup moves
to `finishing-a-development-branch`, step 7.

**Why:** the ledger lives in the workspace, and the review gate in
`finishing-a-development-branch` reads it — it matches the SHA on the ledger line
against the branch before landing. If SDD deletes the workspace at handover, that
gate is structurally uncheckable: which is exactly what happened in the first
end-to-end test run, and why the gate item was left open there with reason given.

**The price:** the workspace outlives the skill that created it. Anyone who runs
SDD and then does not land leaves it behind. That is the deliberately chosen
trade against a review gate that cannot check itself.

**Scope note:** this is a deviation from the vendoring spec, not merely from
upstream — it was taken during implementation and is therefore recorded here
rather than in the spec.
