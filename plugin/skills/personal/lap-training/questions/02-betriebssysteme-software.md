# 2) Betriebssysteme und Software

### 02-01 · Betriebssystem
**Themenpunkt:** 2.1 Fachbegriff Betriebssystem
**Frage:** Was ist ein Betriebssystem und wofür ist es zuständig?
**Muss:** Software, die die Hardware verwaltet und den Anwendungsprogrammen eine einheitliche Schnittstelle darauf gibt
**Sicher:** Hauptaufgaben benannt: Prozessverwaltung, Speicherverwaltung, Dateisystem, Geräteverwaltung, Benutzeroberfläche · Anwendungen müssen die Hardware dadurch nicht kennen — dasselbe Programm läuft auf verschiedener Hardware
**Nachhaken bei:** nur Beispiele („Windows, Linux") ohne Aufgabenbeschreibung

### 02-02 · Verbreitete Betriebssysteme
**Themenpunkt:** 2.2 Kenntnis der am Markt führend verbreiteten Betriebssysteme
**Frage:** Welche Betriebssysteme sind am Markt führend?
**Muss:** Desktop: Windows, macOS, Linux · Mobil: Android, iOS
**Sicher:** Server: Windows Server, Ubuntu Server, Red Hat Enterprise Linux, Debian · Zuordnung Hersteller: Windows/Microsoft, macOS und iOS/Apple, Android/Google, Linux Open Source
**Nachhaken bei:** nur Desktop genannt, mobil und Server fehlen

### 02-03 · Desktop-Betriebssysteme
**Themenpunkt:** 2.3 Kenntnisse über Desktop-Betriebssysteme
**Frage:** Worin unterscheiden sich Windows, macOS und Linux als Desktop-Betriebssysteme?
**Muss:** Windows am weitesten verbreitet, breiteste Hardware- und Softwareunterstützung · macOS nur auf Apple-Hardware, Unix-basiert · Linux Open Source, viele Distributionen
**Sicher:** Linux stark anpassbar, Distributionen wie Ubuntu, Fedora, Mint · macOS geschlossenes Ökosystem aus Hard- und Software · Kriterien für die Auswahl: verfügbare Fachsoftware, Hardwarebindung, Lizenzkosten, Administrierbarkeit im Unternehmen
**Nachhaken bei:** Aufzählung ohne Unterscheidungsmerkmal

### 02-04 · Firmware
**Themenpunkt:** 2.4 Fachbegriff Firmware
**Frage:** Was ist Firmware?
**Muss:** Software, die fest in der Hardware sitzt (ROM/Flash) und deren Grundfunktionen steuert · liegt zwischen Hardware und Betriebssystem
**Sicher:** Beispiele BIOS/UEFI, Router-Firmware, Firmware in Druckern, SSDs, Smartphones · startet vor dem Betriebssystem und initialisiert die Hardware · ist aktualisierbar (Firmware-Update), aber ein fehlgeschlagenes Update kann das Gerät unbrauchbar machen
**Nachhaken bei:** „Software auf einem Gerät" ohne Abgrenzung zum Betriebssystem

### 02-05 · Systemprogramm und Anwendungsprogramm
**Themenpunkt:** 2.5 Fachbegriffe Systemprogramm, Anwendungsprogramm
**Frage:** Was ist der Unterschied zwischen einem Systemprogramm und einem Anwendungsprogramm?
**Muss:** Systemprogramm arbeitet nah an der Hardware bzw. für das System selbst · Anwendungsprogramm läuft auf dem Betriebssystem und dient dem Endnutzer
**Sicher:** Systemprogramme: Treiber, Betriebssystemkomponenten, Compiler, Systemdienste · Anwendungsprogramme: Browser, Textverarbeitung, IDE · Anwendungsprogramme greifen nie direkt auf Hardware zu, sondern über das Betriebssystem
**Nachhaken bei:** je ein Beispiel ohne die Abgrenzung dahinter

### 02-06 · Multitasking
**Themenpunkt:** 2.6 Fachbegriff Multitasking-Betriebssystem
**Frage:** Was bedeutet Multitasking bei einem Betriebssystem?
**Muss:** Das System führt mehrere Prozesse scheinbar gleichzeitig aus, indem es zwischen ihnen umschaltet
**Sicher:** Präemptives Multitasking: das Betriebssystem entzieht dem Prozess die CPU nach einer Zeitscheibe — heutiger Standard · Kooperatives Multitasking: der Prozess gibt die CPU selbst frei, ein hängender Prozess blockiert das ganze System — veraltet · echte Parallelität erst durch mehrere Kerne
**Nachhaken bei:** „mehrere Programme gleichzeitig" ohne den Unterschied zwischen scheinbar und echt parallel

### 02-07 · Single-User und Multi-User
**Themenpunkt:** 2.7 Fachbegriffe Single-User-System, Multi-User-System
**Frage:** Was unterscheidet ein Single-User- von einem Multi-User-System?
**Muss:** Single-User: nur ein Benutzer arbeitet gleichzeitig am System · Multi-User: mehrere Benutzer gleichzeitig, mit eigenen Berechtigungen und getrennten Prozessen
**Sicher:** Beispiele: klassisches DOS als Single-User, Linux und Windows Server als Multi-User · Multi-User braucht Benutzerverwaltung, Zugriffsrechte und Trennung der Benutzerdaten · Mehrbenutzerfähig heißt nicht dasselbe wie mehrere angelegte Benutzerkonten
**Nachhaken bei:** „mehrere Benutzerkonten" statt gleichzeitiger Nutzung

### 02-08 · PowerShell
**Themenpunkt:** 2.8 Kenntnis über die Powershell (inkl. einfacher Befehle)
**Frage:** Was ist die PowerShell und welche Befehle kennen Sie?
**Muss:** Kommandozeilen-Shell und Skriptsprache von Microsoft · mindestens zwei Befehle korrekt genannt
**Sicher:** basiert auf .NET und gibt Objekte statt Text zurück, deshalb lassen sich Befehle sauber über die Pipeline verketten · Verb-Substantiv-Schema · `Get-Help`, `Get-ChildItem` (dir/ls), `Set-Location` (cd), `Get-Process`, `Get-Service`, `Copy-Item`, `Remove-Item`, `New-Item`
**Nachhaken bei:** Befehle genannt, aber der Objekt-Charakter fehlt — das ist der wesentliche Unterschied zur klassischen Eingabeaufforderung

### 02-09 · Grafische Oberflächen unter Linux
**Themenpunkt:** 2.9 Kenntnisse über grafische Oberflächen unter Linux
**Frage:** Wie ist die grafische Oberfläche unter Linux aufgebaut?
**Muss:** Die Oberfläche ist austauschbar und nicht Teil des Kerns · mindestens eine Desktop-Umgebung genannt (GNOME, KDE Plasma, XFCE)
**Sicher:** Schichten: Display-Server (X11, moderner Wayland) → Window Manager → Desktop-Umgebung · XFCE und LXDE als leichtgewichtige Varianten für schwache Hardware · ein Linux-Server läuft üblicherweise ganz ohne grafische Oberfläche
**Nachhaken bei:** nur Namen von Desktop-Umgebungen ohne den Schichtaufbau

### 02-10 · Dateisystem
**Themenpunkt:** 2.10 Fachbegriff Dateisystem
**Frage:** Was ist ein Dateisystem und welche kennen Sie?
**Muss:** Struktur, die festlegt, wie Dateien auf einem Speichermedium abgelegt und verwaltet werden · mindestens NTFS und ext4 genannt
**Sicher:** Windows: NTFS (Berechtigungen, Journaling), FAT32 (sehr kompatibel, aber max. 4 GB pro Datei), exFAT für USB-Sticks und SD-Karten · Linux: ext4, Btrfs, XFS · macOS: APFS, früher HFS+ · Aufgaben: Speicherplatzverwaltung, Zugriffsrechte, Metadaten wie Größe und Datum
**Nachhaken bei:** Namen aufgezählt, aber FAT32-Grenze oder Berechtigungen nicht erwähnt
