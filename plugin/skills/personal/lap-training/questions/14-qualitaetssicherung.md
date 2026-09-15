# 14) Qualitätssicherung

### 14-01 · Code-Review
**Themenpunkt:** 14.1 Kenntnisse über den Zweck von Code-Reviews
**Frage:** Wozu macht man Code-Reviews?
**Muss:** Fehler früh finden, bevor sie in Test oder Produktion auffallen · Vier-Augen-Prinzip: ein Zweiter sieht Logikfehler, die der Autor übersieht
**Sicher:** Wissenstransfer im Team — nicht nur einer kennt den Code · Einhaltung von Coding-Standards und einheitlicher Stil · Reviews finden andere Fehler als Tests: Verständlichkeit, Wartbarkeit, übersehene Sonderfälle · praktisch über Pull Requests, oft verpflichtend vor dem Merge · Kritik richtet sich an den Code, nicht an die Person
**Nachhaken bei:** „Fehler finden" ohne Wissenstransfer oder Standards

### 14-02 · Schreibtischtest
**Themenpunkt:** 14.2 Fachbegriff Schreibtischtest
**Frage:** Was ist ein Schreibtischtest?
**Muss:** Manuelles Durchspielen eines Algorithmus auf Papier oder im Kopf, ohne ihn auszuführen · man verfolgt konkrete Eingabewerte Schritt für Schritt
**Sicher:** man notiert dabei die Variablenzustände in einer Tabelle, Zeile für Zeile · findet Denkfehler in der Logik, ohne Testumgebung und ohne Compiler · besonders geeignet für Schleifen und Randfälle: was passiert beim ersten und beim letzten Durchlauf · in der LAP-Prüfarbeit ein realistisches Werkzeug, wenn kein Debugger zur Verfügung steht
**Nachhaken bei:** „Code durchlesen" — der Punkt ist das Mitführen der Variablenwerte

### 14-03 · Black-Box- und White-Box-Test
**Themenpunkt:** 14.3 Kenntnisse über Black-Box-Test/White-Box-Test, wesentliche Unterschiede
**Frage:** Was ist der Unterschied zwischen Black-Box- und White-Box-Test?
**Muss:** Black-Box: ohne Kenntnis des Quellcodes, getestet wird nur das Verhalten nach außen · White-Box: mit Kenntnis des Codes, getestet wird die interne Logik
**Sicher:** Black-Box wird typischerweise vom Tester oder Anwender durchgeführt: Funktionstest, Abnahmetest · White-Box vom Entwickler: Unit-Tests, Pfad- und Zweigüberdeckung · Black-Box findet fehlende Funktionen, White-Box findet nicht durchlaufene Codepfade — sie ergänzen einander · Grey-Box als Mischform mit teilweiser Kenntnis der Struktur
**Nachhaken bei:** Unterschied genannt, aber ohne je ein Beispiel für die Testart

### 14-04 · Qualitätsmerkmale von Software
**Themenpunkt:** 14.4 Kenntnisse über wichtige Qualitätsmerkmale der Softwarefunktionalität
**Frage:** Woran messen Sie die Qualität einer Software?
**Muss:** Mindestens vier Merkmale: Funktionalität, Zuverlässigkeit, Benutzbarkeit, Effizienz, Wartbarkeit, Portierbarkeit, Sicherheit
**Sicher:** Funktionalität: erfüllt sie die Anforderungen · Zuverlässigkeit: Fehlertoleranz und Wiederherstellbarkeit · Benutzbarkeit: erlernbar, verständlich, bedienbar · Effizienz: Antwortzeit und Ressourcenverbrauch · Wartbarkeit: analysierbar, änderbar, testbar · Portierbarkeit: auf andere Umgebungen übertragbar · Sicherheit: Vertraulichkeit, Integrität, Authentizität · Grundlage ist die Norm ISO 25010 (früher 9126) · nicht funktionale Anforderungen müssen messbar formuliert sein, sonst sind sie nicht prüfbar
**Nachhaken bei:** nur „läuft fehlerfrei" — das ist ein einziges Merkmal von sieben

### 14-05 · Changemanagement
**Themenpunkt:** 14.5 Kenntnisse über Changemanagement
**Frage:** Was ist Changemanagement in der IT?
**Muss:** Ein geregelter Prozess für Änderungen an IT-Systemen: Änderungsantrag → Bewertung → Genehmigung → Umsetzung → Nachkontrolle
**Sicher:** Ziel: Risiken beherrschen und die Stabilität des Betriebs sichern — die meisten Störungen entstehen durch Änderungen · bewertet werden Auswirkung, Aufwand, Risiko und der Rückfallplan · dazu gehören ein definiertes Zeitfenster und die Information der Betroffenen · Standardänderungen mit geringem Risiko werden vorab freigegeben, um den Prozess nicht zu ersticken · alles wird dokumentiert, damit im Störungsfall nachvollziehbar ist, was sich geändert hat
**Nachhaken bei:** Prozess aufgezählt ohne Rückfallplan oder Begründung

### 14-06 · Versionierung
**Themenpunkt:** 14.6 Fachbegriff Versionierung und deren Nutzen
**Frage:** Was bedeutet Versionierung und was sagt eine Versionsnummer wie 2.4.1 aus?
**Muss:** Systematische Nummerierung von Releases · nach Semantic Versioning MAJOR.MINOR.PATCH: Major bei inkompatiblen Änderungen, Minor bei neuen, verträglichen Funktionen, Patch bei Fehlerkorrekturen
**Sicher:** Nutzen: man erkennt an der Nummer, ob ein Update gefahrlos einspielbar ist · Nachvollziehbarkeit, welcher Stand wo läuft · gezieltes Zurückrollen auf eine frühere Version · klare Kommunikation gegenüber Kunden und in Abhängigkeiten anderer Software · nicht zu verwechseln mit Versionsverwaltung (Git) — das ist die Historie des Quellcodes, das hier die Nummerierung der Auslieferung
**Nachhaken bei:** Versionierung mit Git gleichgesetzt

### 14-07 · Problemmanagement
**Themenpunkt:** 14.7 Kenntnisse über Problemmanagement
**Frage:** Was ist Problemmanagement und wie unterscheidet es sich vom Incident Management?
**Muss:** Problemmanagement sucht und beseitigt die Ursache wiederkehrender Störungen · Incident Management stellt den Betrieb schnellstmöglich wieder her, egal wie
**Sicher:** Incident = Symptom sofort beheben, notfalls mit Workaround; Problem = Ursache dauerhaft beseitigen (Root Cause Analysis) · bekannte Fehler werden als Known Errors mitsamt Workaround dokumentiert, damit der nächste Vorfall schneller gelöst ist · proaktives Problemmanagement wertet Häufungen aus, bevor der große Ausfall kommt · beides stammt aus ITIL
**Nachhaken bei:** Problem und Incident gleichgesetzt — die Trennung ist die ganze Frage
