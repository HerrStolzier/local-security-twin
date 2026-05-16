# Background Task Management Spike

## Zweck

Diese Notiz hält fest, wie moderne macOS-Login- und Background-Items später geprüft werden sollen.

## Kurzfazit

Der bestehende LaunchAgent-Sensor bleibt ein guter erster Schritt, aber er sieht nur sichtbare `.plist`-Dateien.
Für macOS 13 und neuer sollte ein eigener Spike prüfen, ob Background Task Management eine stabile Quelle für die App sein kann.

Update 2026-05-12:
Der Spike wurde auf einem lokalen macOS-System begonnen.

- System: macOS 26.5, Build 25F71
- `sfltool` ist vorhanden unter `/usr/bin/sfltool`
- `sfltool dumpbtm` lieferte im einfachen Testlauf nicht schnell eine kurze, stabile Ausgabe und musste beendet werden
- Ergebnis: `sfltool dumpbtm` ist für den MVP noch keine direkte Produktquelle

## Zu prüfende Quellen

- `SMAppService` für eigene oder registrierte Helper-Statusinformationen
- `sfltool dumpbtm` als Diagnosequelle für Login- und Background-Items
- System Settings > General > Login Items als manuelle Referenzsicht
- BackgroundTaskManagement-Logs nur für Entwicklung und Diagnose, nicht als MVP-Produktquelle

## Entscheidung für jetzt

Noch keinen produktiven Sensor auf `sfltool dumpbtm` bauen.

Gründe:

- Ausgabeformat und Stabilität müssen erst getestet werden.
- Die App soll nicht früh von einem Diagnosekommando abhängen.
- Der MVP soll ruhig erklären, was sichtbar ist, statt Vollständigkeit zu behaupten.
- Ein einfacher lokaler Aufruf war nicht robust genug für eine direkte UI-Integration.

## Quellenlage

Apple beschreibt `SMAppService` als API zum Registrieren und Steuern eigener Login Items, LaunchAgents und LaunchDaemons innerhalb einer App.
Das ist wertvoll für eigene Helper, aber keine offensichtliche vollständige Leseschnittstelle für alle fremden Background Items.

Apple Platform Deployment beschreibt Background Task Management und nennt unter anderem System Settings, `sfltool dumpbtm` und BackgroundTaskManagement-Logs als Diagnose- und Verwaltungsumfeld.
Das bestätigt die Relevanz, aber nicht automatisch die Eignung als stabile App-Datenquelle.

## Nächster Spike

Ein späterer Agent soll auf mindestens einem aktuellen macOS-Testsystem prüfen:

- ob `sfltool dumpbtm` ohne Zusatzrechte läuft
- welche Daten es liefert
- ob persönliche Daten oder volatile IDs enthalten sind
- ob die Ausgabe maschinenlesbar genug ist
- wie sich Einträge zu sichtbaren `.plist`-Dateien verhalten
- ob ein zeitbegrenzter, nicht hängender Aufruf reproduzierbar möglich ist

## Empfehlung

Für die nächsten Produktiterationen nicht auf Background Task Management springen.

Stattdessen:

1. vorhandene Startup-Hinweise weiter verständlich machen
2. Packaging-/Signing-Fragen klären
3. Background Task Management später erneut mit einem dedizierten Diagnose-Harness prüfen
