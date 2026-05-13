# Xcode Project Decision

## Kurzfazit

Aktuelle Entscheidung:
Noch kein Xcode-Projekt anlegen.

SwiftPM plus die lokalen Bundle-Scripts reichen fuer den naechsten MVP-Abschnitt.

## Warum

Der aktuelle Stand kann bereits:

- mit `swift build` und `swift test` schnell bauen und testen
- mit `./scripts/build-app-bundle.sh` ein lokales `.app`-Bundle erzeugen
- mit `./scripts/app-bundle-smoke.sh` das Bundle starten
- mit `./scripts/hardened-runtime-smoke.sh` Hardened Runtime lokal pruefen
- mit `./scripts/sandbox-smoke.sh` Sandbox-Signing und Startfaehigkeit pruefen

Ein Xcode-Projekt wuerde jetzt vor allem Projektpflege und Metadaten-Komplexitaet hinzufuegen, ohne den naechsten Produktnutzen direkt zu verbessern.

## Wann die Entscheidung kippt

Ein Xcode-Projekt wird sinnvoll, wenn mindestens einer dieser Punkte eintritt:

- echte macOS-UI-Klickautomation wird Pflicht
- Developer-ID-Signing und Notarization sollen reproduzierbar als App-Archiv laufen
- Asset Catalogs, App Icons oder komplexere Bundle-Ressourcen werden wichtig
- Xcode-spezifische Entitlements-/Signing-Konfiguration wird stabiler als Script-Signing
- SwiftPM-Bundling blockiert einen konkreten Test- oder Distributionsschritt

## Praktische Konsequenz

Naechste Schritte bleiben:

1. UI-/UX und Trust-Flow weiter ueber SwiftPM, Store-/Presentation-Tests und Bundle-Smokes absichern.
2. Zweiten Sensor erst nach der aktuellen Sandbox-/Packaging-Einordnung auswaehlen.
3. Xcode-Projekt nicht aus Gewohnheit anlegen, sondern erst bei konkretem Bedarf.

## Bekannte Grenze

Der Sandbox-Smoke beweist aktuell:

- Bundle baut mit Sandbox-Entitlement
- Signatur ist gueltig
- App startet mit vorbereitetem temporaerem HOME

Er beweist noch nicht vollautomatisch:

- dass ein bestimmter SwiftUI-Button klickbar ist
- dass die sichtbaren Startup-Hinweise im echten Fenster erscheinen

Diese Luecke bleibt bewusst offen bis zur UI-Automation-Entscheidung.
