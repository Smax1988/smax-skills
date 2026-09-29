#!/usr/bin/env bash
# PreToolUse auf Bash(git commit *): fragt nach, wenn Skills gestaged sind.
set -euo pipefail

# Hooks erben kein zugesichertes Arbeitsverzeichnis. Wurzel selbst bestimmen,
# sonst laeuft der Praefix-Filter unten ins Leere und der Hook schweigt falsch.
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

# core.quotepath=false: sonst kommen Nicht-ASCII-Pfade gequotet und mit
# fuehrendem Anfuehrungszeichen, und der Praefix-Filter unten greift nicht mehr.
paths=$(git -C "$root" -c core.quotepath=false diff --cached --name-only \
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

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s Datei(en) unter plugin/skills/ sind gestaged:%s\\n\\nWurde /sync-plugin-docs ausgefuehrt? README.md, plugin/NOTICE.md und die Anforderungsliste von setup sind daraus abgeleitet."}}\n' \
  "$count" "$list"
