# 15) Grundkenntnisse des Programmierens

### 15-01 · Stadien der Softwareentwicklung
**Themenpunkt:** 15.1 Stadien der Softwareentwicklung
**Frage:** Welche Stadien durchläuft eine Softwareentwicklung?
**Muss:** Anforderungsanalyse → Entwurf → Implementierung → Test → Inbetriebnahme → Wartung
**Sicher:** Analyse klärt das Was, der Entwurf das Wie · die Wartung ist über die Lebensdauer der teuerste Abschnitt, nicht das Programmieren · je später ein Fehler entdeckt wird, desto teurer wird er — deshalb liegt das Gewicht auf Analyse und Entwurf · in agilen Modellen werden dieselben Stadien in jedem Zyklus durchlaufen, nur eben in kurzen Runden
**Nachhaken bei:** Test oder Wartung fehlt

### 15-02 · Prozedural und objektorientiert
**Themenpunkt:** 15.2 Fachbegriffe Prozedurale Programmierung, Objektorientierte Programmierung, Unterschiede
**Frage:** Was ist der Unterschied zwischen prozeduraler und objektorientierter Programmierung?
**Muss:** Prozedural: Grundeinheit ist die Funktion, Daten und Logik sind getrennt · objektorientiert: Grundeinheit ist die Klasse bzw. das Objekt, Daten und die dazugehörigen Methoden liegen zusammen
**Sicher:** Kapselung als Kernunterschied: das Objekt schützt seine Daten und stellt Methoden bereit · Wiederverwendung prozedural über Funktionen, objektorientiert zusätzlich über Vererbung und Polymorphie · Beispiele: C und Pascal prozedural, Java, C# und Python objektorientiert · Abwägung: bei kleinen Programmen ist prozedural schlanker, bei großen bleibt objektorientiert beherrschbar
**Nachhaken bei:** „mit Klassen statt mit Funktionen" ohne Kapselung

### 15-03 · Algorithmus
**Themenpunkt:** 15.3 Fachbegriff Algorithmus
**Frage:** Was ist ein Algorithmus?
**Muss:** Eine eindeutige, endliche Folge von Anweisungen, die ein Problem löst
**Sicher:** Eigenschaften: Eindeutigkeit (jeder Schritt ist klar), Endlichkeit (er terminiert), Allgemeinheit (er löst eine Klasse von Problemen, nicht einen Einzelfall), Ausführbarkeit, Determiniertheit · unabhängig von einer Programmiersprache — er lässt sich als Pseudocode, Struktogramm oder Flowchart darstellen · Alltagsbeispiel: ein Kochrezept erfüllt fast alle diese Eigenschaften
**Nachhaken bei:** „eine Anleitung" ohne Eindeutigkeit und Endlichkeit

### 15-04 · Pseudocode
**Themenpunkt:** 15.4 Fachbegriff Pseudocode
**Frage:** Was ist Pseudocode und wofür verwendet man ihn?
**Muss:** Sprachunabhängige, umgangssprachliche Beschreibung eines Algorithmus ohne strenge Syntax · dient der Planung vor der Implementierung
**Sicher:** nicht ausführbar und nicht compilierbar — er soll für Menschen lesbar sein · Nutzen: die Logik klären, ohne sich mit Syntaxfehlern aufzuhalten, und die Idee mit Kollegen besprechen, die die Zielsprache nicht können · verwendet Strukturen wie WENN, SOLANGE, WIEDERHOLE · Alternative Darstellungen: Struktogramm und Flowchart
**Nachhaken bei:** Pseudocode als vereinfachte Programmiersprache beschrieben — er hat keine festen Regeln

### 15-05 · Sortieralgorithmen
**Themenpunkt:** 15.5 Kenntnisse über Sortieralgorithmen (Bubblesort, Quicksort)
**Frage:** Erklären Sie mir Bubblesort und Quicksort.
**Muss:** Bubblesort vergleicht benachbarte Elemente und vertauscht sie, bis nichts mehr zu tauschen ist — einfach, aber langsam · Quicksort wählt ein Pivot-Element, teilt die Liste in kleiner und größer und sortiert die Teile rekursiv weiter
**Sicher:** Komplexität: Bubblesort O(n²), Quicksort im Mittel O(n log n), im schlechtesten Fall O(n²) bei ungünstigem Pivot · Quicksort ist ein Divide-and-Conquer-Verfahren · bei Bubblesort steigt das große Element in jedem Durchlauf nach oben — daher der Name · Bubblesort hat praktisch nur Lernwert, produktiv wird Quicksort oder Mergesort verwendet
**Nachhaken bei:** Bubblesort beschrieben, Quicksort nur benannt — hier will der Prüfer beide Verfahren hören

### 15-06 · Suchalgorithmen
**Themenpunkt:** 15.6 Kenntnisse über Suchalgorithmen (sequentielle Suche, binäre Suche)
**Frage:** Was ist der Unterschied zwischen sequentieller und binärer Suche?
**Muss:** Sequentiell: jedes Element der Reihe nach prüfen, funktioniert auf unsortierten Daten, O(n) · binär: den Suchbereich immer halbieren, **setzt sortierte Daten voraus**, O(log n)
**Sicher:** binäre Suche: mit dem mittleren Element vergleichen und je nach Ergebnis in der linken oder rechten Hälfte weitersuchen · Größenordnung: bei einer Million Einträgen braucht die binäre Suche rund 20 Schritte, die sequentielle im Mittel eine halbe Million · Abwägung: lohnt sich das Sortieren? Bei einmaliger Suche nein, bei vielen Suchvorgängen ja — dasselbe Prinzip steckt hinter dem Datenbankindex
**Nachhaken bei:** binäre Suche erklärt, ohne die Voraussetzung sortierter Daten zu nennen

### 15-07 · Ablauf der Programmentwicklung
**Themenpunkt:** 15.7 Ablauf der Programmentwicklung
**Frage:** Welche Schritte durchläuft der Code, bis ein lauffähiges Programm entsteht?
**Muss:** Quellcode schreiben → übersetzen (compilieren oder interpretieren) → linken → ausführen → testen → debuggen
**Sicher:** der Compiler erzeugt aus dem Quellcode Objektcode, der Linker bindet Objektdateien und Bibliotheken zum ausführbaren Programm zusammen · Syntaxfehler stoppen bereits die Übersetzung, Logikfehler fallen erst beim Testen auf · bei interpretierten Sprachen entfällt der eigene Übersetzungsschritt, der Fehler zeigt sich zur Laufzeit · der Zyklus wiederholt sich, Entwicklung ist nicht linear
**Nachhaken bei:** Linken vergessen oder Syntax- und Logikfehler nicht unterschieden

### 15-08 · Aufbau einer Programmiersprache
**Themenpunkt:** 15.8 Fachbegriffe zum Aufbau einer Programmiersprache (Syntax, Semantik, Kommentare, Schlüsselwörter, Anweisung)
**Frage:** Erklären Sie Syntax, Semantik, Schlüsselwörter, Anweisung und Kommentar.
**Muss:** Syntax: die formalen Regeln, wie ein gültiges Programm aufgebaut sein muss · Semantik: die Bedeutung dessen, was da steht · Schlüsselwörter: reservierte Wörter der Sprache · Anweisung: eine einzelne ausführbare Operation · Kommentar: Erklärungstext, der nicht ausgeführt wird
**Sicher:** guter Merksatz: Syntax ist die Grammatik, Semantik die Bedeutung — ein Satz kann grammatikalisch richtig und trotzdem sinnlos sein · genau das ist der Unterschied zwischen Syntaxfehler (der Compiler meckert) und Logikfehler (das Programm läuft, macht aber das Falsche) · Schlüsselwörter wie `if`, `while`, `class` dürfen nicht als Bezeichner verwendet werden · Kommentarformen `//`, `/* */`, `#`
**Nachhaken bei:** Syntax und Semantik nicht klar getrennt

### 15-09 · Interpreter und Compiler
**Themenpunkt:** 15.9 Fachbegriffe Interpreter und Compiler (Unterschiede, Vor- und Nachteile)
**Frage:** Was ist der Unterschied zwischen einem Interpreter und einem Compiler?
**Muss:** Der Compiler übersetzt den gesamten Quellcode vorab in Maschinencode · der Interpreter führt ihn zur Laufzeit Zeile für Zeile aus
**Sicher:** Kompilat läuft schneller und Fehler fallen schon beim Übersetzen auf, dafür ist es plattform- und architekturgebunden · Interpreter ist plattformunabhängig und angenehmer beim Entwickeln, dafür langsamer und Fehler zeigen sich erst zur Laufzeit · Beispiele: C, C++ compiliert; Python, JavaScript interpretiert · Mischform JIT: Java und C# übersetzen erst in Bytecode und dann zur Laufzeit in Maschinencode
**Nachhaken bei:** „übersetzt in Maschinensprache" ohne den Unterschied im Zeitpunkt

### 15-10 · Debugger
**Themenpunkt:** 15.10 Fachbegriff Debugger (Einsatz)
**Frage:** Was ist ein Debugger und wie arbeiten Sie damit?
**Muss:** Werkzeug zur Fehlersuche · erlaubt Haltepunkte (Breakpoints), schrittweises Ausführen und das Beobachten von Variablenwerten zur Laufzeit
**Sicher:** Schrittarten: in eine Funktion hinein, über sie hinweg, aus ihr heraus · Watches auf einzelne Ausdrücke, Aufrufstapel zur Frage, wie man an diese Stelle gekommen ist · bedingte Breakpoints, die nur bei bestimmten Werten auslösen · in jeder modernen IDE eingebaut, im Browser über die Entwicklerwerkzeuge · schneller und verlässlicher als Ausgaben ins Log zu streuen
**Nachhaken bei:** „findet Fehler" ohne Breakpoints oder Variablenbeobachtung

### 15-11 · Assembler
**Themenpunkt:** 15.11 Fachbegriff Assembler
**Frage:** Was ist Assembler?
**Muss:** Maschinennahe Programmiersprache mit symbolischen Befehlen · der Assembler ist zugleich das Programm, das diese in Maschinencode übersetzt
**Sicher:** direkter Zugriff auf CPU-Register und Speicheradressen, ein Befehl entspricht im Wesentlichen einem Maschinenbefehl · prozessorabhängig — Code für eine Architektur läuft nicht auf einer anderen · Einsatz: Betriebssystemkerne, Treiber, Mikrocontroller, extrem zeitkritische Routinen · Vorteil maximale Kontrolle und Geschwindigkeit, Nachteil aufwendig, fehleranfällig und schlecht wartbar
**Nachhaken bei:** Assembler und Maschinencode gleichgesetzt

### 15-12 · Rekursion
**Themenpunkt:** 15.12 Fachbegriff Rekursive Funktionen
**Frage:** Was ist eine rekursive Funktion und worauf müssen Sie dabei achten?
**Muss:** Eine Funktion, die sich selbst aufruft · sie braucht zwingend eine Abbruchbedingung (Basisfall), sonst läuft sie endlos
**Sicher:** ohne Abbruch endet es im Stack Overflow, weil jeder Aufruf Platz auf dem Aufrufstapel belegt · klassische Beispiele: Fakultät, Fibonacci, Durchlaufen von Baumstrukturen und Verzeichnissen · jede Rekursion lässt sich auch iterativ mit einer Schleife lösen — iterativ ist speicherschonender, rekursiv oft lesbarer · sinnvoll dort, wo das Problem selbst rekursiv aufgebaut ist
**Nachhaken bei:** „ruft sich selbst auf" ohne Abbruchbedingung

### 15-13 · ASCII-Tabelle
**Themenpunkt:** 15.13 Kenntnisse über ASCII-Tabellen (ergänzt)
**Frage:** Wie ist die ASCII-Tabelle aufgebaut und wozu brauchen Sie sie beim Programmieren?
**Muss:** Zuordnung von Zahlen zu Zeichen, 128 Einträge von 0 bis 127 · Zeichen werden intern als ihr Zahlenwert gespeichert
**Sicher:** Aufbau: 0-31 Steuerzeichen, 32 Leerzeichen, 48-57 die Ziffern 0-9, 65-90 A-Z, 97-122 a-z · praktische Folgen: Groß- und Kleinbuchstaben liegen genau 32 auseinander, deshalb funktioniert Umwandeln über Addition · von der Ziffer zum Zahlenwert kommt man über `'7' - '0'` · beim Sortieren stehen Großbuchstaben vor Kleinbuchstaben, weil ihr Code kleiner ist · über 127 beginnt der Bereich, in dem Codierungen auseinanderlaufen (siehe 11-15)
**Nachhaken bei:** ASCII erklärt (siehe 01-01), aber kein Bezug zur praktischen Verwendung im Code

### 15-14 · Datentypen
**Themenpunkt:** 15.14 Kenntnisse über Variablenarten, Datentypen und Definitionen
**Frage:** Welche grundlegenden Datentypen kennen Sie?
**Muss:** Ganzzahl (`int`, `long`), Gleitkomma (`float`, `double`), Zeichen (`char`), Zeichenkette (`String`), Wahrheitswert (`boolean`)
**Sicher:** eine Variable wird deklariert (Typ und Name festgelegt) und initialisiert (erster Wert zugewiesen) · der Typ bestimmt Wertebereich und Speicherbedarf: `int` üblicherweise 4 Byte · Unterscheidung primitive Typen und Referenztypen, `String` ist ein Objekt · statische Typisierung prüft beim Compilieren (Java, C#), dynamische erst zur Laufzeit (Python, JavaScript) · Gleitkommazahlen sind ungenau — Geldbeträge nie mit `double` rechnen
**Nachhaken bei:** Typen aufgezählt, aber Deklaration und Initialisierung nicht unterschieden

### 15-15 · Variable und Konstante
**Themenpunkt:** 15.15 Unterschied Variable und Konstante (ergänzt)
**Frage:** Was ist der Unterschied zwischen einer Variablen und einer Konstanten?
**Muss:** Der Wert einer Variablen kann sich während der Laufzeit ändern, der einer Konstanten nicht — er wird einmal festgelegt und ist danach unveränderlich
**Sicher:** Schlüsselwörter je nach Sprache: `const`, `final`, `readonly` · Nutzen: der Compiler verhindert versehentliche Änderungen, und ein benannter Wert wie `MWST_SATZ` ist verständlicher als die Zahl 0,20 mitten im Code · Magic Numbers vermeiden — der Wert steht an einer Stelle und wird dort gepflegt · Konvention: Konstanten oft in GROSSBUCHSTABEN
**Nachhaken bei:** Unterschied genannt, aber nicht warum man Konstanten überhaupt verwendet

### 15-16 · Gültigkeitsbereiche
**Themenpunkt:** 15.16 Gültigkeitsbereiche (Lebensdauer) von Variablen
**Frage:** Welche Gültigkeitsbereiche von Variablen gibt es?
**Muss:** Lokal: nur innerhalb der Funktion oder des Blocks gültig, entsteht beim Aufruf und verschwindet danach · global: im ganzen Programm gültig und über die gesamte Laufzeit vorhanden
**Sicher:** Instanzvariable (Attribut): gehört zu einem Objekt und lebt so lange wie das Objekt · Klassenvariable (`static`): gehört zur Klasse, existiert einmal für alle Objekte · Parameter verhalten sich wie lokale Variablen · Verdeckung: eine lokale Variable überdeckt eine gleichnamige äußere · globale Variablen sparsam einsetzen — sie können von überall geändert werden, was Fehler schwer auffindbar macht
**Nachhaken bei:** nur lokal und global genannt, Instanz- und Klassenvariable fehlen

### 15-17 · Schleifen
**Themenpunkt:** 15.17 Fachbegriff Schleifen, Beispiele für Schleifen
**Frage:** Welche Schleifenarten kennen Sie und wann nehmen Sie welche?
**Muss:** `for` bei bekannter Anzahl von Durchläufen · `while`, wenn die Anzahl von einer Bedingung abhängt · `do-while`, wenn mindestens ein Durchlauf stattfinden soll
**Sicher:** `for (int i = 0; i < 10; i++)` mit Initialisierung, Bedingung und Schrittweite · foreach zum Durchlaufen von Sammlungen ohne Zählvariable · `break` verlässt die Schleife, `continue` springt zum nächsten Durchlauf · Endlosschleife, wenn die Abbruchbedingung nie eintritt — häufigste Ursache ist die vergessene Änderung der Zählvariablen
**Nachhaken bei:** Schleifenarten genannt, aber kein Auswahlkriterium

### 15-18 · Kopf- und fußgesteuerte Schleifen
**Themenpunkt:** 15.18 Fachbegriffe „kopfgesteuert" bzw. „fußgesteuert" im Zusammenhang mit Schleifen (ergänzt)
**Frage:** Was bedeutet kopfgesteuert und fußgesteuert bei Schleifen?
**Muss:** Kopfgesteuert: die Bedingung wird **vor** dem Durchlauf geprüft, die Schleife kann also null Mal laufen (`while`, `for`) · fußgesteuert: die Bedingung wird **nach** dem Durchlauf geprüft, die Schleife läuft mindestens einmal (`do-while`)
**Sicher:** genau darin liegt der einzige Unterschied — mindestens ein Durchlauf oder eventuell keiner · fußgesteuert ist sinnvoll, wenn erst nach dem ersten Durchlauf feststeht, ob weitergemacht wird: Benutzereingabe einlesen und prüfen, Menüwiederholung · kopfgesteuert ist der Normalfall, weil man meist vorher wissen will, ob überhaupt etwas zu tun ist
**Nachhaken bei:** Begriffe zugeordnet, aber die praktische Folge (null gegen mindestens ein Durchlauf) nicht ausgesprochen

### 15-19 · Verzweigungen
**Themenpunkt:** 15.19 Kenntnisse über Verzweigungen und Fallunterscheidungen
**Frage:** Welche Möglichkeiten der Verzweigung gibt es?
**Muss:** `if` / `else if` / `else` für Bedingungsprüfungen · `switch` / `case` für die Fallunterscheidung anhand mehrerer möglicher Werte einer Variablen
**Sicher:** der ternäre Operator `Bedingung ? WertWahr : WertFalsch` als Kurzform für einfache Zuweisungen · `switch` ist bei vielen festen Werten lesbarer als eine lange if-Kette, funktioniert aber nur auf diskreten Werten, nicht auf Bereichen · `default` als Auffangzweig, `break` gegen ungewolltes Durchfallen in den nächsten Fall · Verzweigungen lassen sich verschachteln, tiefe Verschachtelung ist aber ein Warnzeichen
**Nachhaken bei:** nur `if` genannt, `switch` fehlt

### 15-20 · Objektorientierte Programmierung
**Themenpunkt:** 15.20 Kenntnis der objektorientierten Programmierung (Klassen, Objekte, Vererbung, ...)
**Frage:** Erklären Sie mir die Grundbegriffe der objektorientierten Programmierung.
**Muss:** Klasse: Bauplan mit Attributen (Daten) und Methoden (Verhalten) · Objekt: eine konkrete Instanz dieser Klasse · Vererbung: eine Unterklasse übernimmt Eigenschaften und Verhalten der Oberklasse · Kapselung: die Daten sind nach außen geschützt, der Zugriff läuft über Methoden
**Sicher:** die vier Säulen vollständig: Kapselung, Vererbung, Polymorphie, Abstraktion · Polymorphie: derselbe Methodenaufruf verhält sich je nach tatsächlicher Klasse unterschiedlich · Abstraktion: nur das Wesentliche nach außen zeigen, Details verbergen · Zugriffsmodifikatoren `private`, `protected`, `public`, Zugriff über Getter und Setter · gutes eigenes Beispiel bereithalten: Klasse `Fahrzeug` mit Unterklassen `PKW` und `LKW` · Vorteile: Wiederverwendung, Struktur, Wartbarkeit bei großen Systemen
**Nachhaken bei:** Klasse und Objekt richtig, aber Polymorphie oder Abstraktion fehlen — bei dieser Frage werden alle vier Säulen erwartet
