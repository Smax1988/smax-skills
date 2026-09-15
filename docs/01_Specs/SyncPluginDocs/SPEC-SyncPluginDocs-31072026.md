# SPEC — `sync-plugin-docs`

**Erstellt:** 31.07.2026

Ein repo-lokaler Skill, der nach Änderungen unter `plugin/skills/` prüft, ob
`README.md` und `plugin/NOTICE.md` nachgezogen werden müssen, und sie nachzieht.

## Anlass

Drift in den abgeleiteten Dokumenten ist in diesem Repo belegt, nicht vermutet:

- `d59b1eb refactor(skills)` fasste neun `SKILL.md` und eine Referenzdatei an und
  zog `plugin/NOTICE.md` mit — die `README.md` nicht.
- Fast alle README-Commits stehen **allein** da (`docs(readme): …`), sind also
  nachgereicht, nachdem der Drift jemandem auffiel. `e7e0105 docs(readme):
  Helfer sichtbar machen, falsche Aussagen korrigieren` benennt das Ergebnis
  wörtlich: Die README stand falsch da.

Der Auslöser ist immer derselbe — eine Skill-Änderung —, und die Prüfung
unterbleibt, weil niemand daran denkt.

## Ziel

Ein Lauf beantwortet: *Braucht **diese** Änderung eine Anpassung an
`README.md` oder `plugin/NOTICE.md`?* Was ableitbar ist, wird geschrieben; was
erzählt ist, wird ausformuliert vorgelegt.

**Nicht-Ziele.** Der Skill prüft nicht, ob die Dokumente insgesamt aktuell sind
— das wäre der teure Vollabgleich, der beim Entwurf verworfen wurde. Er committet nicht.
Er pflegt keine Dokumente außerhalb des Zuschnitts. Er beobachtet sich nicht
selbst.

## Ubiquitous Language

Die verbindlichen Begriffe stehen in [`CONTEXT.md`](../../../CONTEXT.md). Dieses
Dokument stützt sich auf **Abgeleitetes Dokument**, **Drift**,
**Vergleichsbasis**, **Quelle**, **Quellenliste**, **Bucket**, **Aufruf**,
**Eigenständiger Command**, **Ketten-Command** und **Repo-lokaler Skill** — die
Definitionen stehen dort, nicht hier.

## Entscheidungen

Drei Entscheidungen sind bereits festgehalten und werden hier **nicht**
wiederholt:

- [`0018-sync-plugin-docs-stays-repo-local`](../../decisions/0018-sync-plugin-docs-stays-repo-local.md)
  — warum repo-lokal statt Plugin, und was das ausschließt.
- [`0019-write-sourced-present-the-rest`](../../decisions/0019-write-sourced-present-the-rest.md)
  — warum die Grenze an der Verifizierbarkeit verläuft.
- [`0020-sweep-baseline-keeps-blind-spot`](../../decisions/0020-sweep-baseline-keeps-blind-spot.md)
  — warum der blinde Fleck der Sweep-Basis bleibt.

Ebenfalls einschlägig: `0015` (der `CLAUDE.md`-Block als Auslöser) und `0016`
(Kaltstartfähigkeit).

## 1 · Zuschnitt

Zwei Zieldokumente, beide abgeleitete Dokumente im Sinne des Glossars:
`README.md` (482 Zeilen) und `plugin/NOTICE.md` (159 Zeilen).

**Nicht im Zuschnitt**, weil handgeschrieben: `TODOS.md` (stammt aus dem
Gespräch, hat eine eigene Pflegeregel in `CLAUDE.md`), `CLAUDE.md` (beschreibt
das Repo, nicht die Skills), `docs/decisions/`.

### 1.1 · Was in der `README.md` abgeleitet ist

| Stelle | Art | abgeleitet ist |
|---|---|---|
| §2.1 Command-Tabelle | Tabelle | je eine Zeile pro **eigenständigem** Command — **und die Zahl** im Einleitungssatz („Diese **zehn** rufen keinen Skill…") |
| §2.2 | Prosa mit Namensliste | die Aufzählung der **Ketten-Commands** und die Aussage über `dispatching-parallel-agents` |
| §4 *Geht gar nicht per Modell* | argumentative Prosa | nur die **Mitgliedschaft**, nicht der Text |
| §4 *Geht, kostet aber ein Gate* | Tabelle mit Prosa-Zellen | nur die **Mitgliedschaft** |
| §4 *Läuft ohnehin von selbst* | Namensliste **plus** Prosa-Absatz | dass ein Name **verschwindet**, wenn der Skill gelöscht wird. Dass einer **dazukommt**, ist nicht ableitbar; der Absatz darunter ist erzählt |
| §4 *Verdrängt* | Prosa-Satz | nur die **Mitgliedschaft** |
| §5 — **vier** Gruppen-Tabellen | Tabellen | *dev — Workflow-Kette* · *dev — Denken & Doku* · *dev — Kunden- & Web-Aufgaben* · *personal*. Die Spalte *Argumente* speist sich aus `argument-hint`, **nicht** aus `description` |
| §5 Wer-ruft-wen | Tabelle | wer wen ruft |
| §5 Satellitenabsatz `domain-modeling` | Prosa mit Namensliste | **wer ihn ruft** — fünf Aufrufer |
| §5 Satellitenabsatz `sync-solution-items` | Prosa **ohne** Namensliste | **keine Aufrufer.** Der Absatz nennt die `.slnx`-Bedingung |

**Die Zahl der Gruppen-Tabellen ist vier, nicht drei.** Wer `personal`
übersieht, lässt neue oder umbenannte persönliche Skills die README nie
erreichen.

**§2.1 führt nicht alle Commands.** Das Repo hat **vierzehn** Commands; §2.1
listet **zehn**. Das Kriterium steht im Einleitungssatz der Datei selbst:
*„rufen keinen Skill und werden von keinem gerufen"* — also **Command *und*
er ruft keinen Skill und wird von keinem gerufen**. Die vier übrigen
(`brainstorming`, `code-review`, `sharpen-me`, `sharpen-with-docs`) sind
Ketten-Commands und stehen in §2.2.

Daraus folgt zweierlei:

- Ein neuer Command gehört nur dann nach §2.1, wenn er eigenständig ist. „Ist
  Command" allein ist das falsche Kriterium.
- **Ein neuer Aufruf verschiebt die Mitgliedschaft.** Fängt irgendein Skill an,
  einen eigenständigen Command zu rufen, wandert der nach §2.2 — und die Zahl im
  Einleitungssatz ändert sich, ohne dass jemand sein Frontmatter angefasst hat.

**In §4 ist nur eine der vier Listen eine Liste.** *Läuft ohnehin von selbst*
ist eine reine Namensaufzählung; die anderen drei sind Prosa oder Prosa-Tabelle
und dürfen nach `0019` nicht still umgeschrieben werden.

**Auch diese Namensliste ist nicht ableitbar.** „Wird der Skill gerufen?" sieht
wie eine Quelle aus und ist keine: `commitMessage` wird von `writing-plans` und
`finishing-a-development-branch` gerufen und steht trotzdem nicht darin. Die
Liste nennt, was die Kette *für den Nutzer* mitzieht — eine Wertung, die nur in
der README existiert. Ableitbar ist allein das **Entfernen**: Ist der Skill weg,
sagt das Verzeichnis es.

### 1.2 · Was in `plugin/NOTICE.md` abgeleitet ist

**Die Einheit ist die Datei, nicht der Skill.** NOTICE führt Pfade relativ zu
`plugin/skills/dev/`: `debugging/SKILL.md` steht unter *Substanziell umgebaut*,
`debugging/defense-in-depth.md` unter *Unverändert übernommen*. Wer auf
Skill-Ebene sucht, greift damit systematisch daneben.

| Abschnitt | Einheit | Inhalt |
|---|---|---|
| *Unverändert übernommen* | Datei | Tabelle Datei → Upstream-Herkunft |
| *Übernommen, punktuell ergänzt* | Datei | Tabelle + Beschreibung der Ergänzung |
| *Substanziell umgebaut* | Datei | Tabelle + Art des Umbaus |
| *Eingefrorene Kopie externer Dokumentation* | Datei | genau eine, als Prosa |
| *Ohne Upstream-Herkunft* | **Skill** | zwei Namenslisten: *Älter als der Import* / *Danach entstanden* |
| *Nicht übernommen* | gemischt | Prosa-Aufzählung |

**`plugin/NOTICE.md` ist die driftanfälligste Struktur im Repo**, und zwar auf
zwei Wegen:

1. Wer eine als *unverändert übernommen* geführte **Datei** inhaltlich ändert,
   macht die Einstufung falsch, ohne eine Zeile in NOTICE zu berühren.
2. Wer einen **neuen Skill** anlegt, muss ihn unter *Ohne Upstream-Herkunft →
   Danach entstanden* eintragen. Passiert das nicht, fehlt er dort schlicht.

**Fall 2 ist der Fall, den das `grep`-Netz aus §4 nicht sehen kann**: `grep`
findet vorhandene Fundstellen, ein fehlender Eintrag hat keine. Nur eine
ausdrückliche Quelle deckt ihn ab — und ein neuer Skill ist der häufigste
Änderungstyp in diesem Repo.

## 2 · Auslöser

**Zwei, und sie greifen zu verschiedenen Zeitpunkten.** Der Alltagsfall ist die
Skill-Änderung *ohne* jeden Skill-Aufruf — „mach X an `writing-plans`", fertig,
committen. Ein `description`-Trigger reicht dagegen nicht: Er konkurriert mit
allem anderen im Kontext und feuert unzuverlässig. Ein Aufruf aus der Kette
scheidet aus, weil kein Plugin-Skill einen repo-lokalen referenzieren darf
(`0018`).

**Der Block in der Projekt-`CLAUDE.md`** erinnert *während der Arbeit*. Er steht
neben dem Absatz zu `TODOS.md`, ist eng gefasst — etwas unter `plugin/skills/`
oder `plugin/.claude-plugin/` berührt → vor dem Commit `/sync-plugin-docs`
laufen lassen — und wiederholt die Begründung nicht, sondern verweist auf
`0015`.

**Der Hook fängt *am Commit* ab.** Ein `PreToolUse`-Eintrag, der auf den
Bash-Aufruf des Commits passt:

```json
{ "hooks": { "PreToolUse": [ { "matcher": "Bash", "hooks": [
  { "type": "command", "if": "Bash(git commit *)", "command": "…" } ] } ] } }
```

Das `if`-Matching trägt weiter, als es aussieht: Es entfernt führende
Variablenzuweisungen, prüft **jeden** Teilbefehl einer `&&`-Kette und schaut in
`$(…)` hinein. `npm test && git commit -m x` wird erfasst.

Drei Festlegungen, ohne die der Hook mehr schadet als nützt:

1. **Er entscheidet `ask`, nicht `deny`.** Ein `deny` erzeugt eine Schleife:
   blockieren → Skill läuft → erneut committen → wieder blockieren. Zustandslos
   gibt es daraus keinen Ausweg, und ein Marker-File wäre die dritte
   Wahrheitsquelle, die `0020` schon einmal verworfen hat. `ask` legt die
   Entscheidung dahin, wo sie hingehört, und braucht keinen Zustand.
2. **Er ist still, wenn nichts Einschlägiges gestaged ist.** Die Prüfung ist ein
   Einzeiler; alles darüber hinaus macht ihn zu Lärm bei jedem Commit:
   ```bash
   git diff --cached --name-only | grep -q '^plugin/skills/\|^plugin/\.claude-plugin/'
   ```
   **Keine schärfere Heuristik.** „`plugin/skills/` gestaged, aber weder README
   noch NOTICE" klingt besser und hätte den häufigsten Fall als False Positive:
   die Skill-Änderung, die zu Recht keine Doku-Anpassung braucht.
3. **Er begründet sich.** `permissionDecisionReason` nennt die betroffenen
   Pfade — sonst steht der Nutzer vor einer Rückfrage ohne Anlass.
4. **Er scheitert laut oder gar nicht.** Zwei stille Ausfälle liegen nahe und
   sind beide auszuschließen: Für das Arbeitsverzeichnis von Hooks gibt es keine
   Zusage, also bestimmt das Skript die Repo-Wurzel selbst (`git -C "$(git
   rev-parse --show-toplevel)"`) — sonst greift der Pfad-Präfix ins Leere und
   der Hook schweigt fälschlich. Und er kommt mit `git` aus: Eine externe
   Abhängigkeit wie `jq` bräche unter `set -euo pipefail` genau im
   einschlägigen Zweig ab, Claude Code notierte einen Hook-Fehler und ließe den
   Commit durch. Beides sieht von außen aus wie „nichts zu melden".

**Beide zusammen decken die Lücke des jeweils anderen**, aber nicht alle: Der
Hook sieht nur Commits durch Claudes Bash-Tool. Ein von Hand im Terminal
getipptes `git commit` erreicht weder Block noch Hook. Das bleibt offen und ist
der Preis dafür, keinen git-`pre-commit`-Hook zu installieren — der liegt unter
`.git/`, wird nicht mitversioniert und müsste auf jeder Maschine einzeln
eingerichtet werden.

## 3 · Vergleichsbasis

| Lage | Basis | Güte |
|---|---|---|
| Feature-Branch mit eigenen Commits | `git merge-base main HEAD` | **vollständig** |
| auf `main` | jüngster Commit **bis einschließlich `HEAD`**, der `README.md` oder `plugin/NOTICE.md` angefasst hat | unvollständig, siehe unten |

Uncommittete Änderungen sind in **beiden** Fällen eingeschlossen — sie sind der
Fall, den man vor dem Commit prüfen will.

**Der stille Fehler bleibt im zweiten Fall bestehen** — eine
kosmetische README-Änderung setzt das Fenster zurück und versteckt echte
Veralterung. Dass er bleibt, ist entschieden und begründet in
[`0020-sweep-baseline-keeps-blind-spot`](../../decisions/0020-sweep-baseline-keeps-blind-spot.md).
Die Gegenmaßnahme ist Sichtbarkeit: **Die erste Report-Zeile nennt Basis und
Regel.** Der Branch-Fall ist immun.

## 4 · Die Quellenliste

**Die Leitfrage ist nicht „welchen Abschnitt berührt diese Änderung?", sondern
„woher stammt dieser Fakt?"**

Jeder Fakt in `README.md` und `plugin/NOTICE.md` hat entweder eine Quelle
**außerhalb** des Dokuments — ein Frontmatter-Feld, die Verzeichnisstruktur,
einen Aufruf in einem Skill-Body, ein git-Kommando — oder er hat keine und ist
im Dokument selbst zu Hause. Das ist seine **Quelle**, und daraus folgt beides:
woher der Lauf den richtigen Wert nimmt, und ob er ihn schreiben darf.

| Fakt | Quelle | folglich |
|---|---|---|
| Name eines Skills, an jeder Fundstelle | `name:` im Frontmatter | **schreiben** |
| §5 Spalte *Trigger* | `disable-model-invocation:` | **schreiben** |
| §5 Spalte *Argumente* | `argument-hint:` | **schreiben, wenn wörtlich geführt**, sonst **vorlegen** |
| §2.1 Spalte „wofür" | `description:` | **schreiben, wenn wörtlich geführt**, sonst **vorlegen** |
| Existenz einer Zeile in §5 | Verzeichnis unter `plugin/skills/` | **schreiben** |
| Ob §5 für ein ausgeliefertes Verzeichnis eine Gruppen-Tabelle führt, und wie sie heißt | `plugin/.claude-plugin/plugin.json` | **schreiben** |
| In welche §5-Tabelle ein Skill gehört — der `personal`-Fall | Verzeichnis unter `plugin/skills/` | **schreiben** |
| In welche §5-Tabelle ein Skill gehört — die drei `dev`-Untergruppen | **keine Quelle** | **vorlegen** |
| Dass es diese drei Untergruppen gibt und wie sie heißen | **keine Quelle** | **vorlegen** |
| §5 Wer-ruft-wen | Aufrufe in den Skill-Bodies | **schreiben** |
| §2.1-Mitgliedschaft **und die Zahl im Einleitungssatz** | Aufrufe + `disable-model-invocation:` | **schreiben** |
| §2.2-Mitgliedschaft | dieselben | Mitgliedschaft **schreiben**, den Satz darum **vorlegen** |
| §4 *Läuft ohnehin von selbst*, wer dazugehört | **keine Quelle** | **vorlegen** |
| §4 *Geht gar nicht per Modell*, wer dazugehört | `disable-model-invocation:` | Mitgliedschaft **schreiben**, Text **vorlegen** |
| NOTICE: hat eine Datei ihren Bucket verlassen? | `git diff --numstat c1e7d9e HEAD -- <datei>` | **melden** |
| NOTICE: in **welchen** Bucket sie gehört | — | **vorlegen** |
| NOTICE *Ohne Upstream-Herkunft*, Zugehörigkeit | `git ls-tree c1e7d9e^` | **vorlegen** |
| §3 Einstiegstabelle | **keine Quelle** | **vorlegen** |
| §1 Prosa, §4-Wertungen, Satellitenabsätze, §6.x | **keine Quelle** | **vorlegen** |

**Warum keine Tabelle „Änderungsart → Abschnitt".** Eine solche Tabelle wäre die
zwischengespeicherte Anwendung dieser Quellen auf den heutigen Gliederungsstand.
Ihre Eingaben — §2, §4, §5 — liest der Lauf ohnehin, gespart wird also fast
nichts; veralten würde sie mit jeder Umgliederung. Die Quelle dagegen bleibt:
`argument-hint` speist die Argumente-Spalte, gleich in welchem Abschnitt und
welcher Zeile sie steht.

**Und sie beantwortet die Frage nach der Ausgabegrenze gleich mit.** „Kann ich
das beweisen?" ist im luftleeren Raum schwer zu entscheiden; „welche Datei ist
die Quelle?" nicht. Keine Quelle heißt: Der Fakt existiert nur in dem Dokument,
das gerade bearbeitet wird — dort gibt es nichts nachzuschlagen, nur zu
entscheiden, und Entscheiden ist Sache des Autors.

### 4.1 · Der Wörtlich-Test

Zwei Spalten **geben ihre Quelle wieder, statt sie zu kopieren**. Welches
Verdikt gilt, ist deshalb eine Eigenschaft der Daten und keine Ermessensfrage —
also nachsehen:

```bash
git show <basis>:plugin/skills/<name>/SKILL.md | grep '^argument-hint:'
```

Das Ergebnis gegen den Wert halten, der **heute** in der README steht.

- **Identisch** → die Spalte hat den Rohwert geführt. Neuen Wert still
  einsetzen.
- **Abweichend** → die Abweichung stammt vom Autor, und sein Nachfolger auch.
  `teach` trägt `argument-hint: "What would you like to learn about?"`, §5 zeigt
  `` `[Thema]` ``. Diese Kürzung existiert außerhalb der README nirgends, und
  keine Regel leitet sie her. Alt und neu nebeneinanderlegen.

Bei §2.1 „wofür" fällt der Test fast immer auf *abweichend*: Die Spalte führt
deutsche Einzeiler, mehrere `description:`-Felder sind lange englische
Trigger-Listen. Das ist das erwartete Ergebnis, kein Versagen des Tests.

**Eine neue Zeile hat keinen Altwert zum Vergleichen.** Die Zeile wird angelegt
— dass es sie gibt und die Zahl im Einleitungssatz haben eine Quelle —, aber der
*Inhalt* dieser beiden Spalten wird vorgelegt. Herleiten ließe er sich nur aus
einer eigenen Umschreibung, und eine Umschreibung ist Autorentext.

**Warum ein Test und kein festes Verdikt.** Festes *schreiben* hieße,
`"What would you like to learn about?"` in eine schmale Tabellenspalte zu
kippen. Festes *vorlegen* hieße, bei `md-to-pdf` zu fragen, dessen Spalte seit
jeher den Rohwert trägt und wo die Ersetzung reine Substitution ist. Der Test
entscheidet durch Nachsehen statt durch Abwägen — derselbe Maßstab wie in jeder
anderen Zeile der Liste.

### 4.2 · Zwei Dinge an §5, die wie eines aussehen

**Dass eine Gruppen-Tabelle existiert, hat eine Quelle; wie `dev` aufgeteilt
ist, nicht.** `plugin.json` nennt die ausgelieferten Verzeichnisse — heute
`./skills/dev` und `./skills/personal`. Kommt dort eines dazu, braucht §5 eine
Überschrift, und die heißt wie das Verzeichnis: Substitution.

Die drei `dev`-Tabellen — *Workflow-Kette*, *Denken & Doku*, *Kunden- &
Web-Aufgaben* — kommen in `plugin.json` nicht vor. Dass es sie gibt, wie sie
heißen und wohin ein neuer Skill gehört, sind drei README-interne
Entscheidungen ohne Quelle außerhalb der Datei. Alle drei werden vorgelegt.

`personal` ist der Kontrast, der die Regel sichtbar macht: ein ausgeliefertes
Verzeichnis, eine Tabelle, Zugehörigkeit durch den Ort entschieden. Schreiben.

### 4.3 · §4 *Läuft ohnehin von selbst* hat keine Quelle

„Wird der Skill gerufen?" sieht wie eine aus und ist keine — die Bedingung ist
notwendig, nicht hinreichend. `commitMessage` wird von `writing-plans` und von
`finishing-a-development-branch` gerufen und steht trotzdem nicht in der Liste:
Sie nennt die Skills, die die Kette *für den Nutzer* mitzieht, nicht jeden Skill
mit eingehendem Aufruf. Diese Unterscheidung ist in der README festgehalten und
sonst nirgends.

Nur *Geht gar nicht per Modell* folgt aus dem Frontmatter.

### 4.4 · Die Fallen

Neun Stellen, an denen die naheliegende Lesart falsch ist. Sie sind der
eigentliche Inhalt des Skills — die Quellen oben sagen, *wo* nachzusehen ist,
diese Liste sagt, *was man dabei falsch versteht*.

1. **§2.1 führt nicht alle Commands, sondern die eigenständigen.** Das Repo hat
   vierzehn Commands, §2.1 listet zehn. Das Kriterium steht im Einleitungssatz
   des Abschnitts: *„rufen keinen Skill und werden von keinem gerufen"*. Die
   vier übrigen sind Ketten-Commands und stehen in §2.2.
2. **Ein Aufruf kann als aufgelöster Pfad auftreten.** `finishing-a-development-branch`
   dispatcht `../code-review/code-reviewer.md` und ruft `code-review` damit auf,
   ohne `smax:code-review` zu schreiben (`0017`). Wer nur nach `smax:` sucht,
   übersieht diese Aufrufe systematisch — die Wer-ruft-wen-Tabelle führt sie mit
   dem Zusatz „(als Pfad)".
3. **Eine Erwähnung ist kein Aufruf.** `md-to-pdf` nennt `smax:handoff` und
   `smax:replicate` als Querverweis („dieselbe Regel gilt für…"). Ein Treffer
   auf `smax:<name>` belegt nur, dass der Name vorkommt.
4. **Gerufen zu werden setzt einen Skill nicht auf §4 *Läuft ohnehin von
   selbst*.** `commitMessage` wird von zwei Skills gerufen und steht nicht in
   der Liste. Sie nennt, was die Kette für den Nutzer mitzieht; die Wertung
   dahinter steht in der README. Nur *Geht gar nicht per Modell* folgt aus
   `disable-model-invocation`.
5. **Ein neuer Aufruf kann einen Command aus §2.1 vertreiben.** Fängt irgendein
   Skill an, einen eigenständigen Command zu rufen, ist er keiner mehr: Er
   wandert nach §2.2 und die Zahl im Einleitungssatz ändert sich — ohne dass
   jemand sein Frontmatter angefasst hat.
6. **NOTICE ordnet Dateien ein, nicht Skills — mit zwei Ausnahmen.**
   `debugging/SKILL.md` steht unter *Substanziell umgebaut*,
   `debugging/defense-in-depth.md` unter *Unverändert übernommen*. Die Ausnahmen
   sind *Ohne Upstream-Herkunft*, das Skills führt, und *Nicht übernommen*, das
   gemischt ist — Skills, ganze Verzeichnisse und Dateien nebeneinander.
7. **In *Ohne Upstream-Herkunft* gilt eine eigene Schreibweise**, nicht die
   Kopfzeile „Pfade relativ zu `plugin/skills/dev/`": dev-Skills stehen als
   bloßer Name (`css-review`), personal-Skills mit Präfix
   (`personal/whats-for-lunch`).
8. **Umbenennen ist eine Token-Ersetzung und bleibt still — außer im
   Kettendiagramm §1.1.** Dessen Kästen sind auf Zeichenbreite ausgerichtet; ein
   längerer Name zerlegt die Linienführung. Die Ersetzung ist mechanisch, die
   Neuausrichtung nicht.
9. **§5 kann Tabellen enthalten, die den Skill nichts angehen.** Die
   Gruppen-Tabellen führen Plugin-Skills aus `plugin/skills/<gruppe>/`. Eine
   Tabelle für repo-lokale Skills steht außerhalb: Dort wird nie eine Zeile
   angelegt, geändert oder entfernt.

**Adressiere die beiden Satellitenabsätze am Ende von §5 über ihren Betreff,
nie über die Zeilennummer** — der eine nennt die Aufrufer von `domain-modeling`,
der andere die `.slnx`-Bedingung von `sync-solution-items`. Jede Einfügung
darüber verschiebt beide.

### 4.5 · Das Sicherheitsnetz

Zusätzlich zu jeder Quelle läuft

```bash
grep -n "<skillname>" README.md plugin/NOTICE.md
```

Die Quellenliste sagt, wo ein Fakt herkommt; `grep` findet die Stellen, an denen
er auftaucht, ohne dass jemand daran gedacht hat.

**Das Netz hat zwei strukturelle Lücken.** Beide folgen daraus, dass `grep`
Fundstellen zählt und keine Aussagen prüft:

1. **Fehlendes findet es nicht.** Ein neuer Skill steht nirgends und hat keine
   Fundstelle. Für jede Stelle, an der ein neuer Skill auftauchen **muss**, gibt
   es deshalb keinen Fallback — sie muss über ihre Quelle erreicht werden.
2. **Falsches findet es nicht.** Steht ein Name, wo er nicht mehr hingehört —
   ein entfallener Aufruf, eine gekippte Einstufung —, liefert `grep` einen
   Treffer und keinen Hinweis, dass er falsch ist. Deshalb wird die
   Wer-ruft-wen-Tabelle über ihre Quelle geprüft, nicht über `grep`.

## 5 · Ablauf

1. **Basis bestimmen** nach §3. Regel merken, sie gehört in den Report.
2. `git diff --stat <basis> -- plugin/skills/ plugin/.claude-plugin/` →
   betroffene Skills.
3. Für **nur diese** Skills Frontmatter-Diff und Body-Diff getrennt ansehen und
   den betroffenen Quellen zuordnen.
4. Nur die Abschnitte lesen, die diese Quellen speisen — plus das `grep`-Netz.
5. Abgeleitetes schreiben. Prosa ausformulieren und vorlegen.
6. Report ausgeben. **Nicht committen.**

**Warum nicht committen:** Der `CLAUDE.md`-Block feuert vor dem Commit des
Nutzers; ein eigener Commit hier würde dessen Arbeit zerschneiden und eine
Änderung in die History legen, die niemand angefordert hat.

**Kosten eines typischen Laufs:** rund 135 gelesene Zeilen (§5 ≈ 75, §2 ≈ 30,
§4 ≈ 30) statt 482 Zeilen README plus 30 `SKILL.md`. Das ist der Unterschied
zwischen „diff-skopiert" und „alles lesen". (Beim Entwurf war von
33 Skills die Rede; tatsächlich sind es 30 — 27 unter `dev`, 3 unter `personal`.)

## 6 · Ausgabe

Zwei Sorten, strikt getrennt (`0019`).

**Abgeleitetes** wird still geschrieben und im Report nur aufgezählt.

**Prosa** wird ausformuliert, alt und neu nebeneinander gestellt, und je Punkt
bestätigt. Der Skill schreibt sie nie ohne Zustimmung.

```
Basis: merge-base main HEAD = a1b2c3d  (Branch-Basis — vollständig)
Betroffen: tracking-todos (neu)

Geschrieben (2)
  README.md §5 "dev — Denken & Doku" — Zeile ergaenzt: tracking-todos | — | Command
  README.md §2.1 — Zeile ergaenzt; Einleitungssatz "Diese zehn" → "Diese elf"

Zu uebernehmen (2)
  README.md §3 Einstiegstabelle — kein Eintrag fuer tracking-todos.
    Vorschlag: | **TODOs im Repo verankern.** | `/smax:tracking-todos` |
                 `TODOS.md` + Block in der Projekt-`CLAUDE.md` |
    → uebernehmen? [j/n]

  plugin/NOTICE.md "Ohne Upstream-Herkunft → Danach entstanden" — tracking-todos
    fehlt in der Liste. Kein Upstream erkennbar.
    Vorschlag: dort aufnehmen.
    → uebernehmen? [j/n]
```

**Kein Befund → trotzdem eine Zeile** mit der Basis und „nichts zu tun".
Schweigen liest sich als „lief nicht", und das ist genau die Unsicherheit, die
der Skill beseitigen soll.

## 7 · Kaltstart

Der Skill wird **immer** kalt betreten — es gibt keine Kette vor ihm. Er trägt
die Quellenliste, die Fallen, die Basis-Regel und die Schreiben/Vorlegen-Grenze selbst
(`0016`). Nichts davon darf auf einen Plugin-Skill verweisen, sonst bricht er in
der Fassung, in der das Plugin aus dem Cache statt aus dem Repo bedient wird.

**Der Skilltext ist englisch** (`0021`). Deutsch bleibt, was der Skill
*ausgibt* — der Report und die vorgelegten Textvorschläge, denn die landen in
einem deutschen Dokument.

## 8 · Begleitarbeit

Fünf Dinge gehören zur Umsetzung, nicht zum Skill:

1. **`CLAUDE.md`-Block ergänzen** (§2).
2. **Hook einrichten** (§2) — `PreToolUse` auf `Bash(git commit *)`, Entscheidung
   `ask`, still bei nicht einschlägigen Commits. Er liegt in
   `.claude/settings.json`, nicht im Plugin: Ein Plugin-Hook würde in jedem Repo
   feuern, in dem das Plugin installiert ist, und dort nach einem Skill fragen,
   den es nicht gibt.
3. **README um den ersten repo-lokalen Skill ergänzen.** §5 und §6.7 kennen
   heute nur Plugin-Skills. Handarbeit — der Skill beobachtet `plugin/skills/`,
   nicht `.claude/skills/`, und kann seine eigene Aufnahme nicht erkennen. Das
   ist beabsichtigt: Die Alternative wäre eine zweite Quellenliste für ein
   einmaliges Ereignis. **`.claude/` existiert im Repo noch nicht** und wird mit
   angelegt; `.gitignore` schließt es nicht aus, es wird also mitcommittet.
4. **`TODOS.md` 2.1 streichen — erledigt, nicht vertagt.** Der Skill steht, und
   die offenen Unterpunkte sind mit ihm beantwortet. **Kein Nachfolge-Eintrag:**
   Skills, die abgeleitete Dokumente abgleichen, bleiben repo-lokal (`0018`);
   eine Plugin-Fassung wird nicht mehr geplant. Ein verworfener Weg gehört nach
   `docs/decisions/`, nicht in die offene Arbeit. Die Nummer 2.1 bleibt frei und
   wird nie neu vergeben. Damit blockiert Eintrag 1.1 aus dieser Kette nichts
   mehr — die Zeile „Blockiert 2.1." entfällt, der Eintrag selbst bleibt.
5. **Bestehenden Drift in der README einmalig bereinigen.** Der
   Wer-ruft-wen-Tabelle in §5 fehlen `brainstorming`, `sharpen-me` und
   `sharpen-with-docs` ganz, und `finishing-a-development-branch` ist
   unvollständig — es ruft `code-review` als aufgelösten Pfad. Die README
   widerspricht sich damit selbst: Der Satellitenabsatz daneben nennt Aufrufer,
   die in der Tabelle fehlen. Das ist
   Handarbeit vor dem ersten Lauf: Sonst meldet der Skill diesen Altbestand als
   Befund gegen ein Dokument, das er gerade gepflegt haben will, und der erste
   echte Report beginnt mit Rauschen.

## 9 · Abnahme

Der Skill ist fertig, wenn diese Fälle durchlaufen:

| Fall | erwartet |
|---|---|
| Sauberer Tree auf `main`, seit dem letzten README-Commit keine Skill-Änderung | eine Zeile: Basis, Regel, „nichts zu tun" |
| Lauf auf einem Feature-Branch | Report nennt `merge-base` und „vollständig" |
| **Neuer Plugin-Skill unter `dev`** | §2.1-Zeile **samt Zahl** still angelegt, falls eigenständiger Command — ihr „wofür"-Text jedoch **vorgelegt**, weil eine neue Zeile keinen Altwert für den Wörtlich-Test hat; die §5-Zeile **vorgelegt**, weil die Wahl unter *Workflow-Kette* / *Denken & Doku* / *Kunden- & Web-Aufgaben* keine Quelle hat; **NOTICE *Danach entstanden* als fehlender Eintrag gemeldet**; §3 vorgelegt |
| **Neuer Skill unter `personal`** | §5-Zeile in der `personal`-Tabelle **still geschrieben** — hier ist die Gruppe durch das Verzeichnis bestimmt und damit belegt. Der Kontrast zum Fall darüber ist der eigentliche Test |
| **Umbenannter Skill unter `personal`** | erreicht die **vierte** §5-Tabelle. Ein Lauf, der nur die drei `dev`-Tabellen kennt, fällt hier durch |
| Ein Skill, den **niemand ruft und der niemanden ruft**, bekommt `disable-model-invocation: true` | §5 Trigger-Spalte still geschrieben; §2.1-Zeile samt Zahl still angelegt, ihr „wofür"-Text vorgelegt; §4-Mitgliedschaft vorgelegt |
| Ein Skill **mitten in der Kette** bekommt `disable-model-invocation: true` | §5 Trigger-Spalte still geschrieben; **§2.1 bleibt unangetastet**; §2.2-Aufzählung vorgelegt — der Test auf „eigenständig" statt bloß „Command" |
| Ein Skill wird gelöscht | §5-Zeile, §2.1-Zeile samt Zahl und der Name in §4 *Läuft ohnehin von selbst* still entfernt, **ebenso alle NOTICE-Zeilen seiner Dateien** — die verteilen sich über mehrere Buckets, wer nach dem ersten Treffer aufhört, lässt Zeilen stehen; §1.1, §3, §2.2 und die Prosa-Abschnitte von §4 vorgelegt, **jeweils nur, soweit der Skill dort überhaupt vorkommt.** Kein Skill steht an allen diesen Stellen; ein ausbleibender Abschnitt ist kein Fehlschlag, sondern der Normalfall. **Entfernen ist belegt, auch wo Anlegen es nicht wäre:** dass der Skill weg ist, sagt das Verzeichnis |
| Ein **eigener** Skill ohne Upstream wird gelöscht | sein Name verschwindet auch aus der **Prosa-Namensliste** *Ohne Upstream-Herkunft* — dort gibt es keine Tabellenzeile zu entfernen, und genau deshalb wird der Fall übersehen |
| Ein Skill ruft neu `smax:domain-modeling` | §5 Wer-ruft-wen still ergänzt; **nur** der `domain-modeling`-Satellitenabsatz vorgelegt — der zu `sync-solution-items` nennt keine Aufrufer und darf nicht auftauchen |
| Ein Skill ruft einen anderen neu über einen **aufgelösten Pfad** statt über `smax:` | wird als Aufruf erkannt (`0017`) |
| Ein Skill wird umbenannt und steht im Kettendiagramm §1.1 | überall still ersetzt, **das Diagramm vorgelegt** — die Ausrichtung ist kein mechanischer Schritt |
| `description` ändert sich | §5 Argumente-Spalte **unangetastet**; §2.1 „wofür" nach dem Wörtlich-Test — führt die Spalte den Rohwert nicht wörtlich, wird **vorgelegt**. Das ist hier der Regelfall: Die Spalte trägt deutsche Einzeiler, die `description` oft eine englische Trigger-Liste |
| `argument-hint` ändert sich | §2.1 „wofür" **unangetastet** — der Test darauf, dass diese Spalte **nicht** aus `description` stammt; §5 Argumente-Spalte nach dem Wörtlich-Test: bei `md-to-pdf` still geschrieben, bei `teach` vorgelegt |
| Neue Skill-Gruppe in `plugin.json` | §5 Überschrift still geschrieben; §6.8 vorgelegt |
| `debugging/defense-in-depth.md` wird geändert (steht unter *Unverändert übernommen*) | genau dieser Abschnitt vorgelegt, nicht geschrieben |
| `debugging/SKILL.md` wird geändert (steht unter *Substanziell umgebaut*) | **nur** dieser Abschnitt vorgelegt. Die *unverändert*-Zeilen der Nachbardateien dürfen **nicht** auftauchen — der Test auf Datei- statt Skill-Granularität |
| Die **Mitgliedschaft** in §4 *Geht gar nicht per Modell* ändert sich | Text wird **nie** still geschrieben, immer vorgelegt. Eine bloße Umbenennung in diesem Abschnitt ist **keine** Mitgliedschaftsänderung und bleibt still |
| Ein Skill wird umbenannt und taucht an einer Stelle auf, die **keine** Quelle nennt | `grep` findet sie; sie erscheint im Report |

Die Abnahmefälle fährt Smax selbst. Der Plan beschreibt je Fall die synthetische
Änderung, den Dispatch und das Aufräumen — der Skill wird nie von dem Agenten
geprüft, der ihn geschrieben hat.
