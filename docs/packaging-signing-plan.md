# Packaging, Signing and Sandbox Plan

## Zweck

Diese Datei beschreibt, was vor einer echten Verteilung der macOS-App geklärt werden muss.

## Kurzfazit

Für lokale Entwicklung reicht der aktuelle SwiftPM-Stand.
Vor einer ernsthaften Distribution braucht das Projekt aber einen eigenen Packaging-/Signing-Schnitt.

Update 2026-05-12:
Der Packaging-Spike wurde gegen den aktuellen Repo-Stand geprüft.

Aktueller technischer Zustand:

- SwiftPM-Paket mit einem executable product `LocalSecurityTwin`
- kein `.xcodeproj`
- kein `.xcworkspace`
- kein `.entitlements`-File
- `swift build` erzeugt ein Mach-O-Executable
- `scripts/build-app-bundle.sh` erzeugt daraus ein lokales `.app`-Bundle unter `.build/app/LocalSecurityTwin.app`
- lokaler Debug-Build ist ad-hoc signiert
- `TeamIdentifier` ist nicht gesetzt
- das lokale `.app`-Bundle hat eine minimale `Info.plist`
- Xcode ist lokal vorhanden: Xcode 26.5, Build 17F42

Update 2026-05-13:
Der erste App-Bundle-Spike ist umgesetzt.

Ergebnis:

- `.build/app/LocalSecurityTwin.app` wird reproduzierbar aus SwiftPM gebaut
- Bundle-Struktur enthält `Contents/MacOS/LocalSecurityTwin` und `Contents/Info.plist`
- `codesign --verify --deep --strict` akzeptiert das lokale Bundle
- Start-Smoke per `open -n .build/app/LocalSecurityTwin.app` war erfolgreich
- Signatur bleibt bewusst ad-hoc und ist nur für lokale Entwicklung gedacht

Update nach dem ersten Script-Spike:

- `scripts/app-bundle-smoke.sh` prüft den App-Bundle-Pfad reproduzierbar
- der Smoke baut das Bundle, validiert `Info.plist`, prüft `codesign --verify`, startet die App und beendet sie danach wieder
- der Smoke ersetzt noch keine echte UI-Klickautomation, senkt aber das Risiko für den nächsten UI-Test deutlich

Update nach dem Hardened-Runtime-Smoke:

- `scripts/build-app-bundle.sh` kann über `HARDENED_RUNTIME=1` ad-hoc mit Runtime-Option signieren
- `scripts/hardened-runtime-smoke.sh` prüft, dass die Signatur `runtime` meldet und die App weiterhin startet
- das ist weiterhin keine notarized Distribution, aber ein guter lokaler Vorcheck für spätere Developer-ID-Signing-Schritte

Update nach dem Entitlements-Spike:

- `Packaging/LocalSecurityTwin.entitlements` enthält nur `com.apple.security.app-sandbox`
- `scripts/build-app-bundle.sh` bleibt standardmaessig ohne Sandbox
- `APP_SANDBOX=1 ./scripts/build-app-bundle.sh` signiert lokal ad-hoc mit Sandbox-Entitlements
- es wurden bewusst keine Network-, Accessibility-, Apple-Events-, Full-Disk-Access- oder Helper-Entitlements ergänzt

Update nach dem Sandbox-Smoke:

- `scripts/sandbox-smoke.sh` baut das Bundle mit `APP_SANDBOX=1`
- der Smoke prüft `codesign --verify` und das vorhandene App-Sandbox-Entitlement
- der Smoke startet die App mit temporärem HOME und vorbereitetem Startup-Diff
- automatisiert bestätigt ist damit Startfähigkeit mit Sandbox; die konkrete UI-Sichtbarkeit des Startup-Hinweises bleibt bis zur echten UI-Automation als manueller Check offen

Update nach Sprint 6:

- App-Metadaten liegen zentral in `Packaging/AppMetadata.env`
- `Packaging/Info.plist.template` ist die Vorlage für das lokale Bundle
- `scripts/build-app-bundle.sh` erzeugt `Info.plist` aus Vorlage plus Metadaten
- `docs/distribution-checklist.md` trennt lokale Beta-Smokes von echter Developer-ID-Distribution
- `scripts/notarization-preflight.sh` prüft lokal Bundle, Signatur, Hardened Runtime und Security-Checks, ohne eine echte Notarization auszufuehren

## Entscheidungen für den MVP

- Keine Network-Client-Entitlement ohne konkreten Produktnutzen.
- Keine Automation-, Apple-Events- oder Accessibility-Entitlements.
- Kein Full Disk Access als Standardanforderung.
- Kein privilegierter Helper für den MVP.
- Hardened Runtime für spätere Notarization einplanen.
- SwiftPM bleibt für die aktuelle Code-/Testentwicklung ausreichend.
- Vor echter Nutzerverteilung braucht das Projekt ein App-Bundle mit Signing-/Entitlements-Strategie.
- Der lokale App-Bundle-Spike ersetzt noch kein Xcode-Archiv und keine notarized Distribution.
- Sandbox wird nur explizit für lokale Tests aktiviert, nicht als Standard-Build.
- Version, Bundle-ID, Anzeigename und Mindest-macOS werden über `Packaging/AppMetadata.env` kontrolliert.
- Notarization bleibt ein separater Distribution-Schritt und ist keine Voraussetzung für normale lokale Entwicklung.

## Offene technische Fragen

- Reicht SwiftPM plus manuelles App-Bundling für die nächste UI-Automation oder soll ein Xcode-Projekt ergänzt werden?
- Soll für Signing, Entitlements und UI-Tests ein Xcode-Projekt die bevorzugte Route werden?
- Kann App Sandbox aktiv sein, ohne die sichtbaren Startup-Pfade für den MVP unbrauchbar zu machen?
- Welche Sensoren brauchen später eine klare Berechtigungs-Erklärung vor dem ersten Lauf?

## Quellenlage

Apple verlangt für notarized Distribution außerhalb des Mac App Store Developer-ID-Signing, Hardened Runtime und Notarization.
Ein ad-hoc signierter SwiftPM-Debug-Build ist dafür nicht ausreichend.

Apple beschreibt App Sandbox als Schutz, der Dateisystemzugriff auf Container, App-Groups oder nutzergewählte Dateien begrenzt.
Das kann für unseren Startup-Sensor relevant werden, weil der Sensor sichtbare Dateien in `~/Library/LaunchAgents`, `/Library/LaunchAgents` und `/Library/LaunchDaemons` liest.

## Entscheidung für jetzt

Noch keine Sandbox aktivieren.

Noch kein neues Entitlement hinzufügen.

Nächster Packaging-Schritt:
Den lokalen App-Bundle-Spike für genauere Tests nutzen:

- startet die App wiederholt stabil als echtes `.app`-Bundle?
- funktioniert MenuBarExtra wie erwartet?
- bleiben Startup-`plist`-Pfade ohne Sandbox sichtbar?
- was passiert mit Sandbox?
- kann daraus später UI-Automation stabiler laufen?

## Empfohlener nächster Packaging-Spike

1. Lokales `.app`-Bundle als UI-Automation-Ziel verwenden.
2. Vorerst Store-/Presentation-Tests plus Bundle-Smokes nutzen.
3. Echte macOS-Klickautomation erst nach Sandbox-/Xcode-Projekt-Entscheidung aufbauen.
4. Sandbox einmal bewusst an/aus gegen den Startup-Sensor prüfen.
5. Erst danach entscheiden, ob ein Xcode-Projekt nötig ist.
6. Ergebnis dokumentieren, bevor neue Sensoren mit breiterer System-Sicht gebaut werden.

## UI-Test-Entscheidung

Aktuelle Entscheidung:
Noch keine echte macOS-Klickautomation als Pflicht für jeden UI-Schnitt.

Begründung:

- SwiftPM-Bundling startet lokal stabil, ist aber noch kein vollständiges Xcode-UI-Test-Setup.
- Store-/Presentation-Tests decken den wichtigsten Trust-Flow bereits reproduzierbar ab.
- Bundle-Smokes prüfen, dass das lokale App-Artefakt baut, signiert und startet.
- Echte UI-Automation soll nach dem Sandbox-/Xcode-Projekt-Schnitt entschieden werden.

## SwiftPM vs. Xcode-Projekt

Aktuelle Entscheidung:
Noch kein Xcode-Projekt anlegen.

Die Begründung steht in `docs/xcode-project-decision.md`.

Kurz:
SwiftPM plus lokale Bundle-Scripts reichen für den nächsten MVP-Abschnitt.
Ein Xcode-Projekt wird erst angelegt, wenn echte macOS-Klickautomation, Developer-ID-Archivierung, App-Icons/Assets oder Xcode-spezifische Signing-Konfiguration konkret gebraucht werden.

## Vorlaeufiger Distributionspfad

1. Weiterentwicklung bleibt kurzfristig bei SwiftPM.
2. Für UI-Automation gibt es jetzt ein lokales `.app`-Bundle unter `.build/app/LocalSecurityTwin.app`.
3. Für echte Distribution wird Developer ID plus Hardened Runtime plus Notarization benoetigt.
4. App Sandbox wird nicht pauschal aktiviert, bevor der Startup-Sensor dagegen getestet wurde.
5. Vor jedem Beta-Schnitt laufen die Checks aus `docs/distribution-checklist.md`.
