# Current Overview

## Kurzstand

`local-security-twin` ist aktuell ein lokaler macOS-MVP-Prototyp mit zwei read-only Sensorbereichen, deutscherer UI, lokalem Trust-Flow und reproduzierbaren Packaging-Smokes.

Die App kann:

- sichtbare Startup-`plist`-Dateien in Nutzer- und gemeinsamen Launch-Ordnern finden
- einfache Details aus diesen Dateien lesen
- einen lokalen bekannten Startup-Zustand speichern
- neue oder verschwundene Startup-Hinweise seit diesem Zustand melden
- den aktuellen Startup-Zustand bewusst als erwartet merken
- lokale Systemprofil-Daten und sichtbare Schutzsignale einordnen
- lokale Policy-Entscheidungen speichern und zuruecksetzen
- ein lokales `.app`-Bundle bauen und pruefen

## Wichtiges mentales Modell

Die App ist kein vollstaendiger macOS-Sicherheitscanner.

Sie ist ein ruhiger lokaler Beobachter:

1. Was ist sichtbar?
2. Was hat sich seit dem gemerkten Zustand geaendert?
3. Welche Schutzsignale sind lokal sichtbar?
4. Was bedeutet das in normaler Sprache?
5. Was darf der Nutzer bewusst merken oder spaeter pruefen?

## Hauptfluss

1. `LocalSecurityTwinApp` erstellt `FindingStore` und `PolicyStore`.
2. `FindingStore` ruft die `SensorPipeline` auf.
3. Die Live-Pipeline enthaelt `LaunchAgentInventorySensor` und `SystemProfileSensor`.
4. Die Sensoren bauen `Finding`-Objekte mit Evidence und Recommendations.
5. `ContentView` gruppiert die Hinweise.
6. `FindingDetailView` erklaert Kontext, Belege und sichere naechste Schritte.
7. Guided Actions erklaeren vor dem Speichern, was lokal passiert und was nicht.
8. `SettingsView` zeigt gemerkte Entscheidungen und erlaubt Reset.

## Bewusste Grenzen

Der Startup-Sensor sieht sichtbare `plist`-Dateien, aber nicht den vollstaendigen laufenden Zustand.

Der Systemprofil-Sensor sieht lokale Kontextdaten, aber kein Gesamturteil ueber die Sicherheit des Macs.

Nicht Teil des aktuellen MVP:

- Full Disk Access
- Accessibility
- Screen Recording
- Network Client
- Apple Events
- privilegierte Helper
- echte Developer-ID-Distribution
- echte macOS-Klickautomation

Details stehen in `docs/known-limits.md`.

## Aktueller naechster Schritt

Die sieben Sprints aus `docs/project-completion-plan.md` sind umgesetzt.

Der naechste gute Schnitt ist:

1. Beta-/MVP-Schnitt anhand `docs/mvp-release-checklist.md` pruefen.
2. Echte macOS-UI-Automation oder Xcode-Projekt bewusst entscheiden.
3. Danach erst weitere Sensoren planen.

## Wichtige Startwege

Direkt:

```bash
swift run LocalSecurityTwin
```

Als Bundle:

```bash
./scripts/build-app-bundle.sh
open .build/app/LocalSecurityTwin.app
```

Standardcheck:

```bash
./scripts/checks.sh
```
