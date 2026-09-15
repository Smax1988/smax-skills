# 1) Grundlagen in der Informationstechnik

### 01-01 · ASCII
**Themenpunkt:** 1.1 Kenntnis des Zeichensatzes ASCII
**Frage:** Was ist ASCII?
**Muss:** Zeichensatz, der jedem Zeichen eine Zahl zuordnet · 7 Bit, 128 Zeichen (0-127)
**Sicher:** enthält Groß- und Kleinbuchstaben, Ziffern, Sonderzeichen und Steuerzeichen (Tab, Zeilenumbruch) · nur englisches Alphabet, keine Umlaute · Grundlage der Nachfolger ISO-Latin und Unicode, die die ersten 128 Zeichen unverändert übernehmen
**Nachhaken bei:** „Zeichensatz" ohne Bitbreite oder Zeichenzahl

### 01-02 · Bit und Byte
**Themenpunkt:** 1.2 Kenntnis der Einheiten Bit, Byte
**Frage:** Was ist der Unterschied zwischen einem Bit und einem Byte?
**Muss:** Bit ist die kleinste Informationseinheit, Wert 0 oder 1 · ein Byte sind 8 Bit
**Sicher:** Byte ist die kleinste adressierbare Speichereinheit · 8 Bit ergeben 256 mögliche Werte (2⁸) · Nibble = 4 Bit · Schreibweise: Bit klein `b`, Byte groß `B` — deshalb sind 100 Mbit/s Leitung ≈ 12,5 MB/s
**Nachhaken bei:** nur „8 Bit sind ein Byte", ohne zu sagen, was ein Bit ist

### 01-03 · Dezimale Größeneinheiten
**Themenpunkt:** 1.3 Kenntnis der Begriffe Gigabyte, Terabyte, Petabyte, Exabyte
**Frage:** Nennen Sie mir die Größeneinheiten ab Kilobyte aufwärts und was sie jeweils bedeuten.
**Muss:** Reihenfolge KB, MB, GB, TB, PB, EB · jeweils Faktor 1000 · dezimal, also Zehnerpotenzen
**Sicher:** KB = 10³, MB = 10⁶, GB = 10⁹, TB = 10¹², PB = 10¹⁵, EB = 10¹⁸ · das ist die Angabe, die Hersteller auf Festplatten drucken
**Nachhaken bei:** Faktor 1024 statt 1000 — das ist die binäre Reihe, siehe 01-04

### 01-04 · Binäre Größeneinheiten
**Themenpunkt:** 1.4 Kenntnis der Begriffe Gibibyte, Tebibyte, Pebibyte, Exbibyte
**Frage:** Was ist der Unterschied zwischen einem Gigabyte und einem Gibibyte?
**Muss:** GB ist dezimal (10⁹ = 1.000.000.000 Byte), GiB ist binär (2³⁰ = 1.073.741.824 Byte) · GiB ist größer
**Sicher:** Reihe KiB, MiB, GiB, TiB, PiB, EiB mit Faktor 1024 · KiB = 2¹⁰, GiB = 2³⁰, TiB = 2⁴⁰ · praktische Folge: eine 1-TB-Festplatte zeigt im Betriebssystem nur rund 931 GiB, weil der Hersteller dezimal rechnet und Windows binär anzeigt
**Nachhaken bei:** Unterschied genannt, aber ohne die praktische Auswirkung

### 01-05 · Zahlensysteme
**Themenpunkt:** 1.5 Kenntnis der gebräuchlichen Zahlensysteme in der IT
**Frage:** Welche Zahlensysteme sind in der IT gebräuchlich und wofür braucht man sie?
**Muss:** Dezimal (Basis 10), Binär (Basis 2), Hexadezimal (Basis 16) · Binär, weil der Rechner intern nur zwei Zustände kennt
**Sicher:** Hexadezimal 0-9 und A-F, kompakte Schreibweise für Binärwerte — Farbcodes, Speicheradressen, MAC-Adressen · Oktal (Basis 8) bei Unix-Dateiberechtigungen (`chmod 755`) · eine Hex-Stelle entspricht genau 4 Bit
**Nachhaken bei:** Systeme aufgezählt, aber kein Einsatzgebiet genannt

### 01-06 · Umwandlung zwischen Zahlensystemen
**Themenpunkt:** 1.6 Umwandlung zwischen Binär-, Dezimal- und Hexadezimalzahlen
**Frage:** Rechnen Sie mir `1011` binär in Dezimal um und erklären Sie dabei, wie Sie vorgehen.
**Muss:** Stellenwerte 2⁰, 2¹, 2², 2³ von rechts nach links aufaddieren · 8 + 0 + 2 + 1 = **11**
**Sicher:** Gegenrichtung Dezimal → Binär: fortlaufend durch 2 teilen, Reste rückwärts lesen · Hex ↔ Binär: je Hex-Stelle 4 Bit, `A` = `1010`, `F` = `1111` · Hex → Dezimal über Stellenwerte 16⁰, 16¹, z. B. `1F` = 16 + 15 = 31
**Nachhaken bei:** richtiges Ergebnis ohne erklärten Rechenweg

### 01-07 · Logische Verknüpfungen
**Themenpunkt:** 1.7 Kenntnis der Logik-Schaltungen (AND, OR, XOR, NOT) und deren Wahrheitstabellen
**Frage:** Erklären Sie mir AND, OR, XOR und NOT.
**Muss:** AND: Ergebnis 1, wenn beide Eingänge 1 sind · OR: 1, wenn mindestens einer 1 ist · XOR: 1, wenn genau einer 1 ist · NOT: kehrt den Wert um
**Sicher:** Wahrheitstabelle fehlerfrei durchgesprochen (0/0, 0/1, 1/0, 1/1) · XOR heißt „exklusives Oder", bei 1/1 kommt 0 heraus · Einsatz: Bitmasken, Prüfsummen und Verschlüsselung nutzen XOR, weil zweimal dieselbe Verknüpfung den Ausgangswert zurückgibt
**Nachhaken bei:** XOR als „entweder oder" beschrieben, ohne den Fall 1/1 zu klären
