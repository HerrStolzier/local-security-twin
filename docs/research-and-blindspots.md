# Research and Blindspots

## Zweck

Diese Datei haelt eine kritische Rechercherunde vom 2026-05-06 fest.

Die Frage war:

Haben wir beim aktuellen MVP-Plan fuer `local-security-twin` wichtige Annahmen uebersehen, vor allem bei macOS-Startup-Sichtbarkeit, Berechtigungen, Baselines und Nutzervertrauen?

## Kurzfazit

Die Grundrichtung ist weiterhin richtig:

- local-first
- sichtbare, risikoarme Belege zuerst
- erklaeren vor handeln
- keine stillen Systemaenderungen
- minimale macOS-Rechte im MVP

Aber es gibt wichtige Blindspots:

1. Der aktuelle Startup-Sensor sieht nur einen Teil der modernen macOS-Startup-Realitaet.
2. Baseline-Fehler werden im Sensor noch zu still behandelt.
3. Die App darf sichtbare `.plist`-Dateien nicht als Beweis fuer "laeuft wirklich" oder "ist boese" darstellen.
4. Der Begriff `Baseline` ist fuer normale Nutzer wahrscheinlich zu technisch.
5. Packaging, Sandbox und Notarization muessen frueher mitgedacht werden, bevor echte Distribution startet.

## Gepruefte Annahmen

### Annahme: LaunchAgents und LaunchDaemons sind ein sinnvoller erster Sensor

Status: bestaetigt, aber begrenzt.

Apple dokumentiert, dass `launchd` systemweite Daemons aus `/System/Library/LaunchDaemons/` und `/Library/LaunchDaemons/` laedt. Fuer per-user Agents nennt Apple `/System/Library/LaunchAgents`, `/Library/LaunchAgents` und das `Library/LaunchAgents`-Verzeichnis des Nutzers.

Unsere aktuelle Auswahl ist deshalb ein guter erster Schnitt:

- `~/Library/LaunchAgents`
- `/Library/LaunchAgents`
- `/Library/LaunchDaemons`

Was fehlt bewusst:

- Apples eigene Systempfade unter `/System/Library/...`
- moderne Login Items
- Background Task Management Status
- tatsaechlich geladener oder laufender Zustand via `launchctl` oder andere Systemquellen
- Inhalt der `.plist`-Dateien wie `Label`, `Program`, `ProgramArguments`, `KeepAlive`, `RunAtLoad`

Bewertung:
Der Sensor sollte im Produkt weiter als "sichtbare Startup-Hinweise" beschrieben werden, nicht als vollstaendige Startup-Analyse.

Quelle:
Apple Developer, "Creating Launch Daemons and Agents":
https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html

### Annahme: Moderne macOS-Versionen machen Login-/Background-Items relevanter

Status: bestaetigt.

Apple beschreibt fuer macOS 13 und neuer ein neueres Background Task Management rund um Login Items, LaunchAgents und LaunchDaemons. Apple nennt unter anderem `SMAppService`, System Settings > General > Login Items, `sfltool dumpbtm` und BackgroundTaskManagement-Logs als Wege, diese moderne Sicht zu untersuchen.

Was das fuer uns bedeutet:
Der erste Dateisystem-Sensor ist richtig, aber nicht genug fuer die spaetere MVP-Erklaerung "was startet automatisch". Eine spaetere Recherche-/Sensorstufe sollte Background Task Management gezielt einplanen.

Wichtig:
`sfltool dumpbtm` ist fuer Diagnose und Tests interessant, aber vor Produktintegration muss geprueft werden, ob Ausgabeformat, Stabilitaet und App-Store-/Distribution-Kontext tragfaehig sind.

Quelle:
Apple Support, "Manage login items and background tasks on Mac", published 2025-12-17:
https://support.apple.com/en-ie/guide/deployment/depdca572563/web

Quelle:
Apple Developer, "Service Management":
https://developer.apple.com/documentation/ServiceManagement

### Annahme: Der MVP braucht noch keinen Full Disk Access

Status: aktuell weiterhin plausibel.

Apple beschreibt Full Disk Access als explizite Nutzerentscheidung fuer Apps, die Zugriff auf die gesamte Speichergeraete-Sicht brauchen. Unser aktueller MVP liest sichtbare Startup-Pfade und speichert lokale Entscheidungen in Application Support. Dafuer waere Full Disk Access ein zu grosser Vertrauenspreis.

Was das praktisch bedeutet:
Die App sollte lieber offen sagen "eingeschraenkte lokale Sicht" als frueh Full Disk Access zu verlangen.

Quelle:
Apple Platform Security, "Controlling app access to files in macOS":
https://support.apple.com/en-mide/guide/security/secddd1d86a6/web

### Annahme: Sandbox und Notarization koennen spaeter geklaert werden

Status: teilweise riskant.

Fuer lokale Entwicklung ist das okay. Fuer Distribution sollte es aber nicht zu spaet passieren.

Apple beschreibt, dass App Sandbox Zugriff auf geschuetzte Ressourcen einschraenkt und dass Apps fuer notarized Distribution Hardened Runtime brauchen. Das kann die Dateisystem-Sicht und spaetere Sensoren beeinflussen.

Was das fuer uns bedeutet:
Vor echten UI-Sensoren mit Dateisystemzugriff sollte ein kleiner Packaging-/Signing-Spike kommen:

- SwiftPM-App weiter ausreichend oder Xcode-Projekt noetig?
- Sandbox ja/nein fuer erste Distribution?
- Welche Pfade bleiben ohne Sandbox erreichbar?
- Hardened Runtime ohne Ausnahmen?
- Keine Network-/Automation-/Apple-Events-Entitlements ohne echten Nutzen.

Quellen:
Apple Developer, "Accessing files from the macOS App Sandbox":
https://developer.apple.com/documentation/security/accessing-files-from-the-macos-app-sandbox

Apple Developer, "Hardened Runtime":
https://developer.apple.com/documentation/security/hardened-runtime

## Lokale Code-Blindspots

### Baseline-Fehler sind zu still

Ort:
`Sources/LocalSecurityTwin/Sensors/LaunchAgents/LaunchAgentInventorySensor.swift`

Der Sensor faellt bei Baseline-Load-/Save-Fehlern auf Inventar-Findings zurueck. Das ist robust, aber zu leise.

Risiko:
Die App koennte Change-Detection verlieren, ohne dass der Nutzer oder Entwickler es klar sieht.

Empfehlung:
Vor oder zusammen mit dem Trusted-Baseline-Refresh sollte ein sichtbarer interner Sensorhinweis entstehen:

- "Lokale Baseline konnte nicht geladen werden"
- keine dramatische Warnung
- aber klar genug, dass Change-Detection in diesem Lauf eingeschraenkt ist

### Baseline gehoert nicht hart genug zum Sensor

Ort:
`Sources/LocalSecurityTwin/Core/Baseline/StartupItemBaselineStore.swift`

Beim Laden wird die gespeicherte `sensorID` nicht gegen die aktuelle Sensor-ID validiert.

Risiko:
Wenn spaeter mehrere Baseline-Quellen entstehen, koennte eine falsche Baseline versehentlich akzeptiert werden.

Empfehlung:
Baseline-Store sollte beim Initialisieren oder Laden pruefen koennen, ob die gespeicherte Baseline zum erwarteten Sensor gehoert.

### `.plist` sichtbar heisst nicht "aktiv" und nicht "gefaehrlich"

Ort:
`Sources/LocalSecurityTwin/Sensors/LaunchAgents/LaunchAgentInventorySensor.swift`

Der aktuelle Sensor liest Dateinamen und Pfade, aber nicht:

- plist-Inhalt
- Signatur des Zielprogramms
- tatsaechlich geladenen Zustand
- letzten Lauf
- ob der Eintrag deaktiviert oder durch Background Task Management blockiert ist

Empfehlung:
UI- und Finding-Texte muessen konsequent "sichtbar" und "Hinweis" sagen.

## UX-Blindspots

### `Baseline` ist intern gut, extern zu technisch

Fuer Nutzer besser:

- "bekannter Ausgangszustand"
- "gemerkter Normalzustand"
- "als erwartet merken"

Nicht ideal fuer primaere UI:

- "Baseline refresh"
- "Snapshot"
- "Diff"

### Verschwundene Items brauchen ruhige Sprache

Ein verschwundenes Startup-Item ist meist weniger alarmierend als ein neues.

Empfehlung:
Verschwundene Items sollten eher als "Startup-Verhalten hat sich geaendert" erscheinen, nicht als klassische Warnung.

### Safe Validation darf nicht nach Angriff klingen

`Run Safe Validation` ist als internes Policy-Action-Konzept okay, aber fuer Nutzer wahrscheinlich zu abstrakt.

Moegliche UI-Sprache:

- "Vorsichtig pruefen"
- "Mehr Belege sammeln"
- "Sichere Zusatzpruefung starten"

## Roadmap-Anpassung

Die naechste Reihenfolge sollte jetzt so aussehen:

1. Baseline-Fehler sichtbar machen und Sensor-ID-Validierung einbauen.
2. Trusted-Baseline-Refresh in der Domain-Logik bauen.
3. UI-Sprache fuer "als erwartet merken" entwerfen.
4. Danach Startup-`.plist`-Inhalte vorsichtig lesen.
5. Danach modernen Background-Task-Management-Sensor oder Research-Spike planen.
6. Vor Distribution einen Packaging-/Signing-/Sandbox-Spike einbauen.

## Bewusst nicht im aktuellen MVP

- keine automatische Entfernung von Startup-Items
- kein Admin-Helper
- kein Full Disk Access als Standard
- keine aggressiven Live-Validierungen
- keine Behauptung, dass alle Persistenzmechanismen abgedeckt sind
- keine stille Baseline-Erneuerung

## Konkreter naechster Schnitt

Vor dem Trusted-Baseline-Refresh sollte ein kleiner technischer Sauberkeitsschnitt kommen:

- `StartupItemBaselineStore` validiert die erwartete `sensorID`
- Baseline-Fehler werden als klare Sensor-Note oder Finding-Evidence sichtbar
- Tests decken korrupten/falschen Baseline-Zustand ab

Danach ist der Trusted-Baseline-Refresh deutlich vertrauenswuerdiger.

## Umsetzungsstand nach der Runde

Dieser Sauberkeitsschnitt wurde inzwischen umgesetzt:

- `StartupItemBaselineStore` validiert die erwartete `sensorID`.
- Baseline-Fehler werden als Sensor-Note sichtbar.
- Der aktuelle Startup-Zustand kann explizit als erwartet gemerkt werden.
- Einfache `.plist`-Details werden als Evidence gelesen.

Weiter offen bleibt:

- echte macOS-UI-Automation fuer den `Remember as Expected`-Klickpfad
- moderne Login-/Background-Items
- Packaging, Signing, Sandbox und Notarization
