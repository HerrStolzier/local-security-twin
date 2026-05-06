# Background Task Management Spike

## Zweck

Diese Notiz haelt fest, wie moderne macOS-Login- und Background-Items spaeter geprueft werden sollen.

## Kurzfazit

Der bestehende LaunchAgent-Sensor bleibt ein guter erster Schritt, aber er sieht nur sichtbare `.plist`-Dateien.
Fuer macOS 13 und neuer sollte ein eigener Spike pruefen, ob Background Task Management eine stabile Quelle fuer die App sein kann.

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

## Naechster Spike

Ein spaeterer Agent soll auf mindestens einem aktuellen macOS-Testsystem pruefen:

- ob `sfltool dumpbtm` ohne Zusatzrechte laeuft
- welche Daten es liefert
- ob persoenliche Daten oder volatile IDs enthalten sind
- ob die Ausgabe maschinenlesbar genug ist
- wie sich Eintraege zu sichtbaren `.plist`-Dateien verhalten
