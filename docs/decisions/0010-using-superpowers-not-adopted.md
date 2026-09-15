# `using-superpowers` and its SessionStart hook not adopted

Superpowers ships a meta-skill `using-superpowers` that a SessionStart hook loads
into every session, where it introduces the remaining skills. It was not adopted
— nor were `commands/`, `tests/`, `agents/`, the platform manifests
(`.codex-plugin`, `.cursor-plugin`, `.opencode`, `.pi`,
`gemini-extension.json`) and the development artefacts.

**Why:** a SessionStart hook costs context in *every* session, whether any
development happens or not. The individual skills' trigger descriptions achieve
the same thing on demand. The platform manifests describe runtimes not used
here; maintaining them would be upkeep without benefit.

**Consequence:** the entry point has to be documented elsewhere, or nobody finds
it. That is what the "Wo steige ich ein?" table in `README.md` does — sorted by
situation rather than by skill name.
