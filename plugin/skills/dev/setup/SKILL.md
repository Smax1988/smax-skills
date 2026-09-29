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
/smax:setup erneut.` and no confirmation list. That line is printed only if
something is missing.

## 3 - Check

Every row of `requirements.md`, **in row order**. One script per row, the row's
*Check* as its body. A row is:

- **vorhanden** - exit code 0 and the criterion after the arrow holds. Note the
  version if the output shows one.
- **fehlt** - anything else.

## 4 - Report

A row is **Pflicht** if its *Mandatory for* column names a skill, **or** a
Pflicht row names it under *Needs*. Otherwise it is **optional**. So Node.js
would stay Pflicht as long as Playwright MCP is Pflicht, even if no skill
called `npx` directly.

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

**Nothing missing:** the header line stays, `Alles vorhanden.` follows right
after it, then the table, and the run ends. No question, no installation. A
second run after every installation was accepted ends here - that is what makes
the skill safe to run again.

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
<the row's Install; for winget append --accept-source-agreements --accept-package-agreements --disable-interactivity --no-upgrade>
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
- check fails, winget said the package is already installed (`--no-upgrade`
  makes it report that instead of upgrading) -> **installiert, aber nicht im
  PATH**. Do not retry.
- row of Kind `mcp`: install exited 0 but the check fails (the first `npx -y`
  download can exceed the health-check timeout) -> **registriert, Verbindung
  nach Neustart prüfen**. Do not retry.
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
installed or registered (**registriert, Verbindung nach Neustart prüfen** is
listed under *Installiert* with that note). A row the user declined stays under
*Weiterhin fehlend* with `abgelehnt`; the next run offers it again - this skill
keeps no state.
