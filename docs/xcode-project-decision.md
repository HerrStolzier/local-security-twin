# Xcode Project Decision

## Kurzfazit

Aktuelle Entscheidung:
Noch kein Xcode-Projekt anlegen.

SwiftPM plus die lokalen Bundle-Scripts reichen für den nächsten MVP-Abschnitt.

## Warum

Der aktuelle Stand kann bereits:

- mit `swift build` und `swift test` schnell bauen und testen
- mit `./scripts/build-app-bundle.sh` ein lokales `.app`-Bundle erzeugen
- mit `./scripts/app-bundle-smoke.sh` das Bundle starten
- mit `./scripts/hardened-runtime-smoke.sh` Hardened Runtime lokal prüfen
- mit `./scripts/sandbox-smoke.sh` Sandbox-Signing und Startfähigkeit prüfen

Ein Xcode-Projekt würde jetzt vor allem Projektpflege und Metadaten-Komplexität hinzufügen, ohne den nächsten Produktnutzen direkt zu verbessern.

## Wann die Entscheidung kippt

Ein Xcode-Projekt wird sinnvoll, wenn mindestens einer dieser Punkte eintritt:

- echte macOS-UI-Klickautomation wird Pflicht
- Developer-ID-Signing und Notarization sollen reproduzierbar als App-Archiv laufen
- Asset Catalogs, App Icons oder komplexere Bundle-Ressourcen werden wichtig
- Xcode-spezifische Entitlements-/Signing-Konfiguration wird stabiler als Script-Signing
- SwiftPM-Bundling blockiert einen konkreten Test- oder Distributionsschritt

## Praktische Konsequenz

Nächste Schritte bleiben:

1. UI-/UX und Trust-Flow weiter über SwiftPM, Store-/Presentation-Tests und Bundle-Smokes absichern.
2. Zweiten Sensor erst nach der aktuellen Sandbox-/Packaging-Einordnung auswählen.
3. Xcode-Projekt nicht aus Gewohnheit anlegen, sondern erst bei konkretem Bedarf.

## Bekannte Grenze

Der Sandbox-Smoke beweist aktuell:

- Bundle baut mit Sandbox-Entitlement
- Signatur ist gültig
- App startet mit vorbereitetem temporärem HOME

Er beweist noch nicht vollautomatisch:

- dass ein bestimmter SwiftUI-Button klickbar ist
- dass die sichtbaren Startup-Hinweise im echten Fenster erscheinen

Diese Lücke bleibt bewusst offen bis zur UI-Automation-Entscheidung.
