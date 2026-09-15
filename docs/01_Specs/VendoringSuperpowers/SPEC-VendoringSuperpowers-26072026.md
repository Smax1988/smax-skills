# Vendoring von `superpowers` nach `smax` — Spezifikation

**Erstellt:** 26.07.2026

> **Hinweis zur Entstehung:** Diese Spec wurde **nach** dem Implementierungsplan
> geschrieben (`docs/02_Plans/VendoringSuperpowers/PLAN-VendoringSuperpowers-26072026.md`),
> nicht davor. Sie hebt die Entscheidungen aus dem Plan auf die Anforderungsebene
> und gibt ihnen Nummern, auf die sich der Plan und spätere Änderungen berufen
> können. Umgekehrt gilt: Wo Spec und Plan sich widersprechen, **gewinnt die
> Spec** — sie ist ab jetzt die Referenz.

---

## 1. Problem

Das Plugin `superpowers` bringt eine erprobte Kette aus Brainstorming, Spec,
Plan, subagentengetriebener Umsetzung und Review mit. Genutzt wird davon ein
Teil — mitgeliefert wird alles.

Der konkrete Schmerz ist der SessionStart-Hook mit dem Skill
`using-superpowers` und dessen 1%-Regel (*„If you think there is even a 1%
chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke
the skill"*). Sie liegt in **jeder** Session im Kontext und lässt Skills in
Situationen anspringen, in denen sie nur stören. Das ist keine
Fehlkonfiguration, sondern die ausdrückliche Absicht des Upstream-Autors — es
lässt sich also nicht wegkonfigurieren, nur ablösen.

Dazu kommt: Das eigene Skill `domain-modeling` steht neben der Kette statt in
ihr, und die eigene Doku-Konvention (`docs/00_Analysis/`, `01_Specs/`,
`02_Plans/`, `03_DbChanges/`) wird von superpowers nicht bedient — es schreibt
nach `docs/superpowers/specs/` und `docs/superpowers/plans/`.

## 2. Ziel

Die genutzten Ketten laufen als eigene Skills im Namensraum `smax`, mit
integriertem `domain-modeling`, eigener Doku-Konvention und eigener
Git-Konvention. Das Plugin `superpowers` ist danach deinstalliert und nichts
im Repo verweist mehr darauf.

## 3. Abgrenzung

**Es ist ein einmaliges Kopieren mit Anpassung beim Kopieren.** Danach steht
der Code im eigenen Repo und gehört ihm.

- **Kein Git-Fork.** Kein Remote, keine gemeinsame History, kein Merge-Pfad,
  keine Verpflichtung, Upstream nachzuziehen.
- **Kein Neubau von Null.** Der erprobte Wortlaut wird übernommen statt neu
  erfunden.
- **Keine Plugin-Abhängigkeit.** Nach Abschluss ist `superpowers`
  deinstalliert.

**Quelle:** `superpowers` 6.2.0, Commit `eccd45305a06aacccbd1d96f384b30e626a25ca0`,
MIT-Lizenz, © 2025 Jesse Vincent, <https://github.com/obra/superpowers>

---

## 4. Anforderungen

### A — Invocation-Modell

**A1.** Es wird **kein** SessionStart-Hook übernommen. Das ist der Kern des
Vorhabens; ein Hook, der Skill-Nutzung erzwingt, reproduziert genau das
Problem aus Abschnitt 1.

**A2.** Wo Automatik erwünscht ist, entsteht sie über eine **enge
Description** — nicht über eine Dauerinstruktion im Kontext.

**A3.** `disable-model-invocation: true` entfernt nur die Fähigkeit eines
Skills, sich selbst zu starten. **Jedes** Skill bleibt per `/smax:<name>`
aufrufbar. Die Frage bei jedem Skill lautet deshalb nicht „User oder Modell",
sondern „darf es sich selbst starten".

**A4.** Die Flag sperrt auf **Tool-Ebene**, nicht nur in der Anzeige —
empirisch bestätigt:

```
Skill smax:commitMessage cannot be used with Skill tool
due to disable-model-invocation
```

Es gibt keinen separaten Skill-zu-Skill-Kanal; jede Weitergabe läuft über das
Modell. Ein Skill mit der Flag ist damit von **keinem** anderen Skill aus
erreichbar. (Der Beleg stammt aus einem Aufruf gegen die damals noch gesetzte
Flag von `commitMessage` — siehe F5; nachstellen lässt er sich heute mit
`sharpen-me`.)

**A5.** Skills, die sich **nicht** selbst starten dürfen:
`brainstorming`, `sharpen-me`, `sharpen-with-docs`.

**A6.** Skills, die sich selbst starten dürfen: `debugging`, `writing-specs`,
`writing-plans`, `subagent-driven-development`, `executing-plans`,
`finishing-a-development-branch`, `test-driven-development`,
`verification-before-completion`, `using-git-worktrees`,
`dispatching-parallel-agents`, `commitMessage`, `sharpen`.

**A7.** Ein Skill, das eine Datei eines anderen Skills braucht, referenziert
sie per **relativem Dateipfad**, nicht per Skill-Aufruf. Das ist unabhängig
von jeder Flag und die einzige Kopplungsart, die A4 nicht bricht.

### B — Doku-Konvention

**B1.** Zielstruktur:

```
docs/
├── 00_Analysis/<Thema>/ANALYSIS-<Thema>-DDMMYYYY.md
├── 01_Specs/<Thema>/SPEC-<Thema>-DDMMYYYY.md
├── 02_Plans/<Thema>/PLAN-<Thema>-DDMMYYYY.md
├── 03_DbChanges/<Thema>/DDMMYYYY-<Thema>.forward.sql
│                       DDMMYYYY-<Thema>.rollback.sql
└── decisions/            ← von domain-modeling
```

**B2.** Der **Themen-Slug** ist PascalCase, wird einmal in `writing-specs`
festgelegt und über alle Ordner hinweg unverändert übernommen. Nachgelagerte
Skills bilden **keinen** eigenen Dateinamen.

**B3.** Das Datum steht bei `ANALYSIS-`, `SPEC-` und `PLAN-` als **Suffix**
(`-DDMMYYYY`), bei den SQL-Skripten als **Präfix** (bestehende Konvention).

**B4.** Das Datumssuffix ist funktional notwendig, nicht kosmetisch:
`sdd-workspace` leitet das Arbeitsverzeichnis aus dem Plan-Dateinamen ab
(`.smax/sdd/<plan-basename>/`). Ohne Datum wäre der Pfad für jedes Vorhaben
zum selben Thema derselbe — ein abgebrochener Lauf hinterließe sein Ledger,
ein späterer Anlauf läse `Task 1..5: complete` und **überspränge diese
Tasks**. Genau der Ausfall, gegen den SDDs Ledger gebaut wurde.

**B5.** Restrisiko zu B4: Zwei Pläne zum selben Thema **am selben Tag**
kollidieren weiterhin. Beim Neuschreiben eines Plans am Erstellungstag ist der
Workspace vorher zu löschen.

**B6.** Jede erzeugte `ANALYSIS-`, `SPEC-` und `PLAN-`-Datei trägt das Datum
zusätzlich als zweite Zeile (`**Erstellt:** DD.MM.YYYY`). Die Redundanz zum
Dateinamen ist beabsichtigt: der Dateiname überlebt kein Kopieren in ein
anderes System, die Zeile im Dokument schon. Gesetzt beim Anlegen, bei
Überarbeitungen unverändert.

**B7.** Die Weiche zwischen ANALYSIS und SPEC entscheidet `writing-specs` und
**nennt Wahl und Zielpfad, bevor es schreibt**:

- Untersuchung oder Bewertung von Bestehendem, ohne Entscheidung etwas zu
  bauen → `00_Analysis/`
- Entwurf von etwas, das gebaut werden soll → `01_Specs/`

**B8.** Existiert der Themenordner bereits, wird das **angesagt und gefragt** —
fortschreiben oder neues Dokument? Das Datumssuffix verhindert das
Überschreiben, aber die inhaltliche Frage bleibt offen: eine zweite Fassung
ist etwas anderes als eine Fortschreibung. Gilt für `writing-specs` und
`writing-plans`.

**B9.** `Archive/` wird **nie** beschrieben und **nie** als aktueller
Projektkontext gelesen. Archivierung bleibt Handarbeit und wird in keinem
Skill abgebildet. Kritischste Stelle: `brainstorming` Schritt 1 („Explore
project context") — dort würde sonst eine archivierte Spec als gültig
eingelesen.

**B10.** Erkennt `writing-plans` Schema-Änderungen, spezifiziert es Forward-
und Rollback-Skript als Task-Schritte mit exaktem Pfad und vollständigem
Inhalt. Geschrieben werden sie vom Implementer. **Das Datum der SQL-Dateien
ist das Schreibdatum**, nicht das Planungsdatum — der Plan kann es nicht
vorwegnehmen und spezifiziert nur das Namensschema.

### C — Integration von `domain-modeling`

**C1.** `domain-modeling` wird an fünf Stellen eingesetzt, die 6.2.0 von sich
aus anbietet — nicht vorne drangeklebt:

| # | Ort | Inhalt |
|---|---|---|
| 1 | `brainstorming` Schritt 1 | `CONTEXT.md` / `CONTEXT-MAP.md` gehören zum „Explore project context" |
| 2 | `brainstorming`, neuer Punkt zwischen 3 und 5 | Aktives Modellieren während der Fragen; auch als Knoten im `dot`-Graph |
| 3 | `writing-specs` | Abschnitt „Ubiquitous Language" mit Verweis auf `CONTEXT.md` statt Duplikat |
| 4 | `writing-plans` → `Global Constraints` | *Terminologie ist in `CONTEXT.md` definiert; Abweichung ist ein Defekt* |
| 5 | `code-review/code-reviewer.md` | Stimmt die Benennung mit `CONTEXT.md` überein? Fehlen eingeführte Begriffe im Glossar? |

**C2.** Andockpunkt 4 ist der wirksamste Hebel: SDD reicht den Block `Global
Constraints` laut `task-reviewer-prompt.md` wörtlich an **jeden**
Task-Reviewer weiter. Die Terminologie-Bindung trägt damit ohne weitere
Änderung bis in jede einzelne Review.

**C3.** Der `implementer-prompt` von SDD erhält den relevanten
`CONTEXT.md`-Auszug in den Dispatch-Kontext.

**C4.** Die fünf Andockpunkte decken die Kette ab, aber **nicht**, was
außerhalb passiert („bau schnell den Endpunkt", „fix das") — genau dort
entstehen die abweichenden Namen. Geschlossen wird das über die
Projekt-`CLAUDE.md`, die in jeder Session geladen wird und Compaction
überlebt.

**C5.** Der Anspruch ist **beidseitig** und deckt drei Fälle ab, die leicht
zusammenfallen:

- **Ausgabe:** kanonische Begriffe verwenden — in Gespräch, Code, Bezeichnern,
  Commits, Doku.
- **Eingabe:** die unter `_Avoid_` gelisteten Varianten still übersetzen und
  kanonisch antworten. Die `_Avoid_`-Liste ist eine **Übersetzungstabelle**,
  keine Verbotsliste. Nicht bei jeder Nennung korrigieren — das gehört in eine
  Modellierungssitzung, nicht in die Alltagsarbeit.
- **Lücke:** Bei einem Begriff, der weder kanonisch noch unter `_Avoid_`
  steht, **nicht raten** — sagen, dass er fehlt, und nachfragen.

**C6.** Der `@`-Import macht das Glossar *bekannt*, die Absätze machen es
*wirksam*. Beides bleibt Kontext. Der einzige harte Zwang liegt im
`code-reviewer` — er greift bei Code, nicht im Gespräch.

**C7.** `domain-modeling` verdrahtet C4–C6 **selbst**, statt es der Handarbeit
zu überlassen. Es prüft: Existiert ein Glossar? Ist es in `./CLAUDE.md`
**oder** `./.claude/CLAUDE.md` eingebunden? Wenn nicht: Import und
Verbindlichkeitsabsatz ergänzen und die Änderung ansagen.

**C8.** Die Prüfung aus C7 läuft an **zwei** Stellen: beim Start des Skills
**und** unmittelbar nachdem lazy ein neues `CONTEXT.md` angelegt wurde. Ohne
den zweiten Punkt bleibt jedes frisch entstandene Glossar dauerhaft
uneingebunden — der häufigste Fall, denn der Skill legt die Datei erst an,
wenn der erste Begriff feststeht.

**C9.** Randfälle, die abgedeckt sein müssen:

- Keine `CLAUDE.md` vorhanden → `./CLAUDE.md` anlegen und ansagen. Die Datei
  ist committet und team-geteilt; das Anlegen ist keine stille Nebenwirkung.
- `CONTEXT-MAP.md` vorhanden → **nur die Map** importieren, nicht jedes
  einzelne `CONTEXT.md`. Alles zu importieren sprengt den Kontext.
- Import anders geschrieben (`@./CONTEXT.md`, absoluter Pfad) → auf eine
  **Referenz** prüfen, nicht auf exakte Zeichenfolge. Sonst Doppel-Importe.
- Import da, Verbindlichkeitsabsatz fehlt → nur den Absatz ergänzen.
- Ein in Backticks stehendes `` `@CONTEXT.md` `` ist **kein** Import — beim
  Prüfen wie beim Schreiben zu beachten.

### D — Einstiegs-Architektur

**D1.** Drei Skills führen in die Kette: `brainstorming`, `sharpen-me`,
`sharpen-with-docs`. Was **nach** dem Gespräch passiert, ist bei allen
identisch. Dreimal gepflegt driften diese ~40 Zeilen auseinander.

**D2.** Delegieren an `brainstorming` scheidet aus — es trägt die Flag (A5)
und ist nach A4 von keinem Skill aus startbar.

**D3.** Der gemeinsame Teil wird deshalb als eigenes Skill `writing-specs`
herausgezogen, **ohne** Flag, damit alle drei Einstiege es erreichen:

```
brainstorming        ─┐
sharpen-me           ─┼─► writing-specs ─► writing-plans ─► SDD
sharpen-with-docs    ─┘
```

**D4.** Jeder Einstieg enthält nur noch das Unterscheidende:

| Skill | Gesprächsführung | domain-modeling |
|---|---|---|
| `brainstorming` | Klärungsfragen, dann Design in Abschnitten | ja |
| `sharpen-me` | schonungsloses Interview, ganzer Entscheidungsbaum | nein |
| `sharpen-with-docs` | schonungsloses Interview | ja |

**D5.** Der Übergang ist eine **Frage, keine Automatik**. Jeder Einstieg endet
mit der ausdrücklichen Frage, ob aus dem Ergebnis ein Dokument werden soll.
Bei „nein" endet die Sitzung ohne Datei — **ein gültiger Ausgang, kein
Abbruch**. Besonders `sharpen-me` wird oft nur als Denkwerkzeug benutzt.

**D6.** Der Terminal-State-Satz aus 6.2.0 (*„The ONLY skill you invoke after
brainstorming is writing-plans"*) wird ersetzt: einziger *Nachfolger* ist
`writing-specs`, der Weg dorthin ist optional, und `domain-modeling` darf
begleitend laufen.

**D7.** `sharpen` selbst bekommt den gemeinsamen Teil **nicht** und bleibt
unverändert model-invocable. Der Basis-Skill bleibt dokumentfrei — sonst wird
aus jedem beiläufigen „hinterfrag das mal" eine Spec-Datei samt
Reviewer-Dispatch. (Setzte man dort die Flag, brächen `sharpen-me` und
`sharpen-with-docs`, die beide `sharpen` aufrufen.)

### E — Dokument-Reviews

**E1.** Spec/Analysis **und** Plan werden nach dem Schreiben **automatisch**
von einem frischen `general-purpose`-Subagenten geprüft. Grundlage sind die
beiden in 6.2.0 verwaisten Templates `spec-document-reviewer-prompt.md` und
`plan-document-reviewer-prompt.md`.

**E2.** Das ersetzt die bestehende Selbstprüfung nicht, es **folgt** ihr:

1. **Inline-Selbstprüfung** — Placeholder, Widersprüche, Scope, Ambiguität.
   Billig, fängt das Offensichtliche.
2. **Dispatch des Dokument-Reviewers** — frische Augen ohne Autorenblindheit.
   Das ist der eigentliche Gewinn: das schreibende Modell sieht seine eigenen
   Lücken nicht.
3. **`Issues` inline beheben.** `Recommendations` sind laut Template
   ausdrücklich advisory und blockieren nicht.
4. **Genau ein Re-Review.** Kommt danach immer noch `Issues Found`, wird
   nicht weitergeschleift, sondern Befund und Dokument dem Nutzer vorgelegt.

**E3.** Der Satz aus `writing-plans` — *„This is a checklist you run yourself
— not a subagent dispatch."* — wird gestrichen.

**E4.** Erst nach E2 folgt in `writing-specs` das User-Review-Gate. Der Nutzer
bekommt ein bereits geprüftes Dokument, keinen Rohentwurf.

**E5.** Die Inline-Selbstprüfung wandert aus `brainstorming` nach
`writing-specs` — sie gehört zum Schreiben des Dokuments, nicht zum Gespräch.

### F — Git-Konvention

**F1.** Die History soll am Ende aus **einem** Commit bestehen. Erreicht wird
das durch **Squash beim Landen**, nicht durch Commit-Verzicht während der
Arbeit.

**F2.** Die Task-Commits (ein Commit pro Task) **bleiben**. Sie zu streichen
zerlegt SDD:

- `scripts/review-package PLAN BASE HEAD` verifiziert beide Enden per
  `git rev-parse --verify` und erzeugt `git diff BASE..HEAD`. Ohne
  Task-Commit ist der Range leer und der Task-Reviewer prüft nichts.
- Der Ledger ist laut SDD die Recovery-Map: *„the commits it names exist in
  git even when your context no longer remembers creating them."* Ohne SHAs
  bleibt nach einer Compaction kein Beweis, was fertig ist.
- SDD reviewt **nach jedem Task**, um Fehler früh zu stoppen: Task 5 baut auf
  Task 3 auf. Ein Reviewer ohne abgrenzbaren Diff sähe bei Task 5 kumulativ
  alles von Task 1–5 und meldete Befunde zu Code, den ein früherer Reviewer
  schon durchgewunken hat.

**F3.** Die Task-Commits leben nur auf dem Feature-Branch, der nach dem Squash
gelöscht wird. Der Ablauf:

```bash
git switch <base-branch>
git pull
git merge --squash <feature-branch>   # staged nur, committet nicht
<test command>                        # rot ⇒ git reset --hard, Branch bleibt
git commit -m "<message>"
git branch -D <feature-branch>
```

**F4.** Zwei Fallstricke, die im Skilltext stehen müssen:

- **Getestet wird vor dem Commit.** `--squash` stellt Index und Working Tree
  her, ohne zu committen. Bei Rot macht `git reset --hard` den Base-Branch
  sauber — kein Rücknahme-Commit nötig.
- **`git branch -d` schlägt nach einem Squash fehl.** Der Squash erzeugt
  keinen Merge-Commit mit zweitem Parent; aus Gits Sicht ist der Branch nicht
  gemergt. Es muss `-D` sein — **mit Begründung im Text**, sonst liest sich
  das wie Schludrigkeit und wird beim nächsten Redigieren „korrigiert".

**F5.** Die Squash-Message kommt aus `smax:commitMessage`. Dessen
`disable-model-invocation: true` ist dafür entfernt worden; die Description
wurde auf Trigger-Form umgestellt, weil sie ohne die Flag vom Anzeigetext zum
Trigger wird. Nebenwirkung, bewusst in Kauf genommen: das Skill springt jetzt
auch bei einem beiläufigen „commite das" an — für ein Skill, dessen einziger
Zweck eine gute Commit-Message ist, ist das erwünscht.

**F6.** Eine Message für einen ganzen Feature-Branch ist eine andere Gattung
als eine für eine einzelne Änderung. `commitMessage` kennt heute nur die
konzise erste Zeile; für den Squash-Fall braucht es zusätzlich einen Body, der
die Tasks des Plans auflistet.

**F7.** Die Branch-Logik von 6.2.0 wird **unverändert** übernommen:
`using-git-worktrees` legt die Worktree mit `git worktree add -b` an, der
Branch entsteht dabei. Step 0 mit Isolationserkennung, Submodul-Guard,
Consent-Frage und `check-ignore`-Sicherung bleibt wie er ist.

**F8.** Eine einzige Lücke wird geschlossen: Lehnt der Nutzer die Worktree ab,
sagt 6.2.0 *„work in place and skip to Step 2"* — dann wird auf dem aktuellen
Branch gearbeitet, notfalls `main`. SDD und `executing-plans` haben dagegen
nur eine Rückfrage, keinen Mechanismus. Im Ablehnungszweig gilt deshalb: steht
der Nutzer auf dem Default-Branch, wird ein Feature-Branch per `git switch -c`
vorgeschlagen und nach Zustimmung angelegt. Auf einem anderen Branch wird ohne
Nachfrage in place gearbeitet.

**F9.** Der finale Code-Review ist **blockierend**, nicht angeboten. In 6.2.0
reviewt nur einer von drei Pfaden:

| Pfad | Finaler Review in 6.2.0 |
|---|---|
| `subagent-driven-development` | ja |
| `executing-plans` | **nein** — geht direkt zu `finishing-a-development-branch` |
| Plan von Hand abgearbeitet | **nein** — `writing-plans` schreibt keinen Review-Task ins Dokument |

**F10.** Das Gate wird deshalb in `finishing-a-development-branch` verankert,
als Schritt **vor** dem Optionsmenü — der einzige Ort, an dem alle drei Pfade
vorbeikommen. Es prüft, ob für den Stand ein Code-Review vorliegt; wenn nicht,
wird `code-reviewer.md` dispatcht und `Issues` werden behoben, bevor das Menü
erscheint.

**F11.** Doppelte Reviews werden über den **HEAD-SHA** vermieden, nicht über
eine Behauptung im Gesprächsverlauf. SDDs finaler Reviewer schreibt dazu
`Final review: clean (HEAD <sha7>)` in den Ledger. Ohne diese Zeile reviewt
das Gate jeden SDD-Lauf doppelt.

**F12.** `writing-plans` schreibt in jeden erzeugten Plan einen abschließenden
Code-Review-Abschnitt — nicht als Task mit Steps, sondern als
Abschlussbedingung, damit auch ein von Hand abgearbeiteter Plan das Gate
nennt.

### G — Namensraum und Pfade

**G1.** Alle Skill-Referenzen lauten `smax:<name>`. Nach Abschluss muss
`grep -rn "superpowers" plugin/` **leer** sein.

**G2.** Alle Laufzeitpfade lauten `.smax/` statt `.superpowers/` — betroffen
sind der SDD-Workspace (7 Stellen) und die Companion-Sessions (10 Stellen).
Andernfalls legt das Plugin in fremden Repos Verzeichnisse namens
`.superpowers` an.

**G3.** Cross-Skill-**Datei**referenzen sind gesondert zu prüfen. Der
`superpowers:`-Grep findet sie nicht, weil das Wort darin nicht vorkommt:
`../requesting-code-review/code-reviewer.md` → `../code-review/code-reviewer.md`.
Zusätzliche Prüfung:
`grep -rn "requesting-code-review\|receiving-code-review" plugin/`

**G4.** `plugin/.claude-plugin/plugin.json` bleibt unverändert. `./skills/dev`
und `./skills/personal` lösen sich gegen den Plugin-Root auf; alle neuen
Skills gehen nach `plugin/skills/dev/`.

**G5.** Der Repo-Root ist reiner Marketplace. Alles außerhalb von `plugin/` —
insbesondere `docs/` — wird nicht ausgeliefert. Deshalb gehört auch
`NOTICE.md` nach `plugin/`.

**G6.** **Laufzeitverzeichnisse ignorieren sich selbst.** Jedes Verzeichnis,
das ein Skill zur Laufzeit unter `.smax/` anlegt, schreibt beim Anlegen ein
`.gitignore` mit `*` in seinen Wurzelordner. Das `.gitignore` des
Nutzer-Repos wird **nicht** angefasst.

Begründung: Die Skills laufen in fremden Repos. Eine Regel im `.gitignore`
dieses Repos schützt niemanden dort. SDD macht es bereits richtig —
`sdd-workspace` schreibt `printf '*\n' > "$base/.gitignore"`, ausdrücklich um
*„keep every plan's workspace out of `git status` … without modifying any
tracked file"*. Der Visual Companion macht es **nicht** und verlässt sich
stattdessen auf die Zeile *„Remind the user to add `.superpowers/` to
`.gitignore`"* — eine Erinnerung, die das Modell aussprechen kann oder auch
nicht. Sie wird durch den Mechanismus ersetzt.

**G7.** Aus G6 folgt: Dieses Repo braucht **keinen** `.smax/`-Eintrag im
`.gitignore`. Die Regel `docs/superpowers/` wird entfernt, weil der Ordner
gelöscht ist und sie ins Leere zeigt.

### H — Lizenz

**H1.** Die MIT-Lizenz erlaubt das Vendoring ausdrücklich. Auflage ist allein,
Copyright- und Lizenztext mitzuführen.

**H2.** `plugin/NOTICE.md` enthält: MIT-Lizenztext, © 2025 Jesse Vincent,
Quellversion `superpowers 6.2.0`, Commit
`eccd45305a06aacccbd1d96f384b30e626a25ca0`, Repo-URL und die Liste der
abgeleiteten Dateien.

**H3.** Der Commit-Hash ist der **einzige** spätere Ankerpunkt für einen
Upstream-Vergleich — der Plugin-Cache verschwindet mit der Deinstallation.

**H4.** `anthropic-best-practices.md` ist eine eingefrorene Kopie externer
Dokumentation und wird als solche gesondert gekennzeichnet.

### I — Plattform

**I1.** Fünf Bash-Skripte (drei für SDD mit `awk`, zwei für den
Companion-Server) müssen unter **Git Bash auf Windows** laufen —
`set -euo pipefail` inklusive.

**I2.** Der Companion braucht Node, aber **nur Built-ins** (`crypto`, `http`,
`fs`, `path`, `os`, `child_process`) — keine npm-Installation. Das
HTML-Template zieht nichts aus dem Netz und läuft offline.

**I3.** `render-graphs.js` braucht ein **systemweit installiertes Graphviz**
(`dot`). Fehlt es, ist die Datei harmlos, aber unbenutzbar.

---

## 5. Nicht im Umfang

| Ausgeschlossen | Zeilen | Grund |
|---|---:|---|
| `using-superpowers` + SessionStart-Hook | ~200 | Ist die Ursache des Problems aus Abschnitt 1 |
| `CREATION-LOG.md`, `test-pressure-*.md`, `test-academic.md` | 328 | Entwicklungsartefakte des Upstream-Autors |
| `examples/CLAUDE_MD_TESTING.md` | 189 | Experiment gegen ein abgelöstes Skill-System |
| `commands/`, `tests/`, Plattform-Manifeste (`.codex-plugin` etc.) | — | Nicht anwendbar |
| Archivierungslogik | — | Archivierung bleibt Handarbeit (B9) |

---

## 6. Offene Entscheidungen

**O1.** `writing-skills` — mit oder ohne `disable-model-invocation`? Ohne Flag
würde es bei jeder Skill-Datei triggern, auch beim bloßen Lesen. Neigung:
ohne Flag, weil die Description eng genug ist.

**O2.** `code-review` — mit oder ohne Flag? Durch das Gate (F10) ist die Frage
entschärft: SDD und `finishing-a-development-branch` erreichen den Reviewer
über die Datei (A7), die Flag ist für die Kette folgenlos. Damit fällt das
Argument „nützlich vor einem Merge" weg — der Merge-Fall ist fest verdrahtet.
Übrig bleibt nur das Anspringen bei Zwischenständen. Neigung deshalb:
**mit** Flag, per `/smax:code-review` bleibt es jederzeit greifbar.

---

## 7. Konsequenzen und Risiken

**R1 — Verwässerung beim Redigieren.** Bei ~8.500 Zeilen Durchsicht ist die
Versuchung groß, die harten Formulierungen zu glätten. Genau sie tragen die
Wirkung. `writing-skills` mit `persuasion-principles.md` muss deshalb **vor**
den Übernahmen mit Anti-Rationalisierungs-Passagen gelesen werden.

**R2 — Kopplungen, die beim Teil-Vendoring brechen.** `writing-plans` erzeugt
`Global Constraints`, SDD konsumiert sie. `writing-specs` legt den Themen-Slug
fest, alle nachgelagerten Skills verlassen sich darauf. Drei Einstiege hängen
an `writing-specs`. SDD erreicht den Reviewer über einen relativen Dateipfad.
Diese Skills lassen sich **nicht einzeln** migrieren.

**R3 — Kein Upstream mehr.** Prompt-Fixes gegen beobachtete Failure Modes
fließen nicht mehr automatisch zu. Der Sprung von 5.0.7 auf 6.2.0 zeigt, worum
es geht: SDD wuchs von 477 auf 1.063 Zeilen und bekam Ledger,
Fix-Loop-Breaker und scoped Re-Review — Mechanik aus beobachteten Ausfällen.

Wer nachziehen will, diffe **nicht** gegen die eigenen Dateien — die sind
bewusst divergiert. Verglichen wird upstream gegen upstream
(`git diff v6.2.0..v7.0.0 -- skills/...` in einem Scratch-Clone), oder noch
billiger: die `RELEASE-NOTES.md` des Upstream lesen. **Das ist optional** —
der Zweck des Vorhabens war, den Nachzieh-Zwang loszuwerden. Einfrieren ist
eine gültige Entscheidung, keine Nachlässigkeit.

**R4 — Der Squash kostet die feine History.** Sobald der Feature-Branch
gelöscht ist, sind die Task-Commits weg. Eine spätere Regression lässt sich
nicht mehr per `git bisect` auf einen einzelnen Task eingrenzen. Bewusst
gezahlter Preis; wo er zu hoch ist, ist der PR-Weg der Ausweg — dort bleiben
die Einzelcommits erhalten, bis die Forge selbst squasht.

**R5 — Das Review-Gate kann bremsen.** Es hängt vor jedem Landen, auch bei
einer Zwei-Zeilen-Korrektur. Der SHA-Abgleich (F11) federt nur den SDD-Fall
ab. Fällt das zur Last, ist die richtige Antwort **nicht**, das Gate zu
entschärfen, sondern kleine Korrekturen gar nicht erst über
`finishing-a-development-branch` zu schicken.

**R6 — Der Companion ist der am wenigsten erprobte Teil.** 1.730 Zeilen, davon
ein 723-Zeilen-Server mit eigenem Session-, Port- und Token-Handling — der
einzige übernommene Bestandteil, der ein laufender Prozess ist statt Text. Er
ist isoliert zu testen, bevor er in einem echten Brainstorming hängt.

**R7 — Die tägliche Gewohnheit ändert sich bei genau einem Skill.**
`brainstorming` feuert heute von selbst bei „lass uns X bauen" — danach ist
`/smax:brainstorming` zu tippen. `debugging` bleibt automatisch. Gewollt, aber
die spürbarste Alltagsänderung.

---

## 8. Abnahmekriterien

**AK1.** `grep -rn "superpowers" plugin/` ist leer (G1, G2).

**AK2.** `grep -rn "requesting-code-review\|receiving-code-review" plugin/`
ist leer (G3).

**AK3.** Ende-zu-Ende in einem Wegwerf-Repo: `/smax:brainstorming` →
Abschlussfrage → `writing-specs` → Spec unter `01_Specs/` samt `CONTEXT.md`
im selben Commit → Reviewer-Dispatch → User-Gate → `writing-plans` propagiert
selbstständig → Plan unter `02_Plans/` → SDD mit Ledger unter `.smax/sdd/` →
`finishing-a-development-branch`.

**AK4.** Am Ende von AK3: Feature-Branch existiert · Task-Commits liegen
darauf · das Gate hat den bereits geprüften HEAD erkannt und **nicht** doppelt
reviewt · nach dem Landen steht auf dem Base-Branch **genau ein** Commit ·
der Feature-Branch ist weg.

**AK5.** Zweiter Durchlauf über `/smax:sharpen-with-docs` konvergiert auf
`writing-specs` (D3). Einmal mit „nein" auf die Abschlussfrage: die Sitzung
endet sauber ohne Datei (D5).

**AK6.** Ablehnungszweig: Worktree-Frage mit „nein" beantworten, während man
auf `main` steht — es muss ein `git switch -c` vorgeschlagen werden (F8).

**AK7.** Ungeprüfter Pfad: `finishing-a-development-branch` direkt aufrufen,
ohne vorherigen Review — das Gate dispatcht den Reviewer, bevor das
Optionsmenü erscheint (F10).

**AK8.** `/smax:code-review` funktioniert eigenständig — es hängt nicht in der
Kette, SDD erreicht den Reviewer über die Dateireferenz.

**AK9.** Die fünf Bash-Skripte laufen unter Git Bash auf Windows (I1);
Companion-Start/-Stop inklusive Browser-Öffnung per `--open` ist geprüft.

**AK10.** Nach einem Companion- und einem SDD-Lauf in einem Wegwerf-Repo ist
`git status` sauber und das `.gitignore` dieses Repos **unverändert** (G6).

**AK11.** **Erst nach AK1–AK10** wird `superpowers` deinstalliert, Claude Code
neu gestartet und geprüft, dass `superpowers:*` verschwunden ist. Laut Doku
greifen `SKILL.md`-Änderungen sofort, Änderungen an anderen
Plugin-Bestandteilen erst nach `/reload-plugins` oder Neustart — und der
Plugin-Cache hinkt erfahrungsgemäß hinter `origin` her.

---

## 9. Verhältnis zum Plan

Der Plan (`docs/02_Plans/VendoringSuperpowers/PLAN-VendoringSuperpowers-26072026.md`)
setzt diese Spec in neun Phasen um. Er enthält die Reihenfolge, die
Zeilenzahlen, die Dateilisten und die Checklisten — diese Spec enthält das
Warum und die Abnahmekriterien.

**Überschneidung ist vorhanden und beabsichtigt:** Der Plan trägt seine
Begründungen weiterhin selbst, damit er beim Umsetzen ohne Sprung in ein
zweites Dokument lesbar bleibt. Driften Spec und Plan auseinander, gilt die
Spec (siehe Hinweis am Dokumentanfang).

**Kein `Ubiquitous Language`-Abschnitt:** Dieses Repo hat noch kein
`CONTEXT.md`. Sobald `domain-modeling` eines anlegt, gehört er nach C1/3
ergänzt.
