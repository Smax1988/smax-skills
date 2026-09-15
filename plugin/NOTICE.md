# NOTICE

Teile dieses Plugins sind von zwei Projekten abgeleitet: **superpowers** (Jesse
Vincent) und **mattpocock/skills** (Matt Pocock). Beide MIT.

Je Upstream ein Abschnitt — Kopftabelle, Ankerpunkt, Dateiliste, Lizenztext.
Was aus keinem von beiden stammt, steht in [§3](#3--ohne-upstream-herkunft).

**Diese Datei sagt, *was* abweicht — das *warum* steht in
[`docs/decisions/`](../docs/decisions/).** Wer beim nächsten Upstream-Abgleich
vor einem Konflikt steht und wissen will, ob die Abweichung Absicht war,
liest dort nach, bevor er sie wegmerged.

> **Eine Umbenennung beim Import löscht die Herkunft.** Die fünf Dateien aus
> §2 hießen upstream `grilling`, `grill-me` und `grill-with-docs`; hier heißen
> sie `sharpen*`. Damit war die einzige Spur weg, die am Dateinamen ablesbar
> gewesen wäre, und der zweite Upstream fehlte in dieser Datei von ihrem ersten
> Tag an (Import am 26.07.2026) bis zum 04.08.2026.
> `domain-modeling` und `teach` heißen unverändert wie upstream — dort war die
> Herkunft die ganze Zeit sichtbar. Wer künftig etwas beim Import umbenennt,
> trägt es **in derselben Sitzung** hier ein.

---

## 1 · superpowers

| | |
|---|---|
| Projekt | superpowers |
| Autor | Jesse Vincent |
| Repository | <https://github.com/obra/superpowers> |
| Version | 6.2.0 |
| Commit | `3dcbd5c4b48e02263fbf4a3c01e3fe4f81d584d9` (Tag `v6.2.0`, 23.07.2026) |
| Lizenz | MIT |

Der Commit ist der Ankerpunkt für einen späteren Upstream-Vergleich. Er wird
hier festgehalten, weil der Plugin-Cache mit der Deinstallation von
`superpowers` verschwindet und der Ausgangsstand danach nicht mehr aus dem
System selbst zu rekonstruieren ist. Verglichen wird upstream gegen upstream
(`git diff v6.2.0..v7.0.0 -- skills/<name>/`) in einem separaten Klon, nicht
gegen die Dateien dieses Repos — die sind bewusst divergiert.

Die übernommenen Dateien wurden **schon beim Kopieren** angepasst:
Skill-Referenzen auf das Präfix `smax:` umgestellt, Arbeitsverzeichnisse von
`.superpowers/` auf `.smax/`, Dokumentpfade auf die Doku-Konvention dieses Repos
(`docs/00_Analysis/`, `docs/01_Specs/`, `docs/02_Plans/`, `docs/03_DbChanges/`),
dazu inhaltliche Ergänzungen und Kürzungen.

Pfade relativ zu `plugin/skills/dev/`. Drei Stufen, nach verbliebenem
Upstream-Anteil.

> **Gemessen wird gegen den Anker, nicht gegen die eigene History.** Die
> Dateien trugen die Anpassungen oben schon beim Import — ein Diff gegen einen
> Stand dieses Repos misst deshalb nie den Abstand zum Upstream, und die History
> dieses Repos ist ohnehin nicht garantiert
> ([`0026`](../docs/decisions/0026-notice-anchors-upstream-not-own-history.md)).
> Den Abstand liefert nur der Vergleich gegen den Anker:
>
> ```bash
> git clone --filter=blob:none https://github.com/obra/superpowers.git /tmp/sp
> git -C /tmp/sp checkout 3dcbd5c
> diff --strip-trailing-cr /tmp/sp/skills/<upstream-pfad> plugin/skills/dev/<datei>
> ```
>
> `--strip-trailing-cr`, weil `.gitattributes` hier LF erzwingt und der Klon
> unter Windows CRLF auscheckt — ohne das Flag meldet `diff` jede Zeile als
> geändert. **Die Stufe richtet sich nach diesem Vergleich** —
> `brainstorming/SKILL.md` steht bei 45−/81+ gegen v6.2.0.

> **Der häufigste Grund für Drift** in ursprünglich wörtlich übernommenen
> Dateien: Die vier Lesestellen für `docs/decisions/` (`0005`) und das
> Glossar-Gate auf `CONTEXT.md` wurden nachträglich einmontiert — in Dateien,
> die sonst unangetastet blieben. Beim Upstream-Abgleich liegen die Konflikte
> mit hoher Wahrscheinlichkeit genau an diesen Einschüben.

### Unverändert übernommen

Seit dem Import keine Zeile geändert, Stand der Veröffentlichung am 15.09.2026.
Gegen den Anker ist das nicht nachprüfbar, weil der Import die Anpassungen oben
schon trug. Ändert sich eine dieser Dateien, meldet `sync-plugin-docs` das.

| Datei | Upstream-Herkunft |
|---|---|
| `writing-skills/testing-skills-with-subagents.md` | `skills/writing-skills/testing-skills-with-subagents.md` |
| `writing-skills/persuasion-principles.md` | `skills/writing-skills/persuasion-principles.md` |
| `writing-skills/graphviz-conventions.dot` | `skills/writing-skills/graphviz-conventions.dot` |
| `writing-skills/render-graphs.js` | `skills/writing-skills/render-graphs.js` |
| `test-driven-development/SKILL.md` | `skills/test-driven-development/SKILL.md` |
| `test-driven-development/writing-good-tests.md` | `skills/test-driven-development/writing-good-tests.md` |
| `verification-before-completion/SKILL.md` | `skills/verification-before-completion/SKILL.md` |
| `debugging/root-cause-tracing.md` | `skills/systematic-debugging/root-cause-tracing.md` |
| `debugging/defense-in-depth.md` | `skills/systematic-debugging/defense-in-depth.md` |
| `debugging/condition-based-waiting.md` | `skills/systematic-debugging/condition-based-waiting.md` |
| `debugging/condition-based-waiting-example.ts` | `skills/systematic-debugging/condition-based-waiting-example.ts` |
| `debugging/find-polluter.sh` | `skills/systematic-debugging/find-polluter.sh` |
| `brainstorming/visual-companion.md` | `skills/brainstorming/visual-companion.md` |
| `brainstorming/scripts/server.cjs` | `skills/brainstorming/scripts/server.cjs` |
| `brainstorming/scripts/helper.js` | `skills/brainstorming/scripts/helper.js` |
| `brainstorming/scripts/frame-template.html` | `skills/brainstorming/scripts/frame-template.html` |
| `brainstorming/scripts/start-server.sh` | `skills/brainstorming/scripts/start-server.sh` |
| `brainstorming/scripts/stop-server.sh` | `skills/brainstorming/scripts/stop-server.sh` |
| `subagent-driven-development/task-reviewer-prompt.md` | `skills/subagent-driven-development/task-reviewer-prompt.md` |
| `subagent-driven-development/re-review-prompt.md` | `skills/subagent-driven-development/re-review-prompt.md` |
| `subagent-driven-development/scripts/sdd-workspace` | `skills/subagent-driven-development/scripts/sdd-workspace` |
| `subagent-driven-development/scripts/task-brief` | `skills/subagent-driven-development/scripts/task-brief` |
| `subagent-driven-development/scripts/review-package` | `skills/subagent-driven-development/scripts/review-package` |

### Übernommen, punktuell ergänzt

Upstream-Text im Kern, lokal begrenzte Einschübe.

| Datei | Upstream-Herkunft | Ergänzung |
|---|---|---|
| `using-git-worktrees/SKILL.md` | `skills/using-git-worktrees/SKILL.md` | Die `.gitignore`-Zeile wird bestätigt und committet, **bevor** der Worktree entsteht — sonst landet der ganze Baum im Repo (`0008`) |
| `executing-plans/SKILL.md` | `skills/executing-plans/SKILL.md` | Verdrängungs-Notiz zugunsten `subagent-driven-development`; Kaltstart-Fall ergänzt: der Plan wird selbst gefunden statt vorausgesetzt (`0016`) |
| `writing-plans/plan-document-reviewer-prompt.md` | `skills/writing-plans/plan-document-reviewer-prompt.md` | Von der Platte lesen statt aus dem Gedächtnis; die letzte Nachricht *ist* der Report; ausführbare Plan-Behauptungen werden ausgeführt (`0012`); Terminologie-Autorität wird geprüft |
| `writing-specs/spec-document-reviewer-prompt.md` | `skills/brainstorming/spec-document-reviewer-prompt.md` | One-shot ohne Namen (`0007`); von der Platte lesen; Glossar- und Decisions-**Platzierung** werden geprüft, nicht nur der Inhalt |

### Substanziell umgebaut

| Datei | Upstream-Herkunft | Art des Umbaus |
|---|---|---|
| `code-review/SKILL.md` | `skills/requesting-code-review/SKILL.md` + `skills/receiving-code-review/SKILL.md` | Zwei Skills zu einem verdichtet (`0009`) |
| `code-review/code-reviewer.md` | `skills/requesting-code-review/code-reviewer.md` | Decisions-Prüfung im Reviewer (`0005`); englische Identifier gegen das Glossar; **Mutationsprobe für Wächter** — ein grüner Testlauf belegt einen Wächter erst, wenn die Suite ohne ihn rot wird (`0009`) |
| `writing-plans/SKILL.md` | `skills/writing-plans/SKILL.md` | Glossar-Gate auf `CONTEXT.md`; Bindung der einschlägigen Decisions im `Global Constraints`-Block; `## Before Landing` als Abschluss jedes Plans, mit aufgelöstem Pfad zur Reviewer-Vorlage (`0017`). Rund ein Drittel der Datei ist eigener Text |
| `brainstorming/SKILL.md` | `skills/brainstorming/SKILL.md` | Decisions-Lesestelle als Schritt 1, vor jedem Entwurf (`0005`); Glossar-HARD-GATE mit Rationalisierungs-Tabelle; Dokumenttyp SPEC/ANALYSIS wird benannt statt erfragt; die Spec-Schritte 6–9 sind heraus und liegen in `writing-specs`. 45−/81+ gegen v6.2.0 |
| `debugging/SKILL.md` | `skills/systematic-debugging/SKILL.md` | Neuer Abschnitt *„When the Root Cause Is a Broken Decision"*: Widerspricht der Code einer Decision, **ist** dieser Widerspruch die Ursache — nicht der Absturz, den man verfolgt hat (`0005`) |
| `finishing-a-development-branch/SKILL.md` | `skills/finishing-a-development-branch/SKILL.md` | Eingedampft, Review-Gate und Squash-Landung ergänzt |
| `writing-specs/SKILL.md` | Extrakt aus `skills/brainstorming/SKILL.md` (Schritte 6–9) | Neu geschrieben als eigenständiges Skill (`0003`) |
| `subagent-driven-development/SKILL.md` | `skills/subagent-driven-development/SKILL.md` | Task-Reviewer pro Task entfernt: Gate ist die Selbstprüfung des Implementers plus die Report-Prüfung des Controllers. Ein Task-Reviewer nur noch bei `DONE_WITH_CONCERNS` zu Korrektheit oder Scope. Fix-Loop auf Controller-Verifikation umgestellt, Final Review verstärkt, Ledger behält den Workspace bis zum Landen (`0006`, `0014`) |
| `subagent-driven-development/implementer-prompt.md` | `skills/subagent-driven-development/implementer-prompt.md` | `CONTEXT.md`-Auszug im Dispatch; Selbstprüfung ist jetzt das primäre Gate und entsprechend verschärft |
| `writing-skills/SKILL.md` + `writing-skills/authoring-reference.md` | `skills/writing-skills/SKILL.md` | Aufgeteilt: Disziplin (TDD-Zyklus, Iron Law, Bulletproofing, Match-the-Form) bleibt in `SKILL.md`, Referenzmaterial (Struktur, Naming, Dateilayout, Flowchart-Regeln, Testansatz je Skill-Typ) wandert eine Ebene tiefer nach `authoring-reference.md`. Token-Budgets an Workflow-Skills angepasst; Verbot skill-übergreifender Deduplizierung ergänzt |
| `dispatching-parallel-agents/SKILL.md` | `skills/dispatching-parallel-agents/SKILL.md` | Session-Narrativ und doppelter „When NOT to use"-Block entfernt |

### Eingefrorene Kopie externer Dokumentation

`writing-skills/anthropic-best-practices.md` ist eine über superpowers
übernommene, eingefrorene Kopie öffentlicher Anthropic-Dokumentation zu
Agent Skills. Sie wird nicht mit der Quelle synchronisiert und kann daher
hinter der aktuellen Anthropic-Doku zurückliegen.

### Nicht übernommen

`using-superpowers` samt SessionStart-Hook, `commands/`, `tests/`,
`agents/`, die Plattform-Manifeste (`.codex-plugin`, `.cursor-plugin`,
`.opencode`, `.pi`, `gemini-extension.json`), die Entwicklungsartefakte
`CREATION-LOG.md`, `test-pressure-*.md`, `test-academic.md` sowie
`writing-skills/examples/CLAUDE_MD_TESTING.md`.

### MIT License — superpowers

Copyright (c) 2025 Jesse Vincent

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 2 · mattpocock/skills

| | |
|---|---|
| Projekt | mattpocock/skills |
| Autor | Matt Pocock |
| Repository | <https://github.com/mattpocock/skills> |
| Version | 1.2.0 (`.claude-plugin/plugin.json`) |
| Commit | `2ab958093e83e0ec752e6c1c5932da465bf23e0c` (28.07.2026) |
| Lizenz | MIT |

**Dieser Anker ist gesetzt, nicht rekonstruiert.** Anders als bei superpowers
gibt es hier keinen Import-Commit: Alle fünf Skills betreten ihren heutigen Pfad
gemeinsam mit einem Verschiebe-Commit („Plugin nach `plugin/` verschieben",
26.07.2026). Der erste Commit dieses Repos ist vom 24.07.2026, der Upstream
ist älter (erster Commit 03.02.2026) — der tatsächliche Ausgangsstand ist damit
weder aus der History noch aus den Daten zu klären. Der Commit oben ist ein
**Vergleichspunkt für die Zukunft**, keine Herkunftsbehauptung über die
Vergangenheit: Alle Einstufungen unten sind gegen ihn gemessen, am 04.08.2026.

```bash
git clone --filter=blob:none https://github.com/mattpocock/skills.git /tmp/mp
git -C /tmp/mp checkout 2ab9580
diff --strip-trailing-cr /tmp/mp/skills/<upstream-pfad> plugin/skills/dev/<datei>
```

`--strip-trailing-cr` aus demselben Grund wie bei superpowers.

Pfade relativ zu `plugin/skills/dev/`, Upstream-Pfade relativ zum Repo-Root.
Dieselben drei Stufen wie in §1.

### Unverändert übernommen

Byte-identisch mit dem Anker.

| Datei | Upstream-Herkunft |
|---|---|
| `teach/SKILL.md` | `skills/productivity/teach/SKILL.md` |
| `teach/GLOSSARY-FORMAT.md` | `skills/productivity/teach/GLOSSARY-FORMAT.md` |
| `teach/MISSION-FORMAT.md` | `skills/productivity/teach/MISSION-FORMAT.md` |
| `teach/RESOURCES-FORMAT.md` | `skills/productivity/teach/RESOURCES-FORMAT.md` |

### Übernommen, punktuell ergänzt

| Datei | Upstream-Herkunft | Ergänzung |
|---|---|---|
| `teach/LEARNING-RECORD-FORMAT.md` | `skills/productivity/teach/LEARNING-RECORD-FORMAT.md` | Eine Zeile: „the teaching equivalent of ADRs" → „of Decisions", damit der Vergleich auf den hiesigen Begriff zeigt |
| `sharpen/SKILL.md` | `skills/productivity/grilling/SKILL.md` | Nur Frontmatter: umbenannt `grilling` → `sharpen`, `description` nachgezogen, `argument-hint` ergänzt. **Der Fließtext ist wörtlich upstream** — genau diese Umbenennung hat die Herkunft verdeckt |

### Substanziell umgebaut

| Datei | Upstream-Herkunft | Art des Umbaus |
|---|---|---|
| `sharpen-me/SKILL.md` | `skills/productivity/grill-me/SKILL.md` | Upstream ist ein Satz („Run a `/grilling` session"). Hier entscheidet der Skill den Dokumenttyp SPEC/ANALYSIS selbst und benennt ihn in der Frage, „Nein" ist ausdrücklich ein gültiges Ergebnis, und ein „Ja" übergibt an `smax:writing-specs` statt das Dokument selbst zu schreiben |
| `sharpen-with-docs/SKILL.md` | `skills/engineering/grill-with-docs/SKILL.md` | Wie `sharpen-me`, dazu: keine Secrets und keine PII in `CONTEXT.md` oder Decisions, und Begriffe werden geschrieben, sobald sie feststehen — nicht am Sessionende und nicht als Tabelle im Spec. Upstream ist dieser Skill ein eigenständiger Einstieg; hier ruft `writing-specs` stattdessen `sharpen` + `domain-modeling` einzeln, weil ein Command nicht aus einem Skill heraus startbar ist (README §4) |
| `domain-modeling/SKILL.md` | `skills/engineering/domain-modeling/SKILL.md` | ADR → Decision durchgehend, `docs/adr/` → `docs/decisions/`. Zwei neue Abschnitte verdrahten Glossar und Decisions in die Projekt-`CLAUDE.md` (`0015`), der zweite mit HARD-GATE gegen jeden Import des Verzeichnisses. Dazu die PII-Regel, die Sprachregel für Decisions (`0023`) und der Aufruf von `smax:sync-solution-items` nach jeder neuen Decision. 8−/165+ |
| `domain-modeling/CONTEXT-FORMAT.md` | `skills/engineering/domain-modeling/CONTEXT-FORMAT.md` | Abschnitt *Terms that aren't English*: jeder nicht-englische Begriff trägt seinen englischen Code-Namen im Eintrag, ausnahmslos — auch Produktnamen und Rechtsbegriffe. Dazu drei Sätze im Kopf, was `CONTEXT.md` überhaupt leistet |
| `domain-modeling/DECISION-FORMAT.md` | `skills/engineering/domain-modeling/ADR-FORMAT.md` | Umbenannt ADR → Decision. Neuer Abschnitt *Language*: Dateiname und Fließtext sind englisch, unabhängig von der Sprache des Projekts und des Gesprächs (`0023`) |

### Nicht übernommen

Alle übrigen Skills des Upstreams, die Plattform-Manifeste, `scripts/`, `docs/`
und die `agents/openai.yaml`, die upstream neben jedem der fünf Skills liegt.

**`handoff` ist nicht von hier** — der Name legt es nahe, upstream steht
`skills/productivity/handoff`, und die Frage wird sich jeder spätere Leser
stellen. Der Skill ist vollständig selbst geschrieben (bestätigt am
01.08.2026), und der Vergleich stützt das: Die Repo-Suche über mehrere
git-Repos (Tiefe 6, `node_modules` übersprungen), die feste sechsteilige
Dokumentvorlage, das hartkodierte `C:\Temp` samt Kollisionsschema `-2`/`-3`
und der Block *Principles (binding)* haben upstream keine Entsprechung;
umgekehrt fehlt hier dessen Abschnitt *Suggested Skills*. Gemeinsam sind nur
Name, Frontmatter-Zuschnitt, „Temp-Verzeichnis statt Workspace",
PII-Redaktion und „Argument = Fokus der nächsten Session". Er steht deshalb
in [§3](#3--ohne-upstream-herkunft).

### MIT License — mattpocock/skills

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 3 · Ohne Upstream-Herkunft

Eigene Skills — beim Abgleich mit §1 und §2 gar nicht erst zu betrachten.

**Älter als der Import:** `commitMessage`, `handoff`, `replicate`,
`infographic-page`, `personal/find-beer-deals`, `personal/nano-vs-colors`.

**Danach entstanden:** `data-model-diagram`, `mail-draft`, `md-to-pdf`,
`proad-job-report`, `sync-solution-items`, `personal/whats-for-lunch`,
`personal/lap-training`.

**Die erste Liste ist abgeschlossen.** Kein Skill wird nachträglich älter als
der Import — ein neuer eigener Skill gehört immer unter *Danach entstanden*.
Gezogen wurde die Trennung gegen die History vor der Veröffentlichung, die nicht
mehr Teil dieses Repos ist
([`0026`](../docs/decisions/0026-notice-anchors-upstream-not-own-history.md)).

**Was die Trennung beweist und was nicht.** Sie sagt, wann ein Skill entstand —
mehr nicht. „Älter als der superpowers-Import" hieß in der ersten
Fassung dieser Datei *ohne Upstream*, und genau daran ist §2 von Anfang an
vorbeigelaufen: Die fünf Pocock-Skills sind ebenfalls älter als der Import.
Wer einen Skill hier einträgt, prüft ihn **gegen beide Upstreams**, nicht
gegen die History.
