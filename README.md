# smax — persönliches Skill-Plugin

> ## ⚠️ EXPERIMENTELL
>
> Im Einsatz seit dem 25.07.2026 — also seit gut einer Woche. Vieles ändert sich
> noch laufend: Skill-Zuschnitte, der Verlauf der Ketten, Pfadkonventionen,
> welche Schritte nachfragen und welche nicht. **Erwarte Brüche zwischen zwei
> Commits** und verlass dich nicht darauf, dass ein Ablauf morgen aussieht wie
> heute.
>
> Was bereits bewusst entschieden *ist*, steht in [`docs/decisions/`](./docs/decisions/)
> — das ist der stabile Kern. Was gerade offen ist, steht in
> [`TODOS.md`](./TODOS.md). Alles andere ist in Bewegung.

Mein persönliches Claude-Code-Plugin. Skills unter `plugin/skills/dev/` und `plugin/skills/personal/`, verteilt über einen eigenen Marketplace: dieses Repo **ist** der Marketplace, das Plugin liegt darin unter `plugin/`.

> Marketplace `smax-skills` · Plugin `smax` · Aufruf-Präfix `/smax:`

Alles außerhalb von `plugin/` — insbesondere `docs/` — wird **nicht** ausgeliefert.

## Installation

Das Repo ist öffentlich — eintragen kann es jeder:

```
/plugin marketplace add https://github.com/Smax1988/smax-skills.git
/plugin install smax@smax-skills
```

Aktualisieren mit `/plugin marketplace update smax-skills`, dann `/reload-plugins`. Wer selbst am Plugin entwickelt, nimmt stattdessen die lokale Quelle aus [§6.2](#62-setup-der-dev-maschine).

Firmen- und kundenspezifische Skills stehen hier bewusst nicht: Sie liegen im internen Plugin `cnx` (Marketplace `cnx-skills`, Azure DevOps). Warum: `docs/decisions/0025-company-skills-in-separate-plugin.md`.

---

# 1 · Der Workflow

## 1.1 Von der Idee bis zum gelandeten Branch

```
  Idee                     Entwurf                Plan              Umsetzung           Landung
                                                                                       
  brainstorming ──┐                                                                    
  sharpen-me ─────┼──→ writing-specs ──→ writing-plans ──┬─→ subagent-driven-dev ──┐   
  sharpen-with-docs┘                                     └─→ executing-plans ──────┼──→ finishing-a-
                                                                                   │    development-
       ▲                    ▲                  ▲                                   │    branch
       └────────────────────┴──────────────────┴───────────────────────────────────┘         │
                    domain-modeling  ·  sync-solution-items                                  ↓
                    (Querschnitt, von überall gerufen)                              commitMessage
```

Getippt wird **ein** Einstieg. Den Rest zieht die Kette selbst nach.

Jedes Glied ist aber auch **einzeln betretbar** — eine Session kann jederzeit enden und am nächsten Tag steigt man mittendrin wieder ein. Kein Skill setzt voraus, dass sein Vorgänger in derselben Session lief (siehe `docs/decisions/0016-skills-are-cold-start-capable.md`).

## 1.2 Was wo landet

Alles unter `docs/` gehört ins Repo und wird committet. `.smax/` und `.worktrees/` sind git-ignorierter Scratch. `C:\Temp` verlässt das Projekt bewusst.

| Pfad | Wer legt es an | Wann |
|---|---|---|
| `docs/00_Analysis/<Slug>/ANALYSIS-<Slug>-DDMMYYYY.md` | `writing-specs` | Bewertung von etwas Bestehendem, ohne Bauentscheidung |
| `docs/01_Specs/<Slug>/SPEC-<Slug>-DDMMYYYY.md` | `writing-specs` | Entwurf für etwas, das gebaut wird |
| `docs/02_Plans/<Slug>/PLAN-<Slug>-DDMMYYYY.md` | `writing-plans` | Umsetzungsplan, Task für Task |
| `docs/03_DbChanges/<Slug>/DDMMYYYY-<Slug>.forward.sql` + `.rollback.sql` | Implementer, als Task-Schritt | wenn der Plan Schema-Änderungen enthält — Datum hier **Präfix**, nicht Suffix |
| `CONTEXT.md` (Repo-Root) · ggf. `CONTEXT-MAP.md` | `domain-modeling` | sobald der erste Begriff feststeht — sofort, nicht am Sessionende |
| `docs/decisions/NNNN-slug.md` | `domain-modeling` | pro Entscheidung, die schwer umkehrbar + ohne Kontext überraschend + Ergebnis eines echten Trade-offs ist |
| `CLAUDE.md` (Projekt) | `domain-modeling` | zwei Blöcke: *Domänensprache* (importiert `@CONTEXT.md`) und *Entscheidungen* (lehrt das Zugriffsmuster, importiert **nichts**) |
| `.smax/sdd/<plan-basename>/` | `subagent-driven-development` | Ledger `progress.md`, `task-N-brief.md`, `task-N-report.md`, Review-Pakete. Git-ignoriert. Wird von `finishing-a-development-branch` gelöscht, **erst nachdem** der Branch gelandet ist |
| `.worktrees/<branch>/` | `using-git-worktrees` | isolierter Arbeitsbereich, falls kein nativer Worktree da ist |
| `C:\Temp\HANDOFF-<name>.md` | `handoff` | Session-Übergabe — beschreibt eine Session, nicht den Code, gehört deshalb nicht ins Repo |
| `C:\Temp\REPLICATE-<name>.md` | `replicate` | Rezept für System-/Config-Änderungen dieser Session |
| `C:\Temp\<name>.pdf` | `md-to-pdf` | erzeugtes Artefakt, kein Quelltext |
| `MISSION.md`, `RESOURCES.md`, `NOTES.md`, `lessons/`, `reference/`, `learning-records/`, `assets/` | `teach` | im jeweiligen Lern-Workspace |

Der **PascalCase-Slug** (`TipAllowance`) wird einmal in `writing-specs` festgelegt und von allen nachgelagerten Skills unverändert übernommen. Das **Datumssuffix** ist funktional: `subagent-driven-development` leitet seinen Workspace-Pfad aus dem Plan-Dateinamen ab — ohne Datum teilen sich zwei Pläne desselben Themas ein Ledger.

`Archive/` wird von keinem Skill beschrieben und nie als aktueller Kontext gelesen. Archivieren ist Handarbeit.

## 1.3 Was von selbst läuft — und was gefragt wird

**Ohne Rückfrage:**

- Task-Commits auf dem Feature-Branch (der wird ohnehin gesquasht und gelöscht)
- Einträge in `CONTEXT.md` und `docs/decisions/`, sobald etwas feststeht
- Ergänzungen an der Projekt-`CLAUDE.md` — aber nie stillschweigend, es wird immer gesagt was geändert wurde
- Erkennung eines vorhandenen Worktrees, Setup, Baseline-Tests
- Dispatch von Implementer- und Reviewer-Subagents
- der *Lauf* von `sync-solution-items`, wenn im Repo-Root eine `.slnx` liegt — den Commit macht der aufrufende Skill, und direkt aufgerufen committet es gar nicht

**Mit Rückfrage** — alles, was den Zustand außerhalb des Wegwerf-Branches ändert oder History zerstört (`docs/decisions/0008-confirm-git-actions-outside-branch.md`):

| Aktion | wo |
|---|---|
| Der eine Design-Commit für Spec + Glossar + Decisions + Plan | Ende von `writing-plans` |
| Ausnahme-Commit, wenn die Kette schon am Spec-Gate endet | `writing-specs` |
| Squash-Commit auf den Base-Branch | `finishing-a-development-branch` |
| `git branch -D <feature>` | dito, separat vom Commit |
| `git push` | dito, separat |
| Pull Request anlegen | dito, **noch einmal separat** vom Push |
| Arbeit verwerfen | dito — nur gegen das getippte Wort `discard` |
| Worktree anlegen · `.gitignore`-Zeile committen | `using-git-worktrees` |

Ein Ja zu einer dieser Aktionen ist kein Ja zur nächsten.

## 1.4 Die Gates

Drei Stellen blocken, statt nur zu erinnern:

- **Glossar-Gate** (`writing-specs`, `writing-plans`): kein Dokument und kein Plan, solange gepinnte Begriffe nicht in `CONTEXT.md` stehen. Eine Terminologie-Tabelle *im* Spec zählt nicht — vier Mechanismen lesen `CONTEXT.md`, keiner liest das Spec.
- **Review-Gate** (`finishing-a-development-branch`): kein Branch erreicht das Merge-Menü ungereviewt. Als Nachweis zählt nur eine Ledger-Zeile `Final review: clean (HEAD <sha7>)`, deren SHA auf den aktuellen HEAD passt — keine Erinnerung aus dem Gespräch.
- **Dokument-Reviewer** (`writing-specs`, `writing-plans`): ein frischer Subagent liest gegen, `Issues` werden behoben, genau **ein** Re-Review, dann entscheidet der Mensch.

## 1.5 Decisions — der stabile Kern

`docs/decisions/` hält fest, **was hier absichtlich vom naheliegenden Weg abweicht**. Je eine Datei `NNNN-slug.md`, geschrieben über `smax:domain-modeling`. Kurz — ein bis drei Sätze reichen; der Wert liegt darin, *dass* entschieden wurde und *warum*, nicht in ausgefüllten Abschnitten.

**Eine Decision entsteht nur, wenn alle drei zutreffen:**

1. **Schwer umkehrbar** — es später anders zu machen kostet spürbar
2. **Ohne Kontext überraschend** — ein späterer Leser fragt sich „warum um alles in der Welt so?"
3. **Ergebnis eines echten Trade-offs** — es gab Alternativen, eine wurde aus Gründen gewählt

Fehlt eines davon, entsteht keine. Sonst verwässert das Verzeichnis zu einem Änderungsprotokoll.

**Der Zugriff ist bewusst sparsam.** Der Dateiname ist der Index: `ls docs/decisions/`, nach Titel urteilen, null bis zwei Dateien öffnen. **Nie das ganze Verzeichnis lesen** — es wächst unbegrenzt, und alles zu laden verdrängt genau den Kontext, der für die Aufgabe gebraucht wird.

**Gelesen wird an vier Stellen, zu vier verschiedenen Zeitpunkten:**

| Wo | Wann genau |
|---|---|
| `brainstorming` | Schritt 1 der Checkliste — vor der ersten Rückfrage, vor jedem Entwurf |
| `writing-plans` | beim Schreiben des Plan-Headers, im `Global Constraints`-Block — vor den Tasks |
| `debugging` | bevor eine mechanische Ursachenerklärung akzeptiert wird — nicht am Anfang der Suche |
| `code-reviewer.md` | im dispatchten Reviewer-Subagenten, während er den Diff prüft |

Die Reviewer-Vorlage wird aus **drei** Richtungen dispatcht: getipptes `/smax:code-review`, das Review-Gate in `finishing-a-development-branch`, und das Whole-Branch-Review am Ende von `subagent-driven-development`. Die letzten beiden laufen ohne Zutun — der Check erreicht den Code also öfter, als „`code-review` ist ein Command" vermuten lässt.

**Der Alltagsfall wird von keinem der vier erfasst** — „mach mal X", ein schneller Refactor, kein Skill im Spiel. Dafür trägt `domain-modeling` das Zugriffsmuster zusätzlich in die Projekt-`CLAUDE.md` ein, die immer im Kontext ist. Importiert wird dabei **nichts**: Der Block lehrt den Zugriff, er lädt keine Inhalte. Er hat allerdings auch keinen festen Auslöser, sondern beschreibt Situationen („bevor du eine Architektur- oder Designfrage entscheidest", „bevor du etwas reparierst, das merkwürdig gebaut aussieht"), auf die der Agent selbst kommen muss. Das ist die schwächste Stelle der Kette — und die bewusst in Kauf genommene, weil die Alternative ein Import wäre, der in jeder Session Kontext kostet.

**Überstimmen ist erlaubt, stilles Übergehen nicht.** Läuft ein Vorschlag einer Decision zuwider, wird das mit Dateinamen gesagt, bevor er umgesetzt wird. Wird sie tatsächlich umgeworfen, bekommt die alte den Status `superseded by Decision-NNNN` — gelöscht wird nie. Einträge mit `superseded` oder `deprecated` binden nicht mehr.

> **Bekannte Lücke:** Es gibt **keine** Prüfung von Decisions *gegeneinander*. Alle vier Lesestellen prüfen etwas anderes gegen eine Decision — Entwurf, Diff, Code, Reviewer-Einwand. Ob zwei Decisions einander widersprechen, fällt niemandem auf, außer beide werden zufällig zusammen geöffnet. Das ist strukturell so: Ein vollständiger Konsistenzcheck müsste alle Dateien lesen, und genau das verbietet das Zugriffsmuster oben. Wer die Konsistenz prüfen will, macht das als bewussten, seltenen Durchgang — nicht als Dauerregel.

---

# 2 · Die Commands

Die zweite Hälfte des Plugins. Die Kette oben ist der lange Weg von der Idee zum gelandeten Branch — daneben stehen Commands, die je **eine abgeschlossene Aufgabe** lösen und mit dem Workflow nichts zu tun haben. Kein Beiwerk: Im Alltag tippe ich sie öfter als jeden Kettenschritt.

**Ein Command ist ein Skill mit `disable-model-invocation: true`** — starten kann ihn **nur ich**, Claude nicht, auch nicht aus einem anderen Skill heraus. Ein Plugin kann keine echten Slash-Commands ausliefern (die gibt es nur unter `~/.claude/commands/`), also ist das geflaggte Skill der Weg dorthin. Der Aufruf ist derselbe: `/smax:<name>`.

## 2.1 Eigenständig, ohne Kette

Diese acht rufen keinen Skill und werden von keinem gerufen. Getippt wird der Name, fertig. Argumente stehen in den Tabellen in §5.

| Command | wofür |
|---|---|
| `replicate` | System- und Config-Änderungen dieser Session als nachvollziehbares Rezept, um sie anderswo nachzuziehen |
| `teach` | ein Thema geführt lernen statt es bauen zu lassen — mit Mission, Glossar und Learning-Records |
| `infographic-page` | ein Thema als eigenständige HTML-Seite erklären (dunkles Layout, ausklappbare Abschnitte, eine Datei) |
| `data-model-diagram` | ein Datenmodell als eigenständige HTML-Seite zeichnen — Tabellenkarten mit Schlüsseln, starre Beziehungslinien, zugeklappt lesbar, mit Druckmodus |
| `proad-job-report` | aus einem Commit den deutschen Arbeitsbericht erzeugen, der beim Kunden auf der Rechnung landet |
| `nano-vs-colors` | Syntax-Highlighting für `nano` unter Git Bash einrichten oder auf eine weitere Maschine mitnehmen |
| `find-beer-deals` | aktuelle Bier-Aktionen in der Nähe suchen |
| `whats-for-lunch` | die heutigen Mittagsangebote der Stamm-Lokale zusammenfassen |

## 2.2 Commands, die nicht allein stehen

`brainstorming`, `code-review`, `sharpen-me` und `sharpen-with-docs` tragen dasselbe Flag, sind aber Glieder des Workflows — sie stehen in §1. Aus genau dieser Teilmenge entsteht die Einschränkung in [§4 · Geht gar nicht per Modell](#geht-gar-nicht-per-modell): Ein Skill kann einen Command nicht aufrufen, auch wenn die Kette an der Stelle weiterlaufen müsste.

`lap-training` und `handoff` tragen das Flag ebenfalls und stehen seit dem Handoff-Angebot am Sessionende nicht mehr in §2.1: `lap-training` ruft `handoff` als Pfad auf, damit trifft „ruft keinen Skill und wird von keinem gerufen" auf keinen von beiden mehr zu. Glieder des Workflows in §1 sind sie nicht.

**Nicht dazu gehört `dispatching-parallel-agents`** — kettenlos, aber kein Command: Claude darf es selbst auslösen, sobald mehrere unabhängige Aufgaben anstehen.

---

# 3 · Wo steige ich ein?

| Situation | Einstieg | Was daraus wird |
|---|---|---|
| **Idee, aber noch kein Bild davon.** | `/smax:brainstorming` | Exploration → `domain-modeling` → `writing-specs` |
| **Plan/Entscheidung steht, hält sie?** | `/smax:sharpen-me` | Schonungsloses Interview, Frage für Frage → Angebot, es als SPEC festzuhalten |
| **Dasselbe, Domäne soll mitwachsen.** | `/smax:sharpen-with-docs` | wie oben, pflegt nebenbei `CONTEXT.md` und Decisions |
| **Begriff festzurren oder Entscheidung festhalten.** | `/smax:domain-modeling` | `CONTEXT.md`, `docs/decisions/NNNN-slug.md`, Zugriffsmuster in der Projekt-`CLAUDE.md` |
| **Spec steht, jetzt bauen.** | `/smax:writing-plans` | Plan → `using-git-worktrees` → SDD oder `executing-plans` |
| **Plan steht, abarbeiten.** | `/smax:subagent-driven-development` | Task je Subagent, Controller prüft jeden Report, ein Whole-Branch-Review am Ende |
| **Etwas ist kaputt.** | `/smax:debugging` | Ursache vor Fix → `test-driven-development`, `verification-before-completion` |
| **Fertig, wie kommt es rein?** | `/smax:finishing-a-development-branch` | Review-Gate, Squash-Landung → `commitMessage` |
| **Nur die Commit-Message.** | `/smax:commitMessage` | semantische Message; bei Squash-Branches mit Body |
| **Skill schreiben oder ändern.** | `/smax:writing-skills` | Aufbau, Testen mit Subagents |
| **Etwas verstehen, nicht bauen.** | `/smax:teach` | geführtes Lernen mit Mission, Glossar, Learning-Records |
| **Übergabe an die nächste Session.** | `/smax:handoff` | selbsttragendes Dokument nach `C:\Temp` |
| **Maschinen-Änderungen nachziehen.** | `/smax:replicate` | Re-Apply-Rezept nach `C:\Temp` |
| **Auf die LAP lernen.** | `/smax:lap-training` | Prüfungsrunde, Fortschritt in `log.md`/`progress.md` → Angebot, die Schwachstellen per `handoff` an `/smax:teach` zu übergeben |

Das ist der Weg **in die Kette**. Die eigenständigen Commands stehen davor in [§2.1](#21-eigenständig-ohne-kette) — sie haben mit dem Workflow nichts zu tun.

---

# 4 · Was ich nicht direkt aufrufe

## Geht gar nicht per Modell

Alle **Commands** (`disable-model-invocation: true`) kann **nur ich** tippen — Claude kann sie nicht selbst starten, auch nicht aus einem anderen Skill heraus. Praktische Folge, die dreimal gebissen hat:

- **`code-review`** ist ein Command. Ein Agent, der einen Plan abarbeitet, kann es nicht aufrufen. Deshalb schreibt `writing-plans` in jeden Plan zusätzlich den **aufgelösten Dateipfad** zur Reviewer-Vorlage (`docs/decisions/0017-reviewer-template-as-resolved-path.md`).

  **Das heißt nicht, dass das Review ausfällt.** Blockiert ist nur der Skill-Wrapper, nicht die Vorlage `code-reviewer.md`: `finishing-a-development-branch` dispatcht sie **vor dem Squash automatisch**, `subagent-driven-development` am Branch-Ende ebenso — beide ohne Zutun. Der Pfad im Plan deckt allein den Restfall ab, in dem ein Plan abgearbeitet wird, ohne dass einer dieser beiden Skills Regie führt.
- **`sharpen-with-docs`** ist ein Command. `writing-specs` ruft deshalb `sharpen` + `domain-modeling` einzeln auf, nicht den Wrapper.
- **`handoff`** ist ein Command. `lap-training` bietet am Sessionende an, die Schwachstellen zu übergeben, kann den Skill aber nicht starten — es liest deshalb `../../dev/handoff/SKILL.md` und folgt ihm. `teach` liegt gleich: der Skill gibt den Aufruf aus, tippen musst du ihn.

## Geht, kostet aber ein Gate

| Skill | was fehlt beim Direktaufruf |
|---|---|
| `writing-specs` | die Frage *„soll das überhaupt aufgeschrieben werden?"* — die kommt aus `brainstorming`/`sharpen-me`. Direkt sinnvoll nur, wenn die Denkarbeit schon gelaufen ist. |
| `writing-plans` | ohne Spec gibt es keine Anforderungen für die `Global Constraints`. Das Glossar-Gate greift trotzdem. |
| `finishing-a-development-branch` | ohne passenden SDD-Ledger feuert das Review-Gate und reviewt den ganzen Branch neu. Korrekt, aber teuer. |

## Läuft ohnehin von selbst

Diese zieht die Kette von selbst — getippt werden **müssen** sie nie: `using-git-worktrees`, `domain-modeling`, `sync-solution-items`, `test-driven-development`, `verification-before-completion`.

**„Muss nicht" heißt nicht „bringt nichts".** `domain-modeling` ist der Fall, der beides ist: Die Kette ruft es als Querschnitt (§5), direkt getippt startet es eine eigene Modellierungs-Session — Begriffe festzurren, `CONTEXT.md` aufbauen, eine Decision festhalten. Für eine Decision, während gerade kein Entwurf läuft, ist der Direktaufruf sogar der einzige Weg.

## Verdrängt

`executing-plans` — `subagent-driven-development` ist in fast allen Fällen besser. Der Skill sagt das selbst in seiner ersten Notiz.

---

# 5 · Alle Skills

Aufruf mit Präfix: `/smax:<name>`. Der Name kommt aus dem `name:`-Frontmatter — der Gruppen-Unterordner ist rein organisatorisch.

**Trigger:** *Command* = nur von mir getippt · *Skill* = Claude kann ihn auch selbst auslösen. Der Unterschied ist in [§2](#2--die-commands) erklärt.

### dev — Workflow-Kette

Größtenteils aus **superpowers** abgeleitet und umgebaut. Welche Datei woher stammt und wie weit sie divergiert ist, steht je Datei in [plugin/NOTICE.md](./plugin/NOTICE.md).

| Skill | Argumente | Trigger |
|---|---|---|
| brainstorming | — | Command |
| writing-specs | — | Skill |
| writing-plans | — | Skill |
| executing-plans | — | Skill |
| subagent-driven-development | — | Skill |
| using-git-worktrees | — | Skill |
| code-review | — | Command |
| finishing-a-development-branch | — | Skill |
| commitMessage | — | Skill |
| debugging | — | Skill |
| test-driven-development | — | Skill |
| verification-before-completion | — | Skill |
| dispatching-parallel-agents | — | Skill |
| writing-skills | — | Skill |

### dev — Denken & Doku

`sharpen`, `sharpen-me`, `sharpen-with-docs`, `domain-modeling` und `teach` stammen von **mattpocock/skills**, der Rest ist eigen. Auch hier gilt: Herkunft und Umbautiefe je Datei in [plugin/NOTICE.md](./plugin/NOTICE.md).

| Skill | Argumente | Trigger |
|---|---|---|
| sharpen | `[plan/decision/idea]` | Skill |
| sharpen-me | `[plan or decision]` | Command |
| sharpen-with-docs | `[plan or decision]` | Command |
| domain-modeling | — | Skill |
| sync-solution-items | — | Skill |
| teach | `[Thema]` | Command |
| handoff | `[focus next session]` | Command |
| replicate | `[focus of changes]` | Command |
| infographic-page | `<topic> [focus]` | Command |
| data-model-diagram | `<model source (spec, DDL, schema)> [target path]` | Command |
| md-to-pdf | `<file.md> [more.md ...]` | Skill |

### dev — Kunden- & Web-Aufgaben

| Skill | Argumente | Trigger |
|---|---|---|
| mail-draft | `[Empfänger / Thema]` | Skill |
| proad-job-report | `[commit ref, default HEAD]` | Command |

### personal

| Skill | Argumente | Trigger |
|---|---|---|
| find-beer-deals | `<beer> [ZIP/town]` | Command |
| whats-for-lunch | — | Command |
| nano-vs-colors | — | Command |
| lap-training | `[Minuten] \| simulation \| status` | Command |

### repo-lokal — nur in diesem Repo

Liegt unter `.claude/skills/`, wird **nicht** ausgeliefert und ist nur hier
verfügbar. Aufruf ohne Präfix.

| Skill | Argumente | Trigger |
|---|---|---|
| sync-plugin-docs | — | Skill |

Warum nicht im Plugin: `docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`.

### Wer ruft wen

| Skill | ruft |
|---|---|
| `brainstorming` | `domain-modeling`, `writing-specs` |
| `writing-specs` | `domain-modeling`, `sync-solution-items`, `sharpen`, `writing-plans` |
| `writing-plans` | `domain-modeling`, `sync-solution-items`, `code-review` (als Pfad), `commitMessage`, `subagent-driven-development`, `executing-plans` |
| `executing-plans` | `using-git-worktrees`, `subagent-driven-development`, `finishing-a-development-branch` |
| `subagent-driven-development` | `using-git-worktrees`, `code-review` (als Pfad), `finishing-a-development-branch` |
| `finishing-a-development-branch` | `code-review` (als Pfad), `commitMessage` |
| `debugging` | `test-driven-development`, `verification-before-completion`, `domain-modeling` |
| `writing-skills` | `test-driven-development` |
| `sharpen-me` | `sharpen`, `writing-specs` |
| `sharpen-with-docs` | `sharpen`, `domain-modeling`, `writing-specs` |
| `domain-modeling` | `sync-solution-items` |
| `lap-training` | `handoff` (als Pfad) |

`domain-modeling` ist der Querschnitts-Satellit — gerufen von `brainstorming`, `writing-specs`, `writing-plans`, `debugging`, `sharpen-with-docs`. Mehr eingehende Aufrufe als jeder andere Skill.

`sync-solution-items` ist der zweite Satellit und greift **nur** bei einer `.slnx` im Repo-Root. Die Aufrufer prüfen das vorher und überspringen ihn sonst wortlos. In Nicht-.NET-Projekten existiert der Schritt schlicht nicht.

---

# 6 · Development

Ziel: **im Repo editieren, committen, Claude neu starten, fertig.** Kein Push, kein `/plugin marketplace update`, kein Symlink.

## 6.1 Marketplace-Mechanik in vier Sätzen

Ein *Marketplace* ist ein Katalog (`.claude-plugin/marketplace.json`) und sagt, welche Plugins es gibt und wo sie liegen. Ein *Plugin* hat sein eigenes Manifest (`plugin/.claude-plugin/plugin.json`) und listet seine Skill-Verzeichnisse. **Marketplace-Quelle und Plugin-Quelle sind zwei verschiedene Dinge**: die Marketplace-Quelle sagt, woher der Katalog kommt (GitHub, Git-URL, lokales Verzeichnis), die Plugin-Quelle steht *im* Katalog und ist hier ein relativer Pfad (`./plugin`) — also dasselbe Repo. Registriert wird der Marketplace entweder per `/plugin marketplace add` oder deklarativ über `extraKnownMarketplaces` in den Settings.

**Bei einer `directory`-Quelle wird das Plugin an Ort und Stelle gelesen** — es landet keine Kopie unter `~/.claude/plugins/cache/`, und der Skill-Header zeigt direkt ins Repo. Die offizielle Doku sagt pauschal, Plugins würden beim Installieren in den Cache kopiert; für lokale Quellen stimmt das nicht (am 31.07.2026 nachgeprüft). Genau darauf beruht der ganze Dev-Loop.

## 6.2 Setup der Dev-Maschine

**Repo klonen:**

```bash
git clone https://github.com/Smax1988/smax-skills.git C:/Projects/smax-skills
```

**Als lokale Marketplace-Quelle eintragen** in `~/.claude/settings.json` — maschinenspezifischer Pfad, gehört deshalb **nicht** ins Repo:

```json
{
  "extraKnownMarketplaces": {
    "smax-skills": {
      "source": { "source": "directory", "path": "C:/Projects/smax-skills" }
    }
  },
  "enabledPlugins": {
    "smax@smax-skills": true
  }
}
```

Kein `/plugin install` nötig — `enabledPlugins` genügt, Claude Code zieht den Marketplace beim Start.

Kein `autoUpdate` — es gibt keinen Upstream zu ziehen. Aktualisiert wird mit `git pull` im Repo. Aus demselben Grund ist `/plugin marketplace update smax-skills` hier wirkungslos.

> War die Maschine vorher auf der GitHub-Quelle, reicht das Ändern der Settings **nicht**: Claude Code merkt sich die Registrierung in `~/.claude/plugins/known_marketplaces.json` und den Installationsstand in `installed_plugins.json`. Beide Einträge für `smax-skills` bzw. `smax@smax-skills` entfernen, dann neu starten — sie werden aus den Settings neu angelegt. Sonst läuft weiter die alte Cache-Kopie.

## 6.3 Der Loop

1. `SKILL.md` unter `C:\Projects\smax-skills\plugin\skills\…` editieren.
2. Committen.
3. Claude neu starten.
4. `/smax:<skill>` aufrufen.

**Warum Neustart und nicht `/reload-plugins`:** Claude Code friert Skill-Inhalte **beim Session-Start** ein, nicht beim Aufruf. Eine laufende Session sieht spätere Änderungen an einer `SKILL.md` nicht, egal wann der Skill aufgerufen wird. Wer das vergisst, hält einen frisch gebauten Fix für wirkungslos, weil er nie geladen wurde.

**Immer die Quelle bearbeiten** — nie eine Kopie unter `~/.claude/plugins/cache/`.

**Warum committen, obwohl der Working Tree gelesen wird:** Technisch nötig ist es nicht — bei der lokalen Quelle ist ein Edit auch uncommittet nach dem Neustart wirksam. Der Commit ist Disziplin: Er stellt sicher, dass die Fassung, die du testest, auch die ist, die auf den anderen Maschinen ankommt, und er ist der Rückweg, wenn ein Skill sich nach der Änderung seltsam verhält.

## 6.4 Welche Fassung läuft gerade?

Die Frage, sobald eine Änderung „nicht wirkt".

**Der eine Beweis:** irgendeinen Skill aufrufen und die erste Zeile des injizierten Textes lesen.

```
Base directory for this skill: C:\Projects\smax-skills\plugin\skills\dev\<skill>
```

Zeigt sie ins Repo, läuft die lokale Quelle. Zeigt sie nach `~/.claude/plugins/cache/…`, läuft eine Cache-Kopie — dann stimmt das Setup nicht, siehe den Kasten in 6.2. Das ist der einzige Check, der beweist statt vermutet, und er funktioniert in beiden Betriebsarten.

Fällt er unerwartet aus, diese zwei zur Eingrenzung:

```bash
cat ~/.claude/plugins/known_marketplaces.json       # welche Quelle ist registriert?
ls -d ~/.claude/plugins/cache/smax-skills/smax/*/   # liegen noch Cache-Kopien herum?
```

> **Cache-Zeitstempel beweisen nichts.** Am 31.07.2026 trug eine Cache-Kopie einen taufrischen Zeitstempel und enthielt trotzdem die Fassung von vorgestern — das hat die Diagnose eine Runde gekostet. Bei einer `directory`-Quelle sollte dort ohnehin nichts liegen; was noch da ist, ist Altlast und kann weg.

## 6.5 Eine Maschine wieder auf Nicht-Dev stellen

Für Rechner, die das Plugin nur benutzen sollen:

```json
{
  "extraKnownMarketplaces": {
    "smax-skills": {
      "source": { "source": "git", "url": "https://github.com/Smax1988/smax-skills.git" },
      "autoUpdate": true
    }
  }
}
```

Danach den `smax-skills`-Eintrag aus `known_marketplaces.json` und `smax@smax-skills` aus `installed_plugins.json` entfernen und neu starten — sonst bleibt die lokale Registrierung stehen.

Mit `autoUpdate` holt Claude Code neue Commits nach Session-Start automatisch (Verzögerung bis ~10 Min); die **aktive** Session lädt sie erst nach `/reload-plugins`. Ohne `autoUpdate` manuell:

```
/plugin marketplace update smax-skills
/reload-plugins
```

**Versionierung:** `version` ist in `plugin.json` bewusst weggelassen → jeder Commit gilt als neue Version. Ein `version`-Feld nur setzen, wenn ich kontrollierte Releases will.

**An-/Abschalten ohne Deinstallation:**

```
/plugin disable smax@smax-skills
/plugin enable  smax@smax-skills
```

> Alten Klon unter `~/.claude/skills` entfernen — sonst sind die Skills doppelt (`/handoff` **und** `/smax:handoff`). Dasselbe gilt für gleichnamige Slash-Commands unter `~/.claude/commands/`: die schatten den Plugin-Skill.

## 6.6 Ohne jede Installation testen

Gilt nur für die eine Session:

```
claude --plugin-dir C:/Projects/smax-skills
```

## 6.7 Neuen Skill hinzufügen

1. `plugin/skills/dev/<name>/SKILL.md` anlegen (oder `personal/`).
2. Frontmatter:
   ```yaml
   ---
   name: <name>                         # = Aufrufname, kebab-case
   description: <wann/wofür>            # nur Auslöser, nie den Ablauf zusammenfassen
   argument-hint: [optional]            # nur wenn der Skill Parameter nimmt
   allowed-tools: Tool, mcp__server__*  # nur wenn beschränkt werden soll
   disable-model-invocation: true       # macht den Skill zum Command
   ---
   ```
3. Committen, neu starten.

`allowed-tools` ist bei Skills eine **harte Beschränkung**, keine Auto-Approve-Liste — wer schreibt, braucht `Write` in der Liste.

Die `description` **nie** den Ablauf zusammenfassen lassen: Agenten folgen dann der Beschreibung statt dem Skill-Text. Nur Auslösebedingungen. Details in `writing-skills`.

**Repo-lokal statt Plugin.** Ein Skill, der nur in *diesem* Repo Sinn ergibt,
kommt nach `.claude/skills/<name>/SKILL.md`. Kein Eintrag im Plugin-Manifest,
kein Marketplace, nach einem Neustart da. Er steht **nicht** in
`plugin/NOTICE.md` — das führt ausgelieferte Dateien und ihre Upstream-Herkunft,
und beides trifft hier nicht zu. Aufruf ohne `smax:`-Präfix.

Die Kehrseite: **Kein Plugin-Skill darf ihn referenzieren.** Der Pfad existiert
in keinem anderen Repo, und der Verweis liefe dort still ins Leere.

## 6.8 Neue Gruppe hinzufügen

1. Ordner `plugin/skills/<gruppe>/` anlegen.
2. Pfad in `plugin/.claude-plugin/plugin.json` ergänzen, sonst wird die Gruppe nicht gefunden:
   ```json
   { "skills": ["./skills/dev", "./skills/personal", "./skills/<gruppe>"] }
   ```
   Pfade sind relativ zum **Plugin**-Root (`plugin/`), nicht zum Repo-Root. Der Aufrufname ändert sich dadurch nicht.

---

# 7 · Hintergrund

## Struktur

```
.claude-plugin/
└── marketplace.json           # Marketplace (name: smax-skills)
plugin/
├── .claude-plugin/
│   └── plugin.json            # Plugin-Manifest (name: smax)
├── NOTICE.md                  # Herkunft der abgeleiteten Dateien, je Upstream ein Abschnitt
└── skills/
    ├── dev/<skill>/SKILL.md
    └── personal/<skill>/SKILL.md
docs/                          # wird nicht ausgeliefert
├── 00_Analysis/ 01_Specs/ 02_Plans/ 03_DbChanges/
└── decisions/                 # NNNN-slug.md — warum dieses Repo abweicht
CLAUDE.md                      # Projektanweisungen, immer im Kontext
TODOS.md                       # offene Arbeit, nummeriert und gruppiert
```

## Decisions

Siehe [1.5](#15-decisions--der-stabile-kern) — sie gehören zum Arbeitsablauf, nicht in den Anhang.

## Herkunft

**Zwei Upstreams, beide MIT.**

Der Workflow-Teil ist von **superpowers** (Jesse Vincent) abgeleitet und umgebaut: Referenzen auf `smax:`, Arbeitsverzeichnisse auf `.smax/`, Dokumentpfade auf die `docs/`-Konvention dieses Repos, dazu inhaltliche Änderungen.

Fünf Skills stammen von **mattpocock/skills** (Matt Pocock): `sharpen`, `sharpen-me`, `sharpen-with-docs`, `domain-modeling` und `teach`. Die drei `sharpen*` hießen upstream `grill*` — die Umbenennung hat die Herkunft am Dateinamen getilgt und den zweiten Upstream vom ersten Tag des NOTICE bis zum 04.08.2026 daraus herausgehalten.

Alles andere ist eigen. Upstream-Stand, Dateiliste, Einstufung und Lizenztext je Upstream in [plugin/NOTICE.md](./plugin/NOTICE.md) — das *Warum* in `docs/decisions/`.

## Mehrere Maschinen / zwei git-Konten

Öffentliches GitHub-Repo, getrennt vom betrieblichen Azure DevOps (dort liegt `cnx-skills`), Credentials pro Host getrennt (GCM-Konto-Popup beim Zugriff). Lesen braucht kein Konto. Pushen darf das private GitHub-Konto und, vom Firmengerät aus, das Firmen-GitHub-Konto als Collaborator. Kein `smax`-Skill ruft einen `cnx`-Skill.

## Zeilenenden

`.gitattributes` erzwingt LF überall — kein CRLF/LF-Churn cross-machine.

---

*Änderst du Marketplace- oder Plugin-Namen, hier und in beiden Manifesten mitziehen (`.claude-plugin/marketplace.json`, `plugin/.claude-plugin/plugin.json`).*
