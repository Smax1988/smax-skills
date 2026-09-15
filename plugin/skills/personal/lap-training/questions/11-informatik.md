# 11) Informatik

### 11-01 · Informatik
**Themenpunkt:** 11.1 Fachbegriff Informatik
**Frage:** Was ist Informatik?
**Muss:** Wissenschaft von der systematischen Verarbeitung von Informationen, insbesondere mit Hilfe von Computern
**Sicher:** Teilgebiete: theoretische (Algorithmen, Berechenbarkeit), praktische (Software, Compiler), technische (Hardware, Rechnerarchitektur) und angewandte Informatik (Wirtschafts-, Medizininformatik) · Kernthemen Algorithmen und Datenstrukturen · Informatik ist nicht dasselbe wie Programmieren — Programmieren ist ein Werkzeug darin
**Nachhaken bei:** „Arbeiten mit Computern" ohne den Informationsbegriff

### 11-02 · Statische und dynamische Webseiten
**Themenpunkt:** 11.2 Typen von Webseiten (statische, dynamische Webseiten)
**Frage:** Was ist der Unterschied zwischen einer statischen und einer dynamischen Webseite?
**Muss:** Statisch: der Inhalt liegt fertig als HTML-Datei und ist für alle Besucher gleich · dynamisch: der Inhalt wird zur Laufzeit erzeugt, meist aus einer Datenbank, und kann je Benutzer unterschiedlich sein
**Sicher:** statisch: schnell, günstig, einfach zu hosten, kaum Angriffsfläche · dynamisch: braucht serverseitige Technik (PHP, Node.js, Python) und meist eine Datenbank · Beispiel: Visitenkartenseite gegen Webshop · moderne Zwischenform: statisch generierte Seiten mit dynamischen Teilen
**Nachhaken bei:** „dynamisch heißt mit Animationen" — das ist Gestaltung, nicht Inhaltserzeugung

### 11-03 · Weblog, Webshop, Web-Plattform
**Themenpunkt:** 11.3 Fachbegriffe Weblog, Webshop, Web-Plattform
**Frage:** Was unterscheidet einen Weblog, einen Webshop und eine Web-Plattform?
**Muss:** Weblog: chronologisch geordnete Beiträge eines Autors oder einer Redaktion · Webshop: Verkauf mit Produktkatalog, Warenkorb und Bezahlung · Web-Plattform: bringt Nutzer und Anbieter zusammen, die Inhalte kommen von den Nutzern
**Sicher:** Blog meist mit Kommentarfunktion und RSS · Webshop braucht zusätzlich Zahlungsanbindung, Lager- und Bestellverwaltung sowie rechtliche Pflichten (Impressum, Widerruf, AGB) · Plattformbeispiele: Facebook, GitHub, Airbnb — der Betreiber liefert die Infrastruktur, nicht den Inhalt
**Nachhaken bei:** drei Beispiele ohne das unterscheidende Merkmal

### 11-04 · HTML und XML
**Themenpunkt:** 11.4 Auszeichnungssprachen HTML, XML – Fachbegriff und Einsatzgebiet
**Frage:** Wofür stehen HTML und XML und wo setzt man sie jeweils ein?
**Muss:** HTML: HyperText Markup Language, strukturiert den Inhalt von Webseiten für die Darstellung im Browser · XML: eXtensible Markup Language, beschreibt und transportiert strukturierte Daten
**Sicher:** beides sind Auszeichnungssprachen, keine Programmiersprachen — sie beschreiben, sie berechnen nicht · HTML hat ein festes Tagset, in XML definiert man eigene Tags · XML-Einsatz: Datenaustausch zwischen Systemen, Konfigurationsdateien, SOAP · XML ist streng (wohlgeformt), HTML verzeiht Fehler · heute im Datenaustausch weitgehend von JSON abgelöst
**Nachhaken bei:** HTML als Programmiersprache bezeichnet

### 11-05 · HTML5-Grundgerüst
**Themenpunkt:** 11.5 Kenntnisse über das HTML5-Grundgerüst mit den wichtigsten Bestandteilen
**Frage:** Schreiben bzw. beschreiben Sie mir das Grundgerüst einer HTML5-Seite.
**Muss:** `<!DOCTYPE html>`, `<html>`, darin `<head>` und `<body>` · head enthält Metadaten und Titel, body den sichtbaren Inhalt
**Sicher:** `<meta charset="UTF-8">` gegen Zeichensalat · `<meta name="viewport" content="width=device-width, initial-scale=1.0">` für die Darstellung am Handy · `<title>` erscheint im Browsertab und in Suchergebnissen · `lang="de"` am html-Tag für Barrierefreiheit und Suchmaschinen · Stylesheets im head, Skripte am Ende des body oder mit defer
**Nachhaken bei:** head und body genannt, aber charset oder viewport fehlen

### 11-06 · Meta-Elemente
**Themenpunkt:** 11.6 Fachbegriff Meta-Element/Metadaten
**Frage:** Was sind Meta-Elemente in HTML und wozu dienen sie?
**Muss:** Angaben über das Dokument selbst, stehen im `<head>` und sind für den Besucher nicht sichtbar
**Sicher:** `charset` legt die Zeichenkodierung fest · `description` liefert den Text, den Suchmaschinen im Ergebnis anzeigen · `viewport` steuert die Darstellung auf mobilen Geräten · `robots` steuert die Indexierung · Open-Graph-Tags bestimmen die Vorschau beim Teilen in sozialen Netzwerken · das Keywords-Tag ist ohne Bedeutung, Suchmaschinen ignorieren es
**Nachhaken bei:** „Infos für Suchmaschinen" ohne charset und viewport

### 11-07 · SEO
**Themenpunkt:** 11.7 Fachbegriff SEO und Maßnahmen
**Frage:** Was ist SEO und welche Maßnahmen gehören dazu?
**Muss:** Search Engine Optimization — Maßnahmen, um in Suchmaschinen besser gefunden zu werden · mindestens drei konkrete Maßnahmen
**Sicher:** On-Page: aussagekräftiger `<title>` und Meta-Description, saubere Überschriftenhierarchie h1-h6, sprechende URLs, Alt-Texte bei Bildern, kurze Ladezeit, mobile Darstellung, Barrierefreiheit, verständliche Sprache · Off-Page: Backlinks von anderen Seiten · technisch: sitemap.xml, robots.txt, strukturierte Daten · Trennung On-Page/Off-Page sauber benannt
**Nachhaken bei:** nur „Keywords einbauen"

### 11-08 · CSS
**Themenpunkt:** 11.8 Fachbegriff Cascading StyleSheets und deren Einsatz
**Frage:** Was ist CSS und was bedeutet dabei das „Cascading"?
**Muss:** Sprache zur Gestaltung von HTML — Farben, Schriften, Layout · „Cascading": mehrere Regeln können dasselbe Element betreffen, es gilt eine Rangfolge
**Sicher:** die Rangfolge entscheidet sich über Herkunft, Spezifität und Reihenfolge; `!important` sticht alles · drei Einbindungsarten: inline über das style-Attribut, intern im `<style>`-Block, extern über `<link rel="stylesheet">` — extern ist der Normalfall, weil eine Datei für alle Seiten gilt · Grundgedanke: Trennung von Inhalt (HTML) und Darstellung (CSS)
**Nachhaken bei:** „macht die Seite schön" ohne die Kaskade zu erklären — danach ist ausdrücklich gefragt

### 11-09 · Client- und serverseitiges Scripting
**Themenpunkt:** 11.9 Scripting (clientseitiges Scripting, serverseitiges Scripting)
**Frage:** Was ist der Unterschied zwischen clientseitigem und serverseitigem Scripting?
**Muss:** Clientseitig läuft im Browser des Benutzers (JavaScript) · serverseitig läuft auf dem Webserver (PHP, Node.js, Python) und schickt fertiges HTML zurück
**Sicher:** clientseitig: sofortige Reaktion ohne Serverkontakt — Formularprüfung, Animationen, dynamische Oberfläche · serverseitig: alles, was Zugriff auf Datenbank, Dateien oder Geheimnisse braucht — Authentifizierung, Inhaltserzeugung · **sicherheitsrelevant:** clientseitiger Code ist beim Benutzer und damit manipulierbar, jede Prüfung muss serverseitig wiederholt werden · clientseitige Validierung ist Komfort, keine Sicherheit
**Nachhaken bei:** Unterschied genannt, aber die Sicherheitsfolge fehlt — genau darauf zielen Prüfer hier

### 11-10 · Software für Webentwicklung
**Themenpunkt:** 11.10 Software zum Erstellen und Betrachten von Webseiten (Code-Editoren, Web-Browser, FTP-Programme, Grafikprogramme, Serversoftware)
**Frage:** Welche Software brauchen Sie, um eine Webseite zu erstellen und zu veröffentlichen?
**Muss:** Je ein Beispiel aus mindestens vier Kategorien: Editor, Browser, Übertragungsprogramm, Webserver
**Sicher:** Editoren/IDEs: VS Code, Notepad++, PhpStorm, Visual Studio · Browser: Chrome, Firefox, Edge — plus deren Entwicklerwerkzeuge zum Debuggen · Übertragung: FileZilla (FTP/SFTP), SSH-Clients · Grafik und Design: Photoshop, GIMP, Figma · Webserver: Apache, Nginx, IIS · lokale Entwicklungsumgebung wie XAMPP, dazu Git zur Versionsverwaltung
**Nachhaken bei:** nur Editor und Browser genannt

### 11-11 · Content Management System
**Themenpunkt:** 11.11 Fachbegriff CMS (Einsatzgebiet, notwendige Voraussetzungen, existierende Systeme am Markt)
**Frage:** Was ist ein CMS, was braucht man dafür und welche kennen Sie?
**Muss:** Software zur Verwaltung von Inhalten ohne Programmierkenntnisse · braucht Webserver und Datenbank · mindestens zwei Systeme genannt
**Sicher:** Einsatz: Unternehmensseiten, Blogs, Portale, Shops · Voraussetzungen konkret: Webserver mit PHP, Datenbank (meist MySQL/MariaDB) · Systeme: WordPress (mit Abstand am verbreitetsten), Drupal, TYPO3, Shopware und Shopify für Shops · Trennung von Inhalt, Struktur und Darstellung, Redakteure arbeiten nur am Inhalt · Kehrseite: regelmäßige Updates nötig, weil verbreitete CMS beliebte Angriffsziele sind
**Nachhaken bei:** WordPress genannt, aber Voraussetzungen fehlen

### 11-12 · LIFO und FIFO
**Themenpunkt:** 11.12 Unterschied LIFO/FIFO-Prinzip
**Frage:** Was ist der Unterschied zwischen LIFO und FIFO?
**Muss:** LIFO — Last In, First Out: das zuletzt abgelegte Element wird zuerst entnommen · FIFO — First In, First Out: das zuerst abgelegte Element zuerst
**Sicher:** LIFO entspricht einem Stapel Teller, FIFO einer Warteschlange an der Kassa · Umsetzung als Datenstruktur: Stack für LIFO, Queue für FIFO · begegnet einem auch außerhalb der Programmierung, etwa in der Lagerhaltung
**Nachhaken bei:** Abkürzungen aufgelöst, aber ohne Beispiel oder Datenstruktur

### 11-13 · Stack und Queue
**Themenpunkt:** 11.13 Fachbegriffe Stack und Queue
**Frage:** Was sind Stack und Queue und wo begegnen sie Ihnen in der Praxis?
**Muss:** Stack arbeitet nach LIFO, Queue nach FIFO · je ein Einsatzbeispiel
**Sicher:** Stack-Operationen push und pop, Queue-Operationen enqueue und dequeue · Stack in der Praxis: Aufrufstapel von Funktionen, Undo-Funktion, Auswertung von Klammerausdrücken · Queue: Druckerwarteschlange, Nachrichtenwarteschlangen, Task-Scheduling · der Stack Overflow entsteht, wenn der Aufrufstapel überläuft — typischerweise bei endloser Rekursion
**Nachhaken bei:** LIFO/FIFO wiederholt, ohne ein praktisches Vorkommen zu nennen

### 11-14 · Userinterface
**Themenpunkt:** 11.14 Fachbegriff Userinterface (Arten, Regeln für Entwurf, Gestaltungshilfen/Toolkits/Frameworks)
**Frage:** Welche Arten von Benutzeroberflächen gibt es und worauf achten Sie beim Entwurf?
**Muss:** Arten: CLI (Kommandozeile), GUI (grafisch), dazu Touch- und Sprachbedienung · Entwurfsregeln: Konsistenz, Einfachheit, Rückmeldung auf Aktionen
**Sicher:** weitere Regeln: Fehlertoleranz und Rückgängigmachen, Barrierefreiheit, Erkennbarkeit statt Erinnern, sinnvolle Standardwerte · CLI ist schneller und automatisierbar, GUI leichter erlernbar · Hilfsmittel: Bootstrap, Material UI, Tailwind im Web, WPF und WinForms am Desktop, Figma und Adobe XD für Entwurf und Prototyp
**Nachhaken bei:** nur Arten aufgezählt, Entwurfsregeln fehlen

### 11-15 · Zeichencodierung
**Themenpunkt:** 11.15 Fachbegriff Zeichencodierung (ASCII, ISO-Latin, Unicode, ... – Unterschiede und Verwendung)
**Frage:** Warum braucht es Zeichencodierungen und wie unterscheiden sich ASCII, ISO-Latin und Unicode?
**Muss:** Der Rechner speichert nur Zahlen, die Codierung ordnet jeder Zahl ein Zeichen zu · ASCII 7 Bit und 128 Zeichen, nur Englisch · ISO-8859 erweitert auf 8 Bit und 256 Zeichen · Unicode umfasst alle Schriftsysteme
**Sicher:** die ersten 128 Zeichen sind überall gleich, deshalb ist ASCII-Text immer lesbar · ISO-Latin deckt immer nur eine Sprachgruppe ab (Latin-1 Westeuropa, Latin-2 Osteuropa) — das ist sein Hauptproblem · Unicode vergibt je Zeichen einen eindeutigen Code Point (`ä` = U+00E4), UTF-8 ist die Umsetzung im Speicher mit variabler Byteanzahl · falsche Codierung erzeugt Zeichensalat wie `Ã¤` statt `ä` · UTF-8 ist heute der Standard
**Nachhaken bei:** die drei Namen genannt, aber Code Point und UTF-8 nicht auseinandergehalten

### 11-16 · ANSI, ISO, IEEE
**Themenpunkt:** 11.16 Standards ANSI, ISO, IEEE
**Frage:** Wofür stehen ANSI, ISO und IEEE?
**Muss:** ANSI: US-amerikanische Normungsorganisation · ISO: internationale Normungsorganisation · IEEE: Berufsverband, normiert vor allem Elektrotechnik und Kommunikation
**Sicher:** Beispiele: ANSI-C und ANSI-SQL, ISO 8859 für Zeichensätze und ISO 9001 für Qualitätsmanagement, IEEE 802.11 für WLAN und IEEE 754 für Gleitkommazahlen · Standards machen Produkte verschiedener Hersteller kompatibel · viele Normen entstehen bei einer Organisation und werden von einer anderen übernommen
**Nachhaken bei:** Abkürzungen aufgelöst, aber kein einziges Beispiel

### 11-17 · Frame
**Themenpunkt:** 11.17 Fachbegriff Frame
**Frage:** Was ist ein Frame im Netzwerk?
**Muss:** Ein Datenpaket auf der Sicherungsschicht (Layer 2 im OSI-Modell), zuständig für die Übertragung zwischen zwei Geräten im selben Netz
**Sicher:** Aufbau: Header mit Steuerinformationen, Payload mit Nutzdaten, Trailer mit Prüfsumme · beim Ethernet-Frame: Ziel- und Quell-MAC-Adresse, Typfeld, Daten, CRC-Prüfsumme · Abgrenzung: auf Layer 3 heißt dieselbe Einheit Paket, auf Layer 4 Segment · die MAC-Adresse gilt nur im lokalen Netz, über Router hinweg zählt die IP-Adresse
**Nachhaken bei:** „ein Datenpaket" ohne Schichtzuordnung oder Aufbau

### 11-18 · Webservices
**Themenpunkt:** 11.18 Fachbegriff Webservices (verteiltes System für heterogene Systeme, ...)
**Frage:** Was ist ein Webservice?
**Muss:** Ein Dienst, der über Netzwerkprotokolle Funktionen bereitstellt und damit verschiedene Systeme miteinander verbindet
**Sicher:** heterogen heißt: die beteiligten Systeme dürfen unterschiedliche Plattformen und Programmiersprachen verwenden · lose Kopplung: sie kennen einander nur über die vereinbarte Schnittstelle, nicht über die Implementierung · Kommunikation über HTTP/HTTPS · zwei Ausprägungen: SOAP als Protokoll, REST als Architekturstil · Nutzen: Wiederverwendung und Integration statt Doppelentwicklung
**Nachhaken bei:** „eine Schnittstelle" ohne Plattformunabhängigkeit oder lose Kopplung

### 11-19 · SOAP und WSDL
**Themenpunkt:** 11.19 Kenntnisse über Standards (SOAP, WSDL, ...)
**Frage:** Was sind SOAP und WSDL?
**Muss:** SOAP: XML-basiertes Protokoll für den Nachrichtenaustausch zwischen Systemen · WSDL: XML-Dokument, das einen Webservice beschreibt — Methoden, Parameter, Endpunkte
**Sicher:** SOAP-Nachricht ist streng aufgebaut: Envelope, Header, Body · bringt eigene Standards für Sicherheit und Transaktionen mit (WS-Security), deshalb im Banken- und Versicherungsumfeld verbreitet · aus der WSDL lassen sich Client-Klassen automatisch generieren · Nachteil gegenüber REST: umfangreich, viel Overhead, schwerer manuell zu testen
**Nachhaken bei:** SOAP erklärt, WSDL nicht — oder umgekehrt

### 11-20 · REST-API
**Themenpunkt:** 11.20 Fachbegriff Rest API
**Frage:** Was ist eine REST-API?
**Muss:** Ein Architekturstil, kein Protokoll · nutzt die HTTP-Methoden GET, POST, PUT, DELETE auf Ressourcen, die über URLs angesprochen werden · Datenformat meist JSON
**Sicher:** zustandslos: jede Anfrage enthält alles Nötige, der Server merkt sich zwischen zwei Aufrufen nichts · Zuordnung der Methoden zu CRUD: GET lesen, POST anlegen, PUT ändern, DELETE löschen · HTTP-Statuscodes tragen das Ergebnis: 200, 201, 404, 500 · leichtgewichtiger als SOAP, deshalb heute der Normalfall
**Nachhaken bei:** „Schnittstelle mit JSON" ohne Ressourcen, HTTP-Methoden oder Zustandslosigkeit

### 11-21 · JSON
**Themenpunkt:** 11.21 Fachbegriff JSON
**Frage:** Was ist JSON und wofür wird es verwendet?
**Muss:** JavaScript Object Notation, ein leichtgewichtiges, menschenlesbares Datenformat · besteht aus Objekten in geschweiften Klammern und Arrays in eckigen · Einsatz: Datenaustausch zwischen Client und Server
**Sicher:** Datentypen: String, Zahl, Boolean, null, Objekt, Array — beliebig verschachtelbar · trotz des Namens sprachunabhängig, jede gängige Sprache kann es lesen und schreiben · gegenüber XML kompakter und einfacher zu verarbeiten, dafür ohne Schema und ohne Kommentare · auch als Konfigurationsformat verbreitet
**Nachhaken bei:** „Format für Daten" ohne Aufbau oder Einsatzgebiet

### 11-22 · Agile Softwareentwicklung
**Themenpunkt:** 11.22 Fachbegriff Agile Softwareentwicklung
**Frage:** Was bedeutet agile Softwareentwicklung?
**Muss:** Iteratives und inkrementelles Vorgehen in kurzen Zyklen statt eines starren Phasenplans · enge Zusammenarbeit mit dem Kunden, Anforderungen dürfen sich ändern
**Sicher:** Grundlage ist das Agile Manifest von 2001 mit vier Werten und zwölf Prinzipien · Werte: Individuen und Interaktionen über Prozesse, funktionierende Software über Dokumentation, Zusammenarbeit über Vertragsverhandlung, Reagieren auf Änderung über Planbefolgung · Frameworks: Scrum, Kanban, Extreme Programming · nach jedem Zyklus steht etwas Lauffähiges, das der Kunde beurteilen kann · agil heißt nicht planlos oder ohne Dokumentation
**Nachhaken bei:** „ohne Plan drauflos" — das ist die häufigste Fehlvorstellung

### 11-23 · Reaktive Programmierung
**Themenpunkt:** 11.23 Fachbegriff Reaktive Programmierung
**Frage:** Was ist reaktive Programmierung?
**Muss:** Programmierstil rund um Datenströme und die automatische Weitergabe von Änderungen — das System reagiert selbst, wenn sich ein Wert ändert
**Sicher:** guter Vergleich: eine Formel in Excel rechnet sich neu, sobald sich eine Zelle ändert, statt einmalig ausgeführt zu werden · Einsatz: Echtzeit-Oberflächen, Event-Streams, asynchrone Verarbeitung · Umsetzungen: RxJS, Reactive Extensions, Datenbindung in Angular und modernen UI-Frameworks · Vorteil: weniger manuelle Aktualisierungslogik; Nachteil: Ablauf ist schwerer nachzuvollziehen und zu debuggen
**Nachhaken bei:** „reagiert auf Events" — das täte jeder Event-Handler auch, der Punkt ist die automatische Weitergabe

### 11-24 · Frameworks allgemein
**Themenpunkt:** 11.24 Kenntnisse über Frameworks
**Frage:** Was ist ein Framework und was bringt es?
**Muss:** Ein vorgefertigtes Grundgerüst mit fertigen Bausteinen und einer vorgegebenen Struktur, auf dem man die eigene Anwendung aufbaut
**Sicher:** Unterschied zur Bibliothek: die Bibliothek rufe ich auf, das Framework ruft meinen Code auf (Inversion of Control) · Vorteile: weniger eigener Code, erprobte Lösungen, einheitliche Struktur im Team, Sicherheit und Barrierefreiheit oft schon berücksichtigt · Nachteile: Einarbeitung, Abhängigkeit, Overhead, man muss den vorgesehenen Weg gehen
**Nachhaken bei:** „fertige Funktionen" — dann nach dem Unterschied zur Bibliothek fragen

### 11-25 · Angular
**Themenpunkt:** 11.25 Einsatzgebiete Angular JS
**Frage:** Wofür setzt man Angular ein?
**Muss:** Framework für umfangreiche Webanwendungen im Browser, insbesondere Single-Page-Applications
**Sicher:** die Seite wird einmal geladen und danach nur noch der Inhalt ausgetauscht, Daten kommen per API nach — kein vollständiges Neuladen · typisch für Dashboards und Verwaltungsoberflächen · bringt Komponenten, Datenbindung, Routing und Dependency Injection mit, entwickelt in TypeScript · Abgrenzung: das alte AngularJS (1.x) ist eingestellt, gemeint ist heute Angular ab Version 2 · Alternativen im selben Feld: React, Vue
**Nachhaken bei:** „für Webseiten" ohne Single-Page-Gedanke

### 11-26 · Bootstrap
**Themenpunkt:** 11.26 Einsatzgebiete Bootstrap
**Frage:** Wofür setzt man Bootstrap ein?
**Muss:** CSS-Framework für Gestaltung und responsives Layout — fertige Buttons, Formulare, Navigationen und ein Rastersystem
**Sicher:** das Grid arbeitet mit 12 Spalten und Breakpoints, dadurch passt sich das Layout ohne eigenes CSS an die Bildschirmbreite an · spart Gestaltungsaufwand und liefert ein einheitliches Erscheinungsbild · Kehrseite: Seiten sehen einander ähnlich, und man lädt viel CSS mit, das man nicht braucht · in der LAP-Prüfarbeit ausdrücklich als Beispiel genannt
**Nachhaken bei:** „macht die Seite responsive" ohne Grid oder Komponenten

### 11-27 · jQuery
**Themenpunkt:** 11.27 Einsatzgebiet jQuery
**Frage:** Was ist jQuery und welche Rolle spielt es heute?
**Muss:** JavaScript-Bibliothek, die den Zugriff auf HTML-Elemente, Events, Animationen und AJAX-Anfragen vereinfacht
**Sicher:** entstand, weil sich die Browser früher stark unterschieden — jQuery glättete diese Unterschiede · Kernstück ist die kurze Selektor-Schreibweise `$(...)` · heute weitgehend überholt: moderne Browser können das gleiche nativ (`querySelector`, `fetch`), und Frameworks lösen es anders · begegnet einem vor allem noch in bestehenden Projekten und in WordPress
**Nachhaken bei:** als aktuelles Framework dargestellt, ohne die heutige Rolle einzuordnen

### 11-28 · PHP-Zugriff auf MySQL
**Themenpunkt:** 11.28 Kenntnisse über den Zugriff PHP auf mySQL-Datenbank (Dienste Server/Client)
**Frage:** Beschreiben Sie, wie eine PHP-Seite Daten aus einer MySQL-Datenbank anzeigt.
**Muss:** Der Browser schickt eine Anfrage an den Webserver → PHP läuft dort und verbindet sich mit der Datenbank → führt die Abfrage aus → erzeugt HTML aus dem Ergebnis → schickt es an den Browser zurück
**Sicher:** PHP deckt die vier Grundoperationen CRUD ab: lesen, anlegen, ändern, löschen · Verbindung über PDO oder MySQLi · **Prepared Statements verwenden**, sonst ist die Anwendung für SQL-Injection offen — Benutzereingaben gehören nie direkt in den SQL-String · die Datenbank ist von außen nicht erreichbar, nur PHP spricht mit ihr · lokale Testumgebung: XAMPP mit Apache, PHP und MySQL/MariaDB
**Nachhaken bei:** Ablauf korrekt, aber SQL-Injection bzw. Prepared Statements nicht erwähnt

### 11-29 · Multitasking
**Themenpunkt:** 11.29 Fachbegriff Multitasking
**Frage:** Was versteht man unter Multitasking?
**Muss:** Ein System bearbeitet mehrere Aufgaben scheinbar gleichzeitig, indem es sehr schnell zwischen ihnen umschaltet
**Sicher:** die Zuteilung übernimmt der Scheduler über Zeitscheiben · echte Gleichzeitigkeit gibt es erst mit mehreren Kernen — davor ist es Verschachtelung · Ressourcen müssen verwaltet werden, sonst blockieren sich Prozesse gegenseitig (Deadlock) · Abgrenzung: Multitasking betrifft Prozesse, Multithreading mehrere Ausführungsstränge innerhalb eines Prozesses
**Nachhaken bei:** „mehreres gleichzeitig" ohne den Unterschied zwischen schnellem Umschalten und echter Parallelität

### 11-30 · Mobile Webseiten
**Themenpunkt:** 11.30 Kenntnisse über mobile Webseiten/Optimierung für Smartphones
**Frage:** Worauf achten Sie, wenn eine Webseite auf dem Smartphone gut funktionieren soll?
**Muss:** Inhalte für kleines Display und Hochformat aufbereiten · Bedienung für Touch statt Maus · auf Ladezeit und Datenmenge achten
**Sicher:** Bedienelemente groß genug für den Finger, ausreichende Abstände, kein Hover als einzige Interaktion · Navigation vereinfachen, das Wichtigste zuerst · Bilder in passender Größe ausliefern, Lazy Loading · Schriftgröße lesbar ohne Zoomen · Formulare mit passenden Eingabetypen, damit die richtige Tastatur erscheint · Suchmaschinen bewerten heute vorrangig die mobile Fassung
**Nachhaken bei:** nur „responsive machen" — das ist die Technik, gefragt ist die Optimierung

### 11-31 · Responsive Webdesign
**Themenpunkt:** 11.31 Fachbegriff Responsive Webdesign, Umsetzung
**Frage:** Was ist Responsive Webdesign und wie setzt man es technisch um?
**Muss:** Ein Layout, das sich automatisch an die Bildschirmgröße anpasst · Umsetzung über Media Queries in CSS und relative statt fester Einheiten
**Sicher:** relative Einheiten: Prozent, `em`/`rem`, `vw`/`vh` statt fixer Pixel · flexible Layouts mit Flexbox und CSS Grid · Breakpoints legen fest, ab welcher Breite sich das Layout ändert · der `viewport`-Meta-Tag ist Voraussetzung, sonst skaliert das Handy die Desktop-Ansicht einfach herunter · Bilder mit `max-width: 100%` · Abgrenzung: eine eigene mobile Website (m.beispiel.at) ist gerade **nicht** responsive
**Nachhaken bei:** Definition genannt, aber Media Queries oder viewport fehlen

### 11-32 · Mobile First
**Themenpunkt:** 11.32 Kenntnisse über Konzept Mobile First
**Frage:** Was bedeutet Mobile First?
**Muss:** Man entwirft und entwickelt zuerst für das Smartphone und erweitert danach für größere Bildschirme
**Sicher:** Grundgedanke: die kleinste Ansicht zwingt zur Beschränkung auf das Wesentliche — umgekehrt wird beim Verkleinern nur weggeworfen · das Erweitern nach oben heißt Progressive Enhancement · technisch: Basis-CSS für klein, Media Queries mit `min-width` nach oben · Begründung: der Großteil des Traffics kommt heute von mobilen Geräten
**Nachhaken bei:** „Handy zuerst" ohne Begründung, warum die Reihenfolge einen Unterschied macht

### 11-33 · Aktuelle Programmiersprachen
**Themenpunkt:** 11.33 Kenntnisse über aktuelle Programmiersprachen
**Frage:** Welche Programmiersprachen sind aktuell relevant und wofür setzt man sie ein?
**Muss:** Mindestens vier Sprachen mit je einem passenden Einsatzgebiet
**Sicher:** Python: Data Science, KI, Skripting, Web über Django/Flask · JavaScript und TypeScript: Web, im Browser und über Node.js auch am Server · C#: .NET-Anwendungen, Desktop, Unity · Java: Enterprise-Anwendungen, Android · C und C++: Systemnahes, Embedded, maximale Leistung · Swift für iOS, Kotlin für Android · PHP: serverseitige Webentwicklung, ab Version 8 deutlich moderner · Rust: systemnah mit Speichersicherheit ohne Garbage Collector · Auswahlkriterien: Einsatzgebiet, vorhandenes Ökosystem, Know-how im Team
**Nachhaken bei:** Sprachen aufgezählt ohne Einsatzgebiet

### 11-34 · Sprachen für Mobile und Web
**Themenpunkt:** 11.34 Kenntnisse über Programmiersprachen für mobile Anwendungen/Internet
**Frage:** Womit entwickelt man mobile Apps, womit Webanwendungen?
**Muss:** Nativ: Swift für iOS, Kotlin (oder Java) für Android · Web: HTML, CSS und JavaScript als Grundlage
**Sicher:** plattformübergreifend: React Native, Flutter (Dart), .NET MAUI — eine Codebasis für beide Systeme · React Native ist in der LAP-Prüfarbeit ausdrücklich genannt · Web serverseitig: PHP, C#, Java, Python, Node.js · Abwägung nativ gegen cross-platform: nativ bringt volle Gerätefunktion und beste Leistung, cross-platform spart Entwicklungsaufwand
**Nachhaken bei:** nur native Sprachen genannt, plattformübergreifende Ansätze fehlen

### 11-35 · Java im Web
**Themenpunkt:** 11.35 Kenntnisse über die Anwendung von JAVA-Technologien im Web (Servlets, Java-Server-Pages)
**Frage:** Was sind Servlets und JSP?
**Muss:** Servlet: Java-Klasse auf dem Server, die HTTP-Anfragen entgegennimmt und die Antwort erzeugt · JSP: HTML-Seite mit eingebettetem Java-Code für dynamische Inhalte
**Sicher:** beide laufen in einem Servlet-Container bzw. Applikationsserver wie Tomcat · JSP wird beim ersten Aufruf in ein Servlet übersetzt — es ist dieselbe Technik in anderer Schreibweise · Servlet eignet sich für Logik, JSP für Darstellung; daraus entstand die Trennung nach MVC · heute meist durch Spring Boot und REST-APIs abgelöst · JavaScript hat mit Java nichts zu tun
**Nachhaken bei:** Java und JavaScript vermischt

### 11-36 · .NET im Web
**Themenpunkt:** 11.36 Grundkenntnisse über die Anwendung der .NET-Technologien im Web (ASP.NET)
**Frage:** Was ist ASP.NET?
**Muss:** Microsoft-Framework für Webanwendungen, die Anwendungslogik wird üblicherweise in C# geschrieben und läuft am Server
**Sicher:** ASP.NET Core ist die aktuelle, plattformübergreifende Fassung — läuft auch auf Linux · Ausprägungen: MVC und Razor Pages für serverseitig gerenderte Seiten, Web API für REST-Schnittstellen, Blazor für C# im Browser · gehostet über IIS, Kestrel oder Container · Entwicklung mit Visual Studio, Datenzugriff typischerweise über Entity Framework
**Nachhaken bei:** „Webseiten mit C#" ohne eine der Ausprägungen

### 11-37 · Metadaten
**Themenpunkt:** 11.37 Fachbegriff Metadaten
**Frage:** Was sind Metadaten?
**Muss:** Daten über andere Daten — sie beschreiben ein Objekt, sind aber nicht dessen Inhalt
**Sicher:** Beispiele: Dateigröße, Erstellungsdatum, Autor, Dateityp · Foto: Aufnahmezeit, Kameramodell, GPS-Koordinaten (EXIF) · Web: HTML-Meta-Tags · Datenbank: Tabellen- und Spaltendefinitionen im Data Dictionary · **datenschutzrelevant**: Metadaten verraten oft mehr als der Inhalt — GPS-Daten in Fotos, Verbindungsdaten in der Kommunikation
**Nachhaken bei:** „Daten über Daten" ohne ein einziges Beispiel

### 11-38 · KISS und DRY
**Themenpunkt:** 11.38 Prinzipien der Softwareentwicklung: KISS, DRY
**Frage:** Was besagen KISS und DRY?
**Muss:** KISS — Keep It Simple, Stupid: so einfach wie möglich lösen, unnötige Komplexität vermeiden · DRY — Don't Repeat Yourself: jede Logik existiert nur an einer Stelle
**Sicher:** Begründung DRY: doppelte Logik führt dazu, dass eine Änderung an einer Kopie vergessen wird — daraus entstehen genau die Fehler, die niemand findet · Umsetzung über Funktionen, Klassen, Konstanten statt Copy-Paste · KISS zielt auf Wartbarkeit: Code wird viel öfter gelesen als geschrieben · verwandte Prinzipien: YAGNI, Separation of Concerns, SOLID
**Nachhaken bei:** Abkürzungen aufgelöst, aber ohne zu sagen, welches Problem sie verhindern

### 11-39 · Coding-Standards
**Themenpunkt:** 11.39 Kenntnisse über Coding-Standards/Code-Konventionen
**Frage:** Was sind Coding-Standards und warum braucht man sie?
**Muss:** Vereinbarte Regeln für Formatierung, Benennung und Aufbau von Code · Zweck: Lesbarkeit und Wartbarkeit im Team
**Sicher:** Inhalte: Einrückung, Klammersetzung, Namenskonventionen (camelCase, PascalCase, snake_case), Aufbau von Dateien, Kommentar- und Dokumentationsregeln, maximale Zeilenlänge · durchgesetzt über Linter und Formatter (ESLint, Prettier, EditorConfig), automatisch im Build oder beim Commit · Nutzen: Code sieht aus wie aus einer Hand, Diffs zeigen echte Änderungen statt Formatierungsrauschen, Einarbeitung wird schneller · welche Regel gilt, ist weniger wichtig, als dass alle dieselbe verwenden
**Nachhaken bei:** „schöner Code" ohne den Teamnutzen

### 11-40 · Cross-Platform-Entwicklung
**Themenpunkt:** 11.40 Fachbegriff Cross Plattform Entwicklung
**Frage:** Was bedeutet Cross-Platform-Entwicklung?
**Muss:** Aus einer gemeinsamen Codebasis Software für mehrere Betriebssysteme erzeugen, statt jede Plattform einzeln zu entwickeln
**Sicher:** Frameworks: Flutter, React Native, .NET MAUI, Xamarin, Electron für Desktop · Vorteile: einmal entwickeln, einheitliches Verhalten, weniger Aufwand und Kosten · Nachteile: Zugriff auf neue Gerätefunktionen oft verzögert, geringere Leistung, das Ergebnis fühlt sich nicht immer wie eine native App an · Abgrenzung: native Entwicklung je Plattform gegen Web-App im Browser
**Nachhaken bei:** Definition ohne Framework-Beispiel oder ohne Nachteile

### 11-41 · Continuous Integration
**Themenpunkt:** 11.41 Fachbegriff Continuous Integration (CI)
**Frage:** Was ist Continuous Integration?
**Muss:** Änderungen werden häufig in einen gemeinsamen Stand integriert und dabei automatisch gebaut und getestet
**Sicher:** Ziel: Integrationsfehler früh finden, statt am Ende alle Zweige gleichzeitig zusammenzuführen · ausgelöst bei jedem Push oder Pull Request · die Pipeline baut, führt Tests aus und prüft Codequalität; schlägt sie fehl, wird nicht gemergt · Voraussetzung: Versionsverwaltung und automatisierte Tests · Werkzeuge: GitHub Actions, GitLab CI, Jenkins, Azure DevOps
**Nachhaken bei:** „Code zusammenführen" ohne automatisches Bauen und Testen

### 11-42 · Continuous Delivery und Deployment
**Themenpunkt:** 11.42 Fachbegriff Continuous Delivery bzw. Continuous Deployment (CD)
**Frage:** Was ist der Unterschied zwischen Continuous Delivery und Continuous Deployment?
**Muss:** Continuous Delivery: die Software ist jederzeit auslieferbar, die Freigabe in die Produktion erfolgt aber manuell · Continuous Deployment: jede erfolgreich getestete Änderung geht automatisch live
**Sicher:** beide bauen auf Continuous Integration auf · der einzige Unterschied ist der manuelle Freigabeschritt · Continuous Deployment setzt sehr gute Testabdeckung und Überwachung voraus, weil kein Mensch mehr dazwischen steht · Absicherung über Feature Flags, Canary Releases, schnelles Zurückrollen
**Nachhaken bei:** beide Begriffe gleichgesetzt — der Freigabeschritt ist die ganze Frage

### 11-43 · CI/CD in der Praxis
**Themenpunkt:** 11.43 CI/CD Vorgaben bei der Applikationsentwicklung
**Frage:** Was braucht ein Team konkret, um CI/CD einzusetzen?
**Muss:** Versionsverwaltung (Git) · einen Build- bzw. Automatisierungsdienst · automatisierte Tests
**Sicher:** Werkzeuge: Jenkins, GitHub Actions, GitLab CI, Azure DevOps · in der Pipeline automatisiert: Build, Tests, Sicherheits- und Abhängigkeitsprüfungen, Deployment · getrennte Umgebungen für Entwicklung, Test und Produktion · Vorgaben im Team: Branch-Strategie, verpflichtender Review, keine roten Builds im Hauptzweig · Nutzen: kürzere Releasezyklen, gleichbleibende Qualität, schnelles Feedback statt großer Big-Bang-Releases
**Nachhaken bei:** Werkzeuge genannt, aber Tests oder Umgebungen fehlen
