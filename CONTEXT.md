# Smax Skills

Marketplace-Repo für das `smax`-Plugin. Die Domäne ist das Plugin selbst: Skills,
ihre Verdrahtung untereinander und die Dokumente, die beides beschreiben.

## Language

**Skill** (`Skill`):
Ein Verzeichnis mit einer `SKILL.md`, deren Frontmatter `name` und `description`
trägt. Auslösbar über `/<name>`.
_Avoid_: Command (das ist eine Teilmenge, siehe unten), Prompt, Rezept

**Command** (`Command`):
Ein Skill mit `disable-model-invocation: true` — nur der Nutzer kann ihn tippen,
kein anderer Skill und auch das Modell nicht von sich aus.
_Avoid_: Slash-Command (ein Plugin kann keine echten liefern), User-Skill

**Aufruf** (`Call`):
Ein Skill ruft einen anderen — als `smax:<name>` oder als aufgelöster Pfad auf
eine seiner Dateien. Eine bloße Erwähnung des Namens ist kein Aufruf. Die Marker
`**REQUIRED SUB-SKILL:**` und `**REQUIRED BACKGROUND:**` zählen beide als Aufruf
(siehe `docs/decisions/0024-required-markers-count-as-calls.md`).
_Avoid_: Kante, Aufrufkante, Edge, Referenz

**Eigenständiger Command** (`StandaloneCommand`):
Ein Command, der keinen Skill ruft und von keinem gerufen wird. README §2.1
führt genau diese und heißt deshalb „Standalone, outside the chain".
_Avoid_: kantenloser Command, freistehender Command, isolierter Command

**Ketten-Command** (`ChainCommand`):
Ein Command, der im Workflow steht — er ruft oder wird gerufen. README §2.2
führt diese; sie stehen bewusst **nicht** in §2.1.
_Avoid_: Workflow-Command, gebundener Command, verketteter Command

**Plugin-Skill** (`PluginSkill`):
Ein Skill unter `plugin/skills/`. Wird ausgeliefert und steht in jedem Repo zur
Verfügung, in dem das Plugin installiert ist.
_Avoid_: globaler Skill, ausgelieferter Skill

**Repo-lokaler Skill** (`LocalSkill`):
Ein Skill unter `.claude/skills/` eines einzelnen Repos. Nur dort verfügbar, und
**kein Plugin-Skill darf auf ihn verweisen** — der Pfad existiert anderswo nicht
(siehe `docs/decisions/0018-sync-plugin-docs-stays-repo-local.md`).
_Avoid_: Projekt-Skill, privater Skill

**Abgeleitetes Dokument** (`DerivedDocument`):
Ein Dokument, dessen Inhalt aus dem Skill-Bestand herleitbar ist — heute
`README.md` und `plugin/NOTICE.md`. Das Gegenstück ist handgeschriebener Inhalt
(`TODOS.md`, `CLAUDE.md`, `docs/decisions/`), der aus dem Gespräch stammt und
aus keiner Datei berechnet werden kann. Die Grenze verläuft innerhalb eines
Dokuments, nicht zwischen Dokumenten: Eine Tabellenzeile ist abgeleitet, der
Absatz daneben nicht.
_Avoid_: generiertes Dokument, Doku, Zieldatei

**Drift** (`Drift`):
Der Zustand, in dem ein abgeleitetes Dokument dem Skill-Bestand nicht mehr
entspricht. Immer still — es gibt keinen Fehler, nur eine falsche Aussage.
_Avoid_: Veraltung, Inkonsistenz, Doku-Schulden

**Quelle** (`Source`):
Die Stelle **außerhalb** eines abgeleiteten Dokuments, aus der ein darin
stehender Fakt stammt — ein Frontmatter-Feld, die Verzeichnisstruktur, ein
Aufruf im Skill-Body, ein git-Kommando. Ein Fakt ohne Quelle ist im abgeleiteten
Dokument selbst zu Hause und anderswo nicht nachprüfbar.
_Avoid_: Anker, Referenz, Ursprung

**Quellenliste** (`SourceList`):
Die Aufstellung „Fakt → Quelle" im Skill. Sie ersetzt eine Tabelle
„Änderungsart → Abschnitt": Woher ein Fakt stammt, ist stabil; welcher
Abschnitt ihn heute trägt, veraltet mit der Gliederung.
_Avoid_: Ankerliste, Zuordnungstabelle, Abbildung, Mapping, Regelwerk

**Verdikt** (`Verdict`):
Das Urteil, das die Quellenliste einem Fakt gibt — write, ask oder report. Es
legt fest, ob geschrieben wird und welchen Abschnitt des Reports der Fakt
erreicht. Bei *ask* entscheidet zusätzlich, ob die Änderung den neuen Wert
mitliefert: dann *Zu übernehmen*, sonst *Gemeldet*.
_Avoid_: Mapping, Zuordnung, Regel

**Bucket** (`Bucket`):
Ein Klassifizierungsabschnitt in `plugin/NOTICE.md` — *Taken over unchanged*,
*Taken over, selectively extended*, *Substantially rebuilt*, *Frozen copy of
external documentation*, *No upstream origin*, *Not taken over*. Die ersten
vier ordnen **Dateien** ein, *No upstream origin* ordnet **Skills** ein, *Not
taken over* ist gemischt — dort stehen Skills, ganze Verzeichnisse
und Dateien nebeneinander.
_Avoid_: Eimer, Kategorie, Stufe, Klasse

**Vergleichsbasis** (`ComparisonBase`):
Der git-Ref, gegen den ein Drift-Lauf diffst. Bestimmt, wie viel ein Lauf
überhaupt sehen kann, und wird deshalb im Report genannt. Zwei Fälle: die
**Branch-Basis** (`git merge-base`) sieht den vollständigen Branch, die
**Sweep-Basis** nur zurück bis zur letzten Pflege eines abgeleiteten Dokuments.
_Avoid_: Referenz, Startpunkt, Baseline

**Güte** (`Coverage`):
Die Angabe im Report, wie viel die gewählte Vergleichsbasis sehen konnte —
*vollständig* bei der Branch-Basis, *unvollständig* bei der Sweep-Basis. Sie ist
die Gegenmaßnahme zum bekannten blinden Fleck, nicht seine Behebung
(siehe `docs/decisions/0020-sweep-baseline-keeps-blind-spot.md`).
_Avoid_: Abdeckung, Vollständigkeit, Konfidenz

**Sicherheitsnetz** (`SafetyNet`):
Der `grep` über die abgeleiteten Dokumente, der zusätzlich zu jeder Quelle
läuft. Er findet Fundstellen, die keine Quelle nennt — und kann prinzipiell
weder Fehlendes noch Falsches finden.
_Avoid_: Fallback, Absicherung, Fangnetz

**Falle** (`Trap`):
Eine benannte Stelle im Skill, an der die naheliegende Lesart falsch ist. Keine
Regel, sondern eine Warnung vor einer bestimmten Fehlannahme.
_Avoid_: Stolperstein, Sonderfall, Ausnahme
