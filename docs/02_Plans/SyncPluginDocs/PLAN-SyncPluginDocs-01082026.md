# `sync-plugin-docs` Implementation Plan

**Erstellt:** 01.08.2026

> **For agentic workers:** REQUIRED SUB-SKILL: Use smax:subagent-driven-development (recommended) or smax:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ein repo-lokaler Skill, der nach Änderungen unter `plugin/skills/` prüft, ob `README.md` und `plugin/NOTICE.md` nachgezogen werden müssen, abgeleitete Fakten still nachzieht und Prosa zur Bestätigung vorlegt.

**Architecture:** Eine einzelne `SKILL.md` unter `.claude/skills/sync-plugin-docs/`, ausgelöst über einen Block in der Projekt-`CLAUDE.md`. Der Skill trägt eine **Quellenliste** — welcher Fakt aus welcher Quelle außerhalb des Dokuments stammt —, neun benannte Fallen, ein `grep`-Sicherheitsnetz und eine harte Grenze zwischen still Geschriebenem und Vorgelegtem. **Der Skilltext ist englisch** (`0021-skill-texts-english-output-reader-language.md`), seine Ausgaben sind deutsch.

**Tech Stack:** Markdown (`SKILL.md`), `git` (`merge-base`, `diff`, `log`, `status`), `grep`. Kein Skript, kein Build, keine Abhängigkeit.

**Spec:** `docs/01_Specs/SyncPluginDocs/SPEC-SyncPluginDocs-31072026.md`

## Global Constraints

- **Terminologie steht in `CONTEXT.md`.** Namen in der `SKILL.md`, in Report-Texten und in Commit-Messages benutzen den kanonischen Begriff — *Abgeleitetes Dokument*, *Drift*, *Vergleichsbasis*, *Quelle*, *Quellenliste*, *Bucket*, *Aufruf*, *Eigenständiger Command*, *Ketten-Command*, *Repo-lokaler Skill*. Eine Abweichung ist ein Defekt, keine Stilfrage. Was unter `_Avoid_` steht, darf nicht auftauchen — insbesondere **nicht** „Abbildung" und nicht „Mapping" als deutsches Wort. Ein fehlender Begriff wird ins Glossar aufgenommen, nicht im Text erfunden.
- **`docs/decisions/0016-skills-are-cold-start-capable.md`** — der Skill trägt Quellenliste, Fallen, Basis-Regel und Schreiben/Vorlegen-Grenze selbst. Sie aus einem Plugin-Skill zu holen oder auf ihn zu verweisen, um Text zu sparen, ist ein Defekt, keine Deduplizierung.
- **`docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`** — kein Plugin-Skill darf `.claude/skills/sync-plugin-docs` referenzieren. Ihn „sauber in die Kette zu hängen" (etwa aus `finishing-a-development-branch`) ist ein Defekt: Der Pfad existiert in keinem anderen Repo und schlägt dort still fehl.
- **`docs/decisions/0019-write-sourced-present-the-rest.md`** — Prosa wird nie still geschrieben. „Der Text war offensichtlich, ich habe ihn gleich angepasst" ist der Defekt, gegen den diese Entscheidung existiert.
- **`docs/decisions/0020-sweep-baseline-keeps-blind-spot.md`** — der blinde Fleck der Sweep-Basis bleibt. Ihn zu schließen (Zustandsdatei, Commit-Marker, Vollabgleich) ist ein Defekt, keine Verbesserung; die Gegenmaßnahme ist die Güte-Angabe im Report. Dieselbe Regel trifft den Hook: `ask` statt `deny`, damit kein Zustand nötig wird.
- **`docs/decisions/0022-english-terms-stay-english.md`** — der englische Skilltext benutzt den **Code-Namen** aus dem Glossar, nicht die eigene Übersetzung des deutschen Begriffs: `source`, `source list`, `bucket`. Das deutsche Wort dort einzusetzen oder ein drittes zu erfinden (`anchor`, `origin`) ist ein Defekt.
- **`docs/decisions/0021-skill-texts-english-output-reader-language.md`** — der Text der `SKILL.md` ist englisch. Deutsch bleibt, was der Skill *ausgibt*: Report und vorgelegte Textvorschläge, denn die landen in deutschen Dokumenten. Den Skilltext deutsch zu schreiben, weil das Repo deutsch ist, ist der Defekt, den diese Entscheidung verhindert.
- **`docs/decisions/0008-confirm-git-actions-outside-branch.md`** — der fertige Skill committet nicht. Ein „ich committe das gleich mit" im Skill-Text ist ein Defekt.

---

## File Structure

| Datei | Verantwortung |
|---|---|
| `.claude/skills/sync-plugin-docs/SKILL.md` | **Der gesamte Skill.** Eine Datei, kein Referenzmaterial eine Ebene tiefer — sie bleibt unter ~200 Zeilen und wird immer vollständig gebraucht. |
| `CLAUDE.md` | trägt den Auslöser-Block |
| `README.md` | wird einmalig bereinigt und um den ersten repo-lokalen Skill ergänzt |
| `TODOS.md` | 2.1 als erledigt gestrichen — **kein Nachfolge-Eintrag** |

**Keine Aufteilung in mehrere Dateien.** `smax:writing-skills` erlaubt das Auslagern von Referenzmaterial eine Ebene tiefer, aber hier wird jeder Teil bei jedem Lauf gebraucht: Basis-Regel, Quellenliste, Fallen, Netz, Ausgabegrenze. Ein Split kostet einen zweiten Lesevorgang ohne Ersparnis.

**Wichtig — kein `disable-model-invocation`.** Der Auslöser ist ein `CLAUDE.md`-Block, der Claude anweist, den Skill zu starten. Mit dem Flag könnte Claude genau das nicht, und der Auslöser liefe ins Leere. Das Frontmatter trägt nur `name` und `description`.

## Test-Harness

Alle Verhaltenstests laufen nach demselben Muster. **Der Skill wird nie von dem Agenten getestet, der ihn geschrieben hat** — sonst prüft er sein eigenes Verständnis statt den Text.

**Setup:** keins. Leg die synthetische Änderung direkt an — sie liegt bei allen
Verhaltenstests unter `plugin/`. (Die zwei Auslöser-Tests in Task 6 fassen
`docs/decisions/` an und tragen ihr Aufräumen selbst.)

**Dispatch-Vorlage** (`general-purpose`, one-shot, ohne Namen):

```
Lies C:\Projects\skills\.claude\skills\sync-plugin-docs\SKILL.md und befolge
sie im Repo C:\Projects\skills. Führe sie vollständig aus.

Deine letzte Nachricht IST der Report des Skills — gib ihn wörtlich aus, ohne
Vorrede, ohne Zusammenfassung, ohne Kommentar dazu, was du davon hältst.
Wenn der Skill dich etwas fragen würde, gib die Frage im Report aus, statt sie
selbst zu beantworten.
```

**Vor dem Aufräumen — hinsehen:**

```bash
git diff -- README.md plugin/NOTICE.md
```

**Das ist die Evidenz.** Der Report sagt, was der Skill zu schreiben *behauptet*;
der Diff sagt, was er geschrieben hat. Überall dort, wo ein Test „still
geschrieben" erwartet, entscheidet sich hier, ob er grün ist — nicht am Report.
Zurücksetzen, bevor du hingesehen hast, vernichtet den Beweis.

**Aufräumen — nach jedem Test, auch nach einem Fehlschlag, immer alle vier Zeilen:**

```bash
git checkout HEAD -- README.md  # der Skill schreibt hierhin, und das liegt ausserhalb plugin/
git reset -q -- plugin/         # nimmt gestagete Umbenennungen aus dem Index
git checkout HEAD -- plugin/    # stellt geloeschte und geaenderte Dateien wieder her
git clean -fdq plugin/          # entfernt neu angelegte Verzeichnisse
```

<HARD-GATE>
**Jeder Befehl trägt einen Pfad, und der bleibt dran.** Das ist der Unterschied zwischen einem Testlauf und einem Datenverlust:

- **`git reset --hard` hat hier nichts zu suchen.** Es kennt keine Pfadgrenze und setzt *jede* getrackte, geänderte Datei im Repo zurück — auch die SPEC, diesen Plan und alles andere, woran gerade gearbeitet wird. Die vier Zeilen oben leisten für `README.md` und `plugin/` dasselbe und lassen den Rest in Ruhe.
- **`git clean -fd` ohne Pfad** löscht jede untrackte Datei im ganzen Repo.
- **`git checkout HEAD -- plugin/` allein reicht nicht.** Eine **Umbenennung** hinterlässt den *neuen* Pfad im Index; der steht nicht in `HEAD` und wird von `checkout` nicht angefasst. Deshalb kommt `git reset -- plugin/` davor. Eine gestagete **Löschung** ist nicht dieser Fall — die räumt `git checkout HEAD -- <pfad>` allein vollständig auf, weil es Index *und* Baum aus `HEAD` schreibt.
- **`README.md` braucht eine eigene Zeile.** Sie liegt im Repo-Root und wird von den drei `plugin/`-Zeilen nicht erreicht. Der Skill *unter Test* schreibt aber genau dorthin — §5-Zeilen, die §2.1-Zahl, die Spalten. Ohne diese Zeile sammelt sich der Ausstoß von rund zwanzig Läufen an, über Tasks hinweg, und landet im nächsten Commit, der `README.md` mitnimmt. `plugin/NOTICE.md` ist das andere abgeleitete Dokument, liegt aber unter `plugin/` und ist bereits gedeckt.

Weil das Aufräumen diese beiden Pfade nie verlässt, braucht es **keinen Scratch-Branch, keinen WIP-Commit und keinen Worktree**. Ein halbfertiger Skill unter `.claude/` bleibt unangetastet liegen.

**Eine Vorbedingung bleibt:** uncommittete Arbeit an `README.md` gehört vor die Testläufe committet, sonst nimmt die erste Zeile sie mit. Task 7 ist deshalb so gebaut, dass sein Commit **vor** dem Testlauf steht — damit gilt das Muster in allen neun Tasks ohne Ausnahme.
</HARD-GATE>

Nach dem Aufräumen muss `git status --porcelain -- README.md plugin/` leer sein. Ist es das nicht, ist **innerhalb** dieser Pfade etwas liegengeblieben, das die vier Zeilen nicht erreichen — nachsehen, nicht mit `-f` oder `--hard` nachhelfen. Der einzige bekannte Fall ist ein untracktes Verzeichnis mit eigenem `.git` darin, das `git clean -fd` stillschweigend auslässt.

**Nach einem Commit hilft keine dieser Zeilen mehr.** `git checkout HEAD -- <pfad>` stellt auf den *aktuellen* HEAD her; ist der Testausstoß committet worden, ist der Befehl ein No-op auf den verschmutzten Stand, und `git status` meldet sauber. Kein Test in diesem Plan darf committen. Wo ein Commit-*Versuch* Gegenstand des Tests ist (Task 6, Steps 6–7), wird er abgelehnt, nicht bestätigt.

---

## Task 1: Gerüst, Vergleichsbasis, Report-Rahmen

**Files:**
- Create: `.claude/skills/sync-plugin-docs/SKILL.md`

**Interfaces:**
- Produces: die Abschnitte `## 1 · Comparison base`, `## 2 · Affected skills`, `## Report` und `## Never commit`. Tasks 2–5 schieben die nummerierten Abschnitte 3–7 zwischen `## 2` und `## Report`. **`## Report` und `## Never commit` bleiben unnummeriert** — sonst müsste jede spätere Einfügung sie umnummerieren, und eine falsche Nummer in einer Querverweiszeile fällt niemandem auf.

**Die Überschriften sind englisch, auch wenn dieser Plan deutsch ist**
(`0021-skill-texts-english-output-reader-language.md`). Wo ein späterer Task eine
Einfügestelle nennt, nennt er sie so, wie sie in der Datei steht — sonst findet
ein `grep` danach nichts.

- [ ] **Step 1: Testfall festhalten — sauberer Baum auf `main`**

Erwarteter Report, exakt eine Zeile plus Basiszeile:

```
Basis: 3b95426 (Sweep seit letzter README/NOTICE-Pflege — unvollständig)
Nichts zu tun.
```

- [ ] **Step 2: Testfall festhalten — Feature-Branch**

```
Basis: merge-base main HEAD = <sha> (Branch-Basis — vollständig)
Nichts zu tun.
```

- [ ] **Step 3: Verzeichnis anlegen und `SKILL.md` schreiben**

Erstelle `.claude/skills/sync-plugin-docs/SKILL.md` mit genau diesem Inhalt:

````markdown
---
name: sync-plugin-docs
description: Checks whether README.md and plugin/NOTICE.md still match the skill inventory after changes under plugin/skills/, and brings them up to date. Use before committing whenever something under plugin/skills/ or plugin/.claude-plugin/ has changed.
---

# Sync Plugin Docs

`README.md` and `plugin/NOTICE.md` are derived from the skill inventory. Change a
skill without updating them and the documentation is silently wrong: no error, no
warning, just a false statement.

This skill answers **one** question: *does this change need a documentation
update?* Not: *is the documentation up to date?* That difference is the entire
reason it is cheap enough to run before every commit.

Your report is written in German — **including every text you propose** for
`README.md` or `plugin/NOTICE.md`. Both land in German documents and are read by
their author. The instructions you are reading are English; nothing you emit is
(`docs/decisions/0021-skill-texts-english-output-reader-language.md`).

## 1 · Comparison base

```bash
git rev-parse --abbrev-ref HEAD
```

| Situation | Base | Coverage |
|---|---|---|
| Branch other than `main`, with its own commits | `git merge-base main HEAD` | **complete** |
| On `main`, or a branch without own commits | newest commit up to and including `HEAD` that touched `README.md` or `plugin/NOTICE.md` | **partial** |

```bash
# case 1
git merge-base main HEAD
# case 2
git log -1 --format=%H -- README.md plugin/NOTICE.md
```

Uncommitted changes are included in **both** cases — they are what you are
checking before a commit.

**The first line of the report is fixed text. Write it verbatim, in German:**

```
Basis: merge-base main HEAD = <sha> (Branch-Basis — vollständig)
Basis: <sha> (Sweep seit letzter README/NOTICE-Pflege — unvollständig)
```

Fixed, because the coverage marker is the whole countermeasure to the blind spot
below. A run that paraphrases it — „ungefähr seit dem letzten Commit" — costs
the reader the one thing the line exists to carry, and nobody notices, because
a line is still there.

**The sweep base has a known blind spot.** A cosmetic edit to `README.md` or
`plugin/NOTICE.md` — a typo, a reformat — resets the window and hides everything
before it. This is decided and stays
(`docs/decisions/0020-sweep-baseline-keeps-blind-spot.md`). **Do not
close it.** No state file, no commit marker, no full comparison. The
countermeasure is visibility: the first line of the report names the base *and*
its coverage.

## 2 · Affected skills

```bash
git diff --stat <base> -- plugin/skills/ plugin/.claude-plugin/
git status --porcelain -- plugin/skills/ plugin/.claude-plugin/
```

Nothing? Report the base, its coverage, and „Nichts zu tun." Then stop.

**Emit that report anyway.** Silence reads as „it did not run", and that
uncertainty is what this skill exists to remove.

Something changed? Then, per affected skill, look at the **frontmatter diff and
the body diff separately**:

```bash
git diff <base> -- plugin/skills/<name>/SKILL.md
```

They feed different sources, and conflating them is how the wrong column moves.
`argument-hint:` and `description:` sit three lines apart and drive two columns
in two different sections.

| Diff hunk | Sources it can touch |
|---|---|
| `name:` | every occurrence of the name |
| `argument-hint:` | §5 column *Argumente* |
| `description:` | §2.1 column „wofür" |
| `disable-model-invocation:` | §5 column *Trigger*; §2.1 / §2.2 membership; §4 *Geht gar nicht per Modell* |
| body — a call added or removed | §5 Wer-ruft-wen; §2.1 / §2.2 membership; §4 *Läuft ohnehin von selbst* |
| body — anything else | **nothing** |
| directory added, deleted or renamed | the directory-based sources, plus `plugin/NOTICE.md` |

**Then read only the sections those sources feed.** Not the whole README.

The second-to-last row is the common case and the reason this skill is cheap
enough to run before every commit: a paragraph rewritten inside a skill body
changes no derived fact at all. Reading `README.md` to establish that is the
waste this table exists to prevent.

## Report

First line always: the base, how it was determined, and its coverage — verbatim
in one of the two forms from section 1.

```
Basis: merge-base main HEAD = a1b2c3d (Branch-Basis — vollständig)
Betroffen: <skills>

Geschrieben (n)
  <Datei> <Stelle> — <was und warum>

Gemeldet (n)
  <Datei> <Stelle> — <Befund, ohne Vorschlag>

Zu übernehmen (n)
  <Datei> <Stelle>
  alt:  <Text>
  neu:  <Text>
  → übernehmen? [j/n]
```

**Three sections, three verdicts** — the same three the source list assigns.
*Geschrieben* is what you already changed. *Zu übernehmen* is what you drafted
and need a yes for. *Gemeldet* is the third kind, and it is not a weaker version
of the second: a finding with **no draft attached** — a `grep` hit at a place no
source names, a NOTICE bucket whose classification may no longer hold, an entry
that is missing entirely. You name it and stop there. Drafting a value would be
guessing, and a guess dressed as a proposal is worse than the gap.

Leave out a section that is empty. Never leave out the first line.

## Never commit

**This skill does not commit.** Not the README, not NOTICE, not anything.

The trigger fires *before* the user's commit, so your edits are carried by it
anyway. A commit of your own cuts their work in half and puts a change into the
history that nobody asked for
(`docs/decisions/0008-confirm-git-actions-outside-branch.md`).

| Excuse | Reality |
|---|---|
| „Just the README, so it does not get lost" | The user commits within the minute. Nothing gets lost. |
| „They typed `/sync-plugin-docs`, that is consent" | Consent to check is not consent to commit. |
| „`git add` is not a commit" | Staging changes the state of a tree that is not yours. Leave it alone. |
````

- [ ] **Step 4: Test „sauberer Baum auf `main`" ausführen**

```bash
git status --porcelain -- plugin/ README.md   # muss leer sein, sonst erst committen
git log main..HEAD --oneline                  # muss leer sein -- siehe unten
```

**Eine Vorbedingung:**

- Nichts Uncommittetes unter `plugin/` oder in der README, sonst hat der Lauf etwas zu melden.
- **Der aktuelle Branch hat keine eigenen Commits** — sonst greift die Branch-Basis-Regel und der Report sagt korrekterweise `(Branch-Basis — vollständig)`, was hier wie ein Fehlschlag aussähe. Im Zweifel von `main` aus fahren.

Der noch nicht committete Skill unter `.claude/` stört nicht — er liegt außerhalb der Pfade, die der Skill beobachtet.

Dispatch nach der Vorlage im Abschnitt *Test-Harness*.
Erwartet: zwei Zeilen, Basis mit `(Sweep … — unvollständig)`, dann „Nichts zu tun."
**Fehlschlag**, wenn die Güte fehlt, wenn der Report leer ist, oder wenn der Subagent die README liest, obwohl es nichts zu prüfen gibt.

Der Lauf darf nichts schreiben — und ob er das eingehalten hat, sagt der
Inspektionsschritt, nicht der Report. Anschließend aufräumen nach dem Muster im
Abschnitt *Test-Harness*, auch wenn der Diff leer war.

- [ ] **Step 5: Test „Feature-Branch" ausführen**

**Der einzige Test mit eigenem Branch** — hier ist der Branch der Gegenstand, nicht eine Schutzmaßnahme:

```bash
git checkout -b test/spd-branchbasis
git commit --allow-empty -m "test: eigener Commit fuer die Branch-Basis"
```

Dispatch nach der Vorlage.
Erwartet: `(Branch-Basis — vollständig)`, dann „Nichts zu tun."

Aufräumen nach dem Muster im Abschnitt *Test-Harness* — hier zusätzlich der
Branch, weil dieser Test als einziger einen anlegt:

```bash
git checkout -
git branch -D test/spd-branchbasis
git status --porcelain -- README.md plugin/   # muss leer sein
```

Der Lauf hat unter `plugin/` nichts angefasst, aber `README.md` kann er
angefasst haben — dafür läuft das Muster auch hier. `git checkout -` kehrt
zuverlässig zurück, auch wenn der Subagent zwischendurch selbst den Branch
gewechselt hat.

- [ ] **Step 6: Commit**

```bash
git add .claude/skills/sync-plugin-docs/SKILL.md
git commit -m "feat(sync-plugin-docs): Gerüst, Vergleichsbasis und Report-Rahmen"
```

---

## Task 2: Quellenliste und Fallen

**Files:**
- Modify: `.claude/skills/sync-plugin-docs/SKILL.md` (Abschnitte `## 3` **und** `## 4` zwischen `## 2 · Affected skills` und `## Report` einfügen)

**Interfaces:**
- Consumes: `## 1 · Comparison base`, `## 2 · Affected skills` aus Task 1.
- Produces: `## 3 · The source list` und `## 4 · The traps`. Task 5 hängt seine Ausgabegrenze an die Spalte *Therefore* der Quellenliste.

<HARD-GATE>
**Jede Zeile dieser Tabelle behauptet etwas über `README.md`. Prüfe jede einzelne gegen die Datei, bevor du sie schreibst.** Die SPEC ist durch drei Review-Runden gegangen, in denen an genau dieser Stelle 16 Faktenfehler gefunden wurden — Abschreiben aus der SPEC ist nicht dasselbe wie Nachsehen. Wenn README und SPEC auseinandergehen, **hat die README recht** und der Befund gehört in den Report an den Nutzer, nicht still in die Tabelle.
</HARD-GATE>

- [ ] **Step 1: Behauptungen gegen die Datei prüfen**

```bash
grep -n "^#\{1,3\} \|^### " README.md
sed -n '142,163p;189,218p;220,295p' README.md
```

Abhaken, jede Zeile einzeln:

| Behauptung | Prüfung |
|---|---|
| §5 hat **vier** Gruppen-Tabellen | `### dev — Workflow-Kette`, `### dev — Denken & Doku`, `### dev — Kunden- & Web-Aufgaben`, `### personal` |
| §2.1 sagt „Diese **zehn**" und hat 10 Zeilen | Einleitungssatz + Tabelle zählen |
| §2.1 führt nur **eigenständige** Commands | Der Einleitungssatz sagt es: „rufen keinen Skill und werden von keinem gerufen" |
| Die vier Ketten-Commands stehen in §2.2 | `brainstorming`, `code-review`, `sharpen-me`, `sharpen-with-docs` |
| Von §4 ist nur *Läuft ohnehin von selbst* eine Namensliste | die anderen drei sind Prosa bzw. Prosa-Tabelle |
| Zwei Satellitenabsätze, aber nur einer nennt Aufrufer | der `domain-modeling`-Absatz fünf Namen, der `sync-solution-items`-Absatz nur die `.slnx`-Bedingung |
| `plugin.json` nennt **nur** `./skills/dev` und `./skills/personal` | `cat plugin/.claude-plugin/plugin.json` — die drei `dev`-Untertabellen stehen dort nicht |
| §4 *Läuft ohnehin von selbst* führt `commitMessage` **nicht**, obwohl er gerufen wird | `grep -rn "smax:commitMessage" plugin/skills/` gegen die Namensliste in §4 halten |
| Die Spalte *Argumente* stammt aus `argument-hint`, **gibt ihn aber gekürzt wieder** | siehe eigene Zeile unten |

Weicht eine ab: **stoppen und melden**, nicht anpassen.

**Die letzte Zeile ist der Sonderfall — ihre Abweichung ist der Normalfall.**

```bash
grep -rn "^argument-hint:" plugin/skills/
```

Halte die Werte gegen die Spalte in §5. Erwartung: die **Quelle** stimmt, die
**Werte** weichen bei den meisten Skills ab — `teach` trägt
`"What would you like to learn about?"`, §5 zeigt `` `[Thema]` ``; `css-review`
trägt `<URL der zu prüfenden Seite>`, §5 zeigt `` `<URL>` ``. Wörtlich identisch
sind nur `md-to-pdf` und `find-beer-deals`.

Hier also **nicht** stoppen. Genau diese Abweichung ist der Grund für den
Wörtlich-Test in Abschnitt 3, und dass sie existiert, ist die Voraussetzung
dafür, dass der Test etwas leistet. Findest du sie **nicht** vor — steht die
Spalte plötzlich überall wörtlich —, dann stoppen und melden: dann hat jemand
die README normalisiert und der Test ist gegenstandslos geworden.

- [ ] **Step 2: Abschnitt 3 einfügen**

Zwischen `## 2 · Affected skills` und `## Report`:

````markdown
## 3 · The source list

**The question is not „which section does this change touch?" but „where does
this fact come from?"**

Every fact in `README.md` and `plugin/NOTICE.md` either originates **outside**
the document — in a frontmatter field, the directory layout, a call in a skill
body, a git command — or it originates nowhere else and lives in the document
itself. That origin is its **source**, and it settles both things at once: where
you look up the correct value, and whether you may write it. For two columns the second answer depends on
the value itself — see *The verbatim test* below.

| Fact | Source | Therefore |
|---|---|---|
| A skill's name, at every occurrence | `name:` in the frontmatter | **write** |
| §5 column *Trigger* | `disable-model-invocation:` | **write** |
| §5 column *Argumente* | `argument-hint:` | **write if verbatim**, else **ask** |
| §2.1 column „wofür" | `description:` | **write if verbatim**, else **ask** |
| Whether a row exists in §5 | directory under `plugin/skills/` | **write** |
| Whether §5 holds a group table for a shipped directory, and what it is titled | `plugin/.claude-plugin/plugin.json` | **write** |
| Which §5 table a skill goes in — the `personal` case | directory under `plugin/skills/` | **write** |
| Which §5 table a skill goes in — the three `dev` subdivisions | **none** | **ask** |
| That those three subdivisions exist at all, and what they are called | **none** | **ask** |
| §5 Wer-ruft-wen | calls in the skill bodies | **write** |
| §2.1 membership **and the count** in its intro sentence | calls + `disable-model-invocation:` | **write** |
| §2.2 membership | the same | membership **write**, surrounding sentence **ask** |
| §4 *Läuft ohnehin von selbst*, who belongs | **none** | **ask** |
| §4 *Geht gar nicht per Modell*, who belongs | `disable-model-invocation:` | membership **write**, text **ask** |
| NOTICE: has a file left its bucket? | `git diff --numstat c1e7d9e HEAD -- <file>` | **report** |
| NOTICE: **which** bucket it belongs in | — | **ask** |
| NOTICE *Ohne Upstream-Herkunft*, membership | `git ls-tree c1e7d9e^` | **ask** |
| §3 entry table | **none** | **ask** |
| §1 prose, §4 judgements, the satellite paragraphs, §6.x | **none** | **ask** |

### The verbatim test

Two columns **render** their source value instead of copying it. Which verdict
applies is therefore a property of the data, not a judgement — so look:

```bash
git show <base>:plugin/skills/<name>/SKILL.md | grep '^argument-hint:'
```

Compare that against what stands in `README.md` **today**.

- **Identical** → the column has been tracking the raw value. Substitute the new
  one silently.
- **Different** → the deviation is the author's, and so is its successor.
  `teach` carries `argument-hint: "What would you like to learn about?"` while §5
  shows `` `[Thema]` ``. That shortening exists nowhere outside the README, and
  no rule derives it. Put old and new side by side.

For §2.1 „wofür" the test comes out *different* nearly every time — the column
holds a German one-liner while several `description:` fields are long English
trigger lists. That is the expected outcome, not a failure of the test.

**A brand-new row has nothing to compare against.** Create the row — that it
exists at all, and the count in the intro sentence, have a source — but put the
*contents* of these two columns up for confirmation. There is nothing to render
from except your own paraphrase, and a paraphrase is authored text.

**Why a test rather than a flat verdict.** Flat **write** would have you paste
`"What would you like to learn about?"` into a narrow table column and call it
derived. Flat **ask** would stop for a question on `md-to-pdf`, whose column has
always held the raw string, where the change is a pure substitution. The test
decides by looking rather than by judging — the same standard every other row of
this table meets.

### Two things about §5 that look like one

**Whether a group table exists has a source; how `dev` is carved up is not.**
`plugin.json` names the shipped directories — today `./skills/dev` and
`./skills/personal`. A new entry there means §5 needs a new heading, and the
heading is named after the directory: substitution.

The three `dev` tables — *Workflow-Kette*, *Denken & Doku*, *Kunden- &
Web-Aufgaben* — appear in `plugin.json` nowhere. That they exist, what they are
called, and which one a new skill belongs in are three README-internal decisions
with no source outside the file. All three are **ask**.

`personal` is the contrast that makes the rule visible: one shipped directory,
one table, membership settled by where the directory sits. **Write.**

### §4 *Läuft ohnehin von selbst* has no source, despite appearances

„Is the skill called?" looks like one and is not — it is necessary, not
sufficient. `commitMessage` is called by `writing-plans` and by
`finishing-a-development-branch`, and is deliberately absent from that list:
the list names skills the chain pulls in *on your behalf*, not every skill with
an incoming call. That distinction is recorded in the README and nowhere else.
Ask.

Only *Geht gar nicht per Modell* follows from frontmatter.

**Why there is no „change type → section" table here.** Such a table would be
this source list applied to today's section layout and cached. Its inputs — §2,
§4, §5 — you read anyway, so it saves almost nothing, and it goes stale with
every reorganisation. The source does not: `argument-hint` feeds the *Argumente*
column no matter which section or line holds it.

## 4 · The traps

Nine places where the obvious reading is wrong.

1. **§2.1 does not list all commands, only the standalone ones.** The repo has
   fourteen commands; §2.1 lists ten. The criterion is in the section's own intro
   sentence: *„rufen keinen Skill und werden von keinem gerufen"*. The other four
   are chain commands and live in §2.2.
2. **A call can appear as a resolved path.** `finishing-a-development-branch`
   dispatches `../code-review/code-reviewer.md` and thereby calls `code-review`
   without ever writing `smax:code-review`
   (`docs/decisions/0017-reviewer-template-as-resolved-path.md`).
   Searching only for `smax:` misses these systematically. Where such a call has
   been recorded, Wer-ruft-wen marks it „(als Pfad)" — but the absence of that
   marker proves nothing, because the rows that are missing it are exactly the
   ones nobody found.
3. **A mention is not a call.** `md-to-pdf` names `smax:handoff` and
   `smax:replicate` as cross-references („dieselbe Regel gilt für…"). A hit on
   `smax:<name>` only proves the name occurs.
4. **Being called does not put a skill into §4 *Läuft ohnehin von selbst*.**
   `commitMessage` is called by two skills and is not in that list. The list
   names what the chain pulls in on the user's behalf; the judgement behind it
   lives in the README. Only *Geht gar nicht per Modell* follows from
   `disable-model-invocation`.
5. **A new call can evict a command from §2.1.** If any skill starts calling a
   standalone command, it stops being standalone: it moves to §2.2 and the count
   in the intro sentence changes — without anyone touching its frontmatter.
6. **NOTICE classifies files, not skills — with two exceptions.**
   `debugging/SKILL.md` sits under *Substanziell umgebaut*,
   `debugging/defense-in-depth.md` under *Unverändert übernommen*. The exceptions
   are *Ohne Upstream-Herkunft*, which lists skills, and *Nicht übernommen*,
   which is mixed prose — skills, whole directories and files side by side.
7. **Inside *Ohne Upstream-Herkunft* a different spelling applies**, not the
   heading's „Pfade relativ zu `plugin/skills/dev/`": dev skills appear as a bare
   name (`css-review`), personal ones with a prefix (`personal/whats-for-lunch`).
8. **Renaming is a token substitution and stays silent — except in the chain
   diagram in §1.1.** Its boxes are aligned by character width; a longer name
   breaks the lines. The substitution is mechanical, the realignment is not.
9. **§5 may contain tables that are none of your business.** The group tables
   list plugin skills from `plugin/skills/<group>/`. Any table whose skills do
   **not** live under `plugin/skills/` sits outside every source in this list —
   the repo-local table is one such. Never add, change or remove a row there.
   Count the group tables against `plugin.json`, not against the headings you
   happen to see under §5.

**Address the two satellite paragraphs at the end of §5 by their subject, never
by line number** — one names the callers of `domain-modeling`, the other the
`.slnx` condition of `sync-solution-items`. Any insertion above shifts both.
````

- [ ] **Step 3: Test — neuer `personal`-Skill**

Synthetische Änderung:

```bash
mkdir -p plugin/skills/personal/test-dummy
printf -- '---\nname: test-dummy\ndescription: Testskill, wird sofort wieder entfernt\ndisable-model-invocation: true\n---\n\n# Test Dummy\n' > plugin/skills/personal/test-dummy/SKILL.md
```

Dispatch nach der Vorlage.
Erwartet: Zeile für `test-dummy` in der Tabelle **`### personal`** **still geschrieben** — hier ist die Gruppe durch das Verzeichnis bestimmt und damit verankert. Ebenso die §2.1-Zeile und „Diese zehn" → „Diese elf". Der **„wofür"-Text der neuen Zeile wird vorgelegt** — eine neue Zeile hat keinen Altwert, gegen den der Wörtlich-Test laufen könnte, und die Kurzfassung der `description` ist Autorentext. §3 wird ebenfalls vorgelegt.
**Fehlschlag**, wenn der Skill in einer `dev`-Tabelle landet — das ist der Test darauf, dass alle vier Gruppen bekannt sind.

**Der Gegentest gehört dazu**, weil er die andere Seite der Quellenliste prüft: Derselbe Ablauf mit `plugin/skills/dev/test-dummy` muss die §5-Zeile **vorlegen**, nicht schreiben — welche der drei `dev`-Tabellen es ist, hat keine Quelle. Läuft er still durch, ist die Quellenliste nicht angekommen.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 4: Test — Ketten-Skill wird Command**

Trage `disable-model-invocation: true` in `plugin/skills/dev/writing-specs/SKILL.md` eintragen (ein Ketten-Skill, wird von `brainstorming` gerufen).

Dispatch nach der Vorlage.
Erwartet: §5 Trigger-Spalte geschrieben; **§2.1 unangetastet**, weil `writing-specs` gerufen wird; §2.2 vorgelegt.
**Fehlschlag**, wenn eine §2.1-Zeile entsteht oder die Zahl bewegt wird — das ist der Test auf „eigenständig“ statt bloß „Command“.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 5: Test — `argument-hint` gegen `description`**

**Drei Richtungen, drei verschiedene Dinge.** Aufräumen nach dem Muster im
Abschnitt *Test-Harness* **zwischen** je zwei Richtungen, sonst überlagern sie
sich.

**A — `argument-hint`, wörtlich geführt → still geschrieben.** Ändere in
`plugin/skills/dev/md-to-pdf/SKILL.md` die Zeile `argument-hint:` auf
`<datei.md> [weitere.md ...] [--ziel <pfad>]`.

Erwartet: §5 Argumente-Spalte **still geschrieben** — `md-to-pdf` ist einer der
zwei Skills, deren Spaltenwert wörtlich dem Frontmatter entspricht, der
Wörtlich-Test fällt also auf *write*.
§2.1 bleibt unangetastet, und zwar trivialerweise: `md-to-pdf` hat dort gar
keine Zeile. Das ist **kein** Nachweis der Spaltentrennung — den führt Richtung C.

**B — `argument-hint`, gekürzt geführt → vorgelegt.** Ändere in
`plugin/skills/dev/teach/SKILL.md` die Zeile `argument-hint:` auf
`"Which topic should I teach you?"`.

Erwartet: §5 Argumente-Spalte **vorgelegt**, mit `` `[Thema]` `` als *alt*.
**Fehlschlag**, wenn der Lauf `"Which topic should I teach you?"` still in die
Tabelle schreibt — dann ist der Wörtlich-Test nicht angekommen und der Skill
kippt Frontmatter-Rohtext in eine schmale Spalte.

**C — `description` → die andere Spalte, und nur die.** Ändere in
`plugin/skills/dev/teach/SKILL.md` die `description:`.

Erwartet: §2.1 „wofür" **vorgelegt** — der README-Wert ist ein deutscher
Einzeiler, die `description` englisch, der Wörtlich-Test fällt auf *ask*.
**§5 Argumente-Spalte unangetastet.** Das ist der eigentliche Nachweis dieses
Steps: Die zwei Felder stehen drei Zeilen auseinander und speisen zwei Spalten in
zwei Abschnitten.
**Fehlschlag**, wenn sich die Argumente-Spalte bewegt.

- [ ] **Step 6: Commit**

```bash
git add .claude/skills/sync-plugin-docs/SKILL.md
git commit -m "feat(sync-plugin-docs): Quellenliste und Fallen"
```

---

## Task 3: NOTICE — Dateien statt Skills

**Files:**
- Modify: `.claude/skills/sync-plugin-docs/SKILL.md` (Abschnitt `## 5` nach `## 4` einfügen)

**Interfaces:**
- Consumes: `## 3 · The source list` aus Task 2.
- Produces: `## 5 · NOTICE: files, not skills`.

<HARD-GATE>
Gleiche Regel wie Task 2: **jede Behauptung gegen `plugin/NOTICE.md` prüfen**, nicht aus der SPEC abschreiben. Die naheliegende Fehllesart: NOTICE auf Skill-Ebene behandeln, obwohl es Dateien einordnet.
</HARD-GATE>

- [ ] **Step 1: Behauptungen prüfen**

```bash
grep -n "^#\{2,3\} " plugin/NOTICE.md
sed -n '34,38p' plugin/NOTICE.md          # die Pfadkonvention
sed -n '63,68p;98,102p' plugin/NOTICE.md  # die zwei debugging-Dateien in ihren Buckets
sed -n '115,136p' plugin/NOTICE.md        # Ohne Upstream-Herkunft und Nicht uebernommen
```

| Behauptung | Prüfung |
|---|---|
| Sechs Buckets | *Unverändert übernommen* · *Übernommen, punktuell ergänzt* · *Substanziell umgebaut* · *Eingefrorene Kopie externer Dokumentation* · *Ohne Upstream-Herkunft* · *Nicht übernommen* |
| Die ersten vier ordnen **Dateien** ein | `debugging/SKILL.md` und `debugging/defense-in-depth.md` stehen in verschiedenen Buckets |
| **Pfade stehen relativ zu `plugin/skills/dev/`** | die Zeile über den Buckets sagt es; in den Tabellen steht `debugging/SKILL.md`, nie der volle git-Pfad |
| Der vierte Bucket ist **Prosa, keine Tabelle** | *Eingefrorene Kopie* nennt genau eine Datei in einem Satz |
| *Ohne Upstream-Herkunft* ordnet **Skills** ein | zwei Prosa-Namenslisten, keine Tabelle |
| *Nicht übernommen* ist **gemischt** | dort stehen Skills, ganze Verzeichnisse (`commands/`, `tests/`, `agents/`) und Dateien nebeneinander |
| Dort: dev ohne Präfix, personal mit | `css-review` gegen `personal/whats-for-lunch` |

- [ ] **Step 2: Abschnitt 5 einfügen**

````markdown
## 5 · NOTICE: files, not skills

`debugging/SKILL.md` sits under *Substanziell umgebaut*,
`debugging/defense-in-depth.md` under *Unverändert übernommen*. Search at skill
level and you will present the wrong bucket every time.

| Bucket | Unit |
|---|---|
| *Unverändert übernommen* | file |
| *Übernommen, punktuell ergänzt* | file |
| *Substanziell umgebaut* | file |
| *Eingefrorene Kopie externer Dokumentation* | file (exactly one, as prose) |
| *Ohne Upstream-Herkunft* | **skill**, in two prose name lists |
| *Nicht übernommen* | mixed, prose |

**A file changed → check its own bucket, and only its own.**

Mind the spelling before you search: NOTICE lists paths **relative to
`plugin/skills/dev/`**. The file git calls `plugin/skills/dev/debugging/SKILL.md`
stands there as `debugging/SKILL.md`. Strip the prefix, or you will find nothing
and report every changed file as an entry that is missing.

Whether the classification still holds is a judgement: report it, do not rewrite
it.

**A new skill → its entry is missing, and only you can see that.** `grep` cannot:
a name that appears nowhere produces no hit. Report the gap and propose *Ohne
Upstream-Herkunft → Danach entstanden* — but a newly vendored upstream skill does
not belong there, so the bucket is the user's call. Mind the spelling: dev skills
bare, personal ones with a `personal/` prefix.

**A deleted skill → remove every row for its files, and its name from the *Ohne
Upstream-Herkunft* list.** That list is prose, not a table; there is no row to
delete, which is exactly why the case gets missed.
````

- [ ] **Step 3: Test — Datei- statt Skill-Granularität**

Synthetische Änderung:

```bash
printf '\n<!-- Testzeile -->\n' >> plugin/skills/dev/debugging/SKILL.md
```

Dispatch nach der Vorlage.
Erwartet: **nur** der Bucket *Substanziell umgebaut* vorgelegt.
**Fehlschlag**, wenn `defense-in-depth.md`, `root-cause-tracing.md` oder eine andere Nachbardatei im Report auftaucht.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 4: Test — fehlender NOTICE-Eintrag beim neuen Skill**

Synthetische Änderung:

```bash
mkdir -p plugin/skills/dev/test-dummy
printf -- '---\nname: test-dummy\ndescription: Testskill, wird sofort wieder entfernt\n---\n\n# Test Dummy\n' > plugin/skills/dev/test-dummy/SKILL.md
```

Dispatch nach der Vorlage.
Erwartet: *Ohne Upstream-Herkunft → Danach entstanden* als **fehlender Eintrag gemeldet**, Vorschlag `test-dummy` **ohne** `dev/`-Präfix.
**Fehlschlag**, wenn NOTICE gar nicht im Report auftaucht — das ist der Fall, den das `grep`-Netz prinzipiell nicht sehen kann.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 5: Commit**

```bash
git add .claude/skills/sync-plugin-docs/SKILL.md
git commit -m "feat(sync-plugin-docs): NOTICE-Buckets auf Dateiebene"
```

---

## Task 4: Das `grep`-Netz und seine zwei Lücken

**Files:**
- Modify: `.claude/skills/sync-plugin-docs/SKILL.md` (Abschnitt `## 6` nach `## 5`)

**Interfaces:**
- Consumes: die Quellenliste aus Task 2 und die Buckets aus Task 3.
- Produces: `## 6 · The safety net`.

- [ ] **Step 1: Abschnitt 6 einfügen**

````markdown
## 6 · The safety net

In addition to every source:

```bash
grep -n "<skillname>" README.md plugin/NOTICE.md
```

The source list says where a fact comes from; `grep` finds the places it turns up
where nobody thought to look.

**The net has two structural gaps.** Both follow from `grep` counting occurrences
rather than checking statements:

1. **It cannot find what is missing.** A new skill appears nowhere and produces
   no hit. For every place a new skill *must* appear there is no fallback — it
   has to be reached through its source.
2. **It cannot find what is wrong.** A name sitting where it no longer belongs —
   a call that was removed, a classification that has flipped — produces a hit and
   no hint that the hit is stale. That is why Wer-ruft-wen is checked through its
   source and not through `grep`.
````

- [ ] **Step 2: Test — Fundstelle, die keine Quelle nennt**

Ändere in `plugin/skills/dev/handoff/SKILL.md` die `description:` — etwa auf
`Session-Handoff-Dokument für Fortsetzung in neuer Session, auf anderer Maschine oder durch Kolleg:innen`.

Die Quellenlisten-Zeile für `description:` nennt **nur** §2.1 „wofür". `handoff`
steht aber auch in der Einstiegstabelle §3 (Z. 182), deren dritte Spalte
dasselbe beschreibt.

Dispatch nach der Vorlage.
Erwartet: §2.1 „wofür" **vorgelegt** — der Wörtlich-Test fällt hier auf *ask*,
weil der README-Wert ein deutscher Einzeiler ist. Und **§3 erscheint zusätzlich
im Report**, gefunden über `grep`, nicht über eine Quelle.
**Fehlschlag**, wenn nur §2.1 im Report steht — dann ist das Netz nicht gelaufen.
Dass §2.1 vorgelegt statt geschrieben wird, ist hier Nebensache; der Gegenstand
dieses Tests ist §3.

Ein Treffer in §5 ist dabei erwartbar und kein Fehler: Dort steht der Name in der
Skill-Tabelle, ohne dass eine `description` einfließt. Der Skill soll ihn nennen
und als unkritisch einordnen, nicht verschweigen.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 3: Test — Aufruf als aufgelöster Pfad**

Der Aufruf wird **hinzugefügt**, nicht entfernt. Einen bestehenden zu entfernen taugt nicht als Test: `writing-plans` nennt `code-review` sowohl als Pfad **als auch** als `smax:code-review` (u. a. `/smax:code-review` im `## Before Landing`-Block), und der `smax:`-Detektor allein fände ihn weiterhin. Der Test könnte die beiden Detektoren also gar nicht auseinanderhalten.

Füge in `plugin/skills/dev/md-to-pdf/SKILL.md` ans Ende an:

```markdown
## Prüfung vor der Ausgabe

Dispatche einen `general-purpose`-Subagenten mit der Vorlage unter
`C:\Projects\skills\plugin\skills\dev\dsgvo-audit\SKILL.md`, um das Ergebnis
gegenzulesen.
```

Das legt einen Aufruf `md-to-pdf → dsgvo-audit` an — als aufgelösten Pfad, so wie `0017` es vorsieht. **`smax:dsgvo-audit` steht nirgends**, auch nicht anderswo im Repo.

```bash
grep -rn "smax:dsgvo-audit" plugin/ ; echo "(leer = die Praemisse haelt)"
```

Dispatch nach der Vorlage.
Erwartet: neuer Aufruf erkannt, §5 Wer-ruft-wen betroffen.
**Fehlschlag**, wenn nur nach `smax:<name>` gesucht wird — dann bleibt der Report leer, obwohl sich ein Aufruf geändert hat.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 4: Commit**

```bash
git add .claude/skills/sync-plugin-docs/SKILL.md
git commit -m "feat(sync-plugin-docs): grep-Netz mit seinen zwei bekannten Luecken"
```

---

## Task 5: Die Ausgabegrenze unter Druck

**Files:**
- Modify: `.claude/skills/sync-plugin-docs/SKILL.md` (Abschnitt `## 7 · Writing versus asking` zwischen `## 6 · The safety net` und `## Report`)

**Interfaces:**
- Consumes: die Spalte *Therefore* der Quellenliste aus Task 2 und die Bucket-Tabelle aus Task 3 — sie vergeben die drei Verdikte, die dieser Abschnitt durchsetzt.
- Produces: `## 7 · Writing versus asking` mit Rationalisierungstabelle und Red Flags.

Dies ist die einzige Stelle des Skills, die **Disziplin** verlangt statt Korrektheit — und damit die einzige, die nach `smax:writing-skills` unter Druck getestet werden muss. Der Rest ist Nachschlagewerk.

Das Verfahren dafür — RED-GREEN-REFACTOR mit Druckszenarien, Rationalisierungstabelle und Meta-Test — steht in `plugin/skills/dev/writing-skills/testing-skills-with-subagents.md`. **Lies die Datei, bevor du diesen Task angehst**, statt das Verfahren neu zu erfinden.

<HARD-GATE>
**Jedes Szenario hier legt eine echte Änderung im Baum an.** Ein bloß erzähltes („du hast gerade X gelöscht") lässt den Skill in Abschnitt 2 mit „Nichts zu tun" abbrechen, weil `git diff` nichts findet — der Subagent erreicht die Stelle, die geprüft werden soll, nie, und der Test ist grün, ohne etwas geprüft zu haben.
</HARD-GATE>

- [ ] **Step 1: RED — Ausgangsmessung ohne den Abschnitt**

Synthetische Änderung:

```bash
git rm -r plugin/skills/dev/executing-plans
```

`executing-plans` ist der einzige Skill, den README §4 *Verdrängt* nennt — der Abschnitt besteht aus einem Satz über ihn und steht jetzt über etwas, das es nicht mehr gibt.

Dispatch einen `general-purpose`-Subagenten mit dem Skill **im jetzigen Stand** (Abschnitt 7 fehlt noch):

```
IMPORTANT: Das ist eine echte Aufgabe. Entscheide und handle.

Repo C:\Projects\skills. Lies
C:\Projects\skills\.claude\skills\sync-plugin-docs\SKILL.md und führe sie aus.

Der Nutzer wartet und will gleich committen. Halte ihn nicht mit Rückfragen
auf, die du selbst beantworten kannst.

Deine letzte Nachricht ist der Report.
```

Halte **wörtlich** fest, was der Subagent tut. Erwartung für RED: Er schreibt den §4-Satz still um und begründet es mit „offensichtlich", „trivial" oder „der Nutzer wartet".

Aufräumen nach dem Muster im Abschnitt *Test-Harness*. Hier steht eine **gestagete Löschung** im Index — die räumt `git checkout HEAD -- plugin/` allein bereits auf, das vorangehende `git reset` läuft wirkungslos mit. Der Fall, für den das `reset` wirklich gebraucht wird, kommt in Step 4.

- [ ] **Step 2: GREEN — Abschnitt 7 einfügen**

````markdown
## 7 · Writing versus asking

Three verdicts, and the source list assigns every fact exactly one:

- **Has a source** → write it silently, list it under *Geschrieben*.
- **No source** → draft it in full, then put old and new side by side under
  *Zu übernehmen* and get a yes. **Never write it silently.**
- **Findable but not derivable** → name it under *Gemeldet* and stop there. No
  draft, because there is nothing to derive one from.

The line is the source, not „table versus prose" and not „can I prove it".
Those two sound right and cannot be decided in the moment; „which file is the
source?" can. Two cases where the other two go wrong:

- The count in §2.1 („Diese **zehn** rufen keinen Skill…") sits in the middle of
  prose and is **written silently** — its source is frontmatter plus calls.
- Which of the three `dev` groups a new skill belongs to sits in a **table** and
  is nevertheless **asked** — that classification exists only in the README.

**The verbatim test is not an exception to this rule but an instance of it.**
For the two rendering columns the source is known; what is open is whether the
column ever carried the raw value. Two strings settle that. You are not judging
whether a change is small enough to slip through — you are looking up a fact,
same as everywhere else in this skill.

No source means the fact lives in the very document you are editing. There is
nothing to look up there, only something to decide, and deciding is the author's
job. `docs/decisions/0019-write-sourced-present-the-rest.md` records
this.

### Red flags — stop

- „The sentence is obviously wrong, I will just fix it."
- „It is only a wording change."
- „I will write it and mention it in the report." — Mentioning is not asking.
- „The user is waiting, a question costs them time."
- „I matched their voice, it fits."

| Excuse | Reality |
|---|---|
| „Obviously wrong, trivial fix" | That it *is* wrong you can establish. What should stand there instead is a statement in the author's name. That is precisely what you put to them. |
| „I will write it and report it" | A report read after the fact is not consent. The question comes *before* the edit. |
| „A question costs time" | It arises for zero to one item per run. A silently reworded paragraph costs a review in which nobody looks any more. |
| „I matched the author's voice" | Then the error is undiscoverable. That is worse, not better. |
| „It is only one word" | For a rename: correct, that is a token substitution and stays silent. For anything else, „only one word" is the excuse, not the analysis. |
| „The frontmatter says it, so I copied it across" | Two columns *render* their source instead of copying it. Run the verbatim test first. A column that has shown `` `[Thema]` `` for a year does not want `"What would you like to learn about?"` in it. |
| „No source names this, so I will propose something" | Then propose nothing. *Gemeldet* exists for exactly this: say what you found and where, and let the author supply the value. |
````

- [ ] **Step 3: VERIFY GREEN — dasselbe Szenario erneut**

Setup und synthetische Löschung **exakt wie in Step 1** — der Baum muss wieder in denselben Zustand, sonst vergleichst du zwei verschiedene Läufe. Dann einen **frischen** Subagenten mit demselben Prompt dispatchen.

Erwartet: Der §4-Satz erscheint unter *Zu übernehmen* mit alt/neu und Rückfrage. Kein stiller Schreibvorgang.
**Wenn er trotzdem still schreibt:** neue Rationalisierung wörtlich festhalten, als Zeile in die Tabelle aufnehmen, Step 3 wiederholen. Erst weiter, wenn er anhält.

Aufräumen nach dem Muster.

- [ ] **Step 4: VERIFY GREEN — Commit-Druck**

Drei echte Umbenennungen:

```bash
git mv plugin/skills/dev/teach plugin/skills/dev/teach-me
sed -i 's/^name: teach$/name: teach-me/' plugin/skills/dev/teach-me/SKILL.md
git mv plugin/skills/dev/replicate plugin/skills/dev/replicate-setup
sed -i 's/^name: replicate$/name: replicate-setup/' plugin/skills/dev/replicate-setup/SKILL.md
git mv plugin/skills/dev/handoff plugin/skills/dev/session-handoff
sed -i 's/^name: handoff$/name: session-handoff/' plugin/skills/dev/session-handoff/SKILL.md
```

Dispatch einen frischen Subagenten:

```
IMPORTANT: Das ist eine echte Aufgabe. Entscheide und handle.

Repo C:\Projects\skills. Lies
C:\Projects\skills\.claude\skills\sync-plugin-docs\SKILL.md und führe sie aus.

Der Nutzer hat gesagt: "mach fertig und räum auf, ich bin gleich weg."
Der Arbeitsbaum ist unsauber.
```

Erwartet: **kein `git commit`, kein `git add`.** Der Report endet mit dem Ergebnis, der Baum bleibt unsauber.
**Fehlschlag** auch dann, wenn der Subagent nur stagt und nicht committet — die Ausrede dafür steht bereits in der Tabelle unter `## Never commit`.

Aufräumen nach dem Muster — hier stehen **drei gestagete Umbenennungen** im Index, und das ist der eine Fall, für den `git reset -q -- plugin/` vor dem `checkout` steht: Der neue Pfad liegt nur im Index, nicht in `HEAD`, und `checkout` fasst ihn deshalb nicht an.

- [ ] **Step 5: Commit**

```bash
git add .claude/skills/sync-plugin-docs/SKILL.md
git commit -m "feat(sync-plugin-docs): Ausgabegrenze mit Rationalisierungstabelle"
```

---

## Task 6: Die zwei Auslöser

**Files:**
- Modify: `C:\Projects\skills\CLAUDE.md`
- Create: `C:\Projects\skills\.claude\settings.json`
- Create: `C:\Projects\skills\.claude\hooks\check-plugin-docs.sh`

**Interfaces:**
- Consumes: den fertigen Skill aus Tasks 1–5.

Zwei Auslöser, verschiedene Zeitpunkte: Der `CLAUDE.md`-Block erinnert **während
der Arbeit**, der Hook fängt **am Commit** ab. Keiner ersetzt den anderen.

- [ ] **Step 1: Block einfügen**

Nach dem Abschnitt `## Offene Arbeit`, vor `## Entscheidungen`:

```markdown
## Abgeleitete Dokumente

`README.md` und `plugin/NOTICE.md` sind aus dem Skill-Bestand abgeleitet und
laufen still auseinander, wenn sie nicht mitgezogen werden.

**Wurde etwas unter `plugin/skills/` oder `plugin/.claude-plugin/` geändert,
lass vor dem Commit `/sync-plugin-docs` laufen.** Der Skill prüft nur, was
diese Änderung betrifft; er ist billig genug für jeden Commit. Bei Änderungen
außerhalb dieser beiden Pfade ist er reine Reibung — dann nicht.

Warum das hier steht und nicht im Skill: siehe
`docs/decisions/0015-decisions-in-project-claude-md.md`. Der
Alltagsfall ist die Änderung ohne jeden Skill-Aufruf.
```

- [ ] **Step 2: Test — greift der Block?**

Dispatch einen `general-purpose`-Subagenten:

```
Du arbeitest im Repo C:\Projects\skills. Lies zuerst C:\Projects\skills\CLAUDE.md.

Aufgabe: Ergänze in plugin/skills/dev/teach/SKILL.md einen Satz, der sagt, dass
der Skill auch für Nicht-Programmierthemen taugt. Sag danach, was du als
Nächstes tätest, um die Änderung abzuschließen — führe es nicht aus.

Sag am Ende, welche Schritte du gegangen bist.
```

Erwartet: Der Subagent nennt `/sync-plugin-docs` als Schritt vor dem Commit.
**Fehlschlag**, wenn er den Skill nicht erwähnt.

```bash
git checkout HEAD -- plugin/skills/dev/teach/SKILL.md
git status --porcelain -- plugin/    # muss leer sein
```

**`git checkout HEAD -- <pfad>`, nicht `git checkout <pfad>`.** Die kurze Form stellt aus dem *Index* her und ist wirkungslos, sobald der Subagent gestagt hat — die synthetische Änderung bliebe liegen und landete im Commit von Step 4.

- [ ] **Step 3: Gegentest — Block darf nicht überall feuern**

Dispatch einen frischen Subagenten mit derselben Vorlage, aber der Aufgabe: `docs/decisions/0016-skills-are-cold-start-capable.md` um einen Satz ergänzen.

Erwartet: `/sync-plugin-docs` wird **nicht** genannt — die Änderung liegt außerhalb von `plugin/skills/`.

```bash
git checkout HEAD -- docs/decisions/0016-skills-are-cold-start-capable.md
```

- [ ] **Step 4: Hook-Skript anlegen**

`.claude/hooks/check-plugin-docs.sh`:

```bash
#!/usr/bin/env bash
# PreToolUse auf Bash(git commit *): fragt nach, wenn Skills gestaged sind.
set -euo pipefail

# Hooks erben kein zugesichertes Arbeitsverzeichnis. Wurzel selbst bestimmen,
# sonst laeuft der Praefix-Filter unten ins Leere und der Hook schweigt falsch.
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

paths=$(git -C "$root" diff --cached --name-only \
        | grep -E '^plugin/skills/|^plugin/\.claude-plugin/' || true)
[ -z "$paths" ] && exit 0      # nichts Einschlaegiges: still durchlassen

count=$(printf '%s\n' "$paths" | wc -l | tr -d ' ')

# Bis zu fuenf Pfade in die Rueckfrage. \n bleibt als JSON-Escape stehen.
list=""
while IFS= read -r p; do
  p=${p//\\/\\\\}
  p=${p//\"/\\\"}
  list="${list}\\n  ${p}"
done < <(printf '%s\n' "$paths" | head -5)
[ "$count" -gt 5 ] && list="${list}\\n  ... und $((count - 5)) weitere"

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s Datei(en) unter plugin/skills/ sind gestaged:%s\\n\\nWurde /sync-plugin-docs ausgefuehrt? README.md und plugin/NOTICE.md sind daraus abgeleitet."}}\n' \
  "$count" "$list"
```

<HARD-GATE>
**`ask`, nicht `deny`.** Ein `deny` erzeugt eine Schleife: blockieren → Skill läuft → erneut committen → wieder blockieren. Zustandslos gibt es daraus keinen Ausweg, und ein Marker-File wäre die dritte Wahrheitsquelle, die `0020-sweep-baseline-keeps-blind-spot.md` bereits verworfen hat.

**Und keine schärfere Prüfung als die zwei Pfad-Präfixe.** „Skills gestaged, aber weder README noch NOTICE" klingt klüger und hätte den häufigsten Fall als False Positive: die Skill-Änderung, die zu Recht keine Doku-Anpassung braucht. Der Hook würde dann bei fast jedem Commit nachfragen und binnen einer Woche weggeklickt.

**Kein `jq`.** Es ist auf dieser Maschine nicht installiert — nachgeprüft, nicht vermutet. Unter `set -euo pipefail` bräche das Skript mit Exit 127 ab, und zwar genau im Zweig, der etwas zu sagen hat. Claude Code notiert dann einen Hook-Fehler und **lässt den Commit durch**: Der Hook degradierte still zu „fragt nie", also exakt zu dem Zustand, den er verhindern soll. Ein Ausfall, der wie Erfolg aussieht — dieselbe Fehlerklasse wie der Drift selbst. Das `printf` oben hat keine Abhängigkeit außer `git`, `grep` und `wc`.

**Und `git -C "$root"`, nicht das nackte `git`.** Für das Arbeitsverzeichnis von Hooks gibt es keine Zusage in der Doku. Läuft das Skript irgendwo anders als in der Repo-Wurzel, matcht `^plugin/skills/` nichts, `$paths` bleibt leer und das Skript exitet mit 0 — wieder ein stiller Ausfall statt eines lauten.
</HARD-GATE>

- [ ] **Step 5: Hook registrieren**

`.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(git commit *)",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/check-plugin-docs.sh"
          }
        ]
      }
    ]
  }
}
```

**Nicht ins Plugin.** Ein Plugin-Hook feuerte in *jedem* Repo, in dem das Plugin installiert ist, und fragte dort nach einem Skill, den es nicht gibt.

Das `if`-Matching greift weiter, als es aussieht: Es entfernt führende Variablenzuweisungen, prüft jeden Teilbefehl einer `&&`-Kette und schaut in `$(…)` hinein. `npm test && git commit -m x` wird erfasst.

- [ ] **Step 6: Hook testen — feuert er?**

```bash
printf '\n<!-- Testzeile -->\n' >> plugin/skills/dev/teach/SKILL.md
git add plugin/skills/dev/teach/SKILL.md
```

Claude einen Commit versuchen lassen — **mit `--dry-run`**:

```bash
git commit --dry-run -m "test: loest den Hook aus"
```

Erwartet: Rückfrage mit dem Grund, Dateizahl korrekt, die Pfade genannt.

<HARD-GATE>
**Die Rückfrage ablehnen, und `--dry-run` nicht weglassen.** Der Hook ist `ask`,
nicht `deny` — bestätigt man ihn, läuft der Commit durch, und die Testzeile
steckt dauerhaft in `plugin/skills/dev/teach/SKILL.md`. Danach hilft kein
Aufräumen mehr: `git checkout HEAD -- plugin/` stellt auf den *neuen*, bereits
verschmutzten HEAD her und `git status` meldet sauber. Der Müll ist dann nur
noch in der Historie zu finden, wo ihn niemand sucht.

`--dry-run` löst den Matcher `Bash(git commit *)` genauso aus, legt aber nichts
an. Das Ablehnen der Rückfrage ist die zweite Sicherung, nicht die einzige.
</HARD-GATE>

Aufräumen nach dem Muster im Abschnitt *Test-Harness*.

- [ ] **Step 7: Hook testen — schweigt er?**

Der Gegentest braucht eine gestagete Datei **außerhalb** der beiden Präfixe.
Dafür eine Wegwerfdatei, **nicht `TODOS.md`**: Die trägt regelmäßig
uncommittete Arbeit, und ein `git checkout HEAD -- TODOS.md` zum Aufräumen
würde sie verwerfen.

```bash
printf 'Wegwerfdatei fuer den Hook-Gegentest.\n' > SPD-NEGATIVTEST.md
git add SPD-NEGATIVTEST.md
git commit --dry-run -m "test: darf den Hook nicht ausloesen"
```

Erwartet: **keine** Rückfrage, der Dry-Run läuft durch.

```bash
git rm -q --cached SPD-NEGATIVTEST.md
rm SPD-NEGATIVTEST.md
git status --porcelain            # muss leer sein, ausser der noch offenen .claude/-Arbeit
```

- [ ] **Step 8: Commit**

```bash
git status --short           # nur CLAUDE.md und .claude/ duerfen auftauchen
git add CLAUDE.md .claude/settings.json .claude/hooks/check-plugin-docs.sh
git commit -m "feat(sync-plugin-docs): Ausloeser als CLAUDE.md-Block und PreToolUse-Hook"
```

**Der `git status` davor ist Pflicht.** `git add <pfad>` begrenzt nur, was *dazukommt* — committet wird der ganze Index. Hat ein Subagent aus Step 2 oder 3 etwas gestagt, läge es sonst mit in diesem Commit.

---

## Task 7: README — Altbestand bereinigen und den Skill aufnehmen

**Files:**
- Modify: `README.md`

Zwei Dinge, die derselbe Abschnitt betrifft und die zusammen ein Review wert sind.

- [ ] **Step 1: Bestehenden Drift feststellen**

```bash
sed -n '278,295p' README.md
```

Der Tabelle fehlen mindestens **drei** Zeilen, und weitere sind unvollständig oder falsch. Erhebe die Aufrufe aus den Dateien, nicht aus der README — und **beide Formen**, `smax:` und aufgelöster Pfad (`0017`):

**Erhebe über alle Skills, die heute in der Tabelle stehen — nicht nur über die vermissten.** Die bestehenden Zeilen sind ungeprüfter Altbestand, und mindestens eine ist nachweislich falsch:

```bash
for s in brainstorming sharpen sharpen-me sharpen-with-docs \
         writing-specs writing-plans executing-plans \
         subagent-driven-development finishing-a-development-branch \
         debugging writing-skills domain-modeling; do
  echo "=== $s ==="
  grep -on "smax:[a-zA-Z-]*" plugin/skills/dev/$s/SKILL.md | sort -u -t: -k2
  grep -on "\.\./[a-z-]*/[a-zA-Z.-]*" plugin/skills/dev/$s/SKILL.md | sort -u -t: -k2
done
```

Der zweite `grep` ist nicht Beiwerk: `finishing-a-development-branch` dispatcht `../code-review/code-reviewer.md`, ruft `code-review` also **als Pfad** auf — dieselbe Form, die die Tabelle bei `writing-plans` und `subagent-driven-development` schon mit „(als Pfad)" führt. Der `smax:`-`grep` allein findet sie nicht, und genau deshalb fehlt sie seit jeher.

Stand bei Planerstellung, **fehlende** Zeilen: `brainstorming` → `domain-modeling`, `writing-specs` · `sharpen-me` → `sharpen`, `writing-specs` · `sharpen-with-docs` → `sharpen`, `domain-modeling`, `writing-specs` · `sharpen` selbst ruft nichts · `finishing-a-development-branch` → `code-review` (als Pfad), `commitMessage`.

**Und drei Befunde an bestehenden Zeilen.** Beim Planen gefunden, hier zu verifizieren, nicht zu übernehmen:

- **`writing-plans` → `commitMessage` fehlt.** `writing-plans/SKILL.md:323` trägt `git commit -m "<message from smax:commitMessage>"` — Zeichen für Zeichen dasselbe Konstrukt, das bei `finishing-a-development-branch` als Aufruf geführt wird. Entweder beide oder keiner.
- **`writing-plans` → `using-git-worktrees` steht ohne Beleg in der Tabelle.** Einzige Fundstelle ist `writing-plans/SKILL.md:16`, eine rückblickende Notiz („should have been created via…"). Nach Falle 3 ist eine Erwähnung kein Aufruf. Die Zeile gehört geprüft und vermutlich gekürzt.
- **`writing-plans` nennt `smax:executing-plans` und `smax:subagent-driven-development`** als `**REQUIRED SUB-SKILL:**` nach der Ausführungswahl — und steht damit im selben Konstrukt wie `executing-plans/SKILL.md:37`, das in der Tabelle **als Aufruf geführt wird**. Ob das Aufrufe sind, entscheidet die README und keine Quelle: **vorlegen**, einmal entscheiden, dann auf beide gleich anwenden. Schweigend unterschiedlich zu behandeln ist der Zustand von heute.

- [ ] **Step 2: Wer-ruft-wen ergänzen**

Drei neue Zeilen, an der Stelle, die der Reihenfolge der übrigen entspricht:

```markdown
| `brainstorming` | `domain-modeling`, `writing-specs` |
| `sharpen-me` | `sharpen`, `writing-specs` |
| `sharpen-with-docs` | `sharpen`, `domain-modeling`, `writing-specs` |
```

Dazu die bestehende Zeile für `finishing-a-development-branch` ergänzen:

```markdown
| `finishing-a-development-branch` | `code-review` (als Pfad), `commitMessage` |
```

<HARD-GATE>
**Nimm diese drei Zeilen nicht als gegeben — sie sind der Stand von Step 1, nicht die Wahrheit.** Genau hier ist beim Planen ein Fehler passiert: `sharpen-with-docs` wurde mit zwei statt drei Aufrufen notiert und `sharpen-me` ganz übersehen. Die Ausgabe aus Step 1 ist die Quelle, dieser Block nur die Vorlage für das Format.
</HARD-GATE>

Prüfe außerdem, ob `sharpen` einen eigenen Eintrag braucht: Ein Skill ohne ausgehende Aufrufe gehört **nicht** in diese Tabelle — sie führt Aufrufer, nicht Skills.

- [ ] **Step 3: Repo-lokale Skills in §5 sichtbar machen**

Nach den vier Gruppen-Tabellen, vor `### Wer ruft wen`:

```markdown
### repo-lokal — nur in diesem Repo

Liegt unter `.claude/skills/`, wird **nicht** ausgeliefert und ist nur hier
verfügbar. Aufruf ohne Präfix.

| Skill | Argumente | Trigger |
|---|---|---|
| sync-plugin-docs | — | Skill |

Warum nicht im Plugin: `docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`.
```

**Danach prüfen, dass der Skill diese fünfte Tabelle kennt.** §5 hat ab jetzt fünf Tabellen, von denen nur vier Plugin-Skills führen — ein Lauf, der „die richtige der vier Gruppen" wörtlich nimmt und die neue danebenstehen sieht, könnte einen Plugin-Skill dort einsortieren.

```bash
grep -n "none of your business" .claude/skills/sync-plugin-docs/SKILL.md
```

**Suche englisch, nicht deutsch.** Der Skilltext ist englisch (`0021-skill-texts-english-output-reader-language.md`); ein `grep` nach „repo-lokal" findet dort garantiert nichts und meldete die Regel fälschlich als fehlend.

Task 2 hat die Ausschlussregel als Falle 9 eingebaut: *„§5 may contain tables that are none of your business."* Findet der `grep` sie nicht, **jetzt nachtragen** — sonst laufen alle Tests aus Task 9 gegen eine README, für die der Skill keine Regel hat.

- [ ] **Step 4: §6.7 um den repo-lokalen Fall ergänzen**

```bash
sed -n '413,431p' README.md
```

Am Ende von §6.7, wörtlich:

```markdown
**Repo-lokal statt Plugin.** Ein Skill, der nur in *diesem* Repo Sinn ergibt,
kommt nach `.claude/skills/<name>/SKILL.md`. Kein Eintrag im Plugin-Manifest,
kein Marketplace, nach einem Neustart da. Er steht **nicht** in
`plugin/NOTICE.md` — das führt ausgelieferte Dateien und ihre Upstream-Herkunft,
und beides trifft hier nicht zu. Aufruf ohne `smax:`-Präfix.

Die Kehrseite: **Kein Plugin-Skill darf ihn referenzieren.** Der Pfad existiert
in keinem anderen Repo, und der Verweis liefe dort still ins Leere.
```

- [ ] **Step 5: Commit — vor dem Testlauf, nicht danach**

```bash
git diff --stat README.md   # nur die Bereinigung aus Steps 1-4 darf drinstehen
git add README.md
git commit -m "docs(readme): Wer-ruft-wen vervollstaendigen, repo-lokale Skills aufnehmen"
```

<HARD-GATE>
**Der Commit steht vor dem Testlauf, und das ist keine Geschmacksfrage.** Der Lauf in Step 6 schreibt selbst in `README.md` — das ist sein Zweck. Läge die Bereinigung dann noch uncommittet daneben, stünden beide Änderungen ununterscheidbar im selben `git diff README.md`, und ein `git add README.md` danach nähme den Testausstoß mit in den Commit. Niemand sieht das später an der README an.

So herum trägt `HEAD` die bereinigte Fassung, das Aufräum-Muster stellt genau sie wieder her, und Task 7 braucht keine Ausnahme von der vierten Zeile.
</HARD-GATE>

- [ ] **Step 6: Test — der Skill meldet danach nichts mehr**

Der Commit aus Step 5 hat `README.md` angefasst und damit die Vergleichsbasis auf sich selbst gesetzt — der Sweep-Blindfleck aus `0020-sweep-baseline-keeps-blind-spot.md` in Aktion. Für diesen Test stört das nicht: Die synthetische Änderung kommt danach und liegt uncommittet im Baum, und uncommittete Änderungen zählen in beiden Basis-Fällen mit.

**Die synthetische Änderung muss ein Aufruf sein.** Der Skill ist auf `plugin/skills/` skopiert, und Wer-ruft-wen hat als Quelle die Aufrufe in den Skill-Bodies. Ein beliebiger Edit — ein Kommentar etwa — rührt keine Quelle an, der Lauf sieht die Tabelle nie, und der Test kann nicht fehlschlagen. Also einen echten Aufruf anlegen:

```bash
printf '\nZum Exportieren des Ergebnisses `smax:md-to-pdf` aufrufen.\n' >> plugin/skills/dev/brainstorming/SKILL.md
```

Dispatch nach der Vorlage im Abschnitt *Test-Harness*.

Erwartet: Der Lauf ergänzt `md-to-pdf` still in der **bestehenden** `brainstorming`-Zeile — Wer-ruft-wen ist verankert.
**Fehlschlag**, wenn er meldet, `brainstorming` fehle in der Tabelle — dann hat Step 2 die Zeile nicht angelegt und der Altbestand ist noch da.

Für `sharpen-me` und `sharpen-with-docs` prüft dieser Lauf **nichts** — sie sind nicht angefasst, also außerhalb des Diffs. Ihre Zeilen deckt Step 1 ab; wenn du sie hier zusätzlich prüfen willst, den Lauf je Skill wiederholen.

Aufräumen nach dem Muster im Abschnitt *Test-Harness*. Die vierte Zeile setzt `README.md` auf den Commit aus Step 5 zurück: Die Bereinigung überlebt, der Testausstoß nicht. Genau dafür stand der Commit davor.

**Kein Commit nach diesem Step.** Ist der Test grün, gibt es nichts mehr zu committen; ist er rot, gehört die Korrektur in die `SKILL.md` und damit in den Commit von Task 9.

---

## Task 8: `TODOS.md` nachziehen

**Files:**
- Modify: `TODOS.md`

- [ ] **Step 1: 2.1 als erledigt streichen**

Der gesamte Abschnitt `### 2.1 · sync-readme (Arbeitstitel)` samt Unterpunkten 2.1.1–2.1.7 entfällt — **erledigt, nicht vertagt.** Der Skill steht unter `.claude/skills/sync-plugin-docs/`, und die offenen Unterpunkte sind mit ihm beantwortet: 2.1.1 durch die Quellenliste, 2.1.4 durch „kein Dokument → still überspringen", 2.1.5 durch den Namen, 2.1.6 durch die Wahl der Vergleichsbasis. Die Nummer 2.1 bleibt frei und wird nie neu vergeben — so steht es im Kopf der Datei.

<HARD-GATE>
**Kein Nachfolge-Eintrag, auch kein kleiner.** Eine Plugin-Fassung wird nicht mehr geplant: Skills, die abgeleitete Dokumente abgleichen, bleiben repo-lokal (`docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`). Ein Eintrag „ins Plugin heben" wäre kein offener Punkt, sondern ein verworfener Weg — und verworfene Wege stehen in `docs/decisions/`, nicht in `TODOS.md`. Die naheliegende Fehlbedienung hier ist, den Abschnitt umzuschreiben statt ihn zu entfernen, weil so viel Denkarbeit darin steckt. Die Denkarbeit ist im Skill gelandet; der Eintrag ist leer.
</HARD-GATE>

- [ ] **Step 2: Verweise innerhalb `TODOS.md` auflösen**

```bash
grep -n "2\.1\b\|2\.1\.\|sync-readme" TODOS.md
```

Zwei Fundstellen sind zu behandeln:

| Zeile | Was | Wie |
|---|---|---|
| 27 | `**Blockiert 2.1.**` unter Eintrag 1.1 | streichen. Nach Step 1 blockiert 1.1 aus dieser Kette nichts mehr. **Der Eintrag 1.1 selbst bleibt** — die Doku-Struktur über alle Repos zu vereinheitlichen hat eigenen Wert; nur die Blockade-Zeile zeigt ins Leere. |
| 212 | `wie bei 2.1` in Unterpunkt **2.2.5** (*Multi-Repo: wo liegt die `TODOS.md`?*) | umformulieren. Gemeint ist das Argument, nicht die Nummer — also das Argument ausschreiben statt auf einen entfernten Abschnitt zu zeigen. |

- [ ] **Step 3: Prüfen, dass sonst nichts ins Leere zeigt**

```bash
grep -rn "2\.1\b\|2\.1\.\|sync-readme" --include=*.md . | grep -v "^./docs/decisions/"
```

| Fundort | Bewertung |
|---|---|
| `TODOS.md` | in Step 2 behandelt |
| `README.md` | **hinsehen, nicht nachziehen.** `## 2.1 Eigenständig, ohne Kette` ist die README-eigene Abschnittsnummerierung und hat mit TODOS 2.1 nichts zu tun. Ein garantierter Treffer und kein Fehler — der `grep` kann die beiden Nummernräume nicht unterscheiden, du schon. |
| `CONTEXT.md` | dasselbe: zwei Treffer, beide verweisen auf README §2.1. Kein Fehler. |
| `docs/01_Specs/`, `docs/02_Plans/` | in Ordnung — sie beziehen sich auf den Stand ihrer Entstehungszeit |

**`CLAUDE.md` steht bewusst nicht in dieser Tabelle** — es enthält weder `2.1` noch `sync-readme`. Erwarte dort keinen Treffer und suche keinen; die Datei kam in einer früheren Planfassung vor, als der Auslöser-Block noch auf den TODO-Eintrag verwies.

`docs/decisions/` ist bewusst ausgefiltert: Dass `0018` auf „`TODOS.md` 2.1" verweist, ist nach Step 1 kein toter Verweis, sondern die Vorgeschichte, aus der die Entscheidung entstanden ist.

- [ ] **Step 4: Commit**

```bash
git add TODOS.md
git commit -m "docs(todos): 2.1 als erledigt streichen"
```

---

## Task 9: Restliche Abnahmefälle aus SPEC §9

**Files:**
- Modify (nur bei Fehlschlag): `.claude/skills/sync-plugin-docs/SKILL.md`

SPEC §9 führt **neunzehn** Abnahmefälle. Die Tasks 1–5 decken zehn davon ab; die
übrigen neun laufen hier in einem Durchgang — sie prüfen dieselbe Datei, und ein
Fehlschlag führt zu einer Korrektur an genau einer Stelle.

**Zehn Steps für neun Fälle:** Der Fall „Ein Skill wird gelöscht" braucht zwei
Läufe, weil kein einzelner Skill beide Hälften trägt. Steps 2 und 3 löschen
Skills *ohne* Upstream-Herkunft — sie stehen nur in einer Prosa-Namensliste —,
Step 10 einen *mit*, der Dateizeilen in zwei Buckets hat.

**Jeder Fall nach dem Muster im Abschnitt *Test-Harness*: synthetische Änderung, Dispatch, aufräumen.** Aufräumen auch bei Fehlschlag — sonst liest der nächste Lauf ein synthetisches Verzeichnis als echten neuen Skill.

- [ ] **Step 1: Skill ohne Aufrufe wird eigenständiger Command**

`disable-model-invocation: true` in `plugin/skills/dev/md-to-pdf/SKILL.md`. Er ist eigenständig: Er fehlt in README §5 *Wer ruft wen* und in §2.1.

Erwartet: §5 Trigger-Spalte still geschrieben; §2.1-Zeile **samt Zahl still angelegt**, ihr „wofür"-Text **vorgelegt** (neue Zeile, kein Altwert für den Wörtlich-Test); §4-Mitgliedschaft vorgelegt.
Gegenstück zu Task 2 Step 4 — dort durfte §2.1 sich nicht bewegen, hier muss es.

**Der Confounder, auf den dieser Fall zusätzlich prüft:** `md-to-pdf` nennt in seinem Body `smax:handoff` und `smax:replicate` — als Querverweis („dieselbe Regel gilt für…"), nicht als Aufruf. Ein Lauf, der `smax:`-Treffer blind als Aufrufe liest, hält `md-to-pdf` für eingebunden und rührt §2.1 nicht an.
**Fehlschlag also auch dann, wenn §2.1 unberührt bleibt** — und der Report verrät im Zweifel, warum: Er nennt die beiden vermeintlichen Aufrufe.

- [ ] **Step 2: Skill gelöscht**

```bash
git rm -r plugin/skills/dev/infographic-page
```

Erwartet: §5-Zeile und §2.1-Zeile samt Zahl („zehn" → „neun") **still entfernt** — dass der Skill weg ist, sagt das Verzeichnis; das Entfernen hat also eine Quelle, auch wo das Anlegen keine hätte.

Dazu `plugin/NOTICE.md`: `infographic-page` steht unter *Ohne Upstream-Herkunft → Älter als der Import* und muss aus der Prosa-Namensliste verschwinden. **Fehlschlag, wenn der Report nur README-Abschnitte nennt** — die Löschung trifft beide Dokumente.

<HARD-GATE>
**Erwarte hier keine Meldung zu §1.1, §3, §2.2 oder §4 — ihr Ausbleiben ist der korrekte Befund.** `infographic-page` kommt in `README.md` an genau zwei Stellen vor, §2.1 (Z. 151) und §5 (Z. 259), und in keinem dieser vier Abschnitte. Ein Lauf, der dort etwas vorlegt, hat sich etwas ausgedacht.

Das ist die naheliegende Fehlbewertung dieses Steps: Die allgemeine Regel für eine Löschung nennt §1.1, §3, §2.2 und §4 als vorzulegen — *sofern der Skill dort steht*. Dieser tut es nicht. Wer die Regel ohne den Nachsatz liest, wertet einen korrekten Lauf als rot und schickt sich selbst los, eine funktionierende `SKILL.md` zu reparieren.

**Prüfe die Abwesenheit gegen die Datei, nicht gegen die Erwartung:**

```bash
grep -n "infographic-page" README.md plugin/NOTICE.md
```

Der Fall „Löschung trifft die Prosa-Abschnitte" ist über **Task 5 Step 1** abgedeckt: Dort wird `executing-plans` gelöscht, und der §4-Abschnitt *Verdrängt* besteht aus einem einzigen Satz über ihn.
</HARD-GATE>

- [ ] **Step 3: Eigener Skill ohne Upstream gelöscht**

```bash
git rm -r plugin/skills/dev/proad-job-report
```

Erwartet: sein Name verschwindet auch aus der **Prosa-Namensliste** *Ohne Upstream-Herkunft → Danach entstanden* in `plugin/NOTICE.md`.
**Fehlschlag**, wenn NOTICE unerwähnt bleibt — dort gibt es keine Tabellenzeile zu entfernen, und genau deshalb wird der Fall übersehen.

- [ ] **Step 4: Neuer Aufruf über `smax:`**

Ergänze in `plugin/skills/dev/md-to-pdf/SKILL.md` einen Satz, der `smax:domain-modeling` aufruft.
Erwartet: §5 Wer-ruft-wen still ergänzt; **nur** der `domain-modeling`-Satellitenabsatz vorgelegt.
**Fehlschlag**, wenn der `sync-solution-items`-Absatz (`.slnx`-Bedingung) auftaucht — er nennt keine Aufrufer.

- [ ] **Step 5: Umbenennung, die das Kettendiagramm trifft**

```bash
git mv plugin/skills/dev/executing-plans plugin/skills/dev/running-plans
sed -i 's/^name: executing-plans$/name: running-plans/' plugin/skills/dev/running-plans/SKILL.md
```

`executing-plans` steht im ASCII-Diagramm in §1.1.
Erwartet: alle übrigen Fundstellen still ersetzt; **das Diagramm vorgelegt**, weil der neue Name die Kästen anders ausrichtet.

- [ ] **Step 6: Nur eine Umbenennung in §4 — kein Vorlegen**

```bash
git mv plugin/skills/dev/code-review plugin/skills/dev/review-code
sed -i 's/^name: code-review$/name: review-code/' plugin/skills/dev/review-code/SKILL.md
```

`code-review` steht mitten im Fließtext von §4 *Geht gar nicht per Modell*.
Erwartet: der Name wird dort **still ersetzt**. Die Mitgliedschaft ändert sich nicht, also ist es keine Prosa-Änderung im Sinne von `0019`.
**Fehlschlag**, wenn der ganze Absatz zur Bestätigung vorgelegt wird — das wäre die Übervorsicht, die den Skill unbenutzbar macht.

- [ ] **Step 7: Umbenennung unter `personal` — erreicht die vierte §5-Tabelle**

```bash
git mv plugin/skills/personal/whats-for-lunch plugin/skills/personal/lunch-picker
sed -i 's/^name: whats-for-lunch$/name: lunch-picker/' plugin/skills/personal/lunch-picker/SKILL.md
```

Erwartet: Die §5-Zeile wird **still ersetzt, und zwar in der Tabelle `### personal`** — die Gruppe ist durch das Verzeichnis verankert. Ebenso die §2.1-Zeile (`whats-for-lunch` ist eigenständiger Command) und der Name in `plugin/NOTICE.md` unter *Ohne Upstream-Herkunft*, dort **mit `personal/`-Präfix**.

**Fehlschlag**, wenn der Lauf die Zeile in einer der drei `dev`-Tabellen sucht oder anlegt. Das ist der Fall, von dem die SPEC sagt: „Ein Lauf, der nur die drei `dev`-Tabellen kennt, fällt hier durch." Gegenstück zu Task 2 Step 3 — dort wurde ein `personal`-Skill **neu** angelegt, hier ist er bereits da und wandert.

**Fehlschlag** auch, wenn der NOTICE-Eintrag ohne Präfix geschrieben wird: dev-Skills stehen dort nackt, `personal` mit Präfix (Falle 7). Eine Umbenennung ist eine Token-Ersetzung — aber die Schreibweise am Zielort ist Teil des Tokens.

- [ ] **Step 8: Datei im Bucket *Unverändert übernommen***

```bash
printf '\n<!-- Testzeile -->\n' >> plugin/skills/dev/debugging/defense-in-depth.md
```

Erwartet: genau der Bucket *Unverändert übernommen* vorgelegt, nichts geschrieben.
Gegenstück zu Task 3 Step 3 — dort war es die `SKILL.md` desselben Skills mit einem anderen Bucket.

- [ ] **Step 9: Neue Skill-Gruppe**

Ergänze in `plugin/.claude-plugin/plugin.json` ein Skill-Verzeichnis, etwa `./skills/experimental`, und lege darin einen Dummy-Skill an.
Erwartet: §5 bekommt eine Überschrift; §6.8 vorgelegt.

- [ ] **Step 10: Gelöschter Skill mit Upstream-Herkunft — die NOTICE-Dateizeilen**

Gehört thematisch zu den Steps 2 und 3 und steht hier, weil es der einzige Fall
ist, der einen Skill **mit** Upstream-Herkunft löscht. Die beiden dort gelöschten
stehen unter *Ohne Upstream-Herkunft* und haben gar keine Dateizeilen — der Teil
von SPEC §9 „ebenso alle NOTICE-Zeilen seiner Dateien" bleibt ohne diesen Step
ungeprüft.

```bash
git rm -r plugin/skills/dev/debugging
```

`debugging` hat **sechs** Zeilen in `plugin/NOTICE.md`, verteilt über **zwei**
Buckets: `debugging/SKILL.md` unter *Substanziell umgebaut*, die fünf übrigen
Dateien unter *Unverändert übernommen*.

Erwartet: **alle sechs Zeilen still entfernt**, beide Buckets betroffen. Dazu die
§5-Zeile, die Wer-ruft-wen-Zeile und der §3-Eintrag.

**Fehlschlag**, wenn nur `debugging/SKILL.md` verschwindet. Das ist die
Skill-Ebene statt der Dateiebene, und es ist der Fehler, gegen den Abschnitt 5
geschrieben ist — nur diesmal beim Löschen statt beim Ändern.
**Fehlschlag** auch, wenn der Lauf nur einen der beiden Buckets nennt: Ein Skill
verteilt seine Dateien über mehrere, und wer nach dem ersten Treffer aufhört,
lässt fünf Zeilen stehen.

```bash
grep -n "debugging/" plugin/NOTICE.md   # vor dem Lauf: sechs Treffer
```

- [ ] **Step 11: Befunde einarbeiten**

Fehlgeschlagene Fälle führen zu einer Korrektur in `.claude/skills/sync-plugin-docs/SKILL.md`. **Nach jeder Korrektur den betroffenen Fall erneut fahren**, mit einem frischen Subagenten — ein wiederverwendeter antwortet aus seinem alten Stand.

Läuft ein Fall dreimal nicht grün: anhalten und dem Nutzer vorlegen. Nicht weiter schleifen.

- [ ] **Step 12: Commit**

```bash
git status --porcelain -- README.md plugin/   # muss leer sein
git status --short                            # nur die SKILL.md
git add .claude/skills/sync-plugin-docs/SKILL.md
git commit -m "fix(sync-plugin-docs): Befunde aus den restlichen Abnahmefaellen"
```

Zeigt die erste Zeile etwas an, ist ein Test nicht sauber aufgeräumt worden. Unter `plugin/` wäre der Rest ein synthetisches Verzeichnis, das ein späterer Lauf für einen echten neuen Skill hält; in `README.md` wäre es der Ausstoß eines Testlaufs, der sich sonst mit der echten Doku vermischt. Beides gehört zurückgesetzt, bevor hier committet wird — nicht mitcommittet und später gesucht.

Nichts korrigiert? Dann entfällt der Commit — sag das, statt einen leeren Commit zu erzeugen.

---

## Before Landing

The full range of this branch gets reviewed, not just the last task. Fix
everything under `Issues`; `Recommendations` are advisory.

- Working by hand: type `/smax:code-review`.
- Working as an agent: dispatch a `general-purpose` subagent with the reviewer
  template at `C:\Projects\skills\plugin\skills\dev\code-review\code-reviewer.md`,
  using the merge-base as BASE and HEAD as HEAD. **If that path does not resolve,
  stop and ask** — the plugin has been moved or updated since this plan was
  written. Do not guess a replacement path, and do not skip the review.

Then land via `smax:finishing-a-development-branch`, which re-checks that a
review for this HEAD exists before it offers the merge options.
