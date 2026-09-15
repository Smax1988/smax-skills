# English technical terms stay English, German prose inflects them

An established English technical term keeps its English form and is used in
German prose like a German noun — *der Bucket*, *die Buckets*, *das Gate*, *der
Commit*. A term is translated into German only where a natural German word
already exists and the translation is not a construction.

**Why:** the alternative — germanise everything — sounds more consistent than it
is. It produces words nobody says: *Eimer* for a classification section, *Tor*
for a gate, *Fertigkeit* for a skill. Anyone reading such words translates them
back in their head before understanding them. The term does not become more
German that way, only slower.

Conversely, an English word does damage where the German one has long been
available: *coverage* instead of **Güte**, *safety net* instead of
**Sicherheitsnetz**, *trap* instead of **Falle**. The English contributes no
precision here, it merely marks the text as descended from an English original.

**The rule is decided by the word, not by the language.** Does a natural German
word exist? Then it stands. Would the translation be a word-for-word
construction? Then the English stays.

## Two renames that ran in opposite directions

Both came out of the same session, and that is exactly what makes them worth
explaining:

- **Eimer → Bucket.** *Eimer* is the word-for-word translation of *bucket* and
  denotes a cleaning pail in German. The technical term is *Bucket*.
- **Anker → Quelle.** Here the English was the construction. *Anchor* is not an
  established technical term for "the place a fact comes from" — *Quelle* is the
  obvious German word, and had even been listed as an `_Avoid_` variant before.

Whoever sees only the result — one English and one German term swapped in a
single session — takes it for arbitrariness and levels it out on the next pass.
Hence this file.

## Consequence for code names

The English code name in backticks follows the canonical term; it does not run
ahead of it. When *Anker* becomes *Quelle*, `Anchor` becomes `Source`; the source
list is `SourceList`. A pair like *Quelle* / `Anchor` would no longer be a
translation but two names for the same thing — and the glossary exists to prevent
exactly that.

Where the term stays English, canonical name and code name are identical:
*Bucket* / `Bucket`.

## Where the rule applies

**Everywhere a term is written** — not only in German prose. This rule decides
the *form of a term*, not the language of a document.

In German text the canonical term stands: *Quelle*, *Bucket*. In English text —
skill texts ([[0021-skill-texts-english-output-reader-language]]), Decision files
([[0023-decision-files-in-english]]) — the code name from the glossary stands:
`source`, `source list`, `bucket`. Never a translation of your own from the
German term, never a third name.

Which document is written in which language is decided by `0021` and `0023`, not
by this rule.

This is the point at which a rename is more expensive than it looks: it hits
every text carrying the term, in both languages.

## Scope

From now on and forward. Existing prose is aligned when it is being touched
anyway — a dedicated sweep through all documents is not planned for it. Excepted
are the three terms that triggered this decision: for *Quelle*, *Quellenliste*
and *Bucket* the sweep runs immediately, because `sync-plugin-docs` is being
built on them right now and a half-renamed term reaches into every one of its
test cases.
