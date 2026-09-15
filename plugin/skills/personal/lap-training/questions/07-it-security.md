# 7) IT-Security und Betriebssicherheit

### 07-01 · Schadsoftware und Angriffsarten
**Themenpunkt:** 7.1 Kenntnisse über Gefahren von Viren, Würmern, Trojanern, Spyware, Hackern und Phishing
**Frage:** Was ist der Unterschied zwischen einem Virus, einem Wurm und einem Trojaner?
**Muss:** Virus hängt sich an eine vorhandene Datei und braucht eine Benutzeraktion zur Verbreitung · Wurm ist eigenständig und verbreitet sich selbst über das Netzwerk, ohne Zutun des Benutzers · Trojaner tarnt sich als nützliches Programm, wird vom Benutzer freiwillig installiert und verbreitet sich nicht selbst weiter
**Sicher:** Spyware späht Verhalten und Eingaben aus · Ransomware verschlüsselt Daten und fordert Lösegeld · Phishing sind gefälschte Mails und Anmeldeseiten zum Abgreifen von Zugangsdaten, moderne Varianten fangen auch MFA-Codes ab · je ein reales Beispiel: ILOVEYOU, WannaCry, Emotet · Trojaner öffnen typischerweise eine Backdoor und laden weitere Schadsoftware nach
**Nachhaken bei:** alles als „Virus" bezeichnet — die Abgrenzung Wirt/Selbstverbreitung ist der Kern der Frage

### 07-02 · Zero-Day-Exploit
**Themenpunkt:** 7.2 Fachbegriff Zero-Day-Exploit
**Frage:** Was ist ein Zero-Day-Exploit?
**Muss:** Ausnutzung einer Sicherheitslücke, die dem Hersteller noch nicht bekannt ist · deshalb gibt es keinen Patch
**Sicher:** „Zero Day" heißt: der Hersteller hatte null Tage Zeit zu reagieren · besonders gefährlich, weil auch aktuelle Systeme betroffen sind und signaturbasierte Virenscanner nichts finden · solche Lücken werden gehandelt und von staatlichen Akteuren eingesetzt · Gegenmittel sind nicht Patches, sondern Härtung, Rechtebeschränkung und Verhaltenserkennung
**Nachhaken bei:** „Sicherheitslücke wird ausgenutzt" ohne den Punkt, dass sie unbekannt ist

### 07-03 · Einschränkung von Benutzerkonten
**Themenpunkt:** 7.3 Kenntnisse über Einschränkungsmöglichkeiten bei Benutzerkonten
**Frage:** Wie schränken Sie Benutzerkonten in einem Unternehmen sinnvoll ein?
**Muss:** Standardbenutzer ohne Administratorrechte · Passwortrichtlinien · Zwei-Faktor-Authentifizierung
**Sicher:** Gruppenrichtlinien für einheitliche Konfiguration über alle Rechner · Rechtevergabe nach dem Prinzip der geringsten Rechte, Zuweisung über Gruppen statt pro Person · Zugriffsprotokollierung · zeitliche oder gerätebezogene Anmeldebeschränkungen · Konten beim Austritt sofort deaktivieren
**Nachhaken bei:** nur „keine Adminrechte" ohne weitere Maßnahme

### 07-04 · Software-Firewall
**Themenpunkt:** 7.4 Funktion einer Software-Firewall
**Frage:** Was macht eine Software-Firewall?
**Muss:** Überwacht ein- und ausgehenden Netzwerkverkehr und lässt ihn anhand von Regeln zu oder blockiert ihn
**Sicher:** Regeln nach Port, Protokoll, Adresse oder Anwendung · Host-Firewall läuft auf dem einzelnen Rechner, Netzwerk-Firewall auf Router oder Gateway und schützt das ganze Netz · beides ergänzt sich: die Host-Firewall schützt auch gegen Angriffe aus dem eigenen Netz · eine Firewall erkennt keine Schadsoftware im erlaubten Verkehr — dafür braucht es andere Mittel
**Nachhaken bei:** „blockt Angriffe" ohne Regelwerk oder ohne Abgrenzung zum Virenscanner

### 07-05 · Client-PCs schützen
**Themenpunkt:** 7.5 Kenntnisse über Möglichkeiten Client-PCs vor Missbrauch zu schützen
**Frage:** Welche Maßnahmen schützen einen Arbeitsplatzrechner vor Missbrauch?
**Muss:** Mindestens vier: aktuelle Updates und Patches, Virenschutz, Benutzer ohne Adminrechte, Bildschirmsperre, Festplattenverschlüsselung, VPN in fremden Netzen
**Sicher:** Patchmanagement ist die wirksamste Einzelmaßnahme · nur benötigte Software installieren, Angriffsfläche klein halten · Verschlüsselung (BitLocker) schützt bei Diebstahl des Geräts, nicht im laufenden Betrieb · automatische Sperre bei Inaktivität · Wechseldatenträger und USB-Ports regeln · Schulung der Benutzer, weil Phishing an der Technik vorbeigeht
**Nachhaken bei:** nur Virenscanner genannt

### 07-06 · Backup-Planung
**Themenpunkt:** 7.6 Kenntnisse über sichere Planung von Backups
**Frage:** Wie planen Sie ein Backup-Konzept?
**Muss:** 3-2-1-Regel: drei Kopien, auf zwei verschiedenen Medientypen, eine davon außer Haus · regelmäßiger Rücksicherungstest
**Sicher:** ein Backup, das nie zurückgespielt wurde, ist kein Backup · Sicherungsintervall nach der Frage, wie viel Datenverlust verkraftbar ist · Aufbewahrungsdauer und Löschregeln festlegen · Backups offline oder unveränderbar halten, sonst verschlüsselt Ransomware sie mit · Protokollierung und Überwachung, ob der Lauf überhaupt erfolgreich war
**Nachhaken bei:** 3-2-1 genannt, Restore-Test fehlt — darauf zielt die Frage

### 07-07 · Backup-Prinzipien
**Themenpunkt:** 7.7 Kenntnisse über verschiedene Backup-Prinzipien
**Frage:** Erklären Sie Vollbackup, differenzielles und inkrementelles Backup.
**Muss:** Vollbackup: alles · differenziell: alle Änderungen seit dem letzten Vollbackup · inkrementell: nur Änderungen seit der letzten Sicherung, egal welcher Art
**Sicher:** Wiederherstellung: Vollbackup allein · differenziell braucht Vollbackup plus das letzte Differential · inkrementell braucht Vollbackup plus **alle** folgenden Inkremente, fehlt eines, ist die Kette unterbrochen · Abwägung: inkrementell spart Platz und Sicherungszeit, kostet aber bei der Wiederherstellung; differenziell umgekehrt
**Nachhaken bei:** Definitionen richtig, aber die Wiederherstellung nicht durchgespielt — dort liegt der praktische Unterschied

### 07-08 · Backup-Medien und Lagerung
**Themenpunkt:** 7.8 Kenntnisse über Backup-Medien und deren richtiger Lagerung
**Frage:** Welche Backup-Medien kennen Sie und wie werden die richtig gelagert?
**Muss:** Mindestens zwei Medien mit Eigenschaften (externe Festplatte, Magnetband, Cloud, optische Medien) · Lagerung kühl, trocken, dunkel und räumlich getrennt vom Original
**Sicher:** externe HDD/SSD: günstig und schnell, mechanisch bzw. begrenzt haltbar · LTO-Bänder: hohe Kapazität, langlebig, langsamer Zugriff, im Rechenzentrum üblich · Cloud: automatisch außer Haus, dafür Internetabhängigkeit und laufende Kosten · Offsite-Kopie schützt gegen Feuer, Wasser und Einbruch — ein Backup im selben Raum schützt nur gegen Bedienfehler · Verschlüsselung der Medien, weil sie das Haus verlassen
**Nachhaken bei:** Medien aufgezählt, aber der Sinn der räumlichen Trennung fehlt
