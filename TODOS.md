# TODOS

Offene Arbeit an diesem Repo.

**Gruppiert nach Art der Arbeit**, nicht nach Priorität; innerhalb einer Gruppe
steht Dringendes oben. Gruppen kommen und gehen nach Bedarf.

**Alles ist nummeriert** — Gruppe `2`, Eintrag `2.1`, Unterpunkt `2.1.3` — damit
im Gespräch kurz referenziert werden kann. **Nummern werden nie nachgezogen:**
Gestrichenes hinterlässt eine Lücke, Neues bekommt die nächste freie Nummer.
Sonst zeigt jede Referenz aus einer früheren Session ins Leere, und genau das
soll die Nummerierung verhindern.

**Jeder Eintrag muss kalt lesbar sein**: was, warum, und woran man erkennt, dass
es fertig ist. Ein Eintrag, den nur seine Entstehungs-Session versteht, ist
keiner. Steckt eine offene Entscheidung dahinter, gehören die Optionen und der
Stand der Überlegung dazu — nicht nur die Frage.

Erledigtes wird gestrichen, nicht abgehakt — die git-History ist das Archiv.

---

## 1 · Voraussetzungen

### 1.1 · Doku-Struktur über alle Repos vereinheitlichen — Hausaufgabe Smax

Kein Skill-Thema, sondern Handarbeit an den Repos.

Die Basis ist überall dieselbe (`docs/00_Analysis` … `03_DbChanges`, wie in den
Skills beschrieben), aber je Repo mal mehr, mal weniger davon. Dazu kommt der
Multi-Repo-Fall: ein übergeordnetes Verzeichnis mit mehreren Projekten, teils
mit mehreren git-Repos je Projekt, von wo aus repo-übergreifende Aufgaben
laufen (Beispiel: Serverumzug).

Solange das so bleibt, müsste ein Doku-Skill jede Variante einzeln behandeln —
das ist kein Skill mehr, das ist ein Parser. **Erst vereinheitlichen, dann
bauen.**

**Konkret anzusehen:** die drei Kunden-Repos — **hauptsächlich auf einer
anderen Maschine**. Der Ist-Zustand lässt sich von hier aus also nicht
vollständig erheben; der erste Schritt gehört auf die andere Maschine.
`smax:handoff` ist der Weg, das Ergebnis herüberzutragen.

- [ ] **1.1.1** Ist-Zustand je Repo erheben: welche Verzeichnisse existieren,
      welche fehlen, wo weicht die Benennung ab
- [ ] **1.1.2** Zielstruktur festlegen — einschließlich der Frage, was im
      Multi-Repo-Fall auf der obersten Ebene liegt und was je Repo
- [ ] **1.1.3** Repos nachziehen
- [ ] **1.1.4** Ergebnis als Decision festhalten, damit die Struktur danach
      verbindlich ist und nicht wieder auseinanderläuft

---

## 4 · Testdisziplin in der Kette

> 🔺 **Hohe Priorität.** Steht bewusst vor Gruppe 2 und 3, obwohl die Nummer
> höher ist — die Reihenfolge im Dokument sagt hier die Dringlichkeit, die
> Nummer bleibt als Referenz stabil. Grund: Jeder Plan, der vor der Klärung
> ausgeführt wird, zementiert den Ist-Zustand ein Stück weiter.

### 4.1 · Analysieren, wann und wo im Workflow Tests entstehen

**Das ist eine Analyse-Aufgabe, keine beschlossene Änderung.** Am Ende kann
„nichts ändern, festhalten warum" stehen. Was jetzt schon feststeht, ist der
Befund, nicht die Antwort.

**Der Befund.** `test-driven-development` wird von genau zwei Skills
referenziert: `debugging` und `writing-skills` (nachgeprüft am 01.08.2026 per
`grep -rl` über `plugin/skills/`, nicht aus der README-Tabelle abgelesen).
**Kein Skill des Bauwegs ruft ihn** — weder `writing-plans` noch
`executing-plans` noch `subagent-driven-development`.

Das ist der Ast, auf dem er am wenigsten gebraucht wird: Beim Debugging
existiert der Fehlerfall bereits, der Test ist dort Reproduktion. Bei der
Implementierung existiert er noch nicht — dort entscheidet sich, ob überhaupt
einer entsteht.

**Zwei Stellen, die das heute ersatzweise auffangen — und beide nur halb:**

- `writing-plans` backt den RED-GREEN-Zyklus als **Vorlagentext** in jede
  Task-Struktur („Write the failing test" → „Run it to verify it fails" → …).
  Die Schritte stehen da, die Begründung nicht. Der Implementer sieht *dass*,
  nicht *warum* — und genau daran scheitert TDD unter Druck.
- `subagent-driven-development/implementer-prompt.md` sagt in Zeile 48:
  **„Write tests (following TDD if task says to)"**. Die Disziplin ist dort
  ausdrücklich an den Plan delegiert, mit eingebautem Ausweg. Schreibt der Plan
  die Testschritte nicht aus, entfällt sie ersatzlos.

- [ ] **4.1.1 · Den Ist-Zustand vollständig erheben.** Nicht nur „wer ruft
      TDD", sondern: An welchen Stellen der Kette entsteht heute tatsächlich ein
      Test, wodurch ausgelöst, und was passiert, wenn der Plan an der Stelle
      schweigt? Die README-Tabelle *Wer ruft wen* ist dabei **keine** zulässige
      Quelle — sie ist aus den Skill-Dateien abgeleitet, sie gegen sich selbst
      zu prüfen ist ein Zirkel. Gegen die Skill-Dateien prüfen.
      **`grep` allein reicht dort nicht:** Ein Treffer kann in einer Code-Fence
      stehen (Vorlagentext, den ein Skill *ausgibt*) oder in Backticks als
      Stil-Beispiel — beides zählt nicht.
      `docs/decisions/0024-required-markers-count-as-calls.md` entscheidet die
      Grenzfälle und nennt die Stellen namentlich; vor der Erhebung lesen.
      (Der frühere Vermerk „Lücken: `brainstorming` und `sharpen-with-docs`
      fehlen" ist überholt — am 04.08.2026 Zeile für Zeile gegengeprüft, die
      Tabelle stimmt.)
- [ ] **4.1.2 · Beurteilen, ob die Vorlage trägt.** Die ehrliche Gegenfrage
      zuerst: Reicht der Vorlagentext in `writing-plans` in der Praxis? Falls
      ja, ist ein zusätzlicher Aufruf Ballast in einer Kette, die davon reichlich
      hat. Belegen lässt sich das an ausgeführten Plänen — sind dort Tests
      entstanden, und waren sie zuerst rot?
- [ ] **4.1.3 · Erst danach die Optionen abwägen**, falls die Analyse eine
      Lücke zeigt:
      - *Vorlage schärfen* — billigster Eingriff, `writing-plans` trägt die
        Begründung mit, kein neuer Aufruf.
      - *`writing-plans` ruft `test-driven-development`* — die Testschritte
        entstehen aus der Disziplin statt aus der Vorlage.
      - *Der Implementer bekommt ihn im Dispatch* — trifft die Stelle, an der
        Code entsteht, kostet aber Kontext in **jedem** Task. Dann fällt auch
        der Ausweg „if task says to" weg.
- [ ] **4.1.4 · Den Nicht-Code-Fall mitanalysieren.**
      `test-driven-development` und `writing-good-tests.md` sind unverändert aus
      superpowers übernommen und setzen eine Testsuite voraus. Ein Teil der
      Arbeit hier hat keine: Beim Plan für `sync-plugin-docs` ist das Artefakt
      eine `SKILL.md`, und der Testharness — Scratch-Branch, synthetische
      Änderung, One-Shot-Subagent, aufräumen — **musste im Plan selbst erfunden
      werden**, weil kein Skill ihn liefert.
      `writing-skills/testing-skills-with-subagents.md` deckt genau diesen Fall
      ab, wird aber nur von `writing-skills` gerufen. Frage: Gehört der Harness
      dorthin, in `writing-plans`, oder an einen eigenen Ort?
- [ ] **4.1.5 · Ergebnis als Decision festhalten**, auch wenn es „nichts
      ändern" lautet — samt Begründung, warum die anderen Wege verworfen
      wurden. Sonst wird dieselbe Frage in einem halben Jahr neu gestellt.

---

## 2 · Neue Skills

### 2.2 · `tracking-todos` (Arbeitstitel) — die TODO-Systematik in jedes Repo tragen

**Plugin-Skill**, damit sie überall verfügbar ist.

Diese `TODOS.md` und die Pflegeregel in der `CLAUDE.md` sind hier von Hand
entstanden. Beides soll in jedem Repo automatisch funktionieren.

- [ ] **2.2.1 · Der Kern ist nicht der Skill, sondern der `CLAUDE.md`-Block.**
      Ein Skill greift nur, wenn er aufgerufen wird — der Alltagsfall ist die
      Änderung *ohne* Skill-Aufruf. Genau dieselbe Einsicht steht schon in
      `docs/decisions/0015`, dort für die Decisions. Der Skill legt also
      `TODOS.md` lazy an *und* trägt einen Block in die Projekt-`CLAUDE.md`
      ein, der die Pflege zur stehenden Gewohnheit macht. Vorbild ist
      `smax:domain-modeling`: lazy anlegen, `CLAUDE.md` prüfen und ergänzen,
      nie still editieren, Edge Cases (Block vorhanden, anders formuliert,
      veraltete Fassung) behandeln.
- [ ] **2.2.2 · Entscheidung: Name.** Kandidaten: `tracking-todos` (Gerund,
      passt zu `writing-plans`/`using-git-worktrees`) · `todo-list` ·
      `maintain-todos`.
- [ ] **2.2.3 · Entscheidung: eigener Skill oder Anbau an `domain-modeling`?**
      Dagegen spricht, dass `domain-modeling` das Domänenmodell pflegt und
      TODOs damit nichts zu tun haben — der Skill würde zwei Dinge tun.
      Dafür spricht, dass die `CLAUDE.md`-Verdrahtung dort schon vollständig
      gelöst ist und nicht zweimal existieren sollte.
- [ ] **2.2.4 · Entscheidung: Gruppierung und Nummerierung festschreiben?**
      Diese Datei gruppiert nach Art der Arbeit und nummeriert durchgehend.
      Ob das die Vorgabe wird oder nur ein Beispiel, ist offen — eine feste
      Gruppenliste passt nicht auf jedes Projekt, die Nummerierungsregel
      („nie nachziehen") vermutlich schon.
- [ ] **2.2.5 · Multi-Repo: wo liegt die `TODOS.md`?** Dieselbe Randbedingung
      wie bei jedem repo-übergreifenden Doku-Skill: Gearbeitet wird oft in
      einem übergeordneten Verzeichnis mit mehreren Projekten und mehreren
      Repos. Je Repo eine Datei, eine
      übergeordnete, oder beides? Und in welche `CLAUDE.md` kommt der Block,
      wenn das Arbeitsverzeichnis gar kein Repo ist? Vor dem Bauen klären —
      die Antwort bestimmt den ganzen Zuschnitt.
- [ ] **2.2.6** Als Decision festhalten, sobald die Form steht.

### 2.3 · `statusline-setup` — Statusline einrichten

**Plugin-Skill**, `user-only` (`disable-model-invocation: true`).

- [ ] **2.3.1** Statusline-Setup vom Arbeits-Laptop übernehmen und als Skill
      fassen. Vorlage ist die dortige Konfiguration; Referenz auf dieser
      Maschine: `~/.claude/statusline-command.sh`, eingehängt über
      `statusLine` in `~/.claude/settings.json`.

### 2.4 · `install` (Arbeitstitel) — alles einrichten, was das Plugin braucht

**Plugin-Skill**, `user-only` (`disable-model-invocation: true`).

Das Plugin setzt heute stillschweigend eine eingerichtete Maschine voraus:
Einträge in der globalen `~/.claude/CLAUDE.md`, externe Werkzeuge (Node/`npx`
für `md-to-pdf`, `sync-solution-items`, `infographic-page`; Playwright für
`data-model-diagram`, `whats-for-lunch`; PowerShell 7), dazu Abhängigkeiten wie
der PowerShell SecretStore. Auf einer frischen Maschine fällt das erst auf,
wenn ein Skill mitten im Lauf scheitert. Ein Skill soll das in einem Durchgang
prüfen und nachziehen. Fertig, wenn ein Lauf auf einer frischen Maschine jeden
Skill lauffähig hinterlässt und ein zweiter Lauf nichts mehr ändert.

- [ ] **2.4.1** Bestand erheben: je Skill die externen Abhängigkeiten und die
      `CLAUDE.md`-/`settings.json`-Einträge, auf die er sich verlässt. Der
      SecretStore taucht in keinem `smax`-Skill auf — klären, wer ihn braucht.
      Gehört er zu einem `cnx`-Skill, gehört auch seine Einrichtung nach `cnx`
      (`docs/decisions/0025`), nicht hierher.
- [ ] **2.4.2 · Entscheidung: Wo steht die Liste der Anforderungen?** Zentral
      im Install-Skill, oder je Skill deklariert (Frontmatter oder eigene
      Datei) und vom Install-Skill eingesammelt. Zentral ist einfacher, läuft
      aber still auseinander wie `README.md`/`NOTICE.md` — dann gehört die
      Prüfung in `sync-plugin-docs`.
- [ ] **2.4.3 · Idempotent und nie still.** Vorhandenes erkennen, nur Fehlendes
      nachziehen; jede Änderung an der globalen `CLAUDE.md` vorher zeigen und
      bestätigen lassen (Muster wie `domain-modeling`: Block vorhanden, anders
      formuliert, veraltet). Installationen von Software ebenfalls bestätigen.
- [ ] **2.4.4 · Entscheidung: Verhältnis zu 2.3 `statusline-setup`.** Eigener
      Skill bleiben oder als optionaler Schritt im Install-Skill aufgehen.
- [ ] **2.4.5** Nur Windows oder auch andere Plattformen? Die bekannten
      Abhängigkeiten sind Windows-lastig (PowerShell, `.bat`).
- [ ] **2.4.6** Als Decision festhalten, sobald die Form steht.

---

## 3 · Model und Effort je Skill

### 3.1 · Für jeden Skill Model **und** Effort festlegen

**Hohe Priorität.**

Heute läuft jeder Skill auf dem Model und dem Effort, den die Session gerade
benutzt. Bei 30 Skills mit sehr unterschiedlichem Anspruch ist das die falsche
Voreinstellung: Ein Reviewer, der Faktenbehauptungen gegen Dateien prüft,
braucht etwas anderes als `whats-for-lunch`. Kandidaten je Skill: **bestes
Sonnet**, **bestes Opus**, **Fable**, dazu eine Effort-Stufe `low` … `max`.

**Zwei Achsen, nicht eine.** Sie sind unabhängig setzbar, und die Mischungen
sind der interessante Teil: ein kleines Model auf hohem Effort ist etwas
anderes als ein großes auf niedrigem. Für `commitMessage` ist vermutlich beides
niedrig, für `code-review` beides hoch — aber das ist die Vermutung, nicht das
Ergebnis. Nur das Model zu entscheiden lässt die halbe Wahl offen und erzeugt
später eine zweite Runde über dieselben 30 Skills.

**Der Mechanismus ist geklärt (01.08.2026, [Claude-Code-Doku](https://code.claude.com/docs/en/skills)):**
Das `SKILL.md`-Frontmatter kennt zwei Felder: **`model`** — *„Model to use when
this skill is active"*, Werte wie bei `/model`, dazu `inherit` — und **`effort`**
(`low` … `max`). Beides sind **Claude-Code-Erweiterungen** des
Agent-Skills-Standards; die Plattform-Doku kennt nur `name` und `description`,
und die eingefrorene Kopie `writing-skills/anthropic-best-practices.md` im Repo
ebenfalls nicht.

**Ein Detail mit Folgen:** Der Override *„applies for the rest of the current
turn and is not saved to settings"*. Ein Skill, der `model:` setzt, zieht damit
alles nach sich, was im selben Turn noch läuft — also auch die Skills, die er
aufruft. Bei einer Kette wie `writing-specs` → `domain-modeling` →
`sync-solution-items` ist das keine Nebenwirkung, sondern der Hauptfall.

**Der zitierte Satz steht bei `model`.** Ob `effort` dieselbe Turn-Semantik hat,
ist damit **nicht** belegt — nur naheliegend. Solange das ungeprüft ist, darf
keine Zuordnung darauf aufbauen; siehe 3.1.1.

**Vorarbeit, die es schon gibt:** `subagent-driven-development/SKILL.md`
(§ *Model Selection*, Z. 140–162) regelt das Model bereits — aber nur für
**dispatchte Subagents**, und nur in Stufen („least powerful model that can
handle each role"), ohne konkrete Model-Namen. Die drei Prompt-Vorlagen dort
tragen `model:` als Pflichtfeld — **`effort:` kommt dort nicht vor.** Das ist
der Anknüpfungspunkt; ihn nicht zu kennen hieße, dieselbe Regel ein zweites Mal
und abweichend zu schreiben.

- [ ] **3.1.1 · Turn-Semantik durchdenken, bevor irgendwo `model:` oder
      `effort:` steht.** Wer in der Kette darf die Felder setzen, ohne den Rest
      des Turns mitzureißen? Denkbar: nur der Einstiegs-Skill setzt, die
      gerufenen erben (`inherit`); oder gar keiner setzt sie und die Steuerung
      bleibt beim Dispatch. **Das entscheidet den Zuschnitt von 3.1.3** — eine
      Zuordnung „je Skill", die quer durch eine Kette feuert, ist schlimmer als
      keine.
      **Zuerst zu klären: gilt die Turn-Semantik für `effort` überhaupt?** Die
      Doku sagt es nur für `model`. Denkbar ist auch, dass `effort` je Aufruf
      neu greift — dann ist die Antwort für die zwei Achsen verschieden, und
      genau das darf nicht unbemerkt bleiben. Nachlesen, nicht annehmen.
- [ ] **3.1.2 · Ein Kriterium festlegen, das beide Achsen einordnet** — nicht
      Skill für Skill nach Gefühl, und nicht zwei getrennte Kriterien. Denkbare
      Achsen: prüft er Faktenbehauptungen gegen Dateien · schreibt er oder
      berichtet er nur · muss er unter Druck Disziplin halten (die Gates) · wie
      oft läuft er, also Kosten. Die Stufenlogik aus SDD § *Model Selection*
      ist die Vorlage; entweder sie wird übernommen und um konkrete
      Model-Namen ergänzt, oder sie wird ersetzt — **beides an einer Stelle,
      nicht an zweien.**
      **Vorschlag als Ausgangspunkt für den Effort:** Er hängt daran, ob ein
      Skill *urteilt* oder *nachschlägt*. Nachschlagen (`commitMessage`,
      `sync-solution-items`) kommt mit wenig aus, Urteilen (`code-review`,
      `debugging`, `sharpen`) nicht. Das ist eine andere Frage als „wie fähig
      muss das Model sein" und kann deshalb anders ausfallen.
- [ ] **3.1.3 · Zuordnung für alle Skills durchziehen** — **je Skill beide
      Werte**, nach dem Kriterium aus 3.1.2 statt einzeln argumentiert. Ein
      Skill, bei dem nur eine der zwei Achsen gesetzt wird, ist ein bewusster
      Fall und wird als solcher notiert, kein vergessener.
- [ ] **3.1.4 · Als Decision festhalten** — das Kriterium und die Fälle, in
      denen bewusst davon abgewichen wurde.
- [ ] **3.1.5 · README aufnehmen**, sobald es steht: §5 wäre die Stelle, je
      eine Spalte *Model* und *Effort* neben *Argumente* und *Trigger* — oder
      eine gemeinsame, wenn vier Spalten die Tabelle sprengen. **Achtung,
      Kollision:** Das wären abgeleitete Spalten, die `sync-plugin-docs`
      mitpflegen muss — die **Quellenliste** braucht dann eine eigene Zeile je
      Spalte, mit `model:` bzw. `effort:` als Quelle, analog zu
      `argument-hint`. Zwei Spalten heißt zwei Zeilen, nicht eine für beide.
- [ ] **3.1.6 · Die drei Prompt-Vorlagen in `subagent-driven-development`
      nachziehen.** Sie tragen heute `model:` als Pflichtfeld und schweigen zum
      Effort. Ein dispatchender Skill trifft die Wahl **zweimal** — einmal für
      sich, einmal für das, was er startet —, und heute ist nur die zweite
      Hälfte der ersten Achse geregelt. Betrifft neben SDD auch `code-review`,
      `writing-plans` und `finishing-a-development-branch`, soweit sie eigene
      Vorlagen tragen.

---

## 6 · Umbau am Bestand

### 6.2 · Die Gruppe `dev` in zwei Gruppen teilen

`plugin/skills/dev/` hält heute 27 Skills. README §5 zeigt sie bereits in drei
Tabellen — *Workflow-Kette*, *Denken & Doku*, *Kunden- & Web-Aufgaben* —, aber
das ist reine Darstellung: Das Verzeichnis ist eines, und `plugin.json` kennt
nur `./skills/dev` und `./skills/personal`.

- [ ] **6.2.1 · Kriterium festlegen — offen.** Nach welchem Merkmal geteilt
      wird, formuliert Smax noch. Die drei README-Tabellen sind ein Vorschlag,
      keine Vorgabe: Sie sind gewachsen und heute eine reine Einschätzung.
- [ ] **6.2.2 · Der Gewinn, der die Aufgabe trägt.** Welcher `dev`-Gruppe ein
      Skill zugehört, hat heute **keine Quelle** außerhalb der README — es steht
      nur dort. Deshalb muss `sync-plugin-docs` diese Einordnung vorlegen statt
      schreiben (`docs/decisions/0019-write-sourced-present-the-rest.md`).
      Wird die Gruppe zum Verzeichnis, bekommt sie eine Quelle, und aus einer
      Rückfrage wird ein stiller Schreibvorgang. Das ist der konkrete Nutzen —
      nicht Ordnung um ihrer selbst willen.
- [ ] **6.2.3 · Der teure Nebeneffekt: `plugin/NOTICE.md`.** Es führt Pfade
      relativ zu `plugin/skills/dev/` — über 30 Einträge. Eine Teilung ändert
      jeden davon. Vor der Umsetzung entscheiden, ob die Kopfzeile umgestellt
      wird oder jeder Eintrag ein Präfix bekommt.
- [ ] **6.2.4** Nachzuziehen sind außerdem: `plugin/.claude-plugin/plugin.json`,
      README §5 (Überschriften), §6.8, und die Pfade in `CLAUDE.md`.

### 6.3 · `infographic-page`: Schalter zwischen Dark und Light Mode

Die erzeugte Seite kennt heute genau ein Design. Sie soll einen Schalter
bekommen, der zwischen zwei Modi wechselt. **Das heutige Design ist der Dark
Mode; einen Light Mode gibt es noch nicht** — er muss erst entworfen werden.

**Die Mechanik ist der billige Teil.** Das Design läuft fast vollständig über
CSS-Variablen in `:root`; ein zweites Set unter `:root[data-theme="light"]` plus
ein Button, der das Attribut umsetzt, sind wenige Zeilen.

**Die Farben sind der teure Teil**, und daran hängt die Aufgabe:

- **Gold trägt das ganze Design.** `#c9a84c` auf `#0a0c10` hat guten Kontrast —
  dasselbe Gold auf Weiß liegt bei rund 2:1 und ist als Textauszeichnung
  unbrauchbar. Der Light Mode braucht ein eigenes, dunkleres Gold, nicht das
  bestehende vor hellem Grund.
- **Die sechs Accent-Paare sind richtungsgebunden gebaut**: dunkle Füllung
  (`--accent-blue-dim`) plus helle Schrift (`--accent-blue`). Im Light Mode
  kehrt sich das um. Jedes Paar braucht eine zweite Fassung, nicht nur die
  Kernpalette.
- **12 `rgba()`-Literale in den Komponenten-Snippets laufen an den Variablen
  vorbei** (nachgezählt am 01.08.2026 in `SKILL.md`, nicht geschätzt), darunter
  `rgba(255,255,255,.05)` als Code-Hintergrund — im Light Mode unsichtbar. Ein
  zweites Variablen-Set allein reicht deshalb nicht.
- **Dark-Mode-Effekte ohne Entsprechung:** der `text-shadow`-Glow auf `h1`, der
  `box-shadow` an `.info-box--highlight`, und das Noise-Overlay mit
  `opacity:.03` — ob letzteres auf hellem Grund überhaupt trägt, ist ungeprüft.

- [ ] **6.3.1 · Light-Palette festlegen, bevor die erste Zeile CSS entsteht.**
      Je Variable ein zweiter Wert — Kernpalette *und* alle sechs Accent-Paare —
      und für die 12 losen `rgba()`-Stellen die Entscheidung: variabilisieren
      oder je Theme überschreiben. Variabilisieren ist sauberer, vergrößert aber
      den Variablenblock, den der Skill als Copy-Paste ausliefert.
- [ ] **6.3.2 · Entscheidung: Startzustand und Persistenz.** Folgt die Seite
      `prefers-color-scheme` und der Klick überschreibt nur, oder startet sie
      immer dunkel? **Fallstrick vor dem Bauen prüfen, nicht annehmen:** Die
      Seiten werden per Doppelklick aus dem Dateisystem geöffnet, und Chrome
      verweigert `localStorage` unter `file://` (Firefox nicht). Fällt die
      Persistenz aus, muss der Schalter trotzdem funktionieren und darf nicht
      werfen.
- [ ] **6.3.3 · Entscheidung: wo der Schalter sitzt.** Kandidaten: dritter
      Button in `.expand-controls` (billig, scrollt aber weg) ·
      `position:fixed` oben rechts (immer erreichbar, überlagert bei schmaler
      Breite den Header). Unabhängig davon: **kein Flackern beim Laden** — das
      Attribut muss stehen, bevor der erste Frame gerendert wird, also
      Inline-Script im Kopf statt Handler vor `</body>`.
- [ ] **6.3.4 · Die Selbstwidersprüche in der Skill-Datei mitziehen.** Die
      Tabelle *Common Mistakes* führt heute „Light background → Always dark
      (`--bg-deep: #0a0c10`)" als **Fehler**. Bleibt die Zeile stehen,
      widerspricht der Skill der neuen Anforderung. Dasselbe betrifft die Zeile
      *Missing noise texture* und den Eintrag *Background* in den Design Rules.
- [ ] **6.3.5 · Entscheidung: bläht das die `SKILL.md`?** Sie hat heute rund
      1.080 Wörter und wird bei jedem Aufruf vollständig geladen; ein zweites
      Variablen-Set plus Theme-Overrides verdoppelt ihren größten Block.
      Optionen: alles in `SKILL.md` (einfach, teuer je Aufruf) · Palette in eine
      Referenzdatei daneben auslagern (Muster:
      `subagent-driven-development/implementer-prompt.md`) · nur die
      Light-Werte auslagern. **Gegenargument, das die Auslagerung schwächt:**
      Sie spart nur, wenn die Datei nicht ohnehin jedes Mal gelesen werden muss
      — und für die Palette muss sie das.
- [ ] **6.3.6 · Testfall neu erzeugen — im Repo liegt keiner mehr.**
      `docs/smax-plugin.html` war am 01.08.2026 aus der README erzeugt worden
      und am 04.08.2026 gelöscht: ein Test, kein Artefakt, und er alterte mit
      jeder README-Änderung still weiter. Als Testfall taugte er trotzdem, weil
      er **jede** Komponente des Systems trug — Karten mit Badges, Info-Boxen in
      vier Varianten, Tabellen, Flow-Reihen, Compare, Prop-Listen, Code-Blöcke,
      Tree. Die neue Seite muss dieselbe Abdeckung haben, sonst prüft sie den
      halben Schalter. Nach `C:\Temp` erzeugen, nicht ins Repo. **Fertig
      heißt:** umschaltbar ohne Flackern, kein Element in einem der beiden Modi
      unsichtbar, und Gold wie Accents im Light Mode auf Lesbarkeit **geprüft**
      statt geschätzt.
- [ ] **6.3.7 · Bestandsseiten ziehen den Schalter nicht nach.** Eine bereits
      erzeugte Seite bleibt, wie sie ist — es gibt keine Migration. Das gehört
      festgehalten, damit später niemand danach sucht.

**Keine Decision.** Geprüft an den drei Kriterien aus README §1.5: schwer
umkehrbar ist es nicht, und überraschend ist ein Theme-Schalter für keinen
späteren Leser. Sollte 6.3.5 gegen die Auslagerung ausfallen und sich das
später rächen, ist *das* der Kandidat — nicht der Schalter selbst.

**Vorlage im Repo (31.08.2026):**
`plugin/skills/dev/data-model-diagram/template.html` löst 6.3.2 und 6.3.3
bereits — und zwar so: `:root` trägt die Hell-Palette, ein Block
`@media (prefers-color-scheme:dark)` mit dem Guard
`:root:not([data-theme="light"])` die Dunkel-Werte, und ein dritter Block
`:root[data-theme="dark"]` dieselben Werte noch einmal, damit der Schalter in
**beide** Richtungen gewinnt. Ohne die Verdopplung kann ein Klick die
Systemeinstellung nur in einer Richtung überstimmen. Kein `localStorage`,
also auch kein `file://`-Problem und kein Flackern; der Preis ist, dass die
Wahl beim Neuladen verfällt. Das Muster ist im Browser geprüft — es
übersetzt sich aber nicht eins zu eins, weil `infographic-page` keine
Variablen-Symmetrie hat (die 12 losen `rgba()` aus 6.3.1 bleiben das
eigentliche Problem).

### 6.5 · Zwei Lehren aus dem `sync-plugin-docs`-Bau nach `writing-skills` heben

**Eigener Durchgang, nicht nebenbei.** Beide Lehren stammen aus neun
Task-Durchgängen an einer einzigen `SKILL.md` und sind das Übertragbarste, was
dabei entstanden ist. Ziel ist `plugin/skills/dev/writing-skills/` — als Plugin-
Skill, damit sie jeden Skill-Bau erreichen, nicht nur den in diesem Repo.

**Lehre 1: Ein Lauf führt Bash-Blöcke aus und überfliegt Prosa.** Beim Bau von
`sync-plugin-docs` scheiterte dieselbe Korrektur **dreimal** an derselben
Abbruchstelle, obwohl die Prosa davor jedes Mal präziser wurde. Was sie erreichte,
war ein vorgezogener Schritt, der Kommandos enthielt (Task 3). Konsequenz für
`writing-skills`: Wo ein Verhalten erzwungen werden soll, gehört ein Kommando
hin, kein Satz.

**Lehre 2: Eine Prüfung, die erzwungen werden muss, gehört in ein nicht
fälschbares Report-Feld, nicht in einen Schritt.** Prozedurale Anweisungen
driften — dieselbe Anweisung stand an drei Positionen und wurde dreimal
übergangen. Ein Pflichtfeld, dessen Inhalt aus **Zeilennummern** besteht, lässt
sich dagegen nicht erfinden: Der Lauf *muss* suchen, um es zu füllen. Der Beleg
ist die Basiszeile von `sync-plugin-docs` — in 15+ Läufen nie gedriftet, weil
`## Report` sie als Pflichtfeld führt (Task 4).

- [ ] **6.5.1** Beide Lehren in `writing-skills` einarbeiten — als Anleitung,
      wie ein Skill Disziplin durchsetzt, nicht als Anekdote über
      `sync-plugin-docs`. Erledigt ist es, wenn `writing-skills` die Wahl
      „Prosa gegen Kommando" und die Wahl „Schritt gegen Pflichtfeld"
      ausdrücklich stellt und beantwortet.
- [ ] **6.5.2** Dabei prüfen, ob `writing-skills/testing-skills-with-subagents.md`
      der bessere Ort für Lehre 1 ist — sie ist eine Aussage darüber, was ein
      Testlauf mit dem Text macht, nicht darüber, wie man ihn schreibt.

### 6.6 · Ein Subagent darf nie einen Subagenten dispatchen, dessen Ergebnis er braucht

**Die Regel:** Der Testlauf gehört zum Controller. Der Implementer liefert Code
und Report. Wer dispatcht, muss auch derjenige sein, bei dem das Ergebnis
ankommt.

**Warum — am 03.08.2026 gemessen, nicht vermutet.** In der Fix-Welle zu
`sync-plugin-docs` verlangte der Brief vom Implementer, den Ende-zu-Ende-Test
selbst zu dispatchen. Er tat es und wartete danach **70 Minuten und rund 200.000
Tokens** auf einen Report, der ihn nie erreichen konnte: Das Ergebnis eines
Subagenten geht an die **Hauptsitzung**, nicht an den Agenten, der ihn gestartet
hat. Beide Testläufe landeten beim Controller.

Drei Folgeschäden, die den Fall so teuer machen:

- Er pollte in `sleep`- und `while`-Schleifen à 540 Sekunden und prüfte
  dazwischen den Arbeitsbaum. Weil der Lauf tatsächlich schrieb, schloss er
  korrekt „er arbeitet noch" — und wartete weiter. **Ein plausibler Zwischenstand
  hielt den Irrtum am Leben.**
- Sein Versuch, den Lauf zu stoppen, quittierte
  `No task found with ID: a9898fe0a7e3d13aa` — genau die ID, deren Report zu dem
  Zeitpunkt längst beim Controller lag.
- Während er in den Schleifen hing, las er **sein Postfach nicht**. Zwei
  Nachrichten des Controllers und eine direkte Frage von Smax kamen nie an. Von
  außen sah das aus wie ein defekter Agent; er war nur beschäftigt.

Der Fehler stand im Brief, nicht im Modell. In allen neun Tasks davor hatte der
Controller die Testläufe dispatcht — richtig, weil die Ergebnisse dort ankommen.
Erst die Fix-Welle schob eine Controller-Aufgabe in einen Implementer.

- [ ] **6.6.1** Die Regel in `subagent-driven-development` aufnehmen. Erledigt
      ist es, wenn der Skill ausdrücklich sagt, wer einen Testlauf dispatcht, und
      warum ein Implementer es nicht kann — mit dem Wartefall als Beleg, nicht
      als Stilhinweis.
- [ ] **6.6.2** Den Test-Harness-Abschnitt der Planvorlage in `writing-plans`
      daraufhin ansehen. Er beschreibt die Dispatch-Vorlage, sagt aber nicht, wer
      dispatcht — genau die Lücke, in die dieser Fall gefallen ist. Erledigt ist
      es, wenn der Abschnitt benennt, wer einen Testlauf dispatcht — oder
      ausdrücklich festhält, dass die Frage dort nicht hingehört.
- [ ] **6.6.3** Prüfen, ob es für den legitimen Fall einen Weg gibt: Soll ein
      Implementer je einen Lauf brauchen, muss der Controller ihn fahren und das
      Ergebnis als Datei nachreichen. Erledigt, wenn dieser Ablauf in
      `subagent-driven-development` beschrieben ist oder ausdrücklich als
      unzulässig verworfen wurde.

### 6.7 · `sync-plugin-docs`: Vorschlag für eine Zelle einer Zeile, die es nicht gibt

**Der Fall:** Ein neuer Command-Skill braucht eine Zeile in einer der drei
`dev`-Tabellen in README §5. Welche Tabelle, hat keine Quelle — die Zeile wird
deshalb richtig *nicht* angelegt und landet unter *Gemeldet*. Ihre Zelle
*Argumente* hat dagegen einen Wert (`argument-hint:`), und der Lauf legt sie
unter *Zu übernehmen* vor, mit `alt: (leer — Zeile existiert noch nicht)`.

**Warum das ein Problem ist:** Ein „j" auf diesen Eintrag lässt sich nicht
ausführen — es gibt keine Zeile, in die der Wert käme. §7 regelt nur die neue
Zeile, die *angelegt* wird (Zeile rein, quellenlose Zellen leer, Entwurf in den
Report); die zurückgehaltene Zeile regelt es nicht. Beobachtet am 15.09.2026 in
zwei von zwei Läufen mit einem Wegwerf-Command, vor und nach dem Umbau aus
`0026` — der Umbau hat damit nichts zu tun.

**Optionen, noch nicht bewertet:**

- Die Zell-Vorschläge hängen am *Gemeldet*-Eintrag der Zeile, ohne eigene Nummer
  und ohne `[j/n]` — sie werden erst beantwortbar, wenn die Tabelle feststeht.
- Der *Zu übernehmen*-Eintrag bleibt, bekommt aber eine Abhängigkeit
  („setzt Antwort auf 3 voraus").

- [ ] **6.7.1** Regel in §7 von `sync-plugin-docs` ergänzen. Erledigt ist es,
      wenn §7 den Fall der zurückgehaltenen Zeile benennt und ein Lauf mit einem
      neuen Command-Skill keinen unausführbaren `[j/n]`-Eintrag mehr erzeugt.

---

## 5 · Kleinkram

- [ ] **5.3** Backups der Setup-Umstellung löschen, sobald das neue Setup ein
      paar Tage getragen hat: `~/.claude/settings.json.bak-predev`,
      `~/.claude/plugins/known_marketplaces.json.bak-predev`,
      `~/.claude/plugins/installed_plugins.json.bak-predev`.

- [ ] **5.4** `lap-training`: die sieben mit `(ergänzt)` markierten Fragen
      gegenlesen. Sie stehen im WKO-Themenkatalog, fehlten aber in Smax'
      Vorbereitungs-MD — die Antworten sind daher ohne Vorlage geschrieben und
      als einzige ungeprüft gegen eine zweite Quelle. Betroffen: `04-04`,
      `12-14`, `15-13`, `15-15`, `15-18`, `16-04`, `16-07`. Fertig, wenn die
      `(ergänzt)`-Marker entfernt sind.

- [ ] **5.5** `lap-training`: die Musterantworten stammen aus einer
      KI-generierten Vorbereitungsdatei und sind nicht gegen eine Fachquelle
      geprüft. Der Skill sagt im Training an, wenn er einer Antwort
      widerspricht — Korrekturen daraus fließen aber nur zurück, wenn sie
      jemand einträgt. Nach den ersten Trainingseinheiten die aufgefallenen
      Stellen nachziehen.

- [ ] **5.10** Liest ein Plugin-Skill seine Satellitendateien ohne Rückfrage?
      Ein Skill, der neben `SKILL.md` eine zweite Datei braucht, löst beim Lesen
      einen Berechtigungsdialog aus, weil das Plugin-Verzeichnis außerhalb des
      Projekts liegt. Betrifft `debugging`, `teach`, `writing-skills`
      — jeden Skill mit Begleitdateien, ein Klick pro Lauf.
      **Zu klären ist, ob das nur Directory-Source-Marketplaces trifft oder auch
      Cache-Installationen von GitHub.** Test: in einer Session mit
      `--permission-mode acceptEdits` eine Datei unterhalb
      `~/.claude/plugins/cache/…/superpowers/…/skills/` lesen lassen. Fragt sie,
      trifft es jeden Nutzer — dann lohnt ein zweiter Hook-Matcher, der `Read`
      unterhalb `${CLAUDE_PLUGIN_ROOT}` genehmigt. Fragt sie nicht, genügt eine
      `Read()`-Regel in der eigenen `settings.json`.
