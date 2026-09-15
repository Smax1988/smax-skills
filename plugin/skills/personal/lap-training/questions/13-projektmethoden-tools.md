# 13) Projektmethoden, Tools

### 13-01 · Softwareprozessmodelle
**Themenpunkt:** 13.1 Kenntnisse über Softwareprozessmodelle
**Frage:** Was ist ein Softwareprozessmodell und welche kennen Sie?
**Muss:** Ein Modell beschreibt, wie die Softwareentwicklung organisiert und in Phasen strukturiert wird · klassische Modelle: Wasserfall, V-Modell · agile: Scrum, Kanban, XP
**Sicher:** dazwischen liegen iterative und inkrementelle Modelle wie das Spiralmodell · die Auswahl hängt davon ab, wie stabil die Anforderungen sind, wie groß das Team ist, wie kritisch das System ist und wie eng der Kunde eingebunden werden kann · stabile Anforderungen und Nachweispflichten sprechen für klassisch, unklare oder wechselnde Anforderungen für agil
**Nachhaken bei:** Modelle aufgezählt ohne Auswahlkriterium

### 13-02 · Aufbau des Wasserfallmodells
**Themenpunkt:** 13.2 Kenntnisse über den Aufbau des Wasserfallmodells
**Frage:** Wie ist das Wasserfallmodell aufgebaut?
**Muss:** Lineares Phasenmodell: Anforderungen → Analyse → Entwurf → Implementierung → Test → Wartung · jede Phase wird abgeschlossen, bevor die nächste beginnt
**Sicher:** jede Phase liefert ein definiertes Dokument als Ergebnis, das die nächste Phase als Eingang nutzt · Vorteile: klare Struktur, gute Planbarkeit von Aufwand und Terminen, saubere Dokumentation, einfache Fortschrittsmessung · dadurch geeignet für stabile Anforderungen und Projekte mit Nachweispflicht · das Bild vom Wasserfall: es fließt nur nach unten, zurück geht es nicht
**Nachhaken bei:** Phasen genannt, aber die strikte Abfolge nicht betont

### 13-03 · Agiles Projektmanagement
**Themenpunkt:** 13.3 Kenntnisse über Agiles Projektmanagement/Methoden
**Frage:** Wie arbeitet man agil und welche Methoden gibt es?
**Muss:** Iterativ und inkrementell in kurzen Zyklen · enger Kundenkontakt, Anforderungen dürfen sich ändern · Methoden: Scrum, Kanban, Extreme Programming
**Sicher:** Grundlage ist das Agile Manifest von 2001 mit vier Werten und zwölf Prinzipien · nach jedem Zyklus steht etwas Lauffähiges, das der Kunde beurteilen kann — dadurch wird früh korrigiert statt spät · Scrum arbeitet in festen Sprints mit definierten Rollen, Kanban ohne Iterationen über begrenzte parallele Arbeit · Voraussetzung: verfügbarer Kunde und ein Team, das selbst entscheiden darf
**Nachhaken bei:** „flexibel arbeiten" ohne Iterationen oder lieferbares Zwischenergebnis

### 13-04 · DevOps
**Themenpunkt:** 13.4 Fachbegriff DevOps
**Frage:** Was ist DevOps?
**Muss:** Zusammenführung von Entwicklung (Development) und Betrieb (Operations) — beide arbeiten zusammen statt gegeneinander
**Sicher:** Problem davor: Entwicklung will schnell ändern, Betrieb will Stabilität — das Ergebnis war die Übergabe über die Mauer und gegenseitige Schuldzuweisung · Ziel: schnellere und zuverlässigere Auslieferung durch gemeinsame Verantwortung bis in den Betrieb · Werkzeuge: CI/CD-Pipelines, Automatisierung, Container (Docker), Infrastructure as Code, Monitoring · DevOps ist zuerst eine Kultur- und Organisationsfrage, dann eine Werkzeugfrage
**Nachhaken bei:** DevOps als reines Toolset beschrieben

### 13-05 · Scrum Master
**Themenpunkt:** 13.5 Fachbegriff Scrummaster
**Frage:** Welche Rolle hat der Scrum Master?
**Muss:** Sorgt dafür, dass der Scrum-Prozess eingehalten wird, und räumt dem Team Hindernisse aus dem Weg · ist kein Vorgesetzter
**Sicher:** schützt das Team vor Störungen von außen und vor Änderungen mitten im Sprint · moderiert die Scrum-Ereignisse · versteht sich als dienende Führung: er weist keine Aufgaben zu, das Team organisiert sich selbst · Abgrenzung: der Product Owner verantwortet das Was, das Team das Wie, der Scrum Master den Prozess
**Nachhaken bei:** Scrum Master als Projektleiter beschrieben

### 13-06 · Product Owner
**Themenpunkt:** 13.6 Fachbegriff Productowner
**Frage:** Wofür ist der Product Owner zuständig?
**Muss:** Verantwortet das Product Backlog, priorisiert die Anforderungen und vertritt die Kunden- bzw. Fachsicht
**Sicher:** entscheidet, **was** entwickelt wird und in welcher Reihenfolge — nicht wie · nimmt die Ergebnisse am Sprintende ab · ist eine einzelne Person, kein Gremium, sonst gibt es keine klare Priorisierung · das dritte Element ist das Entwicklungsteam: selbstorganisiert, interdisziplinär, üblicherweise drei bis neun Personen
**Nachhaken bei:** Rolle mit dem Scrum Master vermischt

### 13-07 · Backlog
**Themenpunkt:** 13.7 Fachbegriff Backlog
**Frage:** Was ist ein Backlog?
**Muss:** Eine nach Priorität geordnete Liste aller Anforderungen an das Produkt (Product Backlog) · das Sprint Backlog ist die Auswahl daraus für den aktuellen Sprint
**Sicher:** das Product Backlog ist nie fertig, es wird laufend gepflegt und neu priorisiert (Backlog Refinement) · verantwortlich dafür ist der Product Owner · oben stehen die Einträge, die als nächstes umgesetzt werden — die sind fein beschrieben und geschätzt, weiter unten bleibt es grob · das Sprint Backlog gehört dagegen dem Team und wird während des Sprints nicht von außen verändert
**Nachhaken bei:** „Liste offener Aufgaben" ohne Priorisierung oder ohne die Unterscheidung der beiden Backlogs

### 13-08 · Sprint
**Themenpunkt:** 13.8 Fachbegriff Sprint
**Frage:** Was ist ein Sprint?
**Muss:** Ein zeitlich fest begrenzter Entwicklungszyklus, üblicherweise ein bis vier Wochen, meist zwei · Ergebnis ist ein potenziell auslieferbares Produktinkrement
**Sicher:** die Länge bleibt gleich, damit sich eine Planungsrhythmik einspielt · das Sprintziel steht am Anfang fest und wird während des Sprints nicht geändert · dazu gehören Sprint Planning am Anfang, Daily Scrum täglich, Review und Retrospektive am Ende · „potenziell auslieferbar" heißt fertig im Sinn der Definition of Done, nicht halbfertig
**Nachhaken bei:** Sprint als bloßer Zeitabschnitt ohne lieferbares Ergebnis

### 13-09 · Stakeholder
**Themenpunkt:** 13.9 Fachbegriff Stakeholder
**Frage:** Wer sind die Stakeholder eines Projekts?
**Muss:** Alle Personen und Gruppen, die ein Interesse am Projekt haben oder von ihm betroffen sind
**Sicher:** intern: Projektteam, Auftraggeber, Management, betroffene Fachabteilungen, Betriebsrat · extern: Kunden, Endanwender, Lieferanten, Behörden · Stakeholder-Analyse: erfassen, nach Einfluss und Betroffenheit bewerten und die Kommunikation danach ausrichten · übersehene Stakeholder sind ein klassischer Projektkiller — wer spät eingebunden wird, blockiert spät
**Nachhaken bei:** nur der Auftraggeber genannt, betroffene Anwender fehlen

### 13-10 · Daily Scrum
**Themenpunkt:** 13.10 Fachbegriff Daily Scrum/Daily Standup
**Frage:** Was passiert im Daily Scrum?
**Muss:** Tägliches, auf 15 Minuten begrenztes Treffen des Entwicklungsteams · klassisch drei Fragen: was habe ich gestern gemacht, was mache ich heute, wo hakt es
**Sicher:** Zweck ist die Abstimmung im Team und das Sichtbarmachen von Hindernissen, **kein** Statusbericht an den Chef · im Stehen, damit es kurz bleibt · Probleme werden benannt, aber nicht dort gelöst — das passiert danach im kleineren Kreis · Hindernisse nimmt der Scrum Master mit
**Nachhaken bei:** als Berichtstermin an die Führung beschrieben

### 13-11 · User Story und Story Board
**Themenpunkt:** 13.11 Fachbegriff User Story/Story Board
**Frage:** Wie ist eine User Story aufgebaut und was ist ein Story Board?
**Muss:** Schema: „Als [Rolle] möchte ich [Funktion], damit [Nutzen]" · Story Board bzw. Scrum Board visualisiert den Arbeitsfortschritt in Spalten wie To Do, In Arbeit, Erledigt
**Sicher:** die User Story beschreibt die Anforderung aus Nutzersicht und nennt den Nutzen — dadurch bleibt verhandelbar, wie sie umgesetzt wird · dazu gehören Akzeptanzkriterien, an denen geprüft wird, ob sie erfüllt ist · eine Story soll klein genug sein, um in einem Sprint fertig zu werden · das Board macht Engpässe sichtbar: staut sich eine Spalte, weiß man wo
**Nachhaken bei:** Schema aufgesagt, Akzeptanzkriterien fehlen

### 13-12 · Probleme des Wasserfallmodells
**Themenpunkt:** 13.12 Probleme, die beim Wasserfallmodell auftreten können
**Frage:** Welche Probleme bringt das Wasserfallmodell mit sich?
**Muss:** Keine Flexibilität, wenn sich Anforderungen ändern · Fehler und Missverständnisse fallen erst spät auf · der Kunde sieht das Produkt erst am Ende
**Sicher:** ein Fehler in der Anforderungsphase pflanzt sich durch alle Folgephasen fort und wird umso teurer, je später er auffällt · lange Zeit ohne lauffähiges Ergebnis, dadurch kein echter Fortschrittsnachweis · die Testphase am Ende wird bei Terminverzug als erstes gekürzt · Annahme, alle Anforderungen ließen sich zu Beginn vollständig erfassen, hält in der Praxis selten
**Nachhaken bei:** „unflexibel" ohne den Kostenanstieg spät entdeckter Fehler

### 13-13 · Aufbau des V-Modells
**Themenpunkt:** 13.13 Kenntnisse über den Aufbau des V-Modells
**Frage:** Wie ist das V-Modell aufgebaut?
**Muss:** Erweiterung des Wasserfallmodells um eine Testseite · linker Ast: Anforderungen, Grobentwurf, Feinentwurf, Implementierung · rechter Ast: die zugehörigen Teststufen, von unten nach oben Modultest, Integrationstest, Systemtest, Abnahmetest
**Sicher:** jede Entwicklungsstufe hat auf gleicher Höhe ihre Teststufe: die Anforderungen werden im Abnahmetest geprüft, der Feinentwurf im Modultest · die Testfälle entstehen bereits beim Erstellen der jeweiligen Entwicklungsstufe, nicht erst am Ende · unten in der Spitze steht die Implementierung
**Nachhaken bei:** Ast-Zuordnung genannt, aber ohne die waagrechte Entsprechung zwischen Entwurfs- und Teststufe

### 13-14 · Vor- und Nachteile des V-Modells
**Themenpunkt:** 13.14 Kenntnisse über Vor- und Nachteile des V-Modells
**Frage:** Welche Vor- und Nachteile hat das V-Modell?
**Muss:** Vorteil: Testplanung von Anfang an, klare Zuordnung von Test zu Entwicklungsphase · Nachteil: unflexibel bei Änderungen, hoher Dokumentationsaufwand
**Sicher:** weitere Vorteile: hohe Nachvollziehbarkeit und Qualitätssicherung, deshalb im Behörden-, Medizin- und Sicherheitsumfeld gefordert · weitere Nachteile: schwerfällig, teuer, ungeeignet bei unklaren Anforderungen, lauffähige Software erst spät · erbt die grundsätzlichen Schwächen des Wasserfalls, kompensiert aber dessen späte Qualitätssicherung
**Nachhaken bei:** nur Vorteile genannt, oder Nachteile ohne den Bezug zum Wasserfallmodell

### 13-15 · Softwareentwurf
**Themenpunkt:** 13.15 Fachbegriff Softwareentwurf
**Frage:** Was passiert in der Phase Softwareentwurf?
**Muss:** Aus den Anforderungen wird die technische Lösung geplant: Architektur, Datenmodell, Klassenstruktur, Schnittstellen · Ergebnis ist ein technisches Konzept als Grundlage für die Implementierung
**Sicher:** Unterscheidung Grobentwurf (Architektur, Komponenten und ihr Zusammenspiel) und Feinentwurf (innerer Aufbau der einzelnen Komponenten) · Hilfsmittel: UML-Diagramme, ER-Modell, Struktogramm, Schnittstellenbeschreibungen · hier fallen die Entscheidungen, die später am teuersten zu ändern sind · liegt zwischen Analyse (was) und Implementierung (Umsetzung)
**Nachhaken bei:** mit der Anforderungsanalyse vermischt

### 13-16 · Prototyp
**Themenpunkt:** 13.16 Fachbegriff Prototyp
**Frage:** Was ist ein Prototyp und wozu baut man einen?
**Muss:** Eine frühe, vereinfachte Version, um Konzepte, Anforderungen oder Machbarkeit zu prüfen, bevor richtig entwickelt wird
**Sicher:** Wegwerfprototyp: dient nur der Klärung und wird danach verworfen · evolutionärer Prototyp: wird zum Produkt weiterentwickelt · Ausprägungen vom Klickdummy der Oberfläche bis zum technischen Machbarkeitsnachweis · Nutzen: der Kunde sieht etwas Greifbares und äußert Anforderungen, die er abstrakt nie genannt hätte · Risiko: der Wegwerfprototyp geht doch in Produktion und schleppt seine Provisorien mit
**Nachhaken bei:** Prototyp genannt, aber die zwei Arten nicht unterschieden

### 13-17 · Soll-Ist-Analyse
**Themenpunkt:** 13.17 Fachbegriff Soll-Ist-Analyse
**Frage:** Was ist eine Soll-Ist-Analyse?
**Muss:** Vergleich zwischen dem geplanten Zustand (Soll) und dem tatsächlichen (Ist) · daraus ergibt sich die Abweichung und der Handlungsbedarf
**Sicher:** im Projekt angewandt auf Termine, Kosten und Umfang · Voraussetzung ist ein messbar formuliertes Soll — ohne das gibt es nichts zu vergleichen · dient nicht der Schuldfrage, sondern der Korrekturmaßnahme · wird auch bei der Prozessanalyse eingesetzt: Ist-Prozess aufnehmen, Soll-Prozess entwerfen, Lücke schließen
**Nachhaken bei:** Definition ohne die Folge — die Analyse ist Mittel zur Korrektur, nicht Selbstzweck

### 13-18 · Versionsverwaltung
**Themenpunkt:** 13.18 Fachbegriff Versionsverwaltung
**Frage:** Was ist Versionsverwaltung und wie arbeitet man damit?
**Muss:** System, das Änderungen am Quellcode nachvollziehbar macht — wer hat wann was geändert · Standard ist Git, Plattformen sind GitHub, GitLab, Bitbucket
**Sicher:** jeder Stand ist wiederherstellbar, Änderungen lassen sich zurücknehmen · Branches erlauben paralleles Arbeiten, der Merge führt sie wieder zusammen; bei Konflikten entscheidet der Entwickler · Git ist verteilt: jeder hat die vollständige Historie lokal · typischer Ablauf: Branch anlegen, committen, pushen, Pull Request, Review, Merge · Grundlage für Zusammenarbeit im Team und für CI/CD
**Nachhaken bei:** „speichert alte Versionen" ohne Branches oder Zusammenarbeit im Team
