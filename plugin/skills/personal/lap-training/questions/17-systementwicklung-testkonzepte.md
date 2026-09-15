# 17) Systementwicklung/Testkonzepte

### 17-01 · Programmspezifikation
**Themenpunkt:** 17.1 Fachbegriff Programmspezifikation
**Frage:** Was ist eine Programmspezifikation?
**Muss:** Die formale Beschreibung, was ein Programm oder eine Funktion leisten soll — Eingaben, Ausgaben und das erwartete Verhalten
**Sicher:** enthält Vorbedingungen (was muss beim Aufruf gelten), Nachbedingungen (was gilt danach) und das Verhalten im Fehlerfall · beschreibt das Was, nicht das Wie — die Umsetzung bleibt offen · sie ist die Grundlage, gegen die getestet wird: ohne Spezifikation gibt es kein „erwartetes Ergebnis" und damit keinen sinnvollen Test
**Nachhaken bei:** Spezifikation mit dem Entwurf oder der Implementierung vermischt

### 17-02 · Datenmodell
**Themenpunkt:** 17.2 Fachbegriff Datenmodell
**Frage:** Was ist ein Datenmodell und welche Ebenen unterscheidet man?
**Muss:** Abstrakte Darstellung der zu speichernden Daten und ihrer Beziehungen · drei Ebenen: konzeptuell, logisch, physisch
**Sicher:** konzeptuell: ER-Diagramm mit Entitäten, Attributen und Beziehungen — unabhängig von jedem Datenbanksystem · logisch: Überführung in Tabellen mit Primär- und Fremdschlüsseln, Normalisierung · physisch: konkrete Umsetzung im DBMS mit Datentypen, Indizes und Speicherparametern · die Trennung erlaubt, das fachliche Modell zu diskutieren, bevor Technik ins Spiel kommt
**Nachhaken bei:** nur das ER-Diagramm genannt, die drei Ebenen fehlen

### 17-03 · Datentypen und Datenstrukturen
**Themenpunkt:** 17.3 Kenntnisse über wichtige Datentypen und Datenstrukturen
**Frage:** Welche Datenstrukturen kennen Sie und wofür setzt man sie ein?
**Muss:** Primitive Typen (int, float, boolean, char) · zusammengesetzt: Array, String, Struct · abstrakte Strukturen: Stack, Queue, Liste, Baum, Hash-Map
**Sicher:** Array: feste Größe, Zugriff über Index in konstanter Zeit · Liste: dynamisch wachsend, Einfügen günstig, Zugriff über Position teurer · Stack (LIFO) und Queue (FIFO) für geordnete Verarbeitung · Hash-Map: Zugriff über einen Schlüssel, im Mittel konstant schnell — das Mittel der Wahl beim Nachschlagen · Baum für hierarchische Daten und schnelle Suche, Graph für Netze wie Routen oder Beziehungen · die Auswahl richtet sich danach, welche Operation häufig ist: suchen, einfügen oder durchlaufen
**Nachhaken bei:** Strukturen aufgezählt ohne Einsatzkriterium

### 17-04 · Funktionen
**Themenpunkt:** 17.4 Kenntnisse über Funktionen (Definition, Schnittstelle, Parameter, Rückgabewert, Aufruf)
**Frage:** Wie ist eine Funktion aufgebaut?
**Muss:** Benannter, wiederverwendbarer Codeblock mit einer definierten Aufgabe · Schnittstelle aus Name, Parametern und Rückgabetyp · Parameter sind die Eingaben beim Aufruf, der Rückgabewert das Ergebnis
**Sicher:** `void`, wenn nichts zurückgegeben wird · Aufruf: `ergebnis = funktionsname(wert1, wert2)` · Unterscheidung formale Parameter in der Definition und tatsächliche Argumente beim Aufruf · Überladung: gleicher Name, unterschiedliche Parameterliste · Nutzen: Wiederverwendung, Struktur, Testbarkeit — eine Funktion sollte genau eine Aufgabe haben · Methoden sind Funktionen innerhalb einer Klasse
**Nachhaken bei:** Aufbau beschrieben, aber Parameter und Rückgabewert nicht sauber getrennt

### 17-05 · Call by Value und Call by Reference
**Themenpunkt:** 17.5 Unterschiede zwischen Call-By-Value und Call-By-Reference
**Frage:** Was ist der Unterschied zwischen Call by Value und Call by Reference?
**Muss:** Call by Value: eine Kopie des Wertes wird übergeben, Änderungen in der Funktion wirken sich nicht auf das Original aus · Call by Reference: es wird ein Verweis auf das Original übergeben, Änderungen wirken sich dort aus
**Sicher:** Call by Value ist sicherer, weil das Original geschützt bleibt; Call by Reference spart das Kopieren großer Strukturen und erlaubt mehrere Rückgaben · typisch: primitive Datentypen by Value, Objekte und Arrays by Reference · in Java und C# wird formal immer der Wert übergeben — bei Objekten aber der Wert der Referenz, weshalb Änderungen am Objekt trotzdem außen sichtbar sind · genau daraus entstehen die typischen Überraschungen
**Nachhaken bei:** Definitionen richtig, aber ohne Beispiel, welche Typen wie übergeben werden

### 17-06 · Aufbau einer Klasse
**Themenpunkt:** 17.6 Kenntnisse über Klassen (Datenelemente, Konstruktor, Destruktor, Methoden, Zugriffsmodifikatoren)
**Frage:** Aus welchen Bestandteilen besteht eine Klasse?
**Muss:** Attribute (Datenelemente) für den Zustand · Methoden für das Verhalten · Konstruktor zur Initialisierung beim Erzeugen eines Objekts · Zugriffsmodifikatoren
**Sicher:** `public` überall zugreifbar, `private` nur innerhalb der Klasse, `protected` zusätzlich in Unterklassen · der Konstruktor trägt den Klassennamen und kann überladen werden · Destruktor räumt Ressourcen auf, in C++ ausdrücklich; in Java und C# übernimmt das der Garbage Collector, weshalb es dort eher `Dispose` bzw. Finalizer heißt · Attribute grundsätzlich `private` und über Getter und Setter zugänglich — das ist gelebte Kapselung · `static` gehört zur Klasse statt zum Objekt
**Nachhaken bei:** Bestandteile genannt, aber Konstruktor oder Zugriffsmodifikatoren fehlen

### 17-07 · Vererbung
**Themenpunkt:** 17.7 Kenntnisse über das Prinzip der Vererbung
**Frage:** Erklären Sie das Prinzip der Vererbung.
**Muss:** Eine Unterklasse übernimmt Attribute und Methoden der Oberklasse und kann eigene ergänzen · sie kann geerbte Methoden überschreiben
**Sicher:** Zweck: Gemeinsames einmal an einer Stelle definieren statt in jeder Klasse zu wiederholen · Überschreiben (Override) ist die Grundlage der Polymorphie: der Aufruf richtet sich nach der tatsächlichen Klasse des Objekts · Beziehung ist ein „ist ein": ein PKW **ist ein** Fahrzeug — wo das nicht stimmt, gehört Komposition statt Vererbung · Mehrfachvererbung: in C++ möglich, in Java und C# nicht, dort über Interfaces gelöst · `protected` macht Mitglieder für Unterklassen zugänglich · zu tiefe Vererbungshierarchien werden unübersichtlich
**Nachhaken bei:** „erbt Eigenschaften" ohne Überschreiben oder ohne den Nutzen

### 17-08 · Standardbibliothek
**Themenpunkt:** 17.8 Fachbegriff Standardbibliothek
**Frage:** Was ist eine Standardbibliothek?
**Muss:** Die Sammlung vorgefertigter Klassen und Funktionen, die mit der Programmiersprache mitgeliefert wird
**Sicher:** Inhalte: Datenstrukturen und Sammlungen, Ein- und Ausgabe, String-Verarbeitung, Mathematik, Datum und Zeit, Netzwerk, Dateizugriff · Beispiele: Java Standard Library, .NET Base Class Library, Python Standard Library, C++ STL · Vorteil: erprobt, getestet, überall verfügbar — kein Grund, Sortierung oder Datumsrechnung selbst zu schreiben · Abgrenzung zu Fremdbibliotheken, die man über einen Paketmanager (NuGet, npm, pip) nachinstalliert und deren Lizenz und Pflege man prüfen muss
**Nachhaken bei:** Standardbibliothek und externe Bibliothek nicht unterschieden

### 17-09 · Testkonzepte
**Themenpunkt:** 17.9 Kenntnisse über Testkonzepte
**Frage:** Was gehört zu einem Testkonzept?
**Muss:** Testplan mit Umfang, Vorgehen, Ressourcen und Zeitplan · Testfälle mit Eingabe, erwartetem Ergebnis und Akzeptanzkriterium · geeignete Testdaten
**Sicher:** Testdaten müssen Grenzwerte, Sonderfälle und Negativtests abdecken — der gültige Normalfall allein findet nichts · Teststufen: Modul-, Integrations-, System- und Abnahmetest · Regressionstests, damit Änderungen nichts Bestehendes zerstören · Abbruch- und Abnahmekriterien vorher festlegen · vollständiges Testen ist unmöglich, deshalb wird nach Risiko priorisiert
**Nachhaken bei:** Testfälle genannt, Testdaten und Regressionstests fehlen

### 17-10 · Auswertung eines Softwaretests
**Themenpunkt:** 17.10 Auswertung eines Softwaretests
**Frage:** Wie werten Sie einen Softwaretest aus?
**Muss:** Tatsächliches gegen erwartetes Ergebnis stellen · Status je Testfall vergeben: bestanden, fehlgeschlagen, blockiert · Fehler dokumentieren
**Sicher:** ein Fehlerprotokoll enthält Beschreibung, **Schritte zur Reproduktion**, erwartetes und tatsächliches Verhalten, Umgebung, Screenshot oder Log · der Fehlerbericht geht in einen Issue-Tracker (Jira, GitHub Issues) und wird nach Schwere und Priorität eingeordnet · Kennzahlen: Anzahl gefundener Fehler, Testabdeckung, Durchlaufquote · nach der Korrektur Nachtest und Regressionstest · „blockiert" heißt: der Testfall war nicht durchführbar — das ist kein Bestanden
**Nachhaken bei:** Status vergeben, aber die Reproduktionsschritte im Fehlerbericht vergessen

### 17-11 · Test von Datenbankfeldern
**Themenpunkt:** 17.11 Kriterien für den Test von Datenbankfeldern unterschiedlicher Typen (Mail, Datum, ...)
**Frage:** Wie testen Sie ein Eingabeformular mit E-Mail-, Datums- und Zahlenfeldern?
**Muss:** Je Feldtyp gültige und ungültige Werte prüfen · E-Mail auf Format, Datum auf Gültigkeit, Zahlen auf Wertebereich · Pflichtfelder mit leerer Eingabe testen
**Sicher:** E-Mail: fehlendes @, fehlende TLD, Leerzeichen, maximale Länge · Datum: 29.02. in einem Nicht-Schaltjahr, 31.04., Format, Datum in der Zukunft oder Vergangenheit je nach Fachlichkeit · Zahlen: Minimum und Maximum, Grenzwerte knapp darunter und darüber, negative Werte, Dezimaltrennzeichen · Text: Überlänge gegen die Feldgröße, Sonderzeichen und Umlaute, SQL-Injection- und Script-Eingaben · immer Grenzwerte und Äquivalenzklassen statt wahlloser Werte · Prüfung serverseitig wiederholen, clientseitig ist umgehbar
**Nachhaken bei:** nur gültige Eingaben getestet — der Wert liegt in den ungültigen und den Grenzwerten

### 17-12 · Reproduzierbare und nicht reproduzierbare Fehler
**Themenpunkt:** 17.12 Unterschiede zwischen einem reproduzierbaren/nicht-reproduzierbaren Fehler
**Frage:** Was ist der Unterschied zwischen einem reproduzierbaren und einem nicht reproduzierbaren Fehler?
**Muss:** Reproduzierbar: tritt bei denselben Schritten immer wieder auf, daher analysierbar und behebbar · nicht reproduzierbar: tritt nur sporadisch auf und lässt sich nicht gezielt auslösen
**Sicher:** typische Ursachen für sporadische Fehler: Race Conditions und Timing, nicht initialisierte Werte, Speicherprobleme, äußere Abhängigkeiten wie Netz oder Fremdsysteme, Zeitzonen und Umstellungstermine · Vorgehen: umfangreich protokollieren, Umgebung und Zeitpunkt erfassen, Häufungen auswerten, bis ein Muster sichtbar wird · gefährlicher als reproduzierbare Fehler, weil sie gern erst in Produktion und unter Last auftreten · ein Fehler, der nicht reproduzierbar ist, gilt nie als behoben, nur weil er gerade nicht auftritt
**Nachhaken bei:** Unterschied genannt, aber keine Ursache und kein Vorgehen

### 17-13 · Testautomatisierung
**Themenpunkt:** 17.13 Kenntnisse über Möglichkeiten zur Automatisierung von Tests
**Frage:** Wie automatisiert man Tests und was bringt das?
**Muss:** Unit-Tests für einzelne Funktionen (JUnit, NUnit, pytest) · Integrationstests für das Zusammenspiel · End-to-End-Tests, die den Benutzer nachbilden (Selenium, Playwright, Cypress) · Ausführung automatisch in der CI/CD-Pipeline
**Sicher:** Testpyramide: viele schnelle Unit-Tests unten, wenige langsame E2E-Tests oben · Nutzen: Fehler fallen sofort auf, Regressionstests kosten nichts, man kann gefahrlos umbauen · Testabdeckung (Code Coverage) als Kennzahl — aber hohe Abdeckung heißt nicht automatisch gute Tests · Aufwand: automatisierte Tests müssen gepflegt werden, sonst werden sie abgeschaltet · nicht alles lohnt sich zu automatisieren, einmalige oder explorative Tests bleiben manuell
**Nachhaken bei:** Werkzeuge genannt, aber ohne die Einordnung in Teststufen oder ohne den Nutzen
