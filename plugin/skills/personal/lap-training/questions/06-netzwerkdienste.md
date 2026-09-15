# 6) Netzwerkdienste

### 06-01 · Domain, Sub-Domain, Top-Level-Domain
**Themenpunkt:** 6.1 Fachbegriffe Domain, Sub-Domain und Top-Level-Domain
**Frage:** Zerlegen Sie mir `shop.beispiel.at` und benennen Sie die Bestandteile.
**Muss:** `.at` ist die Top-Level-Domain, `beispiel` die Second-Level-Domain (die eigentliche Domain), `shop` eine Sub-Domain
**Sicher:** gelesen wird von rechts nach links, hierarchisch · TLD-Arten: länderbezogen (.at, .de) und generisch (.com, .org) · Sub-Domains sind frei anlegbar und zeigen oft auf eigene Server oder Anwendungen · die Auflösung des Namens in eine IP-Adresse macht DNS
**Nachhaken bei:** Teile richtig benannt, aber Leserichtung oder DNS-Bezug fehlt

### 06-02 · HTTP und HTTPS
**Themenpunkt:** 6.2 Kenntnis der Web-Protokolle HTTP und HTTPS
**Frage:** Was ist der Unterschied zwischen HTTP und HTTPS?
**Muss:** HTTP überträgt unverschlüsselt (Port 80), HTTPS verschlüsselt über TLS (Port 443)
**Sicher:** HTTPS schützt vor Mitlesen **und** vor Manipulation und weist über das Zertifikat zusätzlich die Identität des Servers nach · erkennbar am Schloss im Browser · Zustandslosigkeit: HTTP merkt sich nichts zwischen zwei Anfragen, deshalb Cookies und Sessions · heute Standard, Browser markieren reines HTTP als unsicher
**Nachhaken bei:** „HTTPS ist verschlüsselt" ohne Ports oder ohne Identitätsnachweis

### 06-03 · Funktionsprinzip eines Mail-Servers
**Themenpunkt:** 6.3 Funktionsprinzip eines Mail-Servers
**Frage:** Beschreiben Sie den Weg einer E-Mail vom Absender bis zum Empfänger.
**Muss:** Client übergibt die Mail per SMTP an den eigenen Mailserver → dieser ermittelt den Zielserver → Zustellung per SMTP an den Empfangsserver → Ablage im Postfach → Empfänger holt sie per POP3 oder IMAP ab
**Sicher:** die Ermittlung des Zielservers läuft über den MX-Record im DNS der Empfängerdomain · SMTP ist ausschließlich zum Versenden und Weiterleiten da, das Abholen macht immer POP3 oder IMAP · Schutzmechanismen gegen Fälschung: SPF, DKIM, DMARC
**Nachhaken bei:** Weg beschrieben, aber SMTP und Abholprotokoll nicht klar getrennt

### 06-04 · POP3
**Themenpunkt:** 6.4 Kenntnis des Mail-Protokolls POP3/POP3S
**Frage:** Wie arbeitet POP3?
**Muss:** Holt die E-Mails vom Server auf das Gerät und löscht sie dort standardmäßig · Port 110, verschlüsselt als POP3S auf 995
**Sicher:** Vorteil: die Mails liegen lokal, Offline-Zugriff, wenig Serverspeicher nötig · Nachteil: keine Synchronisation über mehrere Geräte, gelesen auf dem Handy heißt ungelesen am PC · sinnvoll nur noch bei einem einzigen Endgerät
**Nachhaken bei:** „lädt Mails herunter" ohne die Folge für Mehrgeräte-Nutzung

### 06-05 · IMAP
**Themenpunkt:** 6.5 Kenntnis des Mail-Protokolls IMAP/IMAPS
**Frage:** Wie arbeitet IMAP und wann nehmen Sie es statt POP3?
**Muss:** Die Mails bleiben auf dem Server, der Client synchronisiert sich damit · Port 143, verschlüsselt als IMAPS auf 993
**Sicher:** Ordnerstruktur, Gelesen-Status und Löschungen gelten auf allen Geräten gleich · Vorteil: mehrere Geräte, zentrale Sicherung durch den Serverbetreiber · Nachteil: braucht Serverspeicher und eine Verbindung · heute der Normalfall
**Nachhaken bei:** Unterschied zu POP3 genannt, aber ohne die Synchronisation von Status und Ordnern

### 06-06 · SMTP
**Themenpunkt:** 6.6 Kenntnis des Mail-Protokolls SMTP/SMTPS
**Frage:** Wofür ist SMTP zuständig?
**Muss:** Zum Versenden von E-Mails — vom Client an den Server und zwischen den Servern · Port 25, verschlüsselt 587 (STARTTLS) bzw. 465
**Sicher:** SMTP kann nur senden, nie abholen — das ist die zentrale Abgrenzung zu POP3 und IMAP · Port 25 ist der Server-zu-Server-Verkehr und bei Providern oft gesperrt, Clients nutzen 587 · Authentifizierung nötig, sonst wäre der Server ein offenes Relay für Spam
**Nachhaken bei:** „verschickt Mails" ohne den Unterschied zwischen Client-Einlieferung und Server-Zustellung

### 06-07 · FTP und FTPS
**Themenpunkt:** 6.7 Kenntnisse über FTP/FTPS
**Frage:** Wofür nutzt man FTP und was ist der Unterschied zu FTPS und SFTP?
**Muss:** FTP überträgt Dateien zwischen Client und Server, Port 21, unverschlüsselt — auch das Passwort · FTPS ist FTP mit TLS
**Sicher:** SFTP ist etwas ganz anderes: Dateiübertragung über SSH auf Port 22, nicht mit FTPS verwandt trotz des ähnlichen Namens · reines FTP ist im Internet nicht mehr vertretbar · typischer Einsatz: Deployment von Webseiten auf Webspace
**Nachhaken bei:** FTPS und SFTP gleichgesetzt

### 06-08 · SSL und TLS
**Themenpunkt:** 6.8 Kenntnisse über SSL
**Frage:** Erklären Sie mir, wie eine verschlüsselte Verbindung über SSL bzw. TLS zustande kommt.
**Muss:** Der Server weist sich mit einem Zertifikat aus · beim Handshake wird asymmetrisch ein gemeinsamer Sitzungsschlüssel ausgetauscht, die eigentlichen Daten laufen dann symmetrisch verschlüsselt
**Sicher:** Ablauf: Server schickt Zertifikat mit öffentlichem Schlüssel → Client prüft es gegen die Zertifizierungsstelle → Client erzeugt den Session Key und verschlüsselt ihn mit dem öffentlichen Schlüssel → nur der Server kann ihn mit seinem privaten Schlüssel entschlüsseln → ab da symmetrisch, z. B. AES · Warum beides: asymmetrisch ist sicher, aber langsam, symmetrisch ist schnell · SSL selbst ist veraltet und seit 2015 abgelöst, aktuell ist TLS 1.2/1.3 — „SSL-Zertifikat" ist nur noch Sprachgebrauch
**Nachhaken bei:** „verschlüsselt die Verbindung" ohne den Unterschied asymmetrisch/symmetrisch — genau darauf zielt diese Frage

### 06-09 · Cloud-Computing
**Themenpunkt:** 6.9 Fachbegriff Cloud-Computing
**Frage:** Was versteht man unter Cloud-Computing?
**Muss:** Bereitstellung von IT-Ressourcen — Rechenleistung, Speicher, Software — über das Internet, auf Abruf und nach Verbrauch bezahlt
**Sicher:** Vorteile: Skalierbarkeit, keine eigene Hardware, standortunabhängig, kein Investitionsaufwand vorab · Nachteile: Abhängigkeit vom Anbieter, Datenschutz und Serverstandort, ohne Internetverbindung nichts · Kostenverschiebung von Investition zu laufendem Betrieb
**Nachhaken bei:** „Daten im Internet speichern" — das ist Cloud-Speicher, nicht Cloud-Computing

### 06-10 · Private, Public und Hybrid Cloud
**Themenpunkt:** 6.10 Kenntnisse über Private/Public/Hybrid Cloud
**Frage:** Was unterscheidet Private, Public und Hybrid Cloud?
**Muss:** Private Cloud: exklusiv für ein Unternehmen, mehr Kontrolle, teurer · Public Cloud: geteilte Infrastruktur eines Anbieters, günstig und skalierbar · Hybrid: Kombination aus beiden
**Sicher:** Public-Beispiele AWS, Azure, Google Cloud · Hybrid in der Praxis: sensible Daten bleiben im eigenen Rechenzentrum, Lastspitzen wandern in die Public Cloud · Auswahlkriterium ist meist der Datenschutz, nicht die Technik
**Nachhaken bei:** Begriffe genannt, ohne zu sagen, wann man was nimmt

### 06-11 · IaaS, PaaS, SaaS
**Themenpunkt:** 6.11 Fachbegriffe IaaS, PaaS, SaaS
**Frage:** Erklären Sie IaaS, PaaS und SaaS mit je einem Beispiel.
**Muss:** IaaS: virtuelle Infrastruktur — Server, Speicher, Netzwerk · PaaS: Plattform mit Laufzeitumgebung, man liefert nur die Anwendung · SaaS: fertige Software zur Nutzung · je ein Beispiel
**Sicher:** Beispiele: AWS EC2 oder Azure VMs (IaaS), App Service, Heroku, Google App Engine (PaaS), Microsoft 365, Salesforce (SaaS) · der Unterschied ist, wie viel man selbst verwaltet: bei IaaS Betriebssystem und alles darüber, bei PaaS nur die Anwendung, bei SaaS nichts · je weiter oben, desto weniger Aufwand und desto weniger Kontrolle
**Nachhaken bei:** Beispiele genannt, aber die Verantwortungsgrenze nicht erklärt

### 06-12 · Marktbekannte Cloud-Dienste
**Themenpunkt:** 6.12 Beispiele für marktbekannte Cloud-Dienste
**Frage:** Welche Cloud-Dienste kennen Sie aus der Praxis?
**Muss:** Mindestens drei, sinnvoll eingeordnet — etwa AWS, Microsoft Azure, Google Cloud als Plattformen
**Sicher:** Speicher: OneDrive, Google Drive, Dropbox · Entwicklung: GitHub, GitLab, Azure DevOps · Anwendungen: Microsoft 365, Google Workspace, Salesforce · Zuordnung zum Servicemodell (IaaS/PaaS/SaaS) mitgeliefert
**Nachhaken bei:** Namen ohne Einordnung, was der Dienst eigentlich liefert

### 06-13 · Kriterien für den Einsatz von Cloud-Diensten
**Themenpunkt:** 6.13 Kriterien und Voraussetzungen für den Einsatz von Cloud-Diensten
**Frage:** Ein Kunde will in die Cloud. Woran machen Sie fest, ob das eine gute Idee ist?
**Muss:** Datenschutz und Serverstandort · Verfügbarkeit und vertraglich zugesagte Uptime (SLA) · Kosten im laufenden Betrieb · Integration in die bestehende Systemlandschaft
**Sicher:** DSGVO-Konformität und Auftragsverarbeitungsvertrag · Skalierbarkeit gegen den tatsächlich erwarteten Bedarf · Anbindung über APIs, Kompatibilität mit Bestehendem · **Exit-Strategie**: kommt man mit seinen Daten wieder heraus · Internetanbindung und was passiert, wenn sie ausfällt
**Nachhaken bei:** Kosten und Technik genannt, Exit-Strategie und Datenschutz fehlen
