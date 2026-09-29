# SPEC — `setup`

**Erstellt:** 29.09.2026

Ein Plugin-Skill, der auf einer Windows-Maschine prüft, ob alles vorhanden ist,
was die `smax`-Skills voraussetzen, und Fehlendes nach Bestätigung installiert.
Dazu kommt eine Erweiterung von `sync-plugin-docs`, damit die Anforderungsliste
nicht driftet.

Entstanden aus `TODOS.md` 2.4 (Arbeitstitel `install`).

## Anlass

Das Plugin liefert nur Skill-Verzeichnisse aus: kein `.mcp.json`, keine Hooks,
keine Settings. Was die Skills sonst noch brauchen, muss schon auf der Maschine
sein. Auf einer frischen Maschine merkt man das erst, wenn ein Skill mitten im
Lauf scheitert. `md-to-pdf` findet dann kein `npx`, `data-model-diagram` hat
keinen Playwright-Server, und `sync-solution-items` läuft unter
PowerShell 5.1 an, wo sich das Skript nicht einmal parsen lässt.

Seit das Repo öffentlich ist (`0025`), installieren auch Kollegen das Plugin.
Ihre Maschinen sind nicht eingerichtet.

## Ziel

Ein Lauf von `/smax:setup` hinterlässt jeden Skill lauffähig, soweit der Nutzer
die angebotenen Installationen annimmt. **Idempotent** heißt: Ohne Bestätigung
ändert kein Lauf etwas an der Maschine, und ein zweiter Lauf nach vollständig
angenommenen Installationen meldet „Alles vorhanden." und fragt nichts. Hat der
Nutzer eine Anforderung abgelehnt, bietet der nächste Lauf sie wieder an. Der
Skill merkt sich keine Ablehnungen, dafür gibt es keinen Zustand.

**Nicht-Ziele:**

- **Einträge in der globalen `~/.claude/CLAUDE.md` oder `settings.json`.** Die
  Bestandsaufnahme (§2) hat ergeben, dass kein `smax`-Skill einen braucht. Die
  Anforderungsart kommt erst dazu, wenn der erste Skill sie braucht, und nicht
  auf Vorrat.
- **PowerShell SecretStore.** Den brauchen nur `cnx`-Skills, also gehört auch
  seine Einrichtung nach `cnx` (`0025`, `0027`).
- **Fähigkeiten des Harness** wie Subagenten, WebSearch und WebFetch. Sie sind
  keine Anforderungen im Sinne des Glossars, weil sie sich nicht installieren
  lassen.
- **Andere Plattformen als Windows** (`0028`).
- **Upgrades und Deinstallationen.** Was vorhanden ist, bleibt, wie es ist.
- **Verzeichnisse, die Skills selbst anlegen** (`C:\Temp`).
- **Transitive Zuordnung.** `writing-specs` ruft `sync-solution-items`, das
  PowerShell 7 braucht. Die Liste führt nur `sync-solution-items`, weil
  `writing-specs` selbst kein `pwsh` aufruft.

## Ubiquitous Language

Die verbindlichen Begriffe stehen in [`CONTEXT.md`](../../../CONTEXT.md).
Dieses Dokument führt **Anforderung**, **Optionale Anforderung** (Gegenstück:
Pflicht-Anforderung), **Anforderungsliste** und **Signatur** neu ein und
erweitert **Abgeleitetes Dokument** um die Anforderungsliste. Es stützt sich
außerdem auf **Plugin-Skill**, **Command**, **Eigenständiger Command**,
**Drift**, **Quelle**, **Quellenliste**, **Verdikt**, **Vergleichsbasis** und
**Sicherheitsnetz**.

## Entscheidungen

- [`0027-requirement-list-central-guarded-by-sync`](../../decisions/0027-requirement-list-central-guarded-by-sync.md):
  Die Liste steht zentral im Setup-Skill und wird nicht je Skill deklariert.
  `sync-plugin-docs` bewacht sie. Die Entscheidung benennt auch die bekannte
  Lücke.
- [`0028-setup-windows-only-via-winget`](../../decisions/0028-setup-windows-only-via-winget.md):
  nur Windows, Installation per `winget`, jede Installation wird bestätigt.

Ebenfalls einschlägig sind `0016` (Kaltstart), `0018` (`sync-plugin-docs` bleibt
repo-lokal), `0019` (Belegtes schreiben, den Rest vorlegen), `0020` (blinder
Fleck der Sweep-Basis) und `0021` (Skilltext englisch, Ausgabe in der Sprache
des Lesers).

## 1 · Zuschnitt

Neu ist ein Skill unter `plugin/skills/dev/setup/`:

| Datei | Inhalt |
|---|---|
| `SKILL.md` | Ablauf (§4), englisch |
| `requirements.md` | die Anforderungsliste (§3), englisch |

- **Command:** Der Skill trägt `disable-model-invocation: true`. Er ruft keinen
  Skill, und keiner ruft ihn, also ist er ein eigenständiger Command.
- **Keine Argumente.**
- **Kein Skript.** Das Modell liest die Tabelle und führt die Prüf- und
  Installationsbefehle einzeln aus. Die Liste bleibt dadurch Markdown, das
  `sync-plugin-docs` wie die anderen abgeleiteten Dokumente bearbeiten kann. Ein
  Parser, der dieselbe Tabelle noch einmal einliest, entfällt.

Geändert werden außerdem `sync-plugin-docs` (§5), der Commit-Hook, die
Projekt-`CLAUDE.md` und die `README.md` (§7).

## 2 · Bestandsaufnahme

Erhoben am 29.09.2026 über alle 31 Skills (27 unter `dev`, 4 unter
`personal`). Aufgeführt ist
nur, was eine Anforderung im Sinne des Glossars ist. Die Beispiele `npm test` in
`test-driven-development` und `pytest` in `writing-plans` zählen nicht dazu,
ebenso wenig Harness-Fähigkeiten und Verzeichnisse, die ein Skill selbst anlegt.

| Anforderung | Pflicht für | Optional für | Beleg |
|---|---|---|---|
| Git for Windows (`git`, Git Bash, `nano`) | `code-review`, `commitMessage`, `finishing-a-development-branch`, `nano-vs-colors`, `proad-job-report`, `subagent-driven-development`, `using-git-worktrees`, `writing-plans` | `brainstorming`, `debugging`, `handoff`, `sync-solution-items` | Bash-Skripte mit Shebang, `git`-Aufrufe, `nano` ≥ 5 in `nano-vs-colors` |
| PowerShell 7 | `sync-solution-items` | — | Das Skript lässt sich unter 5.1 nicht parsen (UTF-8 ohne BOM, Gedankenstrich in Strings) |
| Node.js LTS (`node`, `npx`) | `md-to-pdf` | `brainstorming` (Visual Companion), `writing-skills` (`render-graphs.js`) | `md-to-pdf.bat:28`, `start-server.sh:180` |
| Python 3 | `data-model-diagram` | — | `python -m http.server`, SKILL.md:71 |
| MCP-Server `playwright` | `data-model-diagram`, `whats-for-lunch` | — | `mcp__playwright__*` |
| GitHub CLI `gh` | — | `code-review` | `gh api …` für Antworten im PR-Thread, `code-review/SKILL.md:35` |
| Graphviz `dot` | — | `writing-skills` | `render-graphs.js:13` |

`finishing-a-development-branch` legt PRs „mit der CLI der Forge, falls
vorhanden" an, nennt `gh` aber nicht. Die Liste führt nur, was eine Signatur
belegt, deshalb fehlt der Skill in der Zeile.

Git for Windows ist praktisch immer da, weil Claude Code unter Windows Git Bash
voraussetzt. Die Zeile steht trotzdem in der Liste, weil sie billig ist und
`nano` mitbringt.

## 3 · Die Anforderungsliste

`plugin/skills/dev/setup/requirements.md`, eine Tabelle, **eine Zeile je
Anforderung**:

| Spalte | Inhalt | abgeleitet? |
|---|---|---|
| *Requirement* | Name | nein |
| *Kind* | `program` oder `mcp` | nein |
| *Check* | ein Befehl, der bei vorhandener Anforderung Exit-Code 0 liefert **und** dessen Ausgabe das Kriterium erfüllt | nein |
| *Install* | ein Befehl | nein |
| *Needs* | eine andere Zeile, die vorher erfüllt sein muss | nein |
| *Signature* | die Zeichenfolgen, an denen `sync-plugin-docs` die Anforderung in einem Skill erkennt | nein |
| *Mandatory for* | Skills, die ohne sie scheitern | **ja** |
| *Optional for* | Skills, die ohne sie eingeschränkt laufen | **ja** |

**Die Zeilenfolge ist die Installationsreihenfolge.** Was eine andere Zeile
unter *Needs* nennt, steht unter ihr.

**Jeder Befehl läuft unter Windows PowerShell 5.1, gestartet aus dem Bash-Tool.**
Der Befehl wird per Heredoc mit einfach gequotetem Begrenzer in eine temporäre
`.ps1` geschrieben (dann interpoliert Bash die `$`-Variablen nicht), mit
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File <Datei>` ausgeführt und
danach gelöscht. Nur diese Kombination existiert sicher auf jeder Maschine:

- Git Bash setzt Claude Code unter Windows voraus.
- `powershell.exe` (5.1) liegt jedem Windows bei.
- Das PowerShell-Tool von Claude Code ist je nach Maschine 5.1, `pwsh` oder gar
  nicht aktiv.
- `pwsh` selbst ist auf einer frischen Maschine noch eine offene Anforderung.
  Ein Prüfbefehl, der es voraussetzt, würde genau das Fehlen verschleiern, das
  er melden soll.

**Falle: `-File -` (Skript über stdin).** Verifiziert am 29.09.2026 unter
5.1: Über stdin läuft PowerShell im interaktiven Modus. Eine mehrzeilige
Anweisung wie der `PATH`-Refresh unten verschluckt dann alle folgenden Zeilen
still, und der Prozess endet trotzdem mit 0. Deshalb eine Datei.

**Jedes Skript beginnt mit `$ErrorActionPreference = 'Stop'`.** Verifiziert:
Ohne diese Zeile endet ein Skript, dessen Befehl gar nicht existiert (`dot` ohne
Graphviz), mit 0. Die Anforderung würde als vorhanden gelten.

**Jedes Skript endet mit `exit $LASTEXITCODE`.** Verifiziert: Ohne diese Zeile
endet `powershell.exe -File` mit 0, auch wenn der letzte native Befehl
fehlschlug.

**Die Datei ist reines ASCII.** 5.1 liest eine UTF-8-Datei ohne BOM als cp1252.
Das ist derselbe Fehler, an dem heute `sync-solution-items.ps1` scheitert
(`TODOS.md` 5.11).

Startbestand:

| Requirement | Kind | Check | Install | Needs | Signature |
|---|---|---|---|---|---|
| Git for Windows | program | `git --version` | `winget install -e --id Git.Git` | — | `git <Unterbefehl>`, Shebang `#!/usr/bin/env bash`, `nano` |
| PowerShell 7 | program | `pwsh -NoProfile -Command '$PSVersionTable.PSVersion.Major'`, Ausgabe ≥ 7 | `winget install -e --id Microsoft.PowerShell` | — | `pwsh`, `#Requires -Version 7` |
| Node.js LTS | program | `node --version` **und** `npx --version` | `winget install -e --id OpenJS.NodeJS.LTS` | — | `npx`, `node` als Befehl, `.cjs`, Shebang `#!/usr/bin/env node` |
| Python 3 | program | `python --version`, Ausgabe beginnt mit `Python 3.` | `winget install -e --id Python.Python.3.14` | — | `python`, `py -`, `pip` |
| Playwright MCP | mcp | `claude mcp get playwright`, Ausgabe enthält `Connected` | `claude mcp add --scope user playwright -- cmd /c npx -y @playwright/mcp@latest --browser msedge` | Node.js LTS | `mcp__playwright__`, `Playwright` |
| GitHub CLI | program | `gh --version` | `winget install -e --id GitHub.cli` | — | `gh <Unterbefehl>` |
| Graphviz | program | `dot -V` | `winget install -e --id Graphviz.Graphviz`, dann `C:\Program Files\Graphviz\bin` an den Nutzer-`PATH` anhängen, falls `dot` dort liegt und noch nicht gefunden wird | — | `dot` als Befehl, `graphviz` |

*Mandatory for* und *Optional for* übernehmen den Stand aus §2.

**Falle: Python-Alias aus dem Store.** Auf einer frischen Windows-Maschine liegt
unter `%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe` ein Platzhalter, der den
Store öffnet oder nichts ausgibt. `where python` findet ihn, deshalb reicht
„Befehl existiert" als Prüfung nicht. Erst die Ausgabe `Python 3.x` gilt als
vorhanden.

**Verifiziert am 29.09.2026** (winget 1.29, Windows 11):

- Alle sieben winget-IDs existieren. Aktuell ist `Python.Python.3.14`.
- `claude` liegt nach der nativen Installation unter `~/.local/bin` im `PATH`
  der Tool-Shells.
- `claude mcp get playwright` startet den Server und meldet `Status: ✔
  Connected`. Die Prüfung belegt also den Start, nicht nur die Registrierung.
  Deshalb prüft sie auf `Connected` und nicht bloß auf den Exit-Code.
- `@playwright/mcp` nutzt ohne Angabe den Chrome-Kanal. Edge liegt jedem
  Windows 11 bei, deshalb installiert der Skill mit `--browser msedge`. So wird
  kein Browser zur weiteren Anforderung. Einen bestehenden Eintrag mit anderen
  Argumenten fasst der Skill nicht an, solange er `Connected` meldet.
- Graphviz kommt als NSIS-Installer. Eine stille Installation trägt `dot`
  erfahrungsgemäß nicht in den `PATH` ein, daher der Nachsatz in der
  *Install*-Spalte. Belegt wird das erst durch den Abnahmefall „Graphviz
  installieren".

**Falle: `npx`-Server unter Windows.** Ein lokaler MCP-Server, der direkt über
`npx` startet, verbindet sich unter nativem Windows nicht. Er braucht den
Wrapper `cmd /c`. Deshalb trägt die *Install*-Spalte `cmd /c npx -y …`.

**Laufzeit:** Eine winget-Installation samt UAC-Fenster kann das
Standard-Timeout des Bash-Tools (120 s) überschreiten. Jeder Installationsaufruf
setzt deshalb ein eigenes Timeout bis 600 s.

## 4 · Ablauf von `setup`

1. **Plattform.** Ist das kein Windows, gibt der Skill eine Zeile „Nur Windows
   wird unterstützt." aus und bricht ab, ohne weitere Prüfung. Der Skill
   verweist nicht auf `docs/decisions/`, weil `docs/` nicht ausgeliefert wird.
2. **winget.** `winget --version`. Fehlt winget, wird trotzdem alles geprüft und
   berichtet. Installiert wird dann nichts, und der Report nennt „App Installer"
   aus dem Microsoft Store als Voraussetzung.
3. **Prüfen.** Alle Zeilen der Liste werden in Listenreihenfolge geprüft. Die
   Status sind **vorhanden** (mit Version, wenn die Prüfung eine ausgibt) und
   **fehlt**.
4. **Report.** Er enthält alle Zeilen **in Listenreihenfolge**, mit Status,
   einer Spalte *Pflicht/optional* und je fehlender Zeile den Skills, die daran
   hängen. Eine Anforderung gilt als **Pflicht**, wenn sie für einen Skill
   Pflicht ist **oder** eine Pflicht-Anforderung sie unter *Needs* nennt.
   Deshalb bleibt Node Pflicht, solange der Playwright-MCP-Server Pflicht ist,
   auch wenn kein Skill `npx` direkt aufruft. Sonst ist sie optional.
   **Fehlt nichts:** Der Report lautet „Alles vorhanden." samt Tabelle, dann
   endet der Lauf. Es wird nichts gefragt und nichts installiert. Das ist der
   Idempotenzfall.
5. **Bestätigen.** Die fehlenden Anforderungen erscheinen als nummerierte Liste
   in Listenreihenfolge, also in der Reihenfolge, in der installiert wird,
   und die Antwort nennt Nummern („1 3", „alle", „keine"). Die Leseregel ist
   dieselbe wie in `sync-plugin-docs`: Es gilt nur, was genannt ist. „alle"
   umfasst auch die optionalen Anforderungen. Vorher weist der Skill darauf hin,
   dass winget für maschinenweite Pakete ein UAC-Fenster öffnet.
   **Abhängigkeit:** Wird eine Zeile gewählt, deren *Needs*-Zeile fehlt und
   nicht gewählt ist, fragt der Skill nach. Er nimmt sie entweder dazu oder
   lässt die abhängige Zeile weg und installiert sie nicht gegen eine fehlende
   Grundlage.
6. **Installieren**, in Listenreihenfolge. Bei winget kommen
   `--accept-source-agreements --accept-package-agreements` dazu. Nach jeder
   Installation wird dieselbe Zeile **im selben Tool-Aufruf** erneut geprüft,
   mit frisch eingelesenem `PATH`, also im selben Skript:

   ```powershell
   $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' +
               [Environment]::GetEnvironmentVariable('Path','User')
   ```

   Das ist nötig, weil jeder Tool-Aufruf und jedes daraus gestartete
   `powershell.exe` den `PATH` des laufenden Claude-Code-Prozesses erbt, und der kennt das eben installierte Programm noch nicht.
   Ohne die Zeile meldet die Nachprüfung jede erfolgreiche Installation als
   fehlgeschlagen.
7. **Schlussreport.** Er meldet je gewählter Zeile *installiert* oder
   *fehlgeschlagen* (mit winget-Exit-Code und der letzten Ausgabezeile) und
   führt die abgelehnten Zeilen weiter als *fehlt*. Wurde überhaupt etwas
   installiert, folgt der Hinweis, **Claude Code neu zu starten**: Die laufende
   Sitzung sieht weder den neuen `PATH` noch einen neu registrierten
   MCP-Server.

**Fehlerbilder, die der Skill benennt statt wiederholt:**

- winget meldet das Paket als schon installiert, die Prüfung findet es aber
  nicht. Das heißt „installiert, aber nicht im `PATH`". Der Skill versucht es
  kein zweites Mal.
- Ein Installationsfehler hält den Lauf nicht an. Die übrigen gewählten Zeilen
  laufen weiter, ausgenommen die Zeilen, deren *Needs*-Zeile gerade
  fehlgeschlagen ist.

**Nie:** installieren, was nicht in der Liste steht; ohne Bestätigung
installieren; vorhandene Software aktualisieren oder entfernen;
`~/.claude/CLAUDE.md` oder `settings.json` anfassen.

**Sprache:** Der Skilltext ist englisch, der Report deutsch (`0021`).

**Kaltstart:** Der Skill wird immer kalt betreten und trägt alles selbst
(`0016`).

## 5 · `sync-plugin-docs`: die Anforderungsliste als drittes abgeleitetes Dokument

Der Skill bleibt repo-lokal (`0018`). Die Liste liegt im selben Repo, also ist
kein Verweis aus einem Plugin-Skill nötig.

### 5.1 · Auslöser

Es kommt keiner hinzu. `requirements.md` liegt unter `plugin/skills/`, die
Skills, deren Änderungen die Liste betreffen, liegen dort ebenfalls, und genau
diesen Pfad beobachten der Hook und der `CLAUDE.md`-Block schon.

### 5.2 · Vergleichsbasis

Die Sweep-Basis bezieht künftig **alle drei** abgeleiteten Dokumente ein:

```bash
git log -1 --format=%H -- README.md plugin/NOTICE.md plugin/skills/dev/setup/requirements.md
```

Die feste erste Reportzeile lautet dann:

```
Basis: <sha> (Sweep seit letzter Pflege eines abgeleiteten Dokuments — unvollständig)
```

**Die Kosten:** Pflege an der Liste setzt jetzt auch das Fenster für README und
NOTICE zurück. Der blinde Fleck aus `0020` wird dadurch größer, entsteht aber
nicht neu. Eine eigene Basis je Dokument wäre genauer, bräuchte aber drei
Basiszeilen und drei Gütestufen im Report. Das ist für einen Fall, den die
Branch-Basis ohnehin vollständig abdeckt, zu viel Aufwand. Die Branch-Basis
selbst bleibt unverändert. Festgehalten in `0027`.

### 5.3 · Neue Zeilen in der Quellenliste

| Fakt | Quelle | Verdikt |
|---|---|---|
| Ein Skill kommt in eine Zeile, in der er noch nicht steht | Treffer einer *Signature* in einer **hinzugefügten** Zeile im Verzeichnis des Skills | **ask**, *Gemeldet*: Der Befund nennt Zeile, Skill und Fundstelle und sagt, dass zwischen *Mandatory for* und *Optional for* zu wählen ist |
| In welche der beiden Spalten er gehört | **keine** | **ask**, *Gemeldet* (derselbe Befund) |
| Ein Skill fällt aus einer Zeile heraus | Treffer in einer **entfernten** Zeile, und im Verzeichnis des Skills bleibt kein Treffer **irgendeiner** Zeichenfolge dieser *Signature* übrig (bleibt `pip`, obwohl `python` wegfiel, bleibt der Skill) | **ask**, *Zu übernehmen*: `neu:` ist die Zelle ohne den Skill |
| Ein gelöschter Skill verschwindet aus allen Zeilen | Verzeichnis unter `plugin/skills/` | **write** |
| Ein umbenannter Skill | `name:` | **write** |
| `allowed-tools` nennt ein `mcp__<server>__`, das keine Zeile als *Signature* führt | Frontmatter | **report** |
| Eine Zeile führt keinen Skill mehr | abgeleitet aus den beiden Spalten | **report**, nie still löschen, weil *Check* und *Install* keine Quelle haben |
| *Requirement*, *Kind*, *Check*, *Install*, *Needs*, *Signature* | **keine** | nie angefasst |

**Warum das Hinzukommen unter *Gemeldet* landet und nicht unter *Zu
übernehmen*:** Die Änderung liefert die Zeile, nicht die Spalte. Zwei Kandidaten
ohne Regel sind derselbe Fall wie die Wahl der `dev`-Gruppe für einen neuen
Skill, und die meldet `sync-plugin-docs` schon heute, statt einen Wert zu
erfinden (§7 des Skills). Beim Herausfallen dagegen steht der neue Wert fest.

**Warum ein Signatur-Treffer nur *ask* ergibt und nicht *write*:** Ein Treffer
belegt die Zeichenfolge, nicht die Abhängigkeit. `npm test` in einem
TDD-Beispiel und `flow-node` in einem HTML-Template treffen genauso (`0027`).
Der Vorschlag ist billig und kommt selten, ein still eingetragener Beispielcode
dagegen wäre falsch und fiele nicht auf.

**Der Setup-Skill selbst ist von der Suche ausgenommen.** Seine
`requirements.md` enthält jede *Signature* per Konstruktion, und sein
`SKILL.md` nennt `powershell.exe`, `winget` und `claude mcp`. Ohne die Ausnahme
würde jede Pflege am Setup-Skill vorschlagen, `setup` in fast jede Zeile
aufzunehmen. Seine eigenen Voraussetzungen sind keine Zeilen der Liste:

- Git Bash und `powershell.exe` sind auf jeder Maschine mit Claude Code unter
  Windows vorhanden.
- `winget` prüft der Skill in Schritt 2 selbst.
- `claude` bringt Claude Code mit.

**Nur in Hunks des Diffs suchen, nicht im ganzen Skill.** Sonst meldet jeder
Lauf den Altbestand erneut. Einzige Ausnahme ist die Restprüfung beim
Herausfallen: Ob noch ein Treffer übrig bleibt, entscheidet das ganze
Verzeichnis.

### 5.4 · Sicherheitsnetz und Report

- Das Sicherheitsnetz sucht den Skillnamen zusätzlich in `requirements.md`.
- `Betroffen:`, `Geändert:` und `Sicherheitsnetz:` nennen die Datei, sobald sie
  betroffen ist, im selben Format wie bei README und NOTICE.
- Die Frontmatter-`description` und der Einleitungsabsatz von
  `sync-plugin-docs` nennen die Liste als drittes Dokument.

### 5.5 · Bekannte Lücke

Eine **neue** Anforderung ohne *Signature* ist unsichtbar. Ruft ein Skill ein
Programm auf, das die Liste nicht kennt, gibt es nichts, wonach sich suchen
ließe. Teilweise abgedeckt ist nur der MCP-Fall über `allowed-tools`. Die Lücke
ist in `0027` festgehalten und wird hier nicht behoben.

## 6 · Kaltstart

`setup` wird immer kalt betreten. `sync-plugin-docs` ebenfalls, und es trägt
die neuen Zeilen der Quellenliste, die Signatur-Regel und die Falle
„Beispielcode trifft" selbst (`0016`).

## 7 · Begleitarbeit

1. **Projekt-`CLAUDE.md`, Abschnitt *Abgeleitete Dokumente*:** Er nennt die
   Anforderungsliste als drittes abgeleitetes Dokument.
2. **Hook `check-plugin-docs.sh`:** Der Text der Rückfrage nennt die
   Anforderungsliste mit. Die Pfadlogik bleibt, wie sie ist, weil der Pfad
   schon abgedeckt ist.
3. **`README.md`, *Installation*:** Nach `/plugin install` folgt ein Satz, der
   `/smax:setup` als nächsten Schritt nennt. Das ist Prosa ohne Quelle, also
   Handarbeit. Die Zeilen in §2.1 und §5 zieht `sync-plugin-docs` nach.
4. **`TODOS.md` 2.4** wird nach der Umsetzung gestrichen. Die Unterpunkte sind
   mit dieser Spec schon entfallen, und bis dahin verweist der Eintrag auf sie.

**Nicht Teil dieser Spec**, bei der Bestandsaufnahme gefunden und in
`TODOS.md` eingetragen (5.11, 5.12): `sync-solution-items.ps1` fehlt ein
`#Requires -Version 7` (bzw. ein BOM), und in `writing-plans` bricht
`git add … 2>/dev/null` still ab, sobald ein Pathspec nicht existiert.

## 8 · Abnahme

Die Abnahmefälle fährt Smax selbst. Der Plan beschreibt je Fall die
Ausgangslage und wie sie sich herstellen und wieder aufräumen lässt.

**`setup`:**

| Fall | erwartet |
|---|---|
| Alles vorhanden | „Alles vorhanden." samt Tabelle, keine Frage, kein winget-Aufruf |
| Nur eine optionale Anforderung fehlt (Graphviz, auf der Dev-Maschine der Ist-Zustand), Antwort „keine" | Report nennt sie unter *optional* mit `writing-skills`; nach „keine" ändert sich nichts, und der Schlussreport führt sie als *fehlt* |
| Wie zuvor mit „keine", danach ein zweiter Lauf | Graphviz wird erneut angeboten; ohne Bestätigung ändert sich nichts |
| Dieselbe, Antwort „1" | winget installiert, die Nachprüfung im selben Aufruf findet `dot`, Neustart-Hinweis erscheint; **ein zweiter Lauf meldet „Alles vorhanden."** |
| `python` löst auf den Store-Alias auf | *fehlt*, nicht *vorhanden* |
| Playwright MCP gewählt, Node fehlt und ist nicht gewählt | Rückfrage nach der Abhängigkeit, keine Installation von Playwright gegen fehlendes Node |
| winget fehlt | vollständiger Prüf-Report, keine Installationsfrage, Hinweis auf „App Installer" |
| Nicht-Windows | eine Zeile, Abbruch. Nur per Review prüfbar |

**`sync-plugin-docs`:**

| Fall | erwartet |
|---|---|
| Ein Skill bekommt eine Zeile `npx foo` | *Gemeldet*: Der Skill trifft die Node-Signatur, die Spalte ist offen, und die Liste bleibt unverändert |
| `data-model-diagram` verliert seinen einzigen `python`-Aufruf | *Zu übernehmen*: `alt:` ist die Zelle mit dem Skill, `neu:` die Zelle ohne ihn |
| `setup/SKILL.md` oder `setup/requirements.md` ändert sich | kein Signatur-Befund, weil der Setup-Skill von der Suche ausgenommen ist |
| Ein `npm test`-Beispiel in `test-driven-development` ändert sich | kein Befund, weil die Node-Signatur `npm test` nicht trifft (`npx `, ` node `, `.cjs`, Shebang); ein Prosa-Treffer an anderer Stelle würde vorgelegt, und die Liste bliebe unverändert |
| `md-to-pdf` wird gelöscht | aus der Node-Zeile **still** entfernt; die Zeile führt danach nur noch optionale Nutzer, und es gibt keine Meldung, weil sie nicht leer ist. `setup` führt Node trotzdem als Pflicht, weil Playwright MCP es unter *Needs* nennt |
| `data-model-diagram` und `whats-for-lunch` werden beide gelöscht | beide still entfernt, Playwright- und Python-Zeile unter *Gemeldet* als ohne Skill |
| `whats-for-lunch` wird umbenannt | in der Playwright-Zeile still ersetzt |
| `allowed-tools` bekommt `mcp__chrome-devtools__*` | *Gemeldet*: MCP-Server ohne Zeile in der Liste |
| Ein Skill ruft einen unbekannten Befehl auf, für den keine *Signature* existiert | kein Befund. Das ist der dokumentierte Fall der Lücke und kein Fehlschlag |
| Nur `requirements.md` wird gepflegt, auf `main` | die Sweep-Basis ist dieser Commit, die erste Zeile hat den neuen Wortlaut |
