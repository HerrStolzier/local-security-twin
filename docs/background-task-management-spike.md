# Background Task Management Spike

## Zweck

Diese Notiz haelt fest, wie moderne macOS-Login- und Background-Items spaeter geprueft werden sollen.

## Kurzfazit

Der bestehende LaunchAgent-Sensor bleibt ein guter erster Schritt, aber er sieht nur sichtbare `.plist`-Dateien.
Fuer macOS 13 und neuer sollte ein eigener Spike pruefen, ob Background Task Management eine stabile Quelle fuer die App sein kann.

Update 2026-05-12:
Der Spike wurde auf einem lokalen macOS-System begonnen.

- System: macOS 26.5, Build 25F71
- `sfltool` ist vorhanden unter `/usr/bin/sfltool`
- `sfltool dumpbtm` lieferte im einfachen Testlauf nicht schnell eine kurze, stabile Ausgabe und musste beendet werden
- Ergebnis: `sfltool dumpbtm` ist fuer den MVP noch keine direkte Produktquelle

## Zu pruefende Quellen

- `SMAppService` fuer eigene oder registrierte Helper-Statusinformationen
- `sfltool dumpbtm` als Diagnosequelle fuer Login- und Background-Items
- System Settings > General > Login Items als manuelle Referenzsicht
- BackgroundTaskManagement-Logs nur fuer Entwicklung und Diagnose, nicht als MVP-Produktquelle

## Entscheidung fuer jetzt

Noch keinen produktiven Sensor auf `sfltool dumpbtm` bauen.

Gruende:

- Ausgabeformat und Stabilitaet muessen erst getestet werden.
- Die App soll nicht frueh von einem Diagnosekommando abhaengen.
- Der MVP soll ruhig erklaeren, was sichtbar ist, statt Vollstaendigkeit zu behaupten.
- Ein einfacher lokaler Aufruf war nicht robust genug fuer eine direkte UI-Integration.

## Quellenlage

Apple beschreibt `SMAppService` als API zum Registrieren und Steuern eigener Login Items, LaunchAgents und LaunchDaemons innerhalb einer App.
Das ist wertvoll fuer eigene Helper, aber keine offensichtliche vollstaendige Leseschnittstelle fuer alle fremden Background Items.

Apple Platform Deployment beschreibt Background Task Management und nennt unter anderem System Settings, `sfltool dumpbtm` und BackgroundTaskManagement-Logs als Diagnose- und Verwaltungsumfeld.
Das bestaetigt die Relevanz, aber nicht automatisch die Eignung als stabile App-Datenquelle.

## Naechster Spike

Ein spaeterer Agent soll auf mindestens einem aktuellen macOS-Testsystem pruefen:

- ob `sfltool dumpbtm` ohne Zusatzrechte laeuft
- welche Daten es liefert
- ob persoenliche Daten oder volatile IDs enthalten sind
- ob die Ausgabe maschinenlesbar genug ist
- wie sich Eintraege zu sichtbaren `.plist`-Dateien verhalten
- ob ein zeitbegrenzter, nicht haengender Aufruf reproduzierbar moeglich ist

## Empfehlung

Fuer die naechsten Produktiterationen nicht auf Background Task Management springen.

Stattdessen:

1. vorhandene Startup-Hinweise weiter verstaendlich machen
2. Packaging-/Signing-Fragen klaeren
3. Background Task Management spaeter erneut mit einem dedizierten Diagnose-Harness pruefen
