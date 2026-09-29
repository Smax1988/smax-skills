# Smax Skills

Marketplace-Repo für das `smax`-Plugin. Die Skills liegen unter
`plugin/skills/dev/` und `plugin/skills/personal/`.

Der Workflow-Teil ist aus **superpowers 6.2.0** abgeleitet (MIT, © 2025 Jesse
Vincent), fünf weitere Skills aus **mattpocock/skills** (MIT, © 2026 Matt
Pocock) — beide bewusst divergiert. `plugin/NOTICE.md` sagt, *was* abweicht;
`docs/decisions/` sagt, *warum*. Vor einem Upstream-Abgleich beides lesen.

## Öffentliches Repo

Dieses Repo ist public. **Keine Kundennamen, internen Hosts, Account-IDs oder
Firmen-Mailadressen** — weder in Skills noch in Docs, Decisions, `TODOS.md`,
Beispielen oder Commit-Messages. Ein Skill, der ohne solche Daten nicht
funktioniert, gehört ins interne Plugin `cnx` (`C:\Projects\cnx-skills`), und
kein `smax`-Skill ruft `cnx:`. Warum:
`docs/decisions/0025-company-skills-in-separate-plugin.md`.

## Domänensprache

Die verbindlichen Begriffe dieses Projekts stehen in @CONTEXT.md.

**Verwende sie.** Im Gespräch genauso wie in Code, Bezeichnern, Commits und
Dokumentation. Wenn du etwas erklärst oder beschreibst, nimm den kanonischen
Namen, nicht ein Synonym.

**Code ist englisch.** Ausnahmslos: Bezeichner, Typen, Funktionen, Dateinamen,
Kommentare. Deutsch steht nur in Strings, die ein Mensch am Bildschirm sieht.
Ist ein kanonischer Begriff deutsch, nennt sein Glossar-Eintrag den englischen
Code-Namen in Backticks — nimm den, nicht deine eigene Übersetzung. Frage ich
„wie heißt X im Code?", steht die Antwort dort.

**Fehlt ein Code-Name, entscheiden wir einen.** Kein Begriff ist ausgenommen,
auch Produktnamen und Rechtsbegriffe nicht. Gibt es kein offensichtliches
englisches Wort, schlag mir zwei oder drei vor und trag das Gewählte ins
Glossar ein — nicht das deutsche Wort stehen lassen, nicht still selbst
übersetzen.

**Verstehe meine.** Die unter `_Avoid_` gelisteten Varianten meinen denselben
Begriff — übersetze still und antworte kanonisch. Korrigiere mich nicht bei
jeder Nennung; das gehört in eine Modellierungs-Sitzung, nicht in die
alltägliche Arbeit.

**Frag bei Unbekanntem.** Benutze ich einen Begriff, der weder kanonisch noch
unter `_Avoid_` steht, rate nicht. Sag, dass er im Glossar fehlt, und frag
nach — entweder fehlt ein Eintrag, oder wir reden von etwas Neuem.

## Offene Arbeit

`TODOS.md` im Root, **mitpflegen**: Was aufkommt und nicht sofort erledigt wird
— Idee, gefundener Fehler, vertagte Entscheidung — kommt dort hinein statt in
der Antwort zu verklingen; Erledigtes wird gestrichen. Wie gruppiert und wie
ein Eintrag auszusehen hat, steht im Kopf der Datei.

## Abgeleitete Dokumente

`README.md`, `plugin/NOTICE.md` und die Anforderungsliste
`plugin/skills/dev/setup/requirements.md` sind aus dem Skill-Bestand abgeleitet
und laufen still auseinander, wenn sie nicht mitgezogen werden.

**Wurde etwas unter `plugin/skills/` oder `plugin/.claude-plugin/` geändert,
lass vor dem Commit `/sync-plugin-docs` laufen.** Der Skill prüft nur, was
diese Änderung betrifft; er ist billig genug für jeden Commit. Bei Änderungen
außerhalb dieser beiden Pfade ist er reine Reibung — dann nicht.

Warum das hier steht und nicht im Skill: siehe
`docs/decisions/0015-decisions-in-project-claude-md.md`. Der
Alltagsfall ist die Änderung ohne jeden Skill-Aufruf.

## Entscheidungen

Unter `docs/decisions/` stehen die Entscheidungen, die dieses Projekt bereits
getroffen hat — je eine Datei `NNNN-slug.md`. Sie halten fest, was hier
absichtlich vom naheliegenden Weg abweicht.

**Der Dateiname ist der Index.** Sieh mit `ls docs/decisions/` nach, was es
gibt, urteile nach dem Titel und öffne nur, was zur aktuellen Aufgabe passt —
in aller Regel keine bis zwei Dateien.

**Lies nie das ganze Verzeichnis.** Es wächst unbegrenzt. Alles zu laden
verbrennt Kontext für Entscheidungen, die mit der Aufgabe nichts zu tun
haben, und verdrängt das, was tatsächlich gebraucht wird.

**Wann nachsehen:** bevor du eine Architektur- oder Designfrage entscheidest;
bevor du etwas „reparierst", das merkwürdig gebaut aussieht; wenn dich der
Aufbau einer Stelle überrascht, die du gerade änderst. Nicht bei Tippfehlern,
Formatierung oder offensichtlichen Bugfixes — dort ist schon der `ls` reine
Reibung.

**Widersprich nie still.** Läuft dein Vorschlag einer Entscheidung zuwider,
sag das mit Dateinamen, bevor du ihn umsetzt. Eine Entscheidung umzuwerfen
ist ein legitimes Ergebnis; sie zu übergehen nicht. Einträge mit Status
`superseded` oder `deprecated` binden nicht mehr.
