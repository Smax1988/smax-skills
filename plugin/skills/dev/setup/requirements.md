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
winget install -e --id Graphviz.Graphviz --accept-source-agreements --accept-package-agreements --disable-interactivity --no-upgrade
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
- **`claude` itself must be on `PATH`.** The Playwright check and install call
  `claude mcp`. With an IDE-bundled Claude Code that is not on `PATH`, both
  report fehlt or fehlgeschlagen although nothing is wrong with the server; run
  `setup` from a terminal where `claude` resolves.
- **An existing `playwright` entry with other arguments** (for example the
  Chrome channel) is left alone as long as it reports `Connected`.
