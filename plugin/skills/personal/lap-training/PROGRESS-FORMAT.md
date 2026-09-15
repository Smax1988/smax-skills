# Progress Format

Both files live in the user's training directory, never in the skill
directory. German, because the user reads them.

## `log.md` — append-only, the truth

One line per question asked, appended **immediately after grading**, not
batched at the end of the session. A crashed session must not cost the answers
already given.

```md
| Datum | ID | Bewertung | Modus | Notiz |
|---|---|---|---|---|
| 2026-08-04 | 15-09 | 2 | drill | Zeitpunkt der Übersetzung erst nach Nachhaken |
| 2026-08-04 | 01-07 | 3 | drill | |
| 2026-08-11 | 16-07 | 0 | sim | 2. NF komplett gefehlt |
```

`Bewertung` is 0-3. `Modus` is `drill` or `sim`. `Notiz` names what was
missing, in a few words — it is what makes a weak spot visible across weeks,
and what feeds the closing recommendation of a session. Empty for grade 3.

Never rewrite or delete rows. A wrong grade is corrected by a new row, not by
editing the old one.

## `progress.md` — derived, written question by question

Derived from `log.md`, but written **as the session runs**: right after the row
lands in `log.md`, that question's row here is edited and the two affected box
counters are moved, before the next question is asked. Never batched to the end
of a session — the same reason `log.md` is not.

Editing the two rows that change is enough; do not rewrite all 228 rows for a
single answer.

The header line — date and session count — is written at the *start* of a
session, so a session that ends mid-question still reads correctly.

If it ever disagrees with `log.md`, `log.md` wins — throw it away and rebuild.
That is the recovery path: at the start of every session, check that
`progress.md` accounts for every row in `log.md`, and rebuild it in full if it
does not.

```md
# Fortschritt

Stand: 2026-08-04 · 18 Einheiten · Prüfung in 68 Tagen

| Box | Fragen |
|---|---|
| 0 nie gestellt | 41 |
| 1 rot | 22 |
| 2 | 35 |
| 3 | 58 |
| 4 | 44 |
| 5 grün | 28 |

| ID | Box | Gestellt | Letzte | Datum | Notiz |
|---|---|---|---|---|---|
| 01-01 | 4 | 3 | 3 | 2026-07-29 | |
| 15-09 | 2 | 2 | 2 | 2026-08-04 | Zeitpunkt der Übersetzung |
```

One row per question, all 228, sorted by ID. `Letzte` is the most recent grade,
`Notiz` the most recent non-empty note. The box summary on top is what gets
reported at the start of the next session — it should be readable without
scrolling.

## Computing the box

Replay `log.md` in order per question, starting at box 0 and applying the
transitions from `SKILL.md` § *Selection* — first answer and later answers
follow different rules there. They are not repeated here, so that there is one
place to change them and no second copy to drift.

Replaying rather than storing means a corrupted `progress.md` is never a
problem, and the rules can change later without invalidating the history.

## `CONFIG.md`

```md
Prüfungstermin: 2026-10-27
Standarddauer: 45 Minuten
Simulation: wöchentlich ab 2026-08-31
```

## `PROFILE.md`

Free prose, half a page. Employer, what the user actually builds, which
languages and frameworks, what the Prüfarbeit project is about. Used to ground
question wording in real practice — never to skip topics the user does not
touch at work. The board asks the whole catalogue.
