# 16) Kenntnis und Verwendung von Datenbanken, Datenmodellen und Datenstrukturen

### 16-01 · Arten von Datenbanksystemen
**Themenpunkt:** 16.1 Fachbegriff Datenbanksysteme (Traditionelle Datenbanken (RDB), Objektorientierte Datenbanken, Multimedia-Datenbanken (GIS), Data-Warehouse und OLAP)
**Frage:** Welche Arten von Datenbanksystemen gibt es?
**Muss:** Relationale Datenbank als Standard — Daten in Tabellen mit Beziehungen · mindestens zwei weitere Arten mit Einsatzgebiet
**Sicher:** relational: MySQL, PostgreSQL, Oracle, SQL Server — für Geschäftsanwendungen · objektorientiert: speichert Objekte direkt, selten im Einsatz · Multimedia und GIS: Bilder, Video, Geodaten, etwa für Kartensysteme · Data Warehouse: für Analyse großer historischer Datenbestände (OLAP), bewusst nicht für den operativen Betrieb · NoSQL: dokumentbasiert (MongoDB), Key-Value (Redis), Graph (Neo4j) — für unstrukturierte Daten und hohe Skalierung
**Nachhaken bei:** nur „MySQL" genannt, ohne Systemarten zu unterscheiden

### 16-02 · SQL
**Themenpunkt:** 16.2 Fachbegriffe zu Datenbankabfragen (z.B.: SQL, SQL/XML)
**Frage:** Was ist SQL?
**Muss:** Structured Query Language, die standardisierte Abfragesprache für relationale Datenbanken
**Sicher:** Aufteilung in Sprachfamilien: DDL zum Erstellen von Strukturen (CREATE, ALTER, DROP), DML zum Arbeiten mit Daten (SELECT, INSERT, UPDATE, DELETE), DCL für Rechte (GRANT, REVOKE), TCL für Transaktionen (COMMIT, ROLLBACK) · deklarativ: man beschreibt das gewünschte Ergebnis, nicht den Weg dorthin · SQL/XML als Erweiterung zur Verarbeitung von XML-Daten · trotz Standard gibt es Herstellerdialekte
**Nachhaken bei:** „Sprache zum Abfragen" ohne DDL/DML oder ohne den deklarativen Charakter

### 16-03 · Datenbankmanagementsystem
**Themenpunkt:** 16.3 Fachbegriff Datenbankmanagementsystem (DBMS)
**Frage:** Was ist ein DBMS und was unterscheidet es von der Datenbank?
**Muss:** Die Software, die die Datenbank verwaltet · die Datenbank ist der Datenbestand, das DBMS das Programm darüber
**Sicher:** Aufgaben: Speicherung, Abfrageverarbeitung, Zugriffskontrolle und Benutzerverwaltung, Transaktionsverwaltung, Mehrbenutzerbetrieb, Sicherung und Wiederherstellung, Sicherstellung der Integrität · Beispiele: MySQL, MariaDB, PostgreSQL, Microsoft SQL Server, Oracle, SQLite · Datenbank plus DBMS ergeben zusammen das Datenbanksystem
**Nachhaken bei:** DBMS und Datenbank synonym verwendet

### 16-04 · CMS und Datenbank
**Themenpunkt:** 16.4 Fachbegriff Content Management System (CMS) (ergänzt)
**Frage:** Was ist ein CMS und welche Rolle spielt die Datenbank darin?
**Muss:** System zur Verwaltung von Inhalten ohne Programmierkenntnisse · die Inhalte liegen nicht in Dateien, sondern in einer Datenbank und werden beim Aufruf in die Seitenvorlage eingesetzt
**Sicher:** Voraussetzungen: Webserver, Skriptsprache (meist PHP), Datenbank (meist MySQL/MariaDB) · in der Datenbank stehen Beiträge, Seiten, Benutzer, Kategorien und Konfiguration; Bilder und Dateien liegen daneben im Dateisystem · Trennung von Inhalt, Struktur und Darstellung · Systeme: WordPress, TYPO3, Drupal, Shopware · Folge für den Betrieb: eine Sicherung muss Datenbank **und** Dateien umfassen, eines allein nützt nichts
**Nachhaken bei:** CMS erklärt (siehe 11-11), aber ohne Bezug zur Datenhaltung — darum geht es in diesem Kapitel

### 16-05 · Integrität
**Themenpunkt:** 16.5 Fachbegriff Integrität im Zusammenhang mit Datenbanken
**Frage:** Was bedeutet Integrität bei Datenbanken?
**Muss:** Die Daten sind korrekt und in sich widerspruchsfrei · mindestens zwei Integritätsarten mit Erklärung
**Sicher:** Entitätsintegrität: jede Zeile ist über den Primärschlüssel eindeutig identifizierbar, der Schlüssel darf nicht NULL sein · referentielle Integrität: ein Fremdschlüsselwert muss in der referenzierten Tabelle tatsächlich existieren — keine Bestellung ohne Kunde · Domänenintegrität: Werte müssen zum Datentyp und Wertebereich passen · durchgesetzt über Constraints: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK · das DBMS erzwingt es, damit nicht jede Anwendung selbst aufpassen muss
**Nachhaken bei:** „Daten müssen stimmen" ohne die Integritätsarten

### 16-06 · Redundanz
**Themenpunkt:** 16.6 Fachbegriff Redundanz im Zusammenhang mit Datenbanken
**Frage:** Was ist Redundanz in einer Datenbank und warum ist sie ein Problem?
**Muss:** Dieselben Daten sind mehrfach gespeichert · Folge: Inkonsistenz, wenn nur eine Kopie geändert wird, dazu unnötiger Speicherverbrauch
**Sicher:** Beispiel: die Kundenadresse steht in jeder Bestellzeile — zieht der Kunde um, muss sie überall geändert werden, und eine wird vergessen · daraus entstehen Anomalien beim Einfügen, Ändern und Löschen · Gegenmittel ist die Normalisierung · Abgrenzung: kontrollierte Redundanz ist ein bewusster Kompromiss — bei Data Warehouses wird zugunsten der Auswertungsgeschwindigkeit denormalisiert · Redundanz im Sinn von Backups oder RAID ist etwas anderes und ausdrücklich erwünscht
**Nachhaken bei:** „doppelte Daten" ohne die Inkonsistenzgefahr

### 16-07 · Vorgehen bei der Datenmodellierung
**Themenpunkt:** 16.7 Vorgangsweise bei der Datenmodellierung (RDB) (ergänzt)
**Frage:** Sie sollen für eine Anwendung eine relationale Datenbank modellieren. Wie gehen Sie vor?
**Muss:** Anforderungen analysieren → Entitäten und ihre Attribute bestimmen → Beziehungen mit ihren Kardinalitäten festlegen → ER-Diagramm erstellen → in Tabellen überführen → normalisieren
**Sicher:** Entitäten sind die Dinge, über die Daten gespeichert werden (Kunde, Bestellung, Artikel) · Kardinalitäten 1:1, 1:n und m:n bestimmen; m:n wird über eine Zwischentabelle aufgelöst · Primär- und Fremdschlüssel festlegen, dann Datentypen und Constraints · Normalisierung bis zur dritten Normalform — in der LAP-Prüfarbeit ausdrücklich gefordert · zum Schluss gegen echte Beispieldaten prüfen: lassen sich alle geforderten Abfragen beantworten
**Nachhaken bei:** direkt bei Tabellen begonnen, ohne Entitäten und Beziehungen zu klären

### 16-08 · SQL-Grundoperationen
**Themenpunkt:** 16.8 Kenntnisse über grundlegende Datenbankoperationen (SELECT, FROM, WHERE, ...)
**Frage:** Formulieren Sie mir eine Abfrage, die alle Kunden aus Wien sortiert nach Namen ausgibt — und erklären Sie die Bestandteile.
**Muss:** `SELECT name FROM kunde WHERE ort = 'Wien' ORDER BY name` · SELECT wählt die Spalten, FROM die Tabelle, WHERE filtert die Zeilen, ORDER BY sortiert
**Sicher:** `GROUP BY` mit `HAVING` zum Gruppieren und Filtern von Gruppen — WHERE filtert vor der Gruppierung, HAVING danach · `JOIN ... ON` zum Verknüpfen zweier Tabellen über Schlüssel · schreibende Befehle: `INSERT INTO ... VALUES`, `UPDATE ... SET ... WHERE`, `DELETE FROM ... WHERE` · Aggregatfunktionen COUNT, SUM, AVG, MIN, MAX · **UPDATE und DELETE ohne WHERE treffen die ganze Tabelle** — der klassische Unfall
**Nachhaken bei:** SELECT genannt, aber WHERE oder ORDER BY nicht erklärt

### 16-09 · Normalformen
**Themenpunkt:** 16.9 Kenntnisse über die ersten drei Normalformen im Zusammenhang mit Datenbanken
**Frage:** Erklären Sie mir die ersten drei Normalformen.
**Muss:** 1NF: alle Werte sind atomar, keine Mehrfachwerte in einer Zelle · 2NF: 1NF erfüllt und jedes Nicht-Schlüsselattribut hängt vom **gesamten** Primärschlüssel ab, nicht nur von einem Teil · 3NF: 2NF erfüllt und kein Nicht-Schlüsselattribut hängt von einem anderen Nicht-Schlüsselattribut ab (keine transitiven Abhängigkeiten)
**Sicher:** 1NF-Verstoß: mehrere Telefonnummern in einer Zelle · 2NF ist nur bei zusammengesetztem Primärschlüssel überhaupt verletzbar · 3NF-Verstoß: PLZ und Ort stehen in der Kundentabelle, der Ort hängt an der PLZ, nicht am Kunden · Ziel: Redundanz und Anomalien beseitigen · Preis: mehr Tabellen und mehr Joins · in der LAP-Prüfarbeit wird die dritte Normalform verlangt · ein eigenes Beispiel griffbereit haben
**Nachhaken bei:** Definitionen auswendig, aber ohne Beispiel für einen Verstoß — genau danach wird gefragt

### 16-10 · Primärschlüssel, Fremdschlüssel, Beziehungen
**Themenpunkt:** 16.10 Fachbegriffe Primärschlüssel, Fremdschlüssel, Relationen
**Frage:** Erklären Sie Primärschlüssel, Fremdschlüssel und die Beziehungstypen.
**Muss:** Primärschlüssel: identifiziert jede Zeile eindeutig, darf nicht NULL sein · Fremdschlüssel: verweist auf den Primärschlüssel einer anderen Tabelle und stellt damit die Beziehung her · Beziehungstypen 1:1, 1:n, m:n
**Sicher:** m:n lässt sich relational nicht direkt abbilden und wird über eine Zwischentabelle mit zwei Fremdschlüsseln aufgelöst — Beispiel Schüler und Kurse · bei 1:n steht der Fremdschlüssel immer auf der n-Seite · zusammengesetzter Primärschlüssel aus mehreren Spalten möglich · künstlicher Schlüssel (fortlaufende ID) gegen natürlichen Schlüssel · in der Prüfarbeit sind ausdrücklich 1:1 und 1:n gefordert
**Nachhaken bei:** m:n genannt, aber die Zwischentabelle fehlt

### 16-11 · Index
**Themenpunkt:** 16.11 Kenntnis über Vor- und Nachteile bei Verwendung eines Indexes
**Frage:** Was bringt ein Index und was kostet er?
**Muss:** Vorteil: deutlich schnellere Lesezugriffe, besonders bei WHERE und JOIN · Nachteil: zusätzlicher Speicherplatz und langsamere Schreibvorgänge, weil der Index mitgepflegt werden muss
**Sicher:** funktioniert wie das Stichwortverzeichnis eines Buchs: statt alle Zeilen zu durchsuchen, wird gezielt nachgeschlagen — technisch meist ein B-Baum, also das Prinzip der binären Suche · sinnvoll auf Spalten, nach denen häufig gefiltert, sortiert oder verknüpft wird · nicht sinnvoll auf Spalten mit wenigen verschiedenen Werten oder auf Tabellen, in die überwiegend geschrieben wird · Primärschlüssel sind automatisch indiziert · zu viele Indizes bremsen und kosten Wartung
**Nachhaken bei:** nur „macht schneller" ohne die Kosten beim Schreiben

### 16-12 · Freeware-Datenbanken
**Themenpunkt:** 16.12 Vor- und Nachteile von Freeware Datenbanken
**Frage:** Welche Vor- und Nachteile haben kostenlose Datenbanksysteme?
**Muss:** Vorteil: keine Lizenzkosten, große Community, anpassbar · Nachteil: kein vertraglich zugesicherter Support, Eigenverantwortung für Updates und Sicherheit
**Sicher:** MySQL/MariaDB und PostgreSQL sind ausgereift und decken die allermeisten Anwendungsfälle vollständig ab · kommerzielle Systeme punkten bei sehr großen Installationen, Spezialfunktionen, Werkzeugen und garantiertem Support mit Reaktionszeiten · Support ist für Freeware zukaufbar · Gesamtkosten betrachten: gesparte Lizenz gegen eigenen Betriebsaufwand · Lizenzmodell prüfen — kostenlos heißt nicht automatisch beliebig kommerziell nutzbar
**Nachhaken bei:** nur Kosten genannt, Support und Verantwortung fehlen

### 16-13 · Sicherungsmethoden
**Themenpunkt:** 16.13 Kenntnisse über Sicherungsmethoden
**Frage:** Wie sichern Sie eine Datenbank?
**Muss:** Logisches Backup: Export als SQL-Dump · physisches Backup: Kopie der Datenbankdateien · dazu inkrementelle Sicherung nur der Änderungen
**Sicher:** logisch: portabel, auch auf eine andere Version oder ein anderes System einspielbar, dafür langsam bei großen Beständen (`mysqldump`) · physisch: schnell, aber die Datenbank muss angehalten sein oder es braucht Werkzeuge für den laufenden Betrieb · Transaktionsprotokolle erlauben die Wiederherstellung auf einen genauen Zeitpunkt · Rücksicherung regelmäßig testen · Sicherung nicht auf demselben Server ablegen
**Nachhaken bei:** „Dump machen" ohne physische Sicherung oder ohne Restore-Test

### 16-14 · Sperren
**Themenpunkt:** 16.14 Fachbegriff Sperrtabelle und Sperrverhalten
**Frage:** Was passiert, wenn zwei Benutzer gleichzeitig denselben Datensatz ändern wollen?
**Muss:** Das DBMS setzt Sperren · Lesesperre (Shared Lock): mehrere dürfen gleichzeitig lesen · Schreibsperre (Exclusive Lock): nur einer darf schreiben, die anderen warten
**Sicher:** Zweck: verhindern, dass gleichzeitige Zugriffe inkonsistente Daten erzeugen — Lost Update, Dirty Read · Deadlock: zwei Transaktionen sperren sich gegenseitig und warten endlos; das DBMS erkennt das und bricht eine Transaktion ab · Sperren können auf Zeilen-, Seiten- oder Tabellenebene liegen — je gröber, desto mehr Wartezeit · Alternative optimistisches Sperren: nicht sperren, sondern beim Speichern prüfen, ob sich der Datensatz zwischenzeitlich geändert hat
**Nachhaken bei:** Sperren genannt, Deadlock fehlt

### 16-15 · Betriebliches Informationssystem
**Themenpunkt:** 16.15 Fachbegriff BIS (Betriebliches Informationssystem)
**Frage:** Was ist ein betriebliches Informationssystem?
**Muss:** Sammelbegriff für IT-Systeme, die betriebliche Daten erfassen, verarbeiten und für Entscheidungen bereitstellen
**Sicher:** unterstützt drei Ebenen: operativ (das Tagesgeschäft abwickeln), taktisch (mittelfristig steuern), strategisch (langfristig entscheiden) · dazu zählen ERP, CRM, Warenwirtschaft, Personalsysteme und die Auswertungssysteme darüber · Ziel ist eine gemeinsame Datenbasis statt Insellösungen, die einander widersprechen
**Nachhaken bei:** „ein System im Betrieb" ohne die Entscheidungsunterstützung

### 16-16 · ERP-Systeme
**Themenpunkt:** 16.16 Kenntnisse/Fachbegriff ERP Systeme
**Frage:** Was ist ein ERP-System?
**Muss:** Enterprise Resource Planning — integrierte Software, die alle wesentlichen Geschäftsprozesse eines Unternehmens auf einer gemeinsamen Datenbasis abbildet
**Sicher:** Module: Finanzbuchhaltung, Einkauf, Lager, Produktion, Vertrieb, Personal · Vorteil: die Daten werden einmal erfasst und stehen überall zur Verfügung, keine Doppelerfassung und keine widersprüchlichen Insellösungen · Beispiele: SAP, Microsoft Dynamics, Oracle ERP, im Mittelstand BMD oder Sage · Kehrseite: teuer, lange Einführungsprojekte, das Unternehmen passt sich oft der Software an statt umgekehrt
**Nachhaken bei:** „Software für Firmen" ohne die integrierte Datenbasis

### 16-17 · BI- und BW-Systeme
**Themenpunkt:** 16.17 Kenntnisse/Fachbegriff BI/BW Systeme
**Frage:** Was ist Business Intelligence und wie hängt das mit einem Data Warehouse zusammen?
**Muss:** BI: Auswertung von Unternehmensdaten zur Entscheidungsunterstützung · das Data Warehouse ist die zentrale, historische Datenbasis, aus der ausgewertet wird
**Sicher:** die Daten werden aus den operativen Systemen extrahiert, aufbereitet und geladen (ETL) · OLAP erlaubt mehrdimensionale Auswertung entlang von Dimensionen wie Zeit, Region, Produkt — das Würfelmodell · bewusste Trennung vom operativen System: Analysen sollen den laufenden Betrieb nicht ausbremsen, und operative Daten werden überschrieben, historische nicht · Werkzeuge: SAP BW, Power BI, Tableau
**Nachhaken bei:** BI erklärt, aber die Trennung vom operativen System nicht begründet

### 16-18 · Datenmodell in eine Datenbank umsetzen
**Themenpunkt:** 16.18 Kenntnisse der Abläufe und Prozessschritte (Auswählen DBMS, Erstellen des physischen Modells, Performance- und Stresstests, Datensicherheit, Datenschutz, Datenverschlüsselung – Kryptografie, Datenmigration) zum Umsetzen von Datenmodellen in eine Datenbank
**Frage:** Ihr Datenmodell steht. Welche Schritte gehen Sie, bis die Datenbank produktiv läuft?
**Muss:** DBMS auswählen → physisches Modell anlegen (Tabellen, Datentypen, Constraints, Indizes) → Performance- und Lasttests → Datensicherheit und Datenschutz einrichten → Altdaten migrieren
**Sicher:** DBMS-Auswahl nach Anforderungen: Datenmenge, Skalierbarkeit, Lizenzkosten, vorhandenes Know-how · Stresstests mit realistischen Datenmengen, nicht mit zehn Testzeilen · Zugriffsrollen nach dem Prinzip der geringsten Rechte, die Anwendung bekommt kein Administratorkonto · Verschlüsselung sensibler Felder, **Passwörter werden gehasht und gesalzen, nie verschlüsselt gespeichert** · Migration mit anschließender Validierung: Datensatzzahlen und Stichproben prüfen · DSGVO mitdenken: Löschkonzept und Aufbewahrungsfristen
**Nachhaken bei:** Schritte aufgezählt, aber Datenschutz oder Migrationsprüfung fehlen

### 16-19 · Datenbankzugriff umsetzen
**Themenpunkt:** 16.19 Kenntnisse der Abläufe und Prozessschritte (Zugriffsschnittstelle, Zugriffstechnologie, Transaktionskonzept, Programmierung, Testreihen, Benutzerabnahmetest, Ergebnisprüfung)
**Frage:** Wie gehen Sie vor, wenn Sie den Datenbankzugriff einer Anwendung umsetzen?
**Muss:** Zugriffstechnologie wählen (JDBC, ODBC, PDO oder ein ORM wie Hibernate bzw. Entity Framework) → Transaktionskonzept festlegen → Zugriffe programmieren → Testreihen → Benutzerabnahmetest → Ergebnisprüfung
**Sicher:** Transaktionen folgen ACID: Atomarität, Konsistenz, Isolation, Dauerhaftigkeit — entweder alles oder nichts, das klassische Beispiel ist die Überweisung · ORM spart Schreibarbeit und schützt vor SQL-Injection, versteckt aber, welche Abfragen tatsächlich laufen · **Prepared Statements verwenden**, Benutzereingaben nie in den SQL-String einsetzen · Tests gestaffelt: Unit-, Integrations- und Lasttests · beim Abnahmetest prüft der Auftraggeber gegen die Anforderungen · Ergebnisprüfung heißt: stimmen die gelieferten Daten inhaltlich, nicht nur technisch
**Nachhaken bei:** Technik genannt, aber ACID oder SQL-Injection fehlen
