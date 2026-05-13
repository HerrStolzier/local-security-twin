# System Profile Sensor Design

## Zweck

Der Systemprofil-Sensor ist der zweite MVP-Sensor.

Er soll dem Nutzer in ruhiger Sprache zeigen, welche lokalen Basisinformationen die App ohne Sonderrechte sehen kann. Er ist kein vollstaendiger Sicherheitsstatus und keine Bewertung, ob der Mac insgesamt sicher ist.

## Datenquellen

Der Sensor soll einen kleinen Snapshot bilden:

- macOS-Version ueber `ProcessInfo.processInfo.operatingSystemVersionString`
- Architektur ueber `uname`
- Computername ueber `Host.current().localizedName`
- Gatekeeper-Status optional ueber `/usr/sbin/spctl --status`
- SIP-Status optional ueber `/usr/bin/csrutil status`

Alle externen Kommandos muessen direkt mit festem Pfad ausgefuehrt werden, nicht ueber eine Shell.

## Rechtebedarf

Der Sensor fordert keine neuen macOS-Rechte an.

Nicht erlaubt fuer diesen Sensor:

- Full Disk Access
- Accessibility
- Screen Recording
- Apple Events
- Network Client
- Adminrechte
- privilegierte Helper

## Finding-Logik

Der Sensor liefert zunaechst ein oder wenige ruhige System-Hinweise mit `source.kind = systemInventory`.

Empfohlene Einordnung:

- normales Systemprofil: `severity = low`, `confidence = supported`
- Gatekeeper sichtbar aktiv: `severity = low`, `confidence = supported`
- Gatekeeper sichtbar deaktiviert: `severity = high`, `confidence = supported`
- optionale Quelle nicht lesbar: keine Panikmeldung, sondern Sensor-Note oder `confidence = tentative`

Wichtig:
Der Sensor darf nicht behaupten, dass ein sichtbarer Schutzstatus den Mac vollstaendig sicher macht.

## Nutzertexte

Beispiel fuer normalen Zustand:

- Titel: `Mac-Grundschutz ist sichtbar`
- Kurztext: `Die App konnte lokale Basisdaten und sichtbare Schutzsignale dieses Macs lesen.`
- Warum wichtig: `Diese Angaben helfen, spaetere Hinweise richtig einzuordnen. Sie beweisen nicht, dass der Mac vollstaendig geschuetzt ist.`
- Naechster Schritt: `Keine schnelle Aktion noetig. Behalte die Hinweise im Blick und pruefe Abweichungen in Ruhe.`

Beispiel fuer deaktivierten Gatekeeper:

- Titel: `Mac-App-Pruefung ist deaktiviert`
- Kurztext: `macOS meldet, dass die App-Pruefung fuer heruntergeladene Apps nicht aktiv ist.`
- Warum wichtig: `Diese Pruefung kann helfen, bekannte unsichere oder nicht vertrauenswuerdige Apps vor dem Oeffnen zu blockieren.`
- Naechster Schritt: `Pruefe in den macOS-Systemeinstellungen, ob diese Einstellung bewusst so gewaehlt wurde.`

## Evidence

Evidence soll knapp und nachvollziehbar bleiben:

- macOS-Version
- Architektur
- optionaler Computername oder Hostname
- Rohmeldung von `spctl --status`, wenn verfuegbar
- Rohmeldung von `csrutil status`, wenn verfuegbar
- Liste nicht verfuegbarer optionaler Checks

## Fehlerverhalten

Fehler duerfen den Sensorlauf nicht abbrechen.

Wenn eine optionale Quelle nicht lesbar ist:

- Sensorlauf bleibt erfolgreich
- andere Daten bleiben sichtbar
- eine ruhige Note erklaert die eingeschraenkte Sicht

Wenn Pflichtdaten fehlen:

- Sensor liefert einen eingeschraenkten Hinweis statt zu crashen
- Tests muessen diesen Fall abdecken

## Tests

Unit-Tests sollen Fake-Snapshots nutzen, damit echte Mac-Zustaende die Tests nicht instabil machen.

Abdeckung:

- vollstaendiger Snapshot erzeugt ruhigen System-Hinweis
- deaktivierter Gatekeeper erzeugt klaren, aber nicht alarmistischen Hinweis
- fehlende optionale Checks erzeugen Notes statt Crash
- Pipeline enthaelt Startup-Sensor und Systemprofil-Sensor
- `./scripts/checks.sh` bleibt gruen

## Nicht-Ziele

- keine Baseline fuer Systemprofil in Sprint 4
- keine automatische Systemaenderung
- keine Privacy-/TCC-Datenbank-Abfrage
- keine moderne Background-Item-Analyse
- keine Aussage "Mac ist sicher"
