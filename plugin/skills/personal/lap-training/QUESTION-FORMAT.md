# Question Format

One file per chapter of the Themenkatalog: `questions/NN-slug.md`, 17 files.
Within a file, one block per question, in Themenkatalog order.

Questions are German — they are read to the user. The field labels are German
too, so nothing has to be translated while asking.

## Block

```md
### 15-09 · Interpreter und Compiler
**Themenpunkt:** 15.9 Fachbegriffe Interpreter und Compiler (Unterschiede, Vor- und Nachteile)
**Frage:** Was ist der Unterschied zwischen einem Interpreter und einem Compiler?
**Muss:** Compiler übersetzt den gesamten Quellcode vorab in Maschinencode; Interpreter führt ihn zur Laufzeit Zeile für Zeile aus.
**Sicher:** Kompilat läuft schneller, Fehler fallen schon beim Übersetzen auf, ist aber plattformgebunden · Interpreter ist plattformunabhängig und leichter zu debuggen, dafür langsamer · Mischform JIT (Java, C#) · je ein Beispiel
**Nachhaken bei:** „übersetzt in Maschinensprache" ohne den Unterschied im Zeitpunkt
```

## Fields

**Heading** — `### <ID> · <short title>`. The ID is `<chapter>-<running number>`,
zero-padded, e.g. `01-03`, `15-09`. **The ID never changes.** It is what
`log.md` refers to; renumbering destroys the progress record.

**Themenpunkt** — the point from the official Themenkatalog, verbatim including
its number. This is the coverage proof: every point in the catalogue must
appear in exactly one block. When the source `lap-vorbereitung` markdown had no
entry for a point, append ` (ergänzt)` — the user should review those.

**Frage** — one plain phrasing. Not the only one that gets asked; the skill
varies the wording. Written so it works as-is if you do not vary it.

**Muss** — what an answer needs for grade 2. Keep it to the smallest set that
an examiner would accept. This field is the calibration anchor: if it is vague,
grades drift between sessions.

**Sicher** — what lifts an answer to grade 3, points separated by `·`. Not
everything worth knowing — what a strong candidate says unprompted.

**Nachhaken bei** — the typical half-answer that should trigger the follow-up.
Optional; omit where there is no obvious one.

## Cutting questions

One question per Themenpunkt, 228 in total. Do not merge points, do not split
them — the point-to-question mapping is 1:1, which is what makes "no topic left
untested" checkable by counting.

Where a point is broad (`Kenntnis der objektorientierten Programmierung
(Klassen, Objekte, Vererbung, ...)`), the breadth goes into **Sicher**, not into
extra questions.

## Sources

Answers come from the user's `lap-vorbereitung-applikationsentwicklung.md`,
condensed to must/sicher. The structure comes from the **PDF Themenkatalog** —
the markdown is missing about a dozen points, and building against it would
inherit the holes. Check every chapter against the PDF, not against the
markdown.
