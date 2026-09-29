# `setup` Implementation Plan

**Erstellt:** 29.09.2026

> **For agentic workers:** REQUIRED SUB-SKILL: Use smax:subagent-driven-development (recommended) or smax:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ein Command `/smax:setup`, der auf Windows prüft, ob alle Anforderungen der `smax`-Skills erfüllt sind, und Fehlendes nach Bestätigung per winget bzw. `claude mcp add` installiert. Dazu kommt eine Erweiterung von `sync-plugin-docs`, die die Anforderungsliste vor Drift schützt.

**Architecture:** Der Plugin-Skill `plugin/skills/dev/setup/` besteht aus zwei Dateien. `requirements.md` ist die Anforderungsliste, eine Tabelle mit einer Zeile je Anforderung, deren Reihenfolge die Installationsreihenfolge ist. `SKILL.md` ist der Ablauf. Jeder Prüf- und Installationsbefehl läuft als temporäre `.ps1` unter Windows PowerShell 5.1, gestartet aus dem Bash-Tool. Der repo-lokale Skill `sync-plugin-docs` behandelt die Liste als drittes abgeleitetes Dokument: Signatur-Treffer in Diff-Hunks werden gemeldet oder vorgelegt, gelöschte oder umbenannte Skills still nachgezogen. **Skilltexte sind englisch, Ausgaben deutsch** (`0021`).

**Tech Stack:** Markdown (`SKILL.md`, `requirements.md`), Git Bash, Windows PowerShell 5.1, winget, `claude mcp`, `git`, `grep`. Kein Build.

**Spec:** `docs/01_Specs/Setup/SPEC-Setup-29092026.md`

## Global Constraints

- **Terminology is defined in `CONTEXT.md`.** Namen in Skilltexten, Report-Texten und Commit-Messages benutzen den kanonischen Begriff: *Anforderung* (`Requirement`), *Optionale Anforderung* (`OptionalRequirement`), *Pflicht-Anforderung* (`MandatoryRequirement`), *Anforderungsliste* (`RequirementList`), *Signatur* (`Signature`), *Abgeleitetes Dokument*, *Drift*, *Quelle*, *Quellenliste*, *Verdikt*, *Sicherheitsnetz*. Im englischen Skilltext steht der Code-Name (`requirement`, `requirement list`, `signature`), nicht die eigene Übersetzung (`0022`). Was unter `_Avoid_` steht, darf nicht auftauchen, insbesondere nicht „dependency" oder „prerequisite" für eine Anforderung und nicht „pattern" für eine Signatur. Ein fehlender Begriff kommt ins Glossar und wird nicht im Text erfunden.
- **Nur Windows** (Spec §4.1). Der Skill bricht auf anderen Plattformen mit einer Zeile ab.
- **Jeder Befehl läuft als temporäre `.ps1` unter `powershell.exe` 5.1** (Spec §3). Die Datei ist reines ASCII, beginnt mit `$ErrorActionPreference = 'Stop'` und endet mit `exit $LASTEXITCODE`. Weder `-File -` (stdin) noch das PowerShell-Tool noch `pwsh`.
- **Installationsaufrufe laufen mit Bash-Timeout 600000 ms.**
- **Ausführung auf einem Feature-Branch**, nicht auf `main`. Spec, Plan, Glossar und die Decisions `0027` und `0028` sind mit dem Design-Commit schon auf `main` und damit in jedem Worktree vorhanden. Alle Pfade in diesem Plan sind **relativ zur Wurzel des Arbeitsbaums**: Jeder Bash-Block beginnt mit `cd "$(git rev-parse --show-toplevel)"`, und jeder Subagent-Prompt nennt als Repository den absoluten Pfad dieser Wurzel, den der Implementer beim Dispatch einsetzt (`git rev-parse --show-toplevel`, per `cygpath -w` in Windows-Schreibweise).
- **`docs/decisions/0027-requirement-list-central-guarded-by-sync.md`** bindet: Die Liste steht zentral in `setup/requirements.md`. Anforderungen stattdessen je Skill im Frontmatter zu deklarieren ist ein Defekt. Ein Signatur-Treffer wird nie still eingetragen, und der Setup-Skill ist von der Signatur-Suche ausgenommen.
- **`docs/decisions/0028-setup-windows-only-via-winget.md`** bindet: Jede Installation wird bestätigt. Ein „fehlt nur ein optionales Tool, installiere ich gleich mit" ist ein Defekt, ebenso macOS- oder Linux-Zweige.
- **`docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`** bindet: `setup` (ein Plugin-Skill) nennt `sync-plugin-docs` nicht und verweist nicht auf `.claude/skills/`. Der Hinweis, wer die Spalten pflegt, lautet „maintained by the plugin repo's documentation check", ohne Pfad.
- **`docs/decisions/0019-write-sourced-present-the-rest.md`** bindet: Was keine Quelle hat, schreibt `sync-plugin-docs` nicht still. Das gilt für Pflicht/optional, *Check*, *Install*, *Needs* und *Signature*.
- **`docs/decisions/0025-company-skills-in-separate-plugin.md`** bindet: Das Repo ist öffentlich. Keine Kundennamen, internen Hosts oder Firmenadressen, und nichts zum SecretStore.

---

## File Structure

| Datei | Verantwortung |
|---|---|
| `plugin/skills/dev/setup/requirements.md` | **neu.** Die Anforderungsliste, Daten ohne Ablauf |
| `plugin/skills/dev/setup/SKILL.md` | **neu.** Der Ablauf, der die Liste liest, prüft, berichtet, bestätigen lässt und installiert |
| `.claude/skills/sync-plugin-docs/SKILL.md` | **ändern.** Die Liste wird drittes abgeleitetes Dokument |
| `.claude/hooks/check-plugin-docs.sh` | **ändern.** Nur der Text der Rückfrage |
| `CLAUDE.md` | **ändern.** Abschnitt *Abgeleitete Dokumente* |
| `README.md` | **ändern.** Satz unter *Installation*; die Zeilen für `setup` zieht `sync-plugin-docs` nach |
| `plugin/NOTICE.md` | **ändern.** `setup` unter *No upstream origin → Created afterwards*, gesetzt über `sync-plugin-docs` |
| `TODOS.md` | **ändern.** 2.4 wird nach der Abnahme gestrichen |

Die Liste steht in einer eigenen Datei und nicht in `SKILL.md`, damit `sync-plugin-docs` genau eine Zieldatei hat und nie den Ablaufteil anfasst.

---

### Task 1: Der Skill `setup`

**Files:**
- Create: `plugin/skills/dev/setup/requirements.md`
- Create: `plugin/skills/dev/setup/SKILL.md`

**Interfaces:**
- Produces: `plugin/skills/dev/setup/requirements.md` mit genau diesen Spaltenüberschriften in dieser Reihenfolge: `Requirement | Kind | Check | Install | Needs | Signature | Mandatory for | Optional for`. Task 2 adressiert die Spalten *Mandatory for* und *Optional for* über diese Namen, und die Signaturen stehen in der Spalte *Signature* als kommagetrennte Code-Spans.

- [ ] **Step 1: Baseline, bevor etwas existiert**

Den Ist-Zustand auf der Entwicklungsmaschine festhalten. Er ist der Erwartungswert für Step 5.

```bash
ps1=$(mktemp --suffix=.ps1)
cat > "$ps1" <<'PSEOF'
$ErrorActionPreference = 'Stop'
foreach ($c in 'git','pwsh','node','npx','python','gh','dot','winget','claude') {
  $cmd = Get-Command $c -ErrorAction SilentlyContinue
  if ($cmd) { Write-Output ("{0,-7} {1}" -f $c, $cmd.Source) } else { Write-Output ("{0,-7} (missing)" -f $c) }
}
exit 0
PSEOF
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ps1")"; rc=$?; rm -f "$ps1"; echo "rc=$rc"
claude mcp get playwright | grep -i status
```

Erwartet auf Smax' Maschine (Stand 29.09.2026, vom Plan-Reviewer nachgemessen): Alles ist vorhanden außer **`gh` und `dot`**, und Playwright meldet `Connected`. **Die fehlenden Zeilen aus diesem Schritt heißen im Folgenden „die Baseline-Lücken".** Step 5, Step 6 und die Abnahme richten sich nach ihnen und nicht nach der Aufzählung hier. Weicht der Ist-Zustand ab, gilt der Ist-Zustand.

- [ ] **Step 2: `requirements.md` anlegen**

Inhalt exakt, reines ASCII bis auf die bestehenden Skillnamen (die sind ASCII):

````markdown
# Requirements

Everything the `smax` skills need on the machine that the plugin does not ship:
programs on `PATH` and MCP servers. `setup` reads this file. The columns
*Mandatory for* and *Optional for* are derived from the skill inventory and
maintained by the plugin repo's documentation check. **Keep the column names and
their order as they are.**

- **Row order is install order.** A row named under *Needs* stands above the row
  that needs it.
- **Check** passes when the command exits with 0 **and** the criterion after the
  arrow holds.
- Every *Check* and *Install* runs under Windows PowerShell 5.1 as described in
  `SKILL.md`, "Running a command". Keep them ASCII and single-line; a multi-step
  install lives under "Install details" below.
- **Mandatory for** lists skills that fail without the requirement, **Optional
  for** skills that only lose an optional step. Only direct use counts: a skill
  that calls another skill which needs the requirement is not listed.

| Requirement | Kind | Check | Install | Needs | Signature | Mandatory for | Optional for |
|---|---|---|---|---|---|---|---|
| Git for Windows | program | `git --version` -> starts with `git version` | `winget install -e --id Git.Git` | - | `git add`, `git commit`, `git diff`, `git log`, `git status`, `git rev-parse`, `git merge-base`, `git worktree`, `git check-ignore`, `#!/usr/bin/env bash`, `nano` | code-review, commitMessage, finishing-a-development-branch, nano-vs-colors, proad-job-report, subagent-driven-development, using-git-worktrees, writing-plans | brainstorming, debugging, handoff, sync-solution-items |
| PowerShell 7 | program | `pwsh -NoProfile -Command '$PSVersionTable.PSVersion.Major'` -> an integer of 7 or more | `winget install -e --id Microsoft.PowerShell` | - | `pwsh`, `#Requires -Version 7` | sync-solution-items | - |
| Node.js LTS | program | `node --version` -> starts with `v`, then `npx --version` -> exits 0 | `winget install -e --id OpenJS.NodeJS.LTS` | - | `npx `, ` node `, `.cjs`, `#!/usr/bin/env node` | md-to-pdf | brainstorming, writing-skills |
| Python 3 | program | `python --version` -> starts with `Python 3.` | `winget install -e --id Python.Python.3.14` | - | `python `, `py -`, `pip ` | data-model-diagram | - |
| Playwright MCP | mcp | `claude mcp get playwright` -> output contains `Connected` | `claude mcp add --scope user playwright -- cmd /c npx -y @playwright/mcp@latest --browser msedge` | Node.js LTS | `mcp__playwright__`, `Playwright` | data-model-diagram, whats-for-lunch | - |
| GitHub CLI | program | `gh --version` -> starts with `gh version` | `winget install -e --id GitHub.cli` | - | `gh api`, `gh pr`, `gh issue` | - | code-review |
| Graphviz | program | `dot -V` -> exits 0 | see "Install details: Graphviz" | - | `dot -T`, `which dot`, `graphviz` | - | writing-skills |

## Install details

### Graphviz

The NSIS installer does not put `dot` on `PATH` when it runs silently. Append
its `bin` directory to the **user** `PATH` if `dot.exe` is there and the entry is
missing. The install confirmation covers this `PATH` change; name it in the
confirmation list.

```powershell
winget install -e --id Graphviz.Graphviz --accept-source-agreements --accept-package-agreements --disable-interactivity
$installRc = $LASTEXITCODE
$bin = 'C:\Program Files\Graphviz\bin'
$userPath = [Environment]::GetEnvironmentVariable('Path','User')
if ($null -eq $userPath) { $userPath = '' }
if ((Test-Path (Join-Path $bin 'dot.exe')) -and -not (($userPath -split ';') -contains $bin)) {
  [Environment]::SetEnvironmentVariable('Path', ($userPath.TrimEnd(';') + ';' + $bin).TrimStart(';'), 'User')
}
```

## Traps

- **The Python alias from the Store.** A fresh Windows has a placeholder
  `python.exe` under `%LOCALAPPDATA%\Microsoft\WindowsApps` that opens the Store
  or prints nothing. `Get-Command python` finds it. Only the output
  `Python 3.x` counts as present.
- **`npx` servers on native Windows** do not connect when started directly;
  they need `cmd /c`. That is why the Playwright install wraps it.
- **An existing `playwright` entry with other arguments** (for example the
  Chrome channel) is left alone as long as it reports `Connected`.
````

Anmerkung für den Implementer: Die Signatur-Strings mit führendem bzw. nachgestelltem Leerzeichen (`npx `, ` node `, `python `, `pip `) sind Absicht. So trifft ` node ` nicht mehr das `flow-node` im HTML von `infographic-page`. Die Leerzeichen bleiben in den Code-Spans stehen.

Verifiziert am 29.09.2026: Zwei Einträge haben heute **keinen** Signatur-Treffer in ihrem Skill-Verzeichnis. `proad-job-report` liest den Commit, ohne einen `git`-Befehl zu nennen, und `sync-solution-items` ruft sein Skript auf, ohne `pwsh` zu nennen (bis `TODOS.md` 5.11 ein `#Requires -Version 7` bringt). Beide sind Handeinträge aus der Bestandsaufnahme. Sie bleiben stehen, denn Herausfallen verlangt einen entfernten Treffer, und den kann es nicht geben. Das ist gewollt und kein Fehler der Liste.

- [ ] **Step 3: `SKILL.md` anlegen**

Inhalt exakt:

````markdown
---
name: setup
description: Checks whether this machine has everything the smax skills need that the plugin does not ship - programs on PATH and MCP servers - and installs what is missing after confirmation. Windows only.
disable-model-invocation: true
---

# Setup

The plugin ships skill directories and nothing else. What the skills call -
`git`, `node`, `python`, a Playwright MCP server - has to be on the machine
already, and on a fresh machine that shows only when a skill fails halfway
through. This skill checks every requirement in one pass and installs what is
missing, **each installation confirmed by the user**.

The requirements live in [requirements.md](requirements.md) next to this file.
Read it first; it is the only list. Never install anything that is not a row
there.

**Your output is German** - it is read by the user. This text is English.

## Never

- install without a confirmation that names the row's number
- update or uninstall software that is already there
- touch `~/.claude/CLAUDE.md`, `~/.claude/settings.json` or any project file
- install a row whose *Needs* row is missing and not installed in this run
- retry a failed installation within the same run

## Running a command

Every *Check* and every *Install* runs as a temporary script under **Windows
PowerShell 5.1**, started from the **Bash tool**:

```bash
ps1=$(mktemp --suffix=.ps1)
cat > "$ps1" <<'PSEOF'
$ErrorActionPreference = 'Stop'
<the commands>
exit $LASTEXITCODE
PSEOF
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ps1")"; rc=$?; rm -f "$ps1"; echo "rc=$rc"
```

Why exactly this and nothing else:

- **Git Bash and `powershell.exe` exist on every Windows machine that runs
  Claude Code.** The PowerShell tool may be 5.1, `pwsh` or disabled, and `pwsh`
  itself may be one of the missing requirements - a check that needs it would
  hide the gap it is meant to report.
- **A file, not stdin.** With `-File -` PowerShell reads interactively: a
  statement spanning two lines swallows every line after it, and the process
  still exits 0.
- **`$ErrorActionPreference = 'Stop'` as the first line.** Without it a
  command that does not exist at all - `dot` on a machine without Graphviz -
  prints an error and the script still exits 0, so a missing requirement would
  pass its check.
- **`exit $LASTEXITCODE` as the last line.** Without it `powershell.exe -File`
  exits 0 even when the last native command failed.
- **The quoted `'PSEOF'`** keeps Bash from expanding `$` inside the script.
- **ASCII only inside the script.** 5.1 reads a UTF-8 file without BOM as
  cp1252.
- **Never `2>&1` on a native command.** Under `Stop`, 5.1 turns every redirected
  stderr line into a terminating error. `dot -V` prints its version to stderr,
  so an installed Graphviz would fail its check.

## 1 - Platform

```bash
echo "$OS"
```

Anything other than `Windows_NT`: output exactly `Nur Windows wird unterstützt.`
and stop. No check, no report. This one command runs directly in Bash - the
PowerShell route does not exist off Windows.

## 2 - winget

Run `winget --version` as described in "Running a command". If it fails, carry
on with step 3 and the report, but **install nothing**: the report ends with the
line `winget fehlt - "App Installer" aus dem Microsoft Store installieren, dann
/smax:setup erneut.` and no confirmation list.

## 3 - Check

Every row of `requirements.md`, **in row order**. One script per row, the row's
*Check* as its body. A row is:

- **vorhanden** - exit code 0 and the criterion after the arrow holds. Note the
  version if the output shows one.
- **fehlt** - anything else.

## 4 - Report

A row is **Pflicht** if its *Mandatory for* column names a skill, **or** a
Pflicht row names it under *Needs*. Otherwise it is **optional**. So Node.js
stays Pflicht while Playwright MCP is Pflicht, even if no skill calls `npx`
directly.

All rows, in row order:

```
Setup - 7 Anforderungen geprüft

| Anforderung | Status | Art | Braucht es |
|---|---|---|---|
| Git for Windows | vorhanden (2.55.0) | Pflicht | |
| Graphviz | fehlt | optional | writing-skills |
```

*Braucht es* is filled only for missing rows: *Mandatory for* and *Optional for*
together.

**Nothing missing:** the report's first line is `Alles vorhanden.`, the table
follows, and the run ends. No question, no installation. A second run after
every installation was accepted ends here - that is what makes the skill safe to
run again.

## 5 - Confirm

Below the table, the missing rows as a numbered list **in row order**, which is
also the install order:

```
Fehlt (2):
  1  Python 3 (Pflicht) - winget Python.Python.3.14
  2  Graphviz (optional) - winget Graphviz.Graphviz, danach Graphviz\bin an den Benutzer-PATH

Installieren? Nummern ("1 2"), "alle" oder "keine".
winget öffnet für maschinenweite Pakete ein UAC-Fenster - bitte bestätigen.
```

Read the answer strictly:

- **Numbers** mean those rows and no others.
- **`alle`** means every listed row, optional ones included.
- **`keine`** means none; go to step 7.
- Anything else: ask which rows are meant. Never install on a guess.

**Needs check before installing:** a chosen row whose *Needs* row is missing and
not chosen - ask whether to add the *Needs* row or drop the row that needs it. Do not
install against a missing base.

## 6 - Install

Chosen rows, in row order. One Bash call per row, **timeout 600000 ms**. The
script installs, refreshes `PATH` and re-checks in the same process - every tool
call and every `powershell.exe` inherits the `PATH` of the running Claude Code
process, which does not know the new program yet, so a re-check without the
refresh reports every successful install as a failure:

```powershell
$ErrorActionPreference = 'Stop'
<the row's Install; for winget append --accept-source-agreements --accept-package-agreements --disable-interactivity>
$installRc = $LASTEXITCODE
Write-Output ("install=" + $installRc)
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
Write-Output '--- check'
<the row's Check>
exit $LASTEXITCODE
```

For a row whose *Install* says "see Install details", the block there replaces
the install line and the `$installRc` line.

`install=` is printed **before** the check on purpose: if the program is still
not found, `Stop` ends the script at the check line, and the installer's exit
code would otherwise be lost.

Judge the result by the **check**, not by the installer's exit code:

- check passes -> **installiert**
- check fails, winget said the package is already installed -> **installiert,
  aber nicht im PATH**. Do not retry.
- check fails otherwise -> **fehlgeschlagen**, with `install=<code>` and the last
  line of the installer output.

A failure does not stop the run. Skip only rows whose *Needs* row just failed,
and report them as **übersprungen**.

## 7 - Final report

```
Installiert (1)
  Python 3 - 3.14.7

Fehlgeschlagen (0)

Weiterhin fehlend (1)
  Graphviz (optional) - abgelehnt

Claude Code neu starten: Die laufende Sitzung sieht weder den neuen PATH noch
einen neu registrierten MCP-Server.
```

Leave out empty sections. The restart line appears only if anything was
installed. A row the user declined stays under *Weiterhin fehlend* with
`abgelehnt`; the next run offers it again - this skill keeps no state.
````

- [ ] **Step 4: Frontmatter und Signaturen mechanisch prüfen**

```bash
cd "$(git rev-parse --show-toplevel)"
head -5 plugin/skills/dev/setup/SKILL.md
grep -c '^| ' plugin/skills/dev/setup/requirements.md
grep -n 'sync-plugin-docs\|\.claude/skills' plugin/skills/dev/setup/*.md
LC_ALL=C grep -n "[^ -~$(printf '\t')]" plugin/skills/dev/setup/requirements.md
```

Erwartet:
- Frontmatter mit `name: setup` und `disable-model-invocation: true`.
- `8` Zeilen (Kopf und 7 Anforderungen; der Trenner beginnt mit `|-` und zählt nicht).
- **kein** Treffer für `sync-plugin-docs` oder `.claude/skills`, sonst Verstoß gegen `0018`.
- **kein** Nicht-ASCII-Treffer in `requirements.md`.

- [ ] **Step 5: Jede *Check*-Zeile einzeln ausführen**

Für jede der sieben Zeilen das Skript aus „Running a command" mit dem *Check* der Zeile als Body. Beispiel für die Zeile Node.js:

```bash
ps1=$(mktemp --suffix=.ps1)
cat > "$ps1" <<'PSEOF'
$ErrorActionPreference = 'Stop'
node --version
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
npx --version
exit $LASTEXITCODE
PSEOF
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ps1")"; rc=$?; rm -f "$ps1"; echo "rc=$rc"
```

Erwartet: Das Ergebnis stimmt mit der Baseline aus Step 1 überein. Genau die Baseline-Lücken sind *fehlt* (`rc` ungleich 0 oder Kriterium verfehlt), alle anderen Zeilen *vorhanden*. Weicht eine Zeile ab, obwohl das Programm laut Baseline vorhanden ist, ist *Check* falsch. Dann die Zeile korrigieren und nicht die Erwartung.

**Store-Alias-Probe**, falls `ls "$LOCALAPPDATA/Microsoft/WindowsApps/python.exe"` existiert:

```bash
ps1=$(mktemp --suffix=.ps1)
cat > "$ps1" <<'PSEOF'
$ErrorActionPreference = 'Stop'
& "$env:LOCALAPPDATA\Microsoft\WindowsApps\python.exe" --version
exit $LASTEXITCODE
PSEOF
timeout 20 powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ps1")"; rc=$?; rm -f "$ps1"; echo "rc=$rc"
```

Erwartet: Die Ausgabe beginnt **nicht** mit `Python 3.` (leer oder ein Store-Hinweis), also würde das Kriterium *fehlt* ergeben. Existiert der Alias nicht, entfällt die Probe; das im Task-Report vermerken.

- [ ] **Step 6: Trockenlauf durch einen fremden Agenten**

Einen `general-purpose`-Subagenten dispatchen, one-shot und ohne Namen. Er ist nicht der Autor. Prompt:

> Read `<ROOT>\plugin\skills\dev\setup\SKILL.md` and `requirements.md` next to it (`<ROOT>` = the working-tree root, see Global Constraints), and follow the skill exactly, as if the user had typed `/smax:setup`. Run steps 1 to 5. At step 5, do **not** install anything: stop after printing the confirmation list and treat the answer as `keine`, then produce the final report of step 7. Your final message is the complete German output the user would have seen, verbatim, followed by a list of every command you ran.

Erwartet:
- Die Tabelle nennt alle sieben Zeilen in Listenreihenfolge.
- Genau die Baseline-Lücken sind *fehlt*, jede mit *Art* und *Braucht es* laut Liste. Beim Stand von Step 1 sind das GitHub CLI (*optional*, `code-review`) und Graphviz (*optional*, `writing-skills`).
- Die Bestätigungsliste nummeriert die Baseline-Lücken in Listenreihenfolge, also `1  GitHub CLI (optional) …` und `2  Graphviz (optional) …` samt `PATH`-Hinweis.
- Der Schlussreport nennt nur *Weiterhin fehlend* mit allen Baseline-Lücken als `abgelehnt` und **keine** Neustart-Zeile.
- Jeder ausgeführte Befehl außer `echo "$OS"` in Schritt 1 lief über `powershell.exe -File` einer temporären `.ps1`, nicht über das PowerShell-Tool und nicht über `-File -`.
- **Kein** `winget install` in der Befehlsliste.

Weicht etwas ab, `SKILL.md` korrigieren und den Trockenlauf mit einem **neuen** Agenten wiederholen.

- [ ] **Step 7: Commit**

```bash
git add plugin/skills/dev/setup/
git commit -m "feat(setup): Anforderungen der Skills pruefen und nach Bestaetigung installieren"
```

---

### Task 2: `sync-plugin-docs` pflegt die Anforderungsliste

**Files:**
- Modify: `.claude/skills/sync-plugin-docs/SKILL.md` (frontmatter l.3, intro l.8-18, §1 l.28-60, §2 after l.170, §3 table l.186-206, §4 l.274-331, §6 l.390-395, §7 l.518-560, Report l.604-695)
- Modify: `.claude/hooks/check-plugin-docs.sh` (letzte Zeile, Text der Rückfrage)
- Modify: `CLAUDE.md` (Abschnitt *Abgeleitete Dokumente*)

**Interfaces:**
- Consumes: `plugin/skills/dev/setup/requirements.md` aus Task 1, mit den Spalten *Signature*, *Mandatory for* und *Optional for*.
- Produces: `sync-plugin-docs` meldet und schreibt Befunde zur Liste in denselben drei Report-Abschnitten wie bisher. Task 3 ruft den Skill auf.

Die Zeilenangaben gelten für den Stand vor diesem Task. Jede Stelle wird über ihren Ankertext gefunden, nicht über die Zeilennummer.

- [ ] **Step 1: Baseline-Befund festhalten (RED)**

Eine synthetische Änderung erzeugen, die eine neue Signatur trifft, und den **unveränderten** Skill darauf laufen lassen:

```bash
cd "$(git rev-parse --show-toplevel)"
printf '\nFor a quick preview, run `npx serve .` in the output folder.\n' >> plugin/skills/dev/infographic-page/SKILL.md
```

Einen `general-purpose`-Subagenten dispatchen, one-shot und ohne Namen, mit diesem Prompt:

> Read `<ROOT>\.claude\skills\sync-plugin-docs\SKILL.md` and follow it exactly in the repository `<ROOT>`. Do not commit. Your final message is the complete report, verbatim.

`<ROOT>` ersetzt der Implementer beim Dispatch durch den absoluten Windows-Pfad der Wurzel des Arbeitsbaums (Global Constraints).

Erwartet: Der Report enthält **keinen Befund zur Anforderungsliste**, also keinen Eintrag, der eine Zeile oder Spalte von `requirements.md` behandelt. Dass `requirements.md` unter `Betroffen:` steht und README-Befunde zum neuen Skill `setup` auftauchen, ist in Ordnung: Task 1 hat ihn committet. **Diese `setup`-Befunde sind in Step 1, 6, 7 und 8 Rauschen und werden ignoriert**; Task 3 arbeitet sie ab. Den Report im Task-Report festhalten. Die synthetische Zeile bleibt für Step 6 stehen, und etwaige Schreibvorgänge des Subagenten an README oder NOTICE werden **zurückgesetzt**:

```bash
git checkout -- README.md plugin/NOTICE.md
```

- [ ] **Step 2: Frontmatter, Einleitung, §1**

Frontmatter `description:` ersetzen durch:

```
description: Checks whether README.md, plugin/NOTICE.md and the setup skill's requirement list still match the skill inventory after changes under plugin/skills/, and brings them up to date. Use before committing whenever something under plugin/skills/ or plugin/.claude-plugin/ has changed.
```

Den ersten Absatz nach `# Sync Plugin Docs` (beginnt mit „`README.md` and `plugin/NOTICE.md` are derived from the skill inventory.") ersetzen durch:

```markdown
`README.md`, `plugin/NOTICE.md` and the requirement list
`plugin/skills/dev/setup/requirements.md` are derived from the skill inventory.
Change a skill without updating them and the documentation is silently wrong: no
error, no warning, just a false statement.
```

Im Absatz, der mit „Your report is written in German" beginnt, die zwei Zeilen

```
propose** for `README.md` or `plugin/NOTICE.md` is English: both documents are
English, and a proposal lands in them verbatim. The report around a proposal is
```

ersetzen durch

```
propose** for `README.md`, `plugin/NOTICE.md` or the requirement list is
English: all three documents are English, and a proposal lands in them verbatim.
The report around a proposal is
```

(Der Zeilenumbruch steht im Original nach „are"; ein Edit auf den einzeiligen Text trifft nicht.)

In §1:
- Tabellenzeile *On `main`…*: „that touched `README.md` or `plugin/NOTICE.md`" ersetzen durch „that touched one of the three derived documents".
- Den Befehl unter `# case 2` ersetzen durch:

```bash
git log -1 --format=%H -- README.md plugin/NOTICE.md plugin/skills/dev/setup/requirements.md
```

- Die zweite feste Reportzeile ersetzen durch:

```
Basis: <sha> (Sweep seit letzter Pflege eines abgeleiteten Dokuments — unvollständig)
```

- Direkt nach dem Absatz, der mit „**The sweep base has a known blind spot.**" beginnt, diesen Absatz einfügen:

```markdown
**The requirement list widens that blind spot, deliberately.** Maintaining the
list moves the sweep base too, so it resets the window for `README.md` and
`plugin/NOTICE.md` as well. One base per document would be exact, but it costs
three base lines and three coverage marks for a case the branch base already
covers completely (`docs/decisions/0027-requirement-list-central-guarded-by-sync.md`).
```

- [ ] **Step 3: §2, neuer Unterabschnitt nach „README second"**

Direkt vor `## 3 · The source list` einfügen:

````markdown
### Requirement list third — the trigger is *which lines* changed

`plugin/skills/dev/setup/requirements.md` says which skills need which
requirement. The column *Signature* holds the strings that give a requirement
away in a skill's directory; **the change's added and removed lines are
searched for them**, never the whole skill.

**Skip `plugin/skills/dev/setup/` entirely.** Its `requirements.md` contains
every signature by construction; searching it would propose `setup` for almost
every row.

Per affected skill other than `setup`:

```bash
git diff <base> -- plugin/skills/<group>/<name>/ | grep '^[+-]' | grep -v '^+++\|^---'
```

Untracked files of a new skill have no diff; read them whole and treat every
line as added.

For every row of the list, look for each string of its *Signature* — a literal
substring, case-sensitive, spaces included:

| What you find | Verdict | Section |
|---|---|---|
| a hit in an **added** line, and the skill is in neither *Mandatory for* nor *Optional for* of that row | **ask** | *Gemeldet* — name row, skill, file and line, and that *Mandatory for* or *Optional for* is the author's choice. No draft: two candidates and no rule |
| a hit in a **removed** line, the skill is in that row, and `grep -rnF` finds **no** string of the row's *Signature* left anywhere in the skill's directory | **ask** | *Zu übernehmen* — `alt:` the cell with the skill, `neu:` the cell without it |
| the skill's directory is **deleted** | **write** | *Geschrieben* — remove the name from every cell of the list |
| the skill is **renamed** (`name:`) | **write** | *Geschrieben* — replace the name in every cell |
| `allowed-tools:` names an `mcp__<server>__` prefix that no row's *Signature* carries | **report** | *Gemeldet* |
| after your writes a row names no skill in either column | **report** | *Gemeldet* — never delete the row: *Check* and *Install* have no source |

**A deleted or renamed skill directory is handled by the two write rows alone.**
Deleting a directory turns every one of its lines into a removed line, and a
rename does the same for the old path. Do not run the removed-line row for it -
that would put the same change under *Geschrieben* and *Zu übernehmen* at once.
The added-line and removed-line rows apply only to a skill whose directory
exists before and after the change under the same name.

**Never touch** *Requirement*, *Kind*, *Check*, *Install*, *Needs* or
*Signature*. They have no source outside the list.

**A hit is evidence, not proof.** `npm test` in a TDD example, `node` in
`flow-node`, `Playwright` in a sentence about testing — all hit. That is why
adding is never written. Expect prose hits; report them like any other, and let
the author say no.

**Known gap: a new requirement without a signature is invisible.** A skill that
starts calling a program the list does not know produces no hit, because there is
nothing to search for. That is decided, not an oversight
(`docs/decisions/0027-requirement-list-central-guarded-by-sync.md`).
````

- [ ] **Step 4: §3 Quellenliste, §4 Fallen, §6 Sicherheitsnetz**

In der Tabelle von §3 nach der Zeile `| §1 prose, §4 judgements, the satellite paragraphs, §6.x | **none** | **ask** |` einfügen:

```markdown
| Requirement list: a skill joins a row | *Signature* hit in an added line | **ask** → *Gemeldet* |
| Requirement list: *Mandatory for* or *Optional for* | **none** | **ask** → *Gemeldet* |
| Requirement list: a skill leaves a row | *Signature* hit in a removed line, none left in the directory | **ask** → *Zu übernehmen* |
| Requirement list: a deleted or renamed skill | directory / `name:` | **write** |
| Requirement list: an MCP server without a row | `allowed-tools:` | **report** |
| Requirement list: *Requirement*, *Kind*, *Check*, *Install*, *Needs*, *Signature* | **none** | never touched |
```

Den Absatz vor der Tabelle („Every fact in `README.md` and `plugin/NOTICE.md` either originates…") so ändern, dass er „Every fact in the three derived documents either originates…" lautet.

In §4 die Zeile „Ten places where the obvious reading is wrong." durch „Eleven places where the obvious reading is wrong." ersetzen. Nach Falle 10 anhängen:

```markdown
11. **In the requirement list, a hit on a signature is not a requirement.**
    `test-driven-development` runs `npm test` as an example of the *project's*
    test command; the skill itself needs no Node. And the setup skill's own
    files hit every row by construction, which is why `plugin/skills/dev/setup/`
    is skipped. A hit decides that something is worth asking about — never what
    the answer is.
```

In §6 den Befehl

```bash
grep -n "<skillname>" README.md plugin/NOTICE.md
```

an **beiden** Stellen (§6 und im Report-Abschnitt) ersetzen durch:

```bash
grep -n "<skillname>" README.md plugin/NOTICE.md plugin/skills/dev/setup/requirements.md
```

- [ ] **Step 5: Report-Felder, Hook, `CLAUDE.md`**

Den Befehl

```bash
git diff -U0 HEAD -- README.md plugin/NOTICE.md | grep '^@@'
```

an **beiden** Stellen (§7 *Before the report: read what you actually changed* und der Report-Abschnitt zu `Geändert:`) ersetzen durch:

```bash
git diff -U0 HEAD -- README.md plugin/NOTICE.md plugin/skills/dev/setup/requirements.md | grep '^@@'
```

In §7 den `neu:`-Leck-Check

```bash
git diff HEAD -- README.md plugin/NOTICE.md | grep '^+'
```

ersetzen durch:

```bash
git diff HEAD -- README.md plugin/NOTICE.md plugin/skills/dev/setup/requirements.md | grep '^+'
```

Ohne diese beiden Erweiterungen fiele ein still geschriebenes Herausfallen in `requirements.md` durch beide Kontrollen (`0019`).

Prüfen, dass keine Zweiliste mehr übrig ist:

```bash
grep -n 'README.md plugin/NOTICE.md' .claude/skills/sync-plugin-docs/SKILL.md
```

Erwartet: Jede Trefferzeile enthält auch `requirements.md`.

Im Report-Skelett die beiden Zeilen

```
Sicherheitsnetz: <gesuchter Name> — README.md <Zeile> <Abschnitt>, <Zeile> <Abschnitt>; plugin/NOTICE.md <Zeile> <Bucket>
Geändert: README.md <Hunk>, <Hunk>; plugin/NOTICE.md <Hunk>
```

ersetzen durch:

```
Sicherheitsnetz: <gesuchter Name> — README.md <Zeile> <Abschnitt>, <Zeile> <Abschnitt>; plugin/NOTICE.md <Zeile> <Bucket>; requirements.md <Zeile> <Anforderung>
Geändert: README.md <Hunk>, <Hunk>; plugin/NOTICE.md <Hunk>; requirements.md <Hunk>
```

In `.claude/hooks/check-plugin-docs.sh`, letzte `printf`-Zeile: „README.md und plugin/NOTICE.md sind daraus abgeleitet." ersetzen durch „README.md, plugin/NOTICE.md und die Anforderungsliste von setup sind daraus abgeleitet."

In `CLAUDE.md`, Abschnitt `## Abgeleitete Dokumente`, den ersten Satz

```
`README.md` und `plugin/NOTICE.md` sind aus dem Skill-Bestand abgeleitet und
laufen still auseinander, wenn sie nicht mitgezogen werden.
```

ersetzen durch:

```
`README.md`, `plugin/NOTICE.md` und die Anforderungsliste
`plugin/skills/dev/setup/requirements.md` sind aus dem Skill-Bestand abgeleitet
und laufen still auseinander, wenn sie nicht mitgezogen werden.
```

Hook-Syntax prüfen:

```bash
bash -n .claude/hooks/check-plugin-docs.sh && echo ok
```

Erwartet: `ok`.

- [ ] **Step 6: Die synthetische Änderung erneut prüfen (GREEN)**

Die Zeile aus Step 1 steht noch in `infographic-page/SKILL.md`. Einen **neuen** `general-purpose`-Subagenten mit demselben Prompt wie in Step 1 dispatchen.

Erwartet:
- *Gemeldet* nennt `requirements.md`, Zeile Node.js LTS, Skill `infographic-page`, die Fundstelle, und dass Pflicht oder optional zu wählen ist.
- *Zu übernehmen* enthält **keinen** Eintrag zur Liste.
- `git diff -- plugin/skills/dev/setup/requirements.md` ist leer, der Subagent hat also nichts still eingetragen.
- `Sicherheitsnetz:` nennt `requirements.md`, auch wenn dort kein Treffer ist.

- [ ] **Step 7: Löschfall und Setup-Ausnahme prüfen**

Die synthetische Zeile entfernen, dann zwei weitere synthetische Zustände nacheinander prüfen, jeweils mit einem **neuen** Subagenten und dem Prompt aus Step 1:

```bash
git checkout -- plugin/skills/dev/infographic-page/SKILL.md README.md plugin/NOTICE.md
# 7a: setup changed only
printf '\nRun `npx --version` if in doubt.\n' >> plugin/skills/dev/setup/SKILL.md
```

Erwartet für 7a: **kein** Befund zur Liste, weil `setup` von der Suche ausgenommen ist. Danach dasselbe mit `requirements.md` statt `SKILL.md` (Zeile `npx --version` unter die Tabelle anhängen): ebenfalls kein Befund, sonst nur die `setup`-Befunde aus Task 1.

```bash
git checkout -- plugin/skills/dev/setup/SKILL.md README.md plugin/NOTICE.md
# 7b: a listed skill is deleted
git rm -r -q plugin/skills/personal/whats-for-lunch
```

Erwartet für 7b:
- *Geschrieben*: `whats-for-lunch` ist aus der Zeile Playwright MCP entfernt.
- `git diff -- plugin/skills/dev/setup/requirements.md` zeigt genau diese Änderung.
- Kein *Gemeldet* „Zeile ohne Skill", weil `data-model-diagram` in der Zeile bleibt.

Aufräumen und den sauberen Stand bestätigen:

```bash
git reset -q HEAD -- plugin/skills/personal/whats-for-lunch
git checkout -- plugin/skills/personal/whats-for-lunch plugin/skills/dev/setup/requirements.md README.md plugin/NOTICE.md
git status --short
```

Erwartet: Nur die Änderungen dieses Tasks an `.claude/skills/sync-plugin-docs/SKILL.md`, `.claude/hooks/check-plugin-docs.sh` und `CLAUDE.md` stehen da.

- [ ] **Step 8: Die übrigen Fälle aus Spec §8**

Jeder Fall wird einzeln hergestellt, von einem **neuen** Subagenten mit dem Prompt aus Step 1 geprüft und danach aufgeräumt. Aufräumen heißt jedes Mal:

```bash
git reset -q HEAD -- plugin/
git checkout -- plugin/ README.md plugin/NOTICE.md
git clean -fdq -- plugin/
git status --short
```

Danach stehen nur die Änderungen dieses Tasks da. `setup`-Befunde im Report sind Rauschen (Step 1).

| Fall | Herstellen | Erwartet zur Liste |
|---|---|---|
| Herausfallen | in `plugin/skills/dev/data-model-diagram/SKILL.md` die Zeile mit `python -m http.server` löschen (`grep -n 'python ' …` vorher: das muss der einzige Treffer von `python `, `py -`, `pip ` im Verzeichnis sein, sonst eine andere Zeile wählen oder alle Treffer löschen) | *Zu übernehmen*: `alt:` die Zelle *Mandatory for* der Zeile Python 3 mit `data-model-diagram`, `neu:` ohne ihn; `requirements.md` unverändert |
| Prosa-Treffer im Beispiel | in `plugin/skills/dev/test-driven-development/SKILL.md` eine Zeile `npm test path/to/other.test.ts` unter eine bestehende `npm test`-Zeile einfügen | kein Befund, denn `npm test` trifft keine Node-Signatur (`npx `, ` node `, `.cjs`, Shebang); fällt doch einer, ist er *Gemeldet* und `requirements.md` unverändert |
| Pflicht-Nutzer gelöscht | `git rm -r -q plugin/skills/dev/md-to-pdf` | *Geschrieben*: `md-to-pdf` aus der Zeile Node.js LTS entfernt; **keine** Meldung „Zeile ohne Skill", weil `brainstorming` und `writing-skills` bleiben |
| Beide Playwright-Nutzer gelöscht | `git rm -r -q plugin/skills/dev/data-model-diagram plugin/skills/personal/whats-for-lunch` | *Geschrieben*: beide aus Playwright MCP, `data-model-diagram` aus Python 3; *Gemeldet*: Playwright MCP und Python 3 führen keinen Skill mehr; keine Zeile gelöscht |
| Umbenennung | `git mv plugin/skills/personal/whats-for-lunch plugin/skills/personal/lunch-menu` und in dessen `SKILL.md` `name: whats-for-lunch` → `name: lunch-menu` | *Geschrieben*: in Playwright MCP `whats-for-lunch` → `lunch-menu`; **kein** *Zu übernehmen* aus entfernten Zeilen des alten Pfads |
| Unbekannter Befehl ohne Signatur | in `plugin/skills/dev/handoff/SKILL.md` eine Zeile ``Run `pandoc --version` first.`` anhängen | **kein** Befund: der dokumentierte Fall der Lücke (`0027`), kein Fehlschlag |
| Unbekannter MCP-Server | in `plugin/skills/personal/find-beer-deals/SKILL.md` die Frontmatter-Zeile `allowed-tools:` um `, mcp__chrome-devtools__*` ergänzen | *Gemeldet*: MCP-Server `chrome-devtools` ohne Zeile in der Liste |

Der Fall „nur `requirements.md` gepflegt, auf `main`" braucht einen Commit auf `main` und gehört deshalb in die Abnahme durch Smax.

- [ ] **Step 9: Commit**

```bash
git add .claude/skills/sync-plugin-docs/SKILL.md .claude/hooks/check-plugin-docs.sh CLAUDE.md
git commit -m "feat(sync-plugin-docs): Anforderungsliste von setup als drittes abgeleitetes Dokument"
```

---

### Task 3: Abgeleitete Dokumente für `setup`

**Files:**
- Modify: `README.md` (§ *Installation*, dazu die Stellen, die `sync-plugin-docs` schreibt oder vorlegt)
- Modify: `plugin/NOTICE.md` (§3 *No upstream origin → Created afterwards*)

**Interfaces:**
- Consumes: Den Skill aus Task 1 und `sync-plugin-docs` in der Fassung aus Task 2.

- [ ] **Step 1: `sync-plugin-docs` gegen den Branch laufen lassen**

Einen `general-purpose`-Subagenten dispatchen, one-shot und ohne Namen, mit dem Prompt aus Task 2 Step 1.

Erwartet (Branch-Basis, vollständig; meldet der Report die Sweep-Basis, läuft die Ausführung auf `main`. Dann stoppen, siehe Global Constraints):
- *Geschrieben*: die §5-Zeile für `setup` (Trigger *Command*), die §2.1-Zeile samt Zahl „nine" statt „eight" und die Mitgliedschaft in §4 *Not invocable by the model*.
- *Zu übernehmen*: der §2.1-*Purpose*-Text, weil eine neue Zeile keinen Altwert für den Wörtlich-Test hat; NOTICE §3 *Created afterwards*; die §5-Gruppe unter `dev`.
- *Gemeldet*: was keine Quelle hat, etwa §3 *Where do I start?*.
- **Kein** Befund zur Anforderungsliste, weil `setup` ausgenommen ist.

- [ ] **Step 2: Vorgelegtes übernehmen**

Die Punkte unter *Zu übernehmen* **mit Smax** durchgehen. Das ist Prosa ohne Quelle (`0019`). Der Implementer legt die Vorschläge vor und trägt nur ein, was bestätigt wurde. Vorgeschlagene Werte:
- §2.1 *Purpose*: `check and install what the skills need on this machine (Windows)`
- §5-Gruppe: Es gibt `dev — workflow chain`, `dev — thinking & docs` und `dev — client & web tasks`. Keine passt genau; am nächsten liegt `thinking & docs`, weil dort die übrigen Werkzeug-Commands stehen. Die Wahl liegt bei Smax.
- NOTICE §3 *Created afterwards*: `setup` in die Namensliste.

- [ ] **Step 3: Satz unter *Installation***

In `README.md`, Abschnitt `## Installation`, direkt nach dem Codeblock mit `/plugin install smax@smax-skills` einfügen:

```markdown
Then run `/smax:setup` once per machine. It checks what the skills need that the plugin does not ship — Git, PowerShell 7, Node.js, Python, the Playwright MCP server, and optionally the GitHub CLI and Graphviz — and installs what is missing after you confirm each item. Windows only.
```

- [ ] **Step 4: Zweiter Lauf, nichts mehr offen**

`sync-plugin-docs` erneut mit einem **neuen** Subagenten laufen lassen.

Erwartet: *Geschrieben* ist leer. *Zu übernehmen* enthält nur, was Smax in Step 2 abgelehnt hat. `Geändert:` nennt die Hunks aus Step 1 bis 3 als `(vorgefunden)`.

- [ ] **Step 5: Commit**

```bash
git add README.md plugin/NOTICE.md
git commit -m "docs(readme): setup aufgenommen, Installation um den Setup-Lauf ergaenzt"
```

---

## Abnahme durch Smax

Die Fälle aus Spec §8 fährt Smax selbst, auf dem Branch vor dem Landen. Der Skill wird nie von dem Agenten abgenommen, der ihn geschrieben hat. Die Fälle von `sync-plugin-docs` sind in Task 2 Step 6 bis 8 schon durch fremde Agenten gelaufen, bis auf den Fall auf `main`. Übrig bleiben die Fälle, die eine echte Maschine oder `main` brauchen:

| Fall | Herstellen | Erwartet | Aufräumen |
|---|---|---|---|
| Baseline-Lücken, Antwort `keine` | nichts | jede Baseline-Lücke mit *Art* und *Braucht es*; Schlussreport ohne Neustart-Zeile | — |
| Zweiter Lauf direkt danach | nichts | die Baseline-Lücken werden erneut angeboten; nichts ändert sich | — |
| Antwort `alle` (heute GitHub CLI und Graphviz, beide optional) | nichts | UAC-Fenster; beide `installiert`; die Nachprüfung im selben Aufruf findet `gh` und `dot`; Neustart-Zeile | bleiben, oder `winget uninstall -e --id GitHub.cli`, `winget uninstall -e --id Graphviz.Graphviz` und `C:\Program Files\Graphviz\bin` aus dem Benutzer-`PATH` entfernen |
| Dritter Lauf nach Neustart | nichts | `Alles vorhanden.`, keine Frage | — |
| `python` löst auf den Store-Alias auf | in einer neuen Claude-Code-Sitzung, deren `PATH` das Python-Verzeichnis nicht enthält, `%LOCALAPPDATA%\Microsoft\WindowsApps` aber schon | Python 3 *fehlt*, nicht *vorhanden* | Sitzung schließen |
| Playwright gewählt, Node fehlt | in einer neuen Claude-Code-Sitzung mit `PATH` ohne Node-Verzeichnis; vorher `claude mcp get playwright` sichern, dann `claude mcp remove playwright -s user` | Rückfrage nach der *Needs*-Zeile, keine Installation gegen fehlendes Node | Playwright mit den gesicherten Argumenten neu anlegen |
| winget fehlt | nur per Review: Schritt 2 prüft, dann Report ohne Bestätigungsliste mit der Zeile zu „App Installer" | — | — |
| Nicht-Windows | nur per Review: Schritt 1 bricht bei `$OS` ungleich `Windows_NT` ab | — | — |
| Nur `requirements.md` gepflegt, auf `main` | nach dem Landen: eine Leerzeile unter der Tabelle ergänzen, committen, `/sync-plugin-docs` | erste Zeile `Basis: <sha dieses Commits> (Sweep seit letzter Pflege eines abgeleiteten Dokuments — unvollständig)` | Commit zurücknehmen (`git revert`) |

Die Installation von Graphviz ist der einzige Fall, der die Annahme „die stille NSIS-Installation setzt keinen `PATH`" belegt oder widerlegt. Widerlegt er sie, bleibt der `PATH`-Block trotzdem harmlos, weil er nur anhängt, was fehlt. Die Spec wird dann in §3 korrigiert.

Nach bestandener Abnahme: `TODOS.md` 2.4 streichen (Nummer bleibt frei) und committen:

```bash
git add TODOS.md
git commit -m "docs(todos): setup (2.4) gestrichen"
```

## Before Landing

The full range of this branch gets reviewed, not just the last task. Fix
everything under `Issues`; `Recommendations` are advisory.

- Working by hand: type `/smax:code-review`.
- Working as an agent: dispatch a `general-purpose` subagent with the reviewer
  template at `C:\Projects\smax-skills\plugin\skills\dev\code-review\code-reviewer.md`, using the merge-base as BASE and HEAD
  as HEAD. **If that path does not resolve, stop and ask** — the plugin has been
  moved or updated since this plan was written. Do not guess a replacement path,
  and do not skip the review.

Then land via `smax:finishing-a-development-branch`, which re-checks that a
review for this HEAD exists before it offers the merge options.
