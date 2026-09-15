# Vendoring von superpowers nach `smax` — Implementierungsplan

**Erstellt:** 26.07.2026

**Spec:** `docs/01_Specs/VendoringSuperpowers/SPEC-VendoringSuperpowers-26072026.md`
— nachträglich aus diesem Plan abgeleitet und ab jetzt die Referenz. Bei
Widersprüchen gewinnt die Spec; ihre Anforderungsnummern (A1, B4, F9 …) sind
der stabile Bezugspunkt für spätere Änderungen.

**Ziel:** Die von mir genutzten Ketten aus dem Plugin `superpowers` in das eigene
Skill-Repo übernehmen, `domain-modeling` fest integrieren, die eigene
Doku-Konvention verdrahten — und danach `superpowers` deinstallieren.

**Quelle:** `superpowers` **6.2.0** (Commit `eccd4530`), MIT-Lizenz,
© 2025 Jesse Vincent, <https://github.com/obra/superpowers>

**Was das ist — und was nicht.** Einmaliges Kopieren mit Anpassung beim
Kopieren, integriert in `plugin/skills/dev/`. Danach steht der Code vollständig
im eigenen Repo und gehört ihm.

- **Kein Git-Fork:** kein Remote, keine gemeinsame History, kein Merge-Pfad,
  keine Verpflichtung, Upstream nachzuziehen.
- **Kein Neubau von Null:** der erprobte Wortlaut wird übernommen statt neu
  erfunden. Die MIT-Lizenz erlaubt das ausdrücklich; Auflage ist allein, den
  Copyright- und Lizenztext mitzuführen (siehe `plugin/NOTICE.md`).
- **Keine Plugin-Abhängigkeit:** nach der letzten Phase ist `superpowers`
  deinstalliert und nichts im Repo verweist mehr darauf.

**Umfang:** ~8.520 Zeilen · 13 Skills (12 übernommen, `writing-specs` neu) ·
4 bestehende Skills angepasst · 5 Bash-Skripte · 3 Node-Dateien ·
1 HTML-Template

**Stand 26.07.2026:** Phasen 1–8 umgesetzt, Phase 9 teilweise. Die Skills
liegen auf Branch `vendoring-superpowers` (nicht gepusht). Beide Greps sind
sauber, der erste Ende-zu-Ende-Testlauf ist durch. Offen sind die restlichen
Einzeltests der Phase 9 und die Deinstallation von `superpowers`. Der zweite
Testlauf validiert die Korrekturen, die aus dem ersten entstanden sind — vor
allem, dass das Review-Gate einen bereits geprüften HEAD erkennt.

**Voraussetzung erledigt:** Commit `8ee2d00` hat das Plugin nach `plugin/`
verschoben. Der Repo-Root ist reiner Marketplace, alles außerhalb von
`plugin/` — insbesondere `docs/` — wird nicht mehr ausgeliefert. Deshalb
gehört auch `NOTICE.md` nach `plugin/`: ausgeliefert wird nur das
Plugin-Verzeichnis, und der Lizenztext muss die Distribution begleiten.

---

## Verifizierte Grundlagen

**Skill-Verkettung** — empirisch bestätigt:

```
Skill smax:commitMessage cannot be used with Skill tool
due to disable-model-invocation
```

Die Flag sperrt auf Tool-Ebene, nicht nur in der Anzeige. Es gibt keinen
separaten Skill-zu-Skill-Kanal — jede Weitergabe läuft über das Modell.

**Wichtig zur Einordnung:** `disable-model-invocation` *entfernt* nur die
Modell-Invocation. **Jedes** Skill ist per `/smax:<name>` aufrufbar; die Flag
macht ein Skill nicht „user-invocable", sondern nimmt ihm die Fähigkeit, von
selbst zu starten. Die Frage lautet also nicht „User oder Modell", sondern
„darf es sich selbst starten".

| Darf sich selbst starten? | Skills |
|---|---|
| **Nein** (`disable-model-invocation: true`) | `brainstorming` — dazu die bestehenden `sharpen-me`, `sharpen-with-docs` |
| **Ja** (kein Flag) | `debugging`, `writing-specs`, `writing-plans`, `subagent-driven-development`, `executing-plans`, `finishing-a-development-branch`, `test-driven-development`, `verification-before-completion`, `using-git-worktrees`, `dispatching-parallel-agents` |
| **Offen — noch zu entscheiden** | `code-review`, `writing-skills` |

**Entschieden (Umsetzung):** `code-review` bekam die Flag, `writing-skills`
nicht — Begründung jeweils bei den Phasen 3 und 2. Zusätzlich fiel die Flag bei
`commitMessage` weg (siehe „Die Commit-Message kommt aus `commitMessage`").

Zu den offenen beiden: `code-review` automatisch feuern zu lassen bedeutet, dass
es nach jeder abgeschlossenen Aufgabe anspringt — nützlich vor einem Merge,
lästig bei jedem Zwischenstand. `writing-skills` würde bei jeder Skill-Datei
triggern, auch beim bloßen Lesen. Meine Neigung: beide **ohne** Flag, weil ihre
Descriptions eng genug sind — aber das ist zu entscheiden, nicht zu raten.

**Nachtrag zu `code-review`:** Das Review-Gate (siehe „Git-Konvention")
entschärft diese Entscheidung. SDD und `finishing-a-development-branch`
erreichen den Reviewer über die Datei `code-reviewer.md`, nicht über einen
Skill-Aufruf — die Flag ist für die Kette also folgenlos. Damit fällt das
Argument „nützlich vor einem Merge" weg: der Merge-Fall ist fest verdrahtet.
Übrig bleibt nur der lästige Teil, das Anspringen bei Zwischenständen. Das
verschiebt die Neigung auf `disable-model-invocation: true` für
`code-review` — es bleibt per `/smax:code-review` jederzeit greifbar.

Es wird **kein SessionStart-Hook übernommen**. Das ist der Ersatz für
`using-superpowers` und dessen 1%-Regel, die das Dazwischenfunken verursacht
hat, das dieses Vorhaben abstellt. Wo Automatik erwünscht ist, entsteht sie
über eine enge Description — nicht über eine Dauerinstruktion im Kontext.

`sharpen` bleibt unverändert model-invocable. (Setzte man dort
`disable-model-invocation`, brächen `sharpen-me` und `sharpen-with-docs` —
beide sind auf Zuruf gestartet und weisen das Modell an, `sharpen` aufzurufen.)

**Plugin-Manifest.** `plugin/.claude-plugin/plugin.json` bleibt unverändert:
`./skills/dev` und `./skills/personal` lösen sich gegen den Plugin-Root auf,
alle neuen Skills gehen nach `plugin/skills/dev/`.

---

## Doku-Konvention — der neue Vertrag über die Kette

Superpowers schreibt nach `docs/superpowers/specs/` und `docs/superpowers/plans/`.
Das wird durchgängig ersetzt:

```
docs/
├── 00_Analysis/<Thema>/ANALYSIS-<Thema>-DDMMYYYY.md
├── 01_Specs/<Thema>/SPEC-<Thema>-DDMMYYYY.md
├── 02_Plans/<Thema>/PLAN-<Thema>-DDMMYYYY.md
├── 03_DbChanges/<Thema>/DDMMYYYY-<Thema>.forward.sql
│                       DDMMYYYY-<Thema>.rollback.sql
└── decisions/            ← von domain-modeling, unberührt
```

**Themen-Slug.** PascalCase (`TipAllowance`), einmal in `writing-specs`
festgelegt und über alle Ordner hinweg identisch. Das ist ein neuer Vertrag quer
über die Kette, den superpowers nicht kennt: `writing-plans` und
`subagent-driven-development` übernehmen den Slug unverändert, statt einen
eigenen Dateinamen zu bilden.

**Datum im Dateinamen.** Bei `ANALYSIS-`, `SPEC-` und `PLAN-` als **Suffix**
(`-DDMMYYYY`), bei den SQL-Skripten als **Präfix** (bestehende Konvention,
unverändert).

Das Suffix ist nicht Kosmetik — es ist funktional notwendig. `sdd-workspace`
leitet das SDD-Arbeitsverzeichnis aus dem Plan-Dateinamen ab:

```bash
slug=$(basename "$plan" .md)   # PLAN-TipAllowance-26072026
dir="$root/.smax/sdd/$slug"
```

Ohne Datum wäre dieser Pfad für jedes TipAllowance-Vorhaben derselbe. Ein
abgebrochener Lauf hinterlässt sein Ledger; ein späterer Anlauf würde es
finden, dessen erste Zeile dieselbe Plandatei nennt, `Task 1..5: complete`
lesen und **diese Tasks überspringen**. Genau der Ausfall, gegen den SDDs
Ledger gebaut wurde — dessen Kommentar dazu: *„A stale ledger misread as
current progress makes controllers skip whole task sequences."* Upstream war
davor durch `YYYY-MM-DD`-Präfixe geschützt; das Suffix stellt diesen Schutz
wieder her.

Restrisiko: zwei Pläne zum selben Thema **am selben Tag** kollidieren weiterhin.
Schmales Fenster, aber beim Neuschreiben eines Plans am Tag der Erstellung
real — dann den Workspace vorher löschen.

**Erstellungsdatum im Dokument.** Zusätzlich zum Dateinamen trägt jede erzeugte
`ANALYSIS-`, `SPEC-` und `PLAN-`-Datei das Datum als zweite Zeile:

```markdown
# <Titel>

**Erstellt:** DD.MM.YYYY
```

Die Redundanz zum Dateinamen ist beabsichtigt: der Dateiname überlebt kein
Kopieren in ein anderes System, die Zeile im Dokument schon. Gesetzt beim
Anlegen, bei Überarbeitungen nicht verändert.

**ANALYSIS oder SPEC.** `writing-specs` entscheidet nach diesem Kriterium und
**nennt Wahl und Zielpfad, bevor es schreibt**, damit die Wahl korrigierbar ist:

- Untersuchung oder Bewertung von Bestehendem, ohne Entscheidung etwas zu
  bauen → `00_Analysis/`
- Entwurf von etwas, das gebaut werden soll → `01_Specs/`

**Bestehende Themen niemals stillschweigend behandeln.** Existiert der
Themenordner bereits, wird das **angesagt und gefragt** — nie im Vorbeigehen
entschieden:

> „`docs/01_Specs/TipAllowance/` existiert bereits mit `SPEC-TipAllowance-12052026.md`.
> Soll ich das bestehende Dokument fortschreiben oder ein neues für heute anlegen?"

Das Datumssuffix verhindert zwar das versehentliche Überschreiben, aber die
Frage bleibt inhaltlich offen: eine zweite Fassung ist etwas anderes als eine
Fortschreibung. Gilt für `writing-specs` und `writing-plans` gleichermaßen.

**DB-Änderungen.** Erkennt `writing-plans`, dass ein Plan Schema-Änderungen
braucht, spezifiziert es Forward- und Rollback-Skript als Task-Schritte mit
exaktem Pfad und vollständigem Inhalt. Geschrieben werden sie vom Implementer —
das folgt der bestehenden „No Placeholders"-Regel, statt sie zu unterlaufen.

**Das Datum der SQL-Dateien ist das Schreibdatum**, nicht das Planungsdatum.
Der Plan kann es also nicht vorwegnehmen; er spezifiziert das Namensschema
(`DDMMYYYY-<Thema>.forward.sql`) und der Implementer setzt das Datum des Tages
ein, an dem er die Datei anlegt.

**Archive.** Die Archivierung erfolgt manuell und wird in **keinem** Skill
abgebildet. Als Regel gilt in allen Skills, die `docs/` anfassen: niemals nach
`Archive/` schreiben, und niemals Inhalte von dort als aktuellen Projektkontext
lesen. Betroffen sind `brainstorming` (Schritt 1 „Explore project context" —
die kritischste Stelle, dort wird sonst eine archivierte Spec als gültig
eingelesen), `writing-specs` und `writing-plans`.

---

## `domain-modeling` — fünf Andockpunkte

Nicht vorne drangeklebt, sondern in die Stellen eingesetzt, die 6.2.0 von sich
aus anbietet:

1. **`brainstorming` Schritt 1** — `CONTEXT.md` / `CONTEXT-MAP.md` gehören zum
   „Explore project context".
2. **`brainstorming`, neuer Checklistenpunkt zwischen 3 und 5** — aktives
   Modellieren während der Fragen: Begriffe gegen das Glossar challengen,
   unscharfe Sprache schärfen, Szenarien gegen Kanten fahren, gegen den Code
   gegenprüfen. Auch als Knoten im `dot`-Graph.
3. **`writing-specs`** — Spec/Analysis, `CONTEXT.md`-Updates und Decisions gehen
   in **einen** Commit. Das Dokument bekommt einen Abschnitt „Ubiquitous
   Language", der auf `CONTEXT.md` verweist statt zu duplizieren. (Punkte 1–2
   liegen in den Einstiegs-Skills, dieser im gemeinsamen Schwanz.)
4. **`writing-plans` → `Global Constraints`** — hier steht: *Terminologie ist in
   `CONTEXT.md` definiert; Abweichung ist ein Defekt.* Das ist der wirksamste
   Hebel im ganzen Umbau: SDD reicht diesen Block laut `task-reviewer-prompt.md`
   wörtlich an jeden Task-Reviewer weiter, damit trägt die Terminologie-Bindung
   ohne weitere Änderung bis in jede einzelne Review.
5. **`code-review/code-reviewer.md`** — Checklistenpunkt: Stimmt die Benennung
   mit `CONTEXT.md` überein? Führt der Code Begriffe ein, die im Glossar fehlen?

Ergänzend: der `implementer-prompt` von SDD bekommt den relevanten
`CONTEXT.md`-Auszug in den Dispatch-Kontext.

### Das Glossar muss auch gelesen werden

Die fünf Andockpunkte decken die Kette ab — Spec, Plan, Implementierung,
Review. Sie decken **nicht** ab, was außerhalb der Kette passiert: „bau schnell
den Endpunkt", „fix das". Genau dort entstehen aber die abweichenden Namen.

Geschlossen wird das über die Projekt-`CLAUDE.md`, die laut Doku in jeder
Session geladen wird und Compaction überlebt. Der Anspruch ist dabei
**beidseitig**: der Agent soll die kanonischen Begriffe verwenden *und* die
abweichenden des Nutzers verstehen. Die `_Avoid_`-Liste ist dafür keine
Verbotsliste, sondern eine Übersetzungstabelle.

```markdown
## Domänensprache

Die verbindlichen Begriffe dieses Projekts stehen in @CONTEXT.md.

**Verwende sie.** Im Gespräch genauso wie in Code, Bezeichnern, Commits und
Dokumentation. Wenn du etwas erklärst oder beschreibst, nimm den kanonischen
Namen, nicht ein Synonym.

**Verstehe meine.** Die unter `_Avoid_` gelisteten Varianten meinen denselben
Begriff — übersetze still und antworte kanonisch. Korrigiere mich nicht bei
jeder Nennung; das gehört in eine Modellierungs-Sitzung, nicht in die
alltägliche Arbeit.

**Frag bei Unbekanntem.** Benutze ich einen Begriff, der weder kanonisch noch
unter `_Avoid_` steht, rate nicht. Sag, dass er im Glossar fehlt, und frag
nach — entweder fehlt ein Eintrag, oder wir reden von etwas Neuem.
```

Die drei Absätze decken drei verschiedene Fälle ab, die leicht zusammenfallen:
Ausgabe (kanonisch sprechen), Eingabe (Synonyme still auflösen) und Lücke (nicht
raten). Der mittlere Absatz ist die bewusste Abgrenzung zum `domain-modeling`-
Skill selbst, der Begriffe sofort challengen soll — das ist richtig *während*
einer Modellierung und unerträglich in der Alltagsarbeit.

Der `@`-Import macht das Glossar *bekannt*, die Absätze machen es *wirksam*.
Beides bleibt Kontext, keine Durchsetzung. Der einzige harte Zwang liegt im
`code-reviewer`, der Benennung gegen `CONTEXT.md` prüft und blockiert — er
greift aber nur bei Code, nicht im Gespräch.

**`domain-modeling` verdrahtet das selbst** statt es der Handarbeit zu
überlassen. Der Skill prüft:

1. Existiert ein Glossar (`CONTEXT.md` oder `CONTEXT-MAP.md`)?
2. Wenn ja: ist es in der Projekt-`CLAUDE.md` eingebunden — geprüft wird
   `./CLAUDE.md` **und** `./.claude/CLAUDE.md`?
3. Wenn nicht: Import und Verbindlichkeitsabsatz ergänzen und ansagen, was
   geändert wurde.

Die Prüfung läuft an **zwei** Stellen: beim Start des Skills, und erneut
unmittelbar nachdem lazy ein neues `CONTEXT.md` angelegt wurde. Ohne den
zweiten Punkt bleibt jedes frisch entstandene Glossar dauerhaft uneingebunden —
der häufigste Fall überhaupt, denn der Skill legt die Datei erst an, wenn der
erste Begriff feststeht.

Randfälle, die der Skill abdecken muss:

- **Keine `CLAUDE.md` vorhanden** → `./CLAUDE.md` mit dem Block anlegen und das
  ansagen. Die Datei ist committet und team-geteilt, das Anlegen ist keine
  stille Nebenwirkung.
- **Mehrere Kontexte** (`CONTEXT-MAP.md` vorhanden) → nur die Map importieren,
  nicht jedes einzelne `CONTEXT.md`. Die Map ist klein und nennt die Pfade; die
  Einzelglossare werden bei Bedarf gelesen. Alles zu importieren sprengt den
  Kontext.
- **Import bereits vorhanden, aber anders geschrieben** (`@./CONTEXT.md`,
  absoluter Pfad) → nicht auf exakte Zeichenfolge prüfen, sondern auf eine
  Referenz. Sonst entstehen Doppel-Importe.
- **Import da, Verbindlichkeitsabsatz fehlt** → nur den Absatz ergänzen.
- Ein in Backticks stehendes `` `@CONTEXT.md` `` ist laut Doku **kein** Import.
  Beim Prüfen wie beim Schreiben zu beachten.

---

## Drei Einstiege, ein gemeinsamer Schwanz

`brainstorming`, `sharpen-me` und `sharpen-with-docs` führen alle drei in die
Kette. Was **nach** dem Gespräch passiert, ist bei allen identisch: Dokumenttyp
wählen, ablegen, prüfen lassen, freigeben, `writing-plans` aufrufen. Dreimal
gepflegt driften diese ~40 Zeilen auseinander.

Delegieren an `brainstorming` scheidet aus: es trägt `disable-model-invocation`
und kann laut Spike-Ergebnis von keinem anderen Skill aus gestartet werden.

**Der gemeinsame Teil wird deshalb als eigenes Skill `writing-specs`
herausgezogen** (Namenssymmetrie zu `writing-plans`), ohne Flag, damit alle drei
Einstiege es erreichen:

```
brainstorming        ─┐
sharpen-me           ─┼─► writing-specs ─► writing-plans ─► SDD
sharpen-with-docs    ─┘
```

Jeder Einstieg enthält dann nur noch das Unterscheidende:

| Skill | Gesprächsführung | domain-modeling |
|---|---|---|
| `brainstorming` | Klärungsfragen, dann Design in Abschnitten | ja |
| `sharpen-me` | schonungsloses Interview, ganzer Entscheidungsbaum | nein |
| `sharpen-with-docs` | schonungsloses Interview | ja |

**Der Übergang ist eine Frage, keine Automatik.** Jeder der drei Einstiege
endet mit der ausdrücklichen Frage, ob aus dem Ergebnis ein Dokument werden
soll. Bei „nein" endet die Sitzung ohne Datei — das ist ein gültiger Ausgang,
kein Abbruch. Besonders `sharpen-me` wird oft nur als Denkwerkzeug benutzt.

Das widerspricht dem Terminal-State-Satz von superpowers' `brainstorming`
(„The ONLY skill you invoke after brainstorming is writing-plans"). Der Satz
wird ersetzt: einziger *Nachfolger* ist `writing-specs`, der Weg dorthin ist
optional, und `domain-modeling` darf begleitend laufen.

**`sharpen` selbst bekommt den Schwanz nicht.** Der Basis-Skill bleibt
dokumentfrei — sonst wird aus jedem beiläufigen „hinterfrag das mal" eine
Spec-Datei samt Reviewer-Dispatch. Die Wrapper hängen den Schwanz an, `sharpen`
bleibt das schnelle Werkzeug.

---

## Automatische Dokument-Reviews

Sowohl die Spec/Analysis als auch der Plan werden nach dem Schreiben
**automatisch** von einem frischen Subagenten geprüft. Grundlage sind die
beiden in 6.2.0 verwaisten Templates `spec-document-reviewer-prompt.md` (49 Z)
und `plan-document-reviewer-prompt.md` (49 Z) — beide dispatchen einen
`general-purpose`-Subagenten, dieselbe Mechanik wie `code-reviewer.md`.

**Das ersetzt die bestehende Selbstprüfung nicht, es folgt ihr.** Beide Skills
enthalten heute eine Inline-Checkliste; `writing-plans` formuliert sogar
ausdrücklich *„This is a checklist you run yourself — not a subagent dispatch."*
Dieser Satz wird gestrichen. Die Reihenfolge ist:

1. **Inline-Selbstprüfung** (bestehend) — Placeholder, Widersprüche, Scope,
   Ambiguität. Billig, fängt das Offensichtliche.
2. **Dispatch des Dokument-Reviewers** — frische Augen ohne Autorenblindheit.
   Das ist der eigentliche Gewinn: das schreibende Modell sieht seine eigenen
   Lücken nicht.
3. **`Issues` inline beheben.** `Recommendations` sind laut Template
   ausdrücklich advisory und blockieren nicht.
4. **Genau ein Re-Review.** Kommt danach immer noch `Issues Found`, wird nicht
   weitergeschleift, sondern Befund und Dokument dem Nutzer vorgelegt.

Erst danach folgt in `writing-specs` das User-Review-Gate — der Nutzer bekommt
also ein bereits geprüftes Dokument vorgelegt, keinen Rohentwurf.

Die Inline-Selbstprüfung wandert dabei aus `brainstorming` mit nach
`writing-specs`: sie gehört zum Schreiben des Dokuments, nicht zum Gespräch.

Die Pfadangaben in beiden Templates (`docs/superpowers/specs/`) werden auf die
eigene Konvention umgestellt.

---

## Git-Konvention — ein Commit, ein Branch, ein Gate

Drei Abweichungen von 6.2.0, die zusammengehören: die History soll am Ende aus
**einem** Commit bestehen, Arbeit findet **immer** auf einem Feature-Branch
statt, und **kein** Zweig führt ungeprüft ins Landen.

### Ein Commit — durch Squash beim Landen, nicht durch Commit-Verzicht

Superpowers committet **einmal pro Task** (`writing-plans` hängt „Step 5:
Commit" an jeden Task, `implementer-prompt.md` Schritt 4 sagt „Commit your
work"). Bei zehn Tasks sind das zehn Commits.

Diese Task-Commits **bleiben** — sie zu streichen zerlegt SDD:

- `scripts/review-package PLAN BASE HEAD` verifiziert beide Enden per
  `git rev-parse --verify` und erzeugt `git diff BASE..HEAD`. Ohne
  Task-Commit ist der Range leer und der Task-Reviewer prüft nichts.
- Der Ledger ist laut SDD ausdrücklich die Recovery-Map: *„the commits it
  names exist in git even when your context no longer remembers creating
  them."* Ohne SHAs bleibt nach einer Compaction kein Beweis, was fertig ist.
- SDD reviewt **nach jedem Task**, nicht nur am Ende. Der Zweck ist, Fehler
  früh zu stoppen: Task 5 baut auf Task 3 auf. Ein Reviewer ohne
  abgrenzbaren Diff sähe bei Task 5 kumulativ alles von Task 1–5 und meldete
  Befunde zu Code, den ein früherer Reviewer schon durchgewunken hat.

Der Wunsch wird stattdessen **beim Landen** erfüllt: die Task-Commits leben
nur auf dem Feature-Branch, der nach dem Squash gelöscht wird. Im
Ziel-Branch landet genau ein Commit.

```bash
git switch <base-branch>
git pull
git merge --squash <feature-branch>   # staged nur, committet nicht
<test command>                        # rot ⇒ git reset --hard, Branch bleibt
git commit -m "<message>"
git branch -D <feature-branch>
```

Zwei Fallstricke, die im Skill stehen müssen:

- **Getestet wird vor dem Commit.** `--squash` stellt Index und Working Tree
  her, ohne zu committen. Schlägt der Test fehl, macht `git reset --hard`
  den Base-Branch sauber — kein Rücknahme-Commit nötig. Committet man
  zuerst, muss man ihn hinterher wieder abtragen.
- **`git branch -d` schlägt nach einem Squash fehl.** Der Squash erzeugt
  keinen Merge-Commit mit zweitem Parent; aus Gits Sicht ist der Branch
  nicht gemergt. Es muss `-D` sein — mit dem ausdrücklichen Hinweis, warum
  das hier kein Datenverlust ist.

### Die Commit-Message kommt aus `commitMessage` — direkt aufgerufen

`finishing-a-development-branch` braucht für den Squash-Commit eine Message.
`commitMessage` trug bisher `disable-model-invocation: true` und war damit
für jeden Skill-Aufruf gesperrt.

**Die Flag ist entfernt.** `finishing-a-development-branch` ruft
`smax:commitMessage` regulär auf, kein Umweg über eine ausgelagerte
Regeldatei, keine zweite Kopie der Konvention.

Die Description musste mitgeändert werden, sonst wäre die Änderung halb
wirkungslos geblieben: mit gesetzter Flag ist sie reiner Anzeigetext, ohne
sie ist sie der Trigger. Aus `Generate commit message from uncommitted
changes` wurde die Trigger-Form `Use when a commit message is needed …`.

Nebenwirkung, bewusst in Kauf genommen: Das Skill springt jetzt auch bei
einem beiläufigen „commite das" von selbst an. Für ein Skill, dessen einziger
Zweck eine gute Commit-Message ist, ist genau das erwünscht — es ist
15 Zeilen lang und produziert keinen Nebeneffekt außer Text.

**Der Spike-Beleg bleibt gültig, ist aber nicht mehr reproduzierbar.** Die
Fehlermeldung unter „Verifizierte Grundlagen" stammt aus einem Aufruf gegen
die damals noch gesetzte Flag. Die Erkenntnis — die Flag sperrt auf
Tool-Ebene, nicht nur in der Anzeige — steht; wer sie nachstellen will,
braucht ein anderes Skill mit der Flag, etwa `sharpen-me`.

### Immer ein Feature-Branch

Die Branch-Logik von 6.2.0 wird **unverändert** übernommen: `using-git-worktrees`
legt die Worktree mit `git worktree add -b` an, der Branch entsteht dabei.
Step 0 erkennt vorhandene Isolation, der Submodul-Guard bleibt, die
Consent-Frage bleibt.

Eine einzige Lücke wird geschlossen. Lehnt der Nutzer die Worktree ab, sagt
6.2.0 *„work in place and skip to Step 2"* — dann wird auf dem aktuellen
Branch gearbeitet, notfalls `main`. SDD und `executing-plans` haben dagegen
nur den Satz „never start implementation on a main/master branch without
your human partner's explicit consent": eine Rückfrage, kein Mechanismus.

Ergänzt wird deshalb in Step 0, im Ablehnungszweig: steht der Nutzer dann auf
dem Default-Branch, wird ein Feature-Branch per `git switch -c` vorgeschlagen
und nach Zustimmung angelegt. Kein Eingriff in die Worktree-Mechanik — der
Zweig, der bisher ins Nichts lief, bekommt ein Ziel.

### Kein ungeprüfter Weg ins Landen

Der finale Code-Review ist **blockierend**, nicht angeboten. Heute gibt es
zwei Pfade und nur einer reviewt:

| Pfad | Finaler Review in 6.2.0 |
|---|---|
| `subagent-driven-development` | ja — dispatcht nach dem letzten Task (`SKILL.md` Z. 103) |
| `executing-plans` | **nein** — geht von „alle Tasks fertig" direkt zu `finishing-a-development-branch` |
| Plan von Hand abgearbeitet | **nein** — `writing-plans` schreibt keinen Review-Task ins Dokument |

Das Gate wird an der Stelle verankert, an der **beide** Pfade und auch die
Handarbeit vorbeikommen: in `finishing-a-development-branch`, als neuer
Schritt vor dem Optionsmenü. Es prüft, ob für den Stand ein Code-Review
vorliegt; wenn nicht, wird `code-reviewer.md` dispatcht, `Issues` werden
behoben, und erst danach erscheinen die Merge-Optionen.

Ein Gate in SDD **und** in `executing-plans` einzubauen wäre die Alternative
— zwei Implementierungen desselben Gates, und die Handarbeit bliebe trotzdem
ungedeckt.

Doppelte Reviews vermeidet ein einfacher Abgleich: hat SDD seinen finalen
Reviewer bereits über denselben Stand laufen lassen und ist seither nichts
dazugekommen, wird das gemeldet und übersprungen. Der Vergleich läuft über
den HEAD-SHA, nicht über eine Behauptung im Gesprächsverlauf.

---

## Was nicht mitkommt

| Ausgeschlossen | Zeilen | Grund |
|---|---:|---|
| `using-superpowers` + SessionStart-Hook | ~200 | Ist die Ursache des Dazwischenfunkens |
| `CREATION-LOG.md`, `test-pressure-*.md`, `test-academic.md` | 328 | Entwicklungsartefakte des Autors |
| `examples/CLAUDE_MD_TESTING.md` | 189 | Experiment gegen ein abgelöstes Skill-System |
| `commands/`, `tests/`, Plattform-Manifeste (`.codex-plugin` etc.) | — | Nicht anwendbar |

---

## Phasen

Die Reihenfolge folgt den Abhängigkeiten: `writing-skills` liefert den Leitfaden
für alles Weitere und steht deshalb vorn; `code-review` wird von SDD über eine
Dateireferenz gebraucht; `using-git-worktrees` und `finishing-a-development-branch`
werden von SDD aufgerufen und müssen davor existieren.

### Phase 1 — Infrastruktur

- [x] `plugin/NOTICE.md`: MIT-Lizenztext, © 2025 Jesse Vincent, Quellversion
      `superpowers 6.2.0`, Commit `eccd45305a06aacccbd1d96f384b30e626a25ca0`,
      Repo-URL und Liste der abgeleiteten Dateien. Ins **Plugin**-Verzeichnis,
      denn nur das wird ausgeliefert. Der Commit ist der einzige spätere
      Ankerpunkt für einen Upstream-Vergleich — der Plugin-Cache verschwindet
      mit der Deinstallation.
- [x] `.gitignore`: Regel `docs/superpowers/` entfernen — der Ordner ist
      gelöscht, die Regel zeigt ins Leere. `docs/` ist versioniert und wird
      trotzdem nicht ausgeliefert, weil außerhalb von `plugin/`
- [x] `.gitignore`: **`.smax/` ist hier *nicht* nötig** — siehe unten

**Erledigt, entfällt:** Der Umzug von
`docs/superpowers/specs/2026-07-24-smax-plugin-restructure-design.md` nach
`01_Specs/SmaxPluginRestructure/`. Der Ordner wurde gelöscht, die Datei war
nie versioniert (die `.gitignore`-Regel hielt sie draußen) und wird nicht
gebraucht.

**Warum kein `.smax/` im `.gitignore`:** Ein Eintrag hier schützt nur *dieses*
Repo — genutzt werden die Skills in fremden. Für SDD wäre er ohnehin
redundant: `sdd-workspace` legt sein eigenes `.gitignore` an
(`printf '*\n' > "$base/.gitignore"`), ausdrücklich um *„keep every plan's
workspace out of `git status` … **without modifying any tracked file**"*. Das
`.gitignore` fremder Repos anzufassen ist dort bewusst vermieden — dem folgen
wir statt es zu unterlaufen.

Bleibt der Companion, der sich **nicht** selbst ignoriert: `visual-companion.md`
hat nur die Bitte *„Remind the user to add `.superpowers/` to `.gitignore`"* —
eine Erinnerung, die das Modell aussprechen kann oder auch nicht. Das
`.gitignore` aus `.smax/sdd/` wirkt nur unterhalb seines eigenen
Verzeichnisses und deckt den Nachbarordner nicht ab. Gelöst wird das an der
Wurzel in **Phase 5**, nicht durch eine Regel bei uns.

### Phase 2 — `writing-skills` (2.739 Z)

Zuerst, weil es der Leitfaden für alle folgenden Phasen ist — insbesondere
`persuasion-principles.md`, das begründet, warum die harten Formulierungen in
Phase 6 nicht geglättet werden dürfen.

- [x] `SKILL.md` 679
- [x] `testing-skills-with-subagents.md` 384
- [x] `anthropic-best-practices.md` 1.150 — eingefrorene Kopie externer Doku;
      als solche in `plugin/NOTICE.md` kennzeichnen
- [x] `persuasion-principles.md` 187 — **vor Phase 6 einmal lesen**
- [x] `graphviz-conventions.dot` 171
- [x] `render-graphs.js` 168 — braucht systemweites Graphviz (`dot`).
      **Nicht lauffähig getestet:** `dot` ist auf dieser Maschine nicht
      installiert. Harmlos, aber unbenutzbar
- [x] Flag-Entscheidung: **ohne Flag** — die Description ist eng genug

### Phase 3 — `code-review` (472 Z)

Kleinste geschlossene Einheit — und sowohl SDD als auch
`finishing-a-development-branch` erreichen das Template später per Dateipfad,
nicht per Skill-Aufruf.

- [x] `plugin/skills/dev/code-review/code-reviewer.md` — das 172-Zeilen-Template
      wörtlich, plus Naming-Check gegen `CONTEXT.md`
- [x] `plugin/skills/dev/code-review/SKILL.md` — **Ziel unter 40 Zeilen**: SHAs
      bestimmen, Template füllen, `general-purpose`-Subagent dispatchen,
      Feedback abarbeiten
- [x] Die Essenz von `receiving-code-review` (205 Z) als Abschnitt
      „Act on feedback" eindampfen — inklusive: bei falschem Reviewer technisch
      begründet widersprechen statt einzuknicken
- [x] Flag-Entscheidung: **`disable-model-invocation: true`** — der Merge-Fall
      ist über `code-reviewer.md` fest verdrahtet, also bleibt vom
      Auto-Trigger nur das Anspringen bei Zwischenständen. Per
      `/smax:code-review` jederzeit greifbar

Vorlage für den dünnen Skill: `git show 68b5d46:skills/dev/code-review/SKILL.md`

### Phase 4 — Einstiege, `writing-specs`, `writing-plans` (~470 Z)

Zusammenhängend, weil über den Themen-Slug und `Global Constraints` gekoppelt.
Diese Phase ist eine Einheit und lässt sich nicht aufteilen.

**`writing-specs/SKILL.md`** — neu geschrieben, ~50 Z

Der aus `brainstorming` extrahierte gemeinsame Schwanz. Ohne Flag, damit alle
drei Einstiege ihn erreichen.

- [x] ANALYSIS/SPEC-Weiche mit Kriterium und Vorab-Ansage
- [x] Themen-Slug festlegen (PascalCase), Zielpfad `docs/00_Analysis/` bzw.
      `docs/01_Specs/<Thema>/`, Dateiname mit `-DDMMYYYY`-Suffix
- [x] Erstellungsdatum als zweite Zeile (`**Erstellt:** DD.MM.YYYY`)
- [x] **Bestehenden Themenordner erkennen, ansagen und fragen** —
      fortschreiben oder neues Dokument?
- [x] `Archive/` niemals beschreiben oder als aktuellen Kontext lesen
- [x] Abschnitt „Ubiquitous Language" mit Verweis auf `CONTEXT.md`
- [x] Dokument, `CONTEXT.md`-Updates und Decisions in **einem** Commit
- [x] Inline-Selbstprüfung (aus `brainstorming` übernommen)
- [x] `spec-document-reviewer-prompt.md` (49 Z) übernehmen, Pfadangabe anpassen
- [x] Dispatch → `Issues` beheben → ein Re-Review → sonst dem Nutzer vorlegen
- [x] User-Review-Gate
- [x] `writing-plans` aufrufen

**`brainstorming/SKILL.md`** (151 Z)

- [x] Übernehmen, Visual-Companion-Abschnitt und Checklistenpunkt 2 **behalten**
- [x] **Schritte 6–9 entfernen** — Schreiben, Selbstprüfung, User-Gate und der
      Übergang zur Implementierung leben jetzt in `writing-specs`
- [x] domain-modeling-Andockpunkte 1–2 einsetzen (Checkliste **und** `dot`-Graph)
- [x] Schritt 1: `Archive/` nicht als aktuellen Projektkontext lesen — hier am
      wichtigsten, „Explore project context" greift sonst archivierte Specs auf
- [x] Abschlussfrage: „Soll daraus ein Dokument werden?" — bei „nein" endet die
      Sitzung ohne Datei, ausdrücklich als gültiger Ausgang formuliert
- [x] Terminal-State-Satz ersetzen (Nachfolger ist `writing-specs`, Weg dorthin
      optional, `domain-modeling` darf begleitend laufen)
- [x] `disable-model-invocation: true`

**`domain-modeling/SKILL.md`** — bestehendes Skill, neuer Abschnitt

- [x] Selbstprüfung ergänzen: Glossar vorhanden? In `./CLAUDE.md` oder
      `./.claude/CLAUDE.md` eingebunden? Sonst Import und
      Verbindlichkeitsabsatz ergänzen und die Änderung ansagen
- [x] Prüfung an **zwei** Stellen verankern: beim Skill-Start und direkt nach
      dem lazy Anlegen eines neuen `CONTEXT.md`
- [x] Randfälle abdecken: fehlende `CLAUDE.md` anlegen · bei `CONTEXT-MAP.md`
      nur die Map importieren · tolerant auf vorhandene Referenz prüfen statt
      auf exakte Zeichenfolge · Import ohne Verbindlichkeitsabsatz nachbessern ·
      Referenzen in Backticks sind keine Importe

**`sharpen-me` / `sharpen-with-docs`** — bestehende Skills, je wenige Zeilen

- [x] Dieselbe Abschlussfrage ergänzen, bei „ja" `writing-specs` aufrufen
- [x] `sharpen-with-docs` behält den `domain-modeling`-Verweis, `sharpen-me` nicht
- [x] `sharpen` selbst **unverändert**

**`writing-plans/SKILL.md`** (168 Z)

- [x] Übernehmen, ohne Flag
- [x] Zielpfad `docs/02_Plans/<Thema>/PLAN-<Thema>-DDMMYYYY.md`
- [x] Erstellungsdatum als zweite Zeile im erzeugten Plan
- [x] Themen-Slug von `writing-specs` unverändert übernehmen
- [x] Bestehenden Themenordner erkennen, ansagen und fragen
- [x] `Archive/` niemals beschreiben oder als aktuellen Kontext lesen
- [x] Andockpunkt 4 in `Global Constraints`
- [x] DB-Changes-Regel ergänzen: Pfad, Namensschema, Forward/Rollback als
      Task-Schritte, **Datum = Schreibdatum des Implementers**
- [x] `plan-document-reviewer-prompt.md` (49 Z) übernehmen, Pfadangabe anpassen
- [x] Satz *„This is a checklist you run yourself — not a subagent dispatch."*
      streichen und den automatischen Dispatch nach der Selbstprüfung
      verdrahten, vor dem Execution-Handoff
- [x] Overview-Zeile: *„DRY. YAGNI. TDD. Frequent commits."* → **ein Commit pro
      Task**, mit dem Zusatz, dass diese Commits beim Landen zu einem
      gequetscht werden. `Step 5: Commit` bleibt im Task-Template — das ist
      der Task-Commit, den SDDs Review-Package und Ledger brauchen
- [x] **Jeder erzeugte Plan endet mit einem Code-Review-Abschnitt** — als
      letzter Punkt nach dem letzten Task, damit auch ein von Hand
      abgearbeiteter Plan das Gate nennt. Nicht als Task mit Steps
      formuliert, sondern als Abschluss­bedingung: „Vor dem Landen läuft
      `smax:code-review` über den Gesamtstand; `Issues` sind zu beheben."

### Phase 5 — Visual Companion (1.730 Z)

- [x] `visual-companion.md` 298
- [x] `scripts/server.cjs` 723 — nutzt ausschließlich Node-Built-ins
      (`crypto`, `http`, `fs`, `path`, `os`, `child_process`), keine npm-Deps
- [x] `scripts/helper.js` 167, `scripts/frame-template.html` 213 — Template ohne
      externe URLs, läuft offline
- [x] `scripts/start-server.sh` 209, `scripts/stop-server.sh` 120
- [x] **`.superpowers/brainstorm/` → `.smax/brainstorm/`** an 10 Stellen
      (4× `start-server.sh`, 1× `stop-server.sh`, 5× `visual-companion.md`)
- [x] **Companion selbst-ignorierend machen** — nach SDD-Vorbild
      `printf '*\n' > .smax/brainstorm/.gitignore` in `start-server.sh`,
      direkt nach dem Anlegen des Verzeichnisses. Damit entfällt die Zeile
      *„Remind the user to add `.superpowers/` to `.gitignore`"* in
      `visual-companion.md` (Z. 58) ersatzlos: eine Erinnerung, die das
      Modell aussprechen kann oder auch nicht, ist kein Schutz. Wirkt in
      **jedem** Repo, in dem das Plugin läuft — nicht nur in unserem
- [x] Start/Stop unter Git Bash auf Windows testen, Browser-Öffnung per `--open`
      prüfen

### Phase 6 — Querschnitt (~910 Z)

Vor SDD, weil SDD `using-git-worktrees` im Setup verlangt und mit
`finishing-a-development-branch` endet.

- [x] `test-driven-development` — `SKILL.md` 320 + `writing-good-tests.md` 198
- [x] `verification-before-completion` 120

**`using-git-worktrees/SKILL.md`** (167 Z) — wörtlich, plus eine Ergänzung

- [x] Übernehmen: Step 0 mit Submodul-Guard, Consent-Frage, native Tools vor
      `git worktree add`, `check-ignore`-Sicherung — alles unverändert
- [x] **Ablehnungszweig in Step 0 ergänzen:** *„work in place and skip to
      Step 2"* bekommt eine Vorbedingung. Steht der Nutzer auf dem
      Default-Branch, wird ein Feature-Branch per `git switch -c`
      vorgeschlagen und nach Zustimmung angelegt; auf einem anderen Branch
      wird ohne Nachfrage in place gearbeitet

**`finishing-a-development-branch/SKILL.md`** — 201 Z → **~90 Z**

Das einzige Skill, das absichtlich eingedampft wird. Gekürzt wird die
Zeremonie, nicht der Verhaltensdruck: die `Common Rationalizations`-Tabelle
bleibt vollständig, weg gehen die redundante `Quick Reference` (dieselbe
Information steht in Schritt 5), die ausgewalzten Erklärabsätze und der
26-Zeilen-Discard-Pfad, der auf drei Zeilen samt `discard`-Bestätigung
zusammengeht.

- [x] Schritte 1–3 (Tests, Umgebungserkennung, Base-Branch bestätigen) und 6
      (Worktree-Cleanup, nur unter `.worktrees/`/`worktrees/`) übernehmen
- [x] **Neuer Schritt vor dem Optionsmenü: das Review-Gate.** Liegt kein
      Code-Review für den aktuellen HEAD vor, wird `../code-review/code-reviewer.md`
      dispatcht und `Issues` werden behoben, bevor das Menü erscheint. Hat
      SDDs finaler Reviewer denselben HEAD-SHA bereits geprüft, wird das
      gemeldet und übersprungen — Abgleich über den SHA, nicht über eine
      Behauptung im Gesprächsverlauf
- [x] **Option 1 auf Squash umstellen:** `git merge --squash`, testen im
      gestageten Zustand, dann committen. Rot ⇒ `git reset --hard`, Branch
      bleibt stehen
- [x] `git branch -d` → `git branch -D` mit der Begründung im Text: nach
      einem Squash existiert kein Merge-Commit mit zweitem Parent, Git hält
      den Branch für ungemergt. Ohne den Satz liest sich `-D` wie
      Schludrigkeit und wird beim nächsten Redigieren „korrigiert"
- [x] Für die Squash-Message `smax:commitMessage` aufrufen
- [x] **keine** Archivierungslogik

**`commitMessage`** — bestehendes Skill, model-invocable gemacht

- [x] `disable-model-invocation: true` entfernt
- [x] Description auf Trigger-Form umgestellt — ohne „Use when …" triggert
      ein model-invocables Skill unzuverlässig
- [x] **Squash-Fall ergänzen:** Eine Message für einen ganzen Feature-Branch
      ist eine andere Gattung als eine für eine einzelne Änderung. Das Skill
      kennt heute nur „konzise erste Zeile unter 72 Zeichen" — für den
      Squash braucht es zusätzlich einen Body, der die Tasks des Plans
      auflistet. Zu ergänzen, wenn Phase 6 den Squash-Ablauf verdrahtet,
      nicht vorher

Der Rest der Phase weitgehend wörtlich. **Dort nicht kürzen:** die überzogen
wirkenden Anti-Rationalisierungs-Passagen sind die einzigen, die unter Druck
greifen. Die Begründung steht in `persuasion-principles.md` aus Phase 2.

### Phase 7 — SDD + `executing-plans` (1.127 Z)

Der größte Einzelposten — SDD ist in 6.2.0 von 477 auf 1.063 Zeilen gewachsen
und trägt jetzt Ledger, Fix-Loop mit 5-Runden-Cap und Breaker, scoped
Re-Review sowie drei Hilfsskripte.

- [x] `SKILL.md` 503 Z
- [x] `implementer-prompt.md` 142 Z — plus `CONTEXT.md`-Auszug im Dispatch
- [x] `task-reviewer-prompt.md` 185 Z
- [x] `re-review-prompt.md` 106 Z
- [x] `scripts/sdd-workspace` (40), `scripts/task-brief` (41),
      `scripts/review-package` (46)
- [x] **`.superpowers/sdd/` → `.smax/sdd/` an 7 Stellen** (5× in den Skripten,
      2× in `SKILL.md`) — sonst legt das Plugin in fremden Repos Verzeichnisse
      namens `.superpowers` an
- [x] **Cross-Skill-Dateipfad umbiegen:** `../requesting-code-review/code-reviewer.md`
      → `../code-review/code-reviewer.md` an **4 Stellen** in `SKILL.md`
      (Z. 74, 103, 104, 400). Das ist eine *Datei*-Referenz, keine
      Skill-Referenz — der `superpowers:`-Grep in der Schlussphase findet sie
      nicht, weil das Wort darin nicht vorkommt
- [x] Skripte unter Git Bash auf Windows testen (`set -euo pipefail`, `awk`)
- [x] **Finalen Reviewer den geprüften HEAD-SHA in den Ledger schreiben
      lassen** — `Final review: clean (HEAD <sha7>)`. Ohne diese Zeile kann
      das Gate in `finishing-a-development-branch` nicht erkennen, dass
      derselbe Stand schon geprüft ist, und reviewt jeden SDD-Lauf doppelt
- [x] `executing-plans/SKILL.md` 64 Z — Step 3 ruft bereits
      `finishing-a-development-branch` auf und erbt damit das Review-Gate.
      Kein eigenes Gate einbauen; nur prüfen, dass der Aufruf beim Umbau
      erhalten bleibt
- [x] Alle `superpowers:`-Skill-Referenzen → `smax:`

### Phase 8 — `debugging` (919 Z)

- [x] `SKILL.md` 283, `root-cause-tracing.md` 169, `defense-in-depth.md` 122,
      `condition-based-waiting.md` 115 + `-example.ts` 158, `find-polluter.sh` 72
- [x] Zu einem Skill mit Referenzdateien zusammenfassen
- [x] **Kein `disable-model-invocation`** — soll bei Fehlern von selbst
      anspringen und bleibt trotzdem per `/smax:debugging` aufrufbar
- [x] Ergänzen: wenn die Root Cause eine Begriffsverwechslung ist, gehört sie ins
      Glossar oder in eine Decision

`test-driven-development` und `verification-before-completion` bleiben
eigenständig — sie sind Querschnitt und werden auch von SDD gezogen.

### Phase 9 — Abschluss (167 Z)

- [x] `dispatching-parallel-agents` 167
- [x] `grep -rn "superpowers" plugin/` muss leer sein — Skill-Referenzen **und**
      Pfade *(erledigt: nur noch `plugin/NOTICE.md`, dort erwünscht)*
- [x] Zusätzlich prüfen: `grep -rn "requesting-code-review\|receiving-code-review" plugin/`
      — fängt die Dateireferenzen, die der erste Grep nicht sieht
      *(erledigt: nur noch die Herkunftstabelle in `plugin/NOTICE.md`)*
- [x] Ende-zu-Ende-Test in einem Wegwerf-Repo: `/smax:brainstorming` →
      Abschlussfrage → `writing-specs` → Spec unter `01_Specs/` samt
      `CONTEXT.md` im selben Commit → Reviewer-Dispatch → User-Gate →
      `writing-plans` propagiert selbstständig → Plan unter `02_Plans/` → SDD
      mit Ledger unter `.smax/sdd/` → `finishing-a-development-branch`
      *(erster Lauf 26.07.2026 in `C:\Projects\test-skills`, vollständig
      durchgelaufen)*
- [ ] Am Ende dieses Durchlaufs die Git-Konvention gegenprüfen:
      Feature-Branch existiert · Task-Commits liegen darauf · das Gate hat
      den bereits geprüften HEAD erkannt und **nicht** doppelt reviewt ·
      nach Option 1 steht auf dem Base-Branch **genau ein** Commit
      (`git log --oneline <base> ^<merge-base>` liefert eine Zeile) und der
      Feature-Branch ist weg

      *Stand: alles bestätigt außer dem Gate-Punkt. Der war im ersten Lauf
      strukturell nicht prüfbar — SDD löschte den Workspace vor der Übergabe,
      damit fehlte die Ledger-Zeile, gegen die das Gate abgleicht. Behoben in
      `f2eaa49`/`7559042` (Workspace bleibt stehen); der zweite Lauf prüft es.*
- [ ] Den Ablehnungszweig separat testen: Worktree-Frage mit „nein"
      beantworten, während man auf `main` steht — es muss ein
      `git switch -c` vorgeschlagen werden statt still auf `main`
      weiterzuarbeiten
- [ ] Den ungeprüften Pfad testen: `finishing-a-development-branch` direkt
      aufrufen, ohne dass vorher ein Review lief — das Gate muss den
      Reviewer dispatchen, bevor das Optionsmenü erscheint
- [ ] Zweiter Durchlauf über `/smax:sharpen-with-docs`, um die Konvergenz auf
      `writing-specs` zu prüfen — und einmal mit „nein" auf die Abschlussfrage,
      um zu sehen, dass die Sitzung sauber ohne Datei endet
- [ ] `/smax:code-review` separat testen — es hängt nicht in der Kette, SDD
      erreicht den Reviewer über die Dateireferenz
- [ ] **Erst danach** `superpowers` deinstallieren, Claude Code neu starten,
      prüfen dass `superpowers:*` verschwunden ist
      *(Zwischenstand: in `settings.json` auf `false` gesetzt, aber noch nicht
      deinstalliert — bleibt als Vergleichsstand liegen, bis die Testläufe
      durch sind)*

Zum Neustart: laut Doku greifen `SKILL.md`-Änderungen sofort, Änderungen an
anderen Plugin-Bestandteilen erst nach `/reload-plugins` oder Neustart. Und der
Plugin-Cache hinkt erfahrungsgemäß hinter `origin` her — nach der
Deinstallation gegenprüfen statt annehmen.

---

## Risiken

**Verwässerung beim Redigieren.** Bei 8.630 Zeilen Durchsicht ist die Versuchung
groß, die harten Formulierungen zu glätten. Genau sie tragen die Wirkung.
Deshalb steht `writing-skills` mit `persuasion-principles.md` in Phase 2 und
nicht am Ende.

**Kopplungen, die beim Teil-Vendoring brechen.** `writing-plans` erzeugt
`Global Constraints`, SDD konsumiert sie. `writing-specs` legt den Themen-Slug
fest, alle nachgelagerten Skills verlassen sich darauf. Drei Einstiege hängen an
`writing-specs`. SDD erreicht den Reviewer über einen relativen Dateipfad in
`code-review`. Diese Skills lassen sich nicht einzeln migrieren — Phase 4 ist
eine Einheit, und die Reihenfolge 3 → 4 → 6 → 7 ist nicht beliebig.

**Kein Upstream mehr.** Prompt-Fixes gegen beobachtete Failure Modes fließen
nicht mehr automatisch zu. Der Sprung von 5.0.7 auf 6.2.0 zeigt, worum es geht:
SDD wuchs von 477 auf 1.063 Zeilen und bekam Ledger, Fix-Loop-Breaker und
scoped Re-Review — Mechanik, die aus beobachteten Ausfällen entstanden ist.

Wer das nachziehen will, diffe **nicht** gegen die eigenen Dateien — die sind
bewusst divergiert, der Diff bestünde fast nur aus dem eigenen Umbau. Verglichen
wird upstream gegen upstream:

```bash
# einmalig, in einem beliebigen Scratch-Verzeichnis:
git clone https://github.com/obra/superpowers && cd superpowers
git fetch --tags

# später, wenn es eine neue Version gibt:
git diff v6.2.0..v7.0.0 -- skills/subagent-driven-development/
```

Die eigenen Dateien kommen darin nicht vor. Man liest die Änderungsliste, sucht
sich aus, was einen Failure Mode adressiert, und überträgt es von Hand. Kein
Remote im eigenen Repo, kein Merge, keine gemeinsame History nötig.

Noch billiger als Einstieg: `RELEASE-NOTES.md` und `CHANGELOG.md` des Upstream
lesen — sie benennen die Änderungen, ohne dass man einen Diff braucht.

Deshalb steht der exakte Ausgangsstand (`6.2.0`, Commit `eccd4530`) in
`plugin/NOTICE.md`: ohne ihn ist später nicht mehr feststellbar, ab wo zu
vergleichen wäre. **Das ist optional.** Der ganze Zweck dieses Vorhabens war,
den Nachzieh-Zwang loszuwerden — Einfrieren ist eine gültige Entscheidung,
keine Nachlässigkeit.

**Der Squash kostet die feine History.** Sobald der Feature-Branch gelöscht
ist, sind die Task-Commits weg. Eine spätere Regression lässt sich dann nicht
mehr per `git bisect` auf einen einzelnen Task eingrenzen — man landet auf
einem Commit, der das ganze Vorhaben enthält. Das ist der bewusst gezahlte
Preis für die aufgeräumte History; wo er zu hoch ist, ist Option 2 (PR) der
Ausweg, weil dort die Einzelcommits erhalten bleiben, bis die Forge selbst
squasht.

**Das Review-Gate kann als Bremse empfunden werden.** Es hängt vor jedem
Landen, auch bei einer Zwei-Zeilen-Korrektur. Der SHA-Abgleich federt nur den
SDD-Fall ab; wer von Hand committet und mergen will, bekommt jedes Mal einen
Reviewer-Dispatch. Fällt das im Alltag zur Last, ist die richtige Antwort
nicht, das Gate zu entschärfen, sondern kleine Korrekturen gar nicht erst
über `finishing-a-development-branch` zu schicken.

**Windows und Laufzeitabhängigkeiten.** Fünf Bash-Skripte (drei für SDD mit
`awk`, zwei für den Companion-Server) müssen unter Git Bash laufen. Der
Companion braucht Node — nur Built-ins, keine npm-Installation, und das
HTML-Template zieht nichts aus dem Netz. `render-graphs.js` dagegen braucht ein
systemweit installiertes Graphviz (`dot`); fehlt das, ist die Datei zwar
harmlos, aber unbenutzbar. Alles vor dem produktiven Einsatz einmal prüfen.

**Der Companion ist der am wenigsten erprobte Teil.** 1.730 Zeilen, davon ein
723-Zeilen-Server mit eigenem Session-, Port- und Token-Handling — der einzige
übernommene Bestandteil, der ein laufender Prozess ist statt Text. Er sollte
isoliert getestet werden, bevor er in einem echten Brainstorming hängt.

**Die tägliche Gewohnheit ändert sich bei genau einem Skill.** `brainstorming`
feuert heute von selbst, wenn du „lass uns X bauen" sagst — danach musst du
`/smax:brainstorming` tippen. `debugging` bleibt automatisch. Das ist gewollt,
aber es ist die spürbarste Alltagsänderung des Vorhabens.
