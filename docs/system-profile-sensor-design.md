# System Profile Sensor Design

## Zweck

Der Systemprofil-Sensor ist der zweite MVP-Sensor.

Er soll dem Nutzer in ruhiger Sprache zeigen, welche lokalen Basisinformationen die App ohne Sonderrechte sehen kann. Er ist kein vollständiger Sicherheitsstatus und keine Bewertung, ob der Mac insgesamt sicher ist.

## Datenquellen

Der Sensor soll einen kleinen Snapshot bilden:

- macOS-Version über `ProcessInfo.processInfo.operatingSystemVersionString`
- Architektur über `uname`
- Computername über `Host.current().localizedName`
- Gatekeeper-Status optional über `/usr/sbin/spctl --status`
- SIP-Status optional über `/usr/bin/csrutil status`

Alle externen Kommandos müssen direkt mit festem Pfad ausgeführt werden, nicht über eine Shell.

## Rechtebedarf

Der Sensor fordert keine neuen macOS-Rechte an.

Nicht erlaubt für diesen Sensor:

- Full Disk Access
- Accessibility
- Screen Recording
- Apple Events
- Network Client
- Adminrechte
- privilegierte Helper

## Finding-Logik

Der Sensor liefert zunächst ein oder wenige ruhige System-Hinweise mit `source.kind = systemInventory`.

Empfohlene Einordnung:

- normales Systemprofil: `severity = low`, `confidence = supported`
- Gatekeeper sichtbar aktiv: `severity = low`, `confidence = supported`
- Gatekeeper sichtbar deaktiviert: `severity = high`, `confidence = supported`
- optionale Quelle nicht lesbar: keine Panikmeldung, sondern Sensor-Note oder `confidence = tentative`

Wichtig:
Der Sensor darf nicht behaupten, dass ein sichtbarer Schutzstatus den Mac vollständig sicher macht.

## Nutzertexte

Beispiel für normalen Zustand:

- Titel: `Mac-Grundschutz ist sichtbar`
- Kurztext: `Die App konnte lokale Basisdaten und sichtbare Schutzsignale dieses Macs lesen.`
- Warum wichtig: `Diese Angaben helfen, spätere Hinweise richtig einzuordnen. Sie beweisen nicht, dass der Mac vollständig geschützt ist.`
- Nächster Schritt: `Keine schnelle Aktion nötig. Behalte die Hinweise im Blick und prüfe Abweichungen in Ruhe.`

Beispiel für deaktivierten Gatekeeper:

- Titel: `Mac-App-Prüfung ist deaktiviert`
- Kurztext: `macOS meldet, dass die App-Prüfung für heruntergeladene Apps nicht aktiv ist.`
- Warum wichtig: `Diese Prüfung kann helfen, bekannte unsichere oder nicht vertrauenswürdige Apps vor dem Öffnen zu blockieren.`
- Nächster Schritt: `Prüfe in den macOS-Systemeinstellungen, ob diese Einstellung bewusst so gewählt wurde.`

## Evidence

Evidence soll knapp und nachvollziehbar bleiben:

- macOS-Version
- Architektur
- optionaler Computername oder Hostname
- Rohmeldung von `spctl --status`, wenn verfügbar
- Rohmeldung von `csrutil status`, wenn verfügbar
- Liste nicht verfügbarer optionaler Checks

## Fehlerverhalten

Fehler dürfen den Sensorlauf nicht abbrechen.

Wenn eine optionale Quelle nicht lesbar ist:

- Sensorlauf bleibt erfolgreich
- andere Daten bleiben sichtbar
- eine ruhige Note erklärt die eingeschränkte Sicht

Wenn Pflichtdaten fehlen:

- Sensor liefert einen eingeschränkten Hinweis statt zu crashen
- Tests müssen diesen Fall abdecken

## Tests

Unit-Tests sollen Fake-Snapshots nutzen, damit echte Mac-Zustände die Tests nicht instabil machen.

Abdeckung:

- vollständiger Snapshot erzeugt ruhigen System-Hinweis
- deaktivierter Gatekeeper erzeugt klaren, aber nicht alarmistischen Hinweis
- fehlende optionale Checks erzeugen Notes statt Crash
- Pipeline enthält Startup-Sensor und Systemprofil-Sensor
- `./scripts/checks.sh` bleibt grün

## Nicht-Ziele

- keine Baseline für Systemprofil in Sprint 4
- keine automatische Systemänderung
- keine Privacy-/TCC-Datenbank-Abfrage
- keine moderne Background-Item-Analyse
- keine Aussage "Mac ist sicher"
