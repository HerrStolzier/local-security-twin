# Current Overview

## Kurzstand

`local-security-twin` ist aktuell ein lokaler macOS-Prototyp mit zwei read-only Sensorbereichen, deutscherer UI, lokalem Trust-Flow und reproduzierbaren Packaging-Smokes.

Das neue Produktziel ist groesser als der bisherige MVP-Schnitt:
Die App soll ein kraftvoller Security Buddy werden, der mit dem Nutzer zusammenarbeitet, aktuelle Bedrohungen einordnet und bei echten Risiken handlungsfähige nächste Schritte liefert.

Die App kann:

- sichtbare Startup-`plist`-Dateien in Nutzer- und gemeinsamen Launch-Ordnern finden
- einfache Details aus diesen Dateien lesen
- einen lokalen bekannten Startup-Zustand speichern
- neue oder verschwundene Startup-Hinweise seit diesem Zustand melden
- den aktuellen Startup-Zustand bewusst als erwartet merken
- lokale Systemprofil-Daten und sichtbare Schutzsignale einordnen
- lokale Policy-Entscheidungen speichern und zurücksetzen
- ein lokales `.app`-Bundle bauen und prüfen

## Wichtiges mentales Modell

Die App ist kein vollständiger macOS-Sicherheitscanner.

Sie ist der Anfang eines starken Verteidigers:

1. Was ist sichtbar?
2. Was hat sich seit dem gemerkten Zustand geändert?
3. Welche Schutzsignale sind lokal sichtbar?
4. Welche echten Bedrohungsinformationen passen dazu?
5. Was bedeutet das in normaler Sprache?
6. Was ist der nächste sichere Schritt?

Der Ton darf ruhig bleiben.
Die Produktambition ist potent: klare Belege, gute Priorisierung und echter Verteidigungsnutzen.

## Hauptfluss

1. `LocalSecurityTwinApp` erstellt `FindingStore` und `PolicyStore`.
2. `FindingStore` ruft die `SensorPipeline` auf.
3. Die Live-Pipeline enthält `LaunchAgentInventorySensor` und `SystemProfileSensor`.
4. Die Sensoren bauen `Finding`-Objekte mit Evidence und Recommendations.
5. `ContentView` gruppiert die Hinweise.
6. `FindingDetailView` erklärt Kontext, Belege und sichere nächste Schritte.
7. Guided Actions erklären vor dem Speichern, was lokal passiert und was nicht.
8. `SettingsView` zeigt gemerkte Entscheidungen und erlaubt Reset.

## Bewusste Grenzen

Der Startup-Sensor sieht sichtbare `plist`-Dateien, aber nicht den vollständigen laufenden Zustand.

Der Systemprofil-Sensor sieht lokale Kontextdaten, aber kein Gesamturteil über die Sicherheit des Macs.

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

## Aktueller nächster Schritt

Die sieben Sprints aus `docs/project-completion-plan.md` sind umgesetzt.

Der nächste gute Schnitt ist:

1. Den roten Faden aus `docs/product-flow-and-feature-plan.md` in die UI übertragen.
2. Die App von einer Inspector-Liste zu einem Buddy-Status mit geführten Meldungen umbauen.
3. Danach SOFA-/Update-Awareness als ersten Online-Intelligence-Baustein planen.

Wichtig:
Online-Intelligence ist nicht Teil des aktuellen lokalen MVPs. Sobald sie gebaut wird, braucht sie eine eigene, sichtbare Entscheidung für Netzwerkzugriff, Datenschutz, Caching und Fehlerfälle.

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
