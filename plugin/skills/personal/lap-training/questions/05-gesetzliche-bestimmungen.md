# 5) Gesetzliche Bestimmungen im Zusammenhang mit Applikationsentwicklung – Coding

### 05-01 · DSGVO
**Themenpunkt:** 5.1 Kenntnis über DSGVO (Datenschutzgrundverordnung)
**Frage:** Was ist die DSGVO und für wen gilt sie?
**Muss:** EU-weite Verordnung zum Schutz personenbezogener Daten, gilt seit Mai 2018 · gilt für alle, die Daten von Personen in der EU verarbeiten
**Sicher:** greift unabhängig vom Sitz des Unternehmens — auch ein US-Anbieter fällt darunter, wenn er EU-Bürger adressiert · Grundsätze: Rechtmäßigkeit, Zweckbindung, Datenminimierung, Richtigkeit, Speicherbegrenzung, Integrität · Verarbeitung braucht immer eine Rechtsgrundlage, Einwilligung ist nur eine davon · Strafen bis 20 Mio. € oder 4 % des weltweiten Jahresumsatzes
**Nachhaken bei:** „Datenschutz in der EU" ohne Geltungsbereich oder Grundsätze

### 05-02 · Datenminimierung
**Themenpunkt:** 5.2 Fachbetriff „Datenminimierung" im Zusammenhang der DSGVO
**Frage:** Was bedeutet Datenminimierung?
**Muss:** Nur so viele Daten erheben, wie für den konkreten Zweck wirklich nötig sind
**Sicher:** dem Zweck angemessen, erheblich und auf das Notwendige beschränkt · praktisches Beispiel aus der Entwicklung: kein Geburtsdatum im Newsletter-Formular, keine Vollprotokollierung von Benutzereingaben · gehört zusammen mit Speicherbegrenzung — Daten auch wieder löschen, wenn der Zweck weg ist
**Nachhaken bei:** „möglichst wenig Daten" ohne Zweckbezug

### 05-03 · Betroffene Person, Verantwortlicher, Auftragsverarbeiter
**Themenpunkt:** 5.3 Fachbegriffe „betroffene Personen", Verantwortlicher, Auftragsverarbeiter
**Frage:** Erklären Sie die Rollen betroffene Person, Verantwortlicher und Auftragsverarbeiter.
**Muss:** Betroffene Person: die natürliche Person, deren Daten verarbeitet werden · Verantwortlicher: legt Zweck und Mittel der Verarbeitung fest · Auftragsverarbeiter: verarbeitet die Daten im Auftrag des Verantwortlichen
**Sicher:** typisches Beispiel: das Unternehmen ist Verantwortlicher, der Cloud- oder Hosting-Anbieter Auftragsverarbeiter, der Kunde die betroffene Person · zwischen beiden braucht es einen Auftragsverarbeitungsvertrag (AV-Vertrag) · die Verantwortung bleibt beim Verantwortlichen, sie lässt sich nicht auslagern
**Nachhaken bei:** Rollen genannt, aber der AV-Vertrag oder ein Beispiel fehlt

### 05-04 · Rechte betroffener Personen
**Themenpunkt:** 5.4 Kenntnis über Rechte von „betroffene Personen" lt. DSGVO
**Frage:** Welche Rechte hat eine betroffene Person nach der DSGVO?
**Muss:** mindestens vier: Auskunft, Berichtigung, Löschung, Einschränkung der Verarbeitung, Datenübertragbarkeit, Widerspruch
**Sicher:** alle sechs genannt · Recht auf Löschung ist das „Recht auf Vergessenwerden" · Datenübertragbarkeit heißt: Herausgabe in einem gängigen, maschinenlesbaren Format · Frist zur Beantwortung: ein Monat · was das für die Entwicklung heißt: Auskunft und Löschung müssen technisch überhaupt möglich sein, das ist ein Architekturthema
**Nachhaken bei:** nur Auskunft und Löschung genannt

### 05-05 · Personenbezogene und sensible Daten
**Themenpunkt:** 5.5 Fachbegriff „personenbezogene und sensible Daten" lt. DSGVO
**Frage:** Was sind personenbezogene, was sensible Daten?
**Muss:** Personenbezogen: alle Daten, über die eine Person direkt oder indirekt identifizierbar wird · sensibel: besondere Kategorien mit erhöhtem Schutzbedarf
**Sicher:** personenbezogen auch indirekt: IP-Adresse, Kundennummer, Standortdaten, Cookie-ID · sensibel: Gesundheitsdaten, politische Meinung, Religion, ethnische Herkunft, Gewerkschaftszugehörigkeit, Sexualleben, biometrische und genetische Daten · sensible Daten sind grundsätzlich verboten und nur mit ausdrücklicher Einwilligung oder gesetzlicher Ausnahme erlaubt
**Nachhaken bei:** nur Name und Adresse als Beispiel, indirekte Identifizierbarkeit fehlt

### 05-06 · Kopplungsverbot
**Themenpunkt:** 5.6 Bedeutung von Kopplungsverbot beim DSGVO
**Frage:** Was besagt das Kopplungsverbot?
**Muss:** Eine Leistung darf nicht davon abhängig gemacht werden, dass man einer Datenverarbeitung zustimmt, die für die Leistung gar nicht nötig ist
**Sicher:** Hintergrund: eine so erzwungene Einwilligung ist nicht freiwillig und damit unwirksam · Beispiel: ein Online-Shop darf die Bestellung nicht davon abhängig machen, dass man Werbe-E-Mails zustimmt · davon zu trennen sind Daten, die für die Leistung notwendig sind — die Lieferadresse darf verlangt werden
**Nachhaken bei:** Verbot genannt, ohne den Freiwilligkeitsgedanken dahinter

### 05-07 · Datenschutzbeauftragter
**Themenpunkt:** 5.7 Datenschutzbeauftragter lt. DSGVO und dessen Funktion
**Frage:** Wann braucht ein Unternehmen einen Datenschutzbeauftragten und was macht der?
**Muss:** Pflicht bei Behörden, bei umfangreicher regelmäßiger Überwachung und bei umfangreicher Verarbeitung sensibler Daten · Aufgabe: Beratung und Überwachung der DSGVO-Einhaltung
**Sicher:** ist zusätzlich Anlaufstelle für Betroffene und Schnittstelle zur Datenschutzbehörde · arbeitet weisungsfrei und unabhängig, darf wegen der Tätigkeit nicht benachteiligt werden · kann intern besetzt oder extern beauftragt werden · Interessenkonflikt: Geschäftsführer oder IT-Leiter können es nicht sein
**Nachhaken bei:** Aufgaben genannt, aber Unabhängigkeit fehlt

### 05-08 · Pflichten bei einer Datenpanne
**Themenpunkt:** 5.8 Pflichten für Unternehmen bei bekannt gewordenen Datendiebstahl lt. DSGVO
**Frage:** In Ihrem Unternehmen wurden Kundendaten gestohlen. Was muss das Unternehmen jetzt tun?
**Muss:** Meldung an die Datenschutzbehörde innerhalb von 72 Stunden ab Kenntnis
**Sicher:** bei hohem Risiko für die Betroffenen: diese unverzüglich zusätzlich benachrichtigen · interne Dokumentationspflicht für **jede** Datenpanne, auch für nicht meldepflichtige · Meldung enthält Art des Vorfalls, betroffene Datenkategorien, wahrscheinliche Folgen und ergriffene Gegenmaßnahmen · die 72 Stunden laufen ab Kenntnis, nicht ab dem Vorfall
**Nachhaken bei:** „melden" ohne Frist oder ohne Benachrichtigung der Betroffenen

### 05-09 · Urheberrecht
**Themenpunkt:** 5.9 Kenntnisse über Grundbegriffe und Gültigkeitsbereich des Urheberrechtes
**Frage:** Was schützt das Urheberrecht und ab wann gilt es?
**Muss:** Schützt geistige Schöpfungen — Software, Texte, Bilder, Musik · entsteht automatisch mit der Schöpfung, es braucht keine Anmeldung
**Sicher:** Schutzdauer: Lebenszeit des Urhebers plus 70 Jahre · bei Software sind Quellcode und Objektcode geschützt · das Urheberrecht selbst ist nicht übertragbar, übertragen werden Nutzungsrechte über Lizenzen · praktische Folge: fremder Code aus dem Netz ist nicht automatisch frei verwendbar — die Lizenz entscheidet (MIT, GPL, proprietär)
**Nachhaken bei:** Schutz bejaht, aber nicht erwähnt, dass er automatisch entsteht

### 05-10 · Gewährleistung und Garantie
**Themenpunkt:** 5.10 Kenntnis gesetzlicher Gewährleistungs- und Garantiebestimmungen und deren unterschiedlicher Anwendung bei Hardware- und Softwareproblemen
**Frage:** Was ist der Unterschied zwischen Gewährleistung und Garantie?
**Muss:** Gewährleistung ist gesetzlich verpflichtend und richtet sich gegen den Verkäufer · Garantie ist eine freiwillige Zusage, meist des Herstellers
**Sicher:** Gewährleistung: zwei Jahre für Verbraucher, betrifft Mängel, die bereits bei Übergabe vorhanden waren · Garantie: Umfang und Dauer bestimmt der Garantiegeber selbst · bei Software: Gewährleistung deckt Mängelfreiheit bei Übergabe, es gibt keinen Rechtsanspruch auf spätere Updates oder neue Funktionen · Individualsoftware wird oft über Werkvertrag mit Abnahme geregelt
**Nachhaken bei:** Unterschied genannt, aber die Besonderheit bei Software fehlt

### 05-11 · Entsorgung
**Themenpunkt:** 5.11 Kenntnisse über umweltgerechte Entsorgung von Elektronikschrott, Toner, Akkus oder Batterien
**Frage:** Wie entsorgen Sie Altgeräte, Toner und Akkus fachgerecht?
**Muss:** Nicht in den Hausmüll · Elektroaltgeräte über Sammelstellen oder Händlerrücknahme
**Sicher:** Grundlage ist das Elektroaltgeräte- bzw. Abfallwirtschaftsgesetz, Händler müssen Altgeräte zurücknehmen · Toner und Druckerpatronen über Rücknahmesysteme der Hersteller · Akkus und Batterien in Sammelboxen im Handel, sie enthalten Schwermetalle und Lithium-Akkus sind brandgefährlich · IT-spezifisch wichtig: Datenträger vor der Entsorgung sicher löschen oder physisch zerstören
**Nachhaken bei:** Entsorgungswege genannt, Datenlöschung vergessen — das ist der IT-Teil der Frage

### 05-12 · E-Commerce-Gesetz
**Themenpunkt:** 5.12 Kenntnisse über das E-Commerce-Gesetz (ECG)
**Frage:** Was regelt das E-Commerce-Gesetz?
**Muss:** Rechtsrahmen für Online-Dienste und elektronischen Geschäftsverkehr in Österreich · Anbieter müssen klar identifizierbar sein (Informations- bzw. Impressumspflicht)
**Sicher:** regelt außerdem die Haftung von Providern: Access-Provider, Caching und Host-Provider haften abgestuft und grundsätzlich nicht für fremde Inhalte, solange sie keine Kenntnis haben · Vorgaben zum Bestellvorgang: klare Information vor Vertragsabschluss, Korrekturmöglichkeit, Bestellbestätigung · greift bei jedem Webshop und jeder kommerziellen Website
**Nachhaken bei:** nur Impressum genannt, Providerhaftung fehlt

### 05-13 · Telekommunikationsgesetz
**Themenpunkt:** 5.13 Kenntnisse über das Telekom-Gesetz (TKG)
**Frage:** Was regelt das Telekommunikationsgesetz und was hat das mit Webentwicklung zu tun?
**Muss:** Regelt Telekommunikationsdienste und den Datenschutz in der Kommunikation · ist die gesetzliche Grundlage für die Cookie-Einwilligung
**Sicher:** deshalb die Cookie-Banner: nicht technisch notwendige Cookies brauchen eine aktive Einwilligung vor dem Setzen · technisch notwendige Cookies (z. B. Session, Warenkorb) sind einwilligungsfrei · regelt daneben unerbetene Nachrichten — Werbe-E-Mails und Anrufe brauchen vorherige Zustimmung
**Nachhaken bei:** Cookie-Banner genannt, ohne zwischen notwendigen und nicht notwendigen Cookies zu trennen

### 05-14 · Impressumspflicht
**Themenpunkt:** 5.14 Kenntnisse über Pflichtangaben eines Homepage-Betreibers (Impressum)
**Frage:** Was muss im Impressum einer Unternehmens-Website stehen?
**Muss:** Name bzw. Firmenwortlaut, Anschrift, Kontaktmöglichkeit (E-Mail), Firmenbuchnummer und UID, zuständige Aufsichts- bzw. Gewerbebehörde
**Sicher:** zusätzlich Rechtsform und Sitz, Kammerzugehörigkeit, anwendbare gewerberechtliche Vorschriften · muss leicht und unmittelbar auffindbar sein — von jeder Seite aus mit einem Klick erreichbar · Grundlage sind ECG, Mediengesetz und UGB
**Nachhaken bei:** nur Name und Adresse genannt

### 05-15 · Pflichtangaben in E-Mails
**Themenpunkt:** 5.15 Kenntnisse über Pflichtangaben beim E-Mail-Verkehr von Unternehmen
**Frage:** Welche Angaben muss eine geschäftliche E-Mail enthalten?
**Muss:** Firmenwortlaut, Rechtsform, Sitz, Firmenbuchnummer und Firmenbuchgericht
**Sicher:** dazu UID-Nummer, bei Bedarf Geschäftsführer bzw. Vertretungsbefugte · gilt genauso wie für Geschäftsbriefe, weil E-Mail rechtlich dasselbe ist — Grundlage UGB · praktisch über eine zentral verwaltete Signatur gelöst, nicht pro Mitarbeiter händisch
**Nachhaken bei:** „Signatur mit Kontaktdaten" ohne die firmenrechtlichen Pflichtangaben

### 05-16 · Bildschirmpausen
**Themenpunkt:** 5.16 Kenntnisse über die gesetzliche Einhaltung von Bildschirmpausen
**Frage:** Was schreibt der Gesetzgeber zu Pausen bei Bildschirmarbeit vor?
**Muss:** Nach spätestens zwei Stunden ununterbrochener Bildschirmarbeit mindestens 10 Minuten Pause oder ein Tätigkeitswechsel
**Sicher:** Grundlage: Bildschirmarbeitsverordnung bzw. ArbeitnehmerInnenschutzgesetz · der Tätigkeitswechsel ist gleichwertig zur Pause — eine andere Arbeit zählt · gilt ab einer bestimmten regelmäßigen Dauer der Bildschirmarbeit · daneben: Anspruch auf Augenuntersuchung und gegebenenfalls Bildschirmbrille auf Kosten des Arbeitgebers
**Nachhaken bei:** Regel genannt, aber Tätigkeitswechsel als Alternative fehlt
