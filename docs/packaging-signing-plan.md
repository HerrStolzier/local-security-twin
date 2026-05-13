# Packaging, Signing and Sandbox Plan

## Zweck

Diese Datei beschreibt, was vor einer echten Verteilung der macOS-App geklaert werden muss.

## Kurzfazit

Fuer lokale Entwicklung reicht der aktuelle SwiftPM-Stand.
Vor einer ernsthaften Distribution braucht das Projekt aber einen eigenen Packaging-/Signing-Schnitt.

Update 2026-05-12:
Der Packaging-Spike wurde gegen den aktuellen Repo-Stand geprueft.

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
- Bundle-Struktur enthaelt `Contents/MacOS/LocalSecurityTwin` und `Contents/Info.plist`
- `codesign --verify --deep --strict` akzeptiert das lokale Bundle
- Start-Smoke per `open -n .build/app/LocalSecurityTwin.app` war erfolgreich
- Signatur bleibt bewusst ad-hoc und ist nur fuer lokale Entwicklung gedacht

Update nach dem ersten Script-Spike:

- `scripts/app-bundle-smoke.sh` prueft den App-Bundle-Pfad reproduzierbar
- der Smoke baut das Bundle, validiert `Info.plist`, prueft `codesign --verify`, startet die App und beendet sie danach wieder
- der Smoke ersetzt noch keine echte UI-Klickautomation, senkt aber das Risiko fuer den naechsten UI-Test deutlich

Update nach dem Hardened-Runtime-Smoke:

- `scripts/build-app-bundle.sh` kann ueber `HARDENED_RUNTIME=1` ad-hoc mit Runtime-Option signieren
- `scripts/hardened-runtime-smoke.sh` prueft, dass die Signatur `runtime` meldet und die App weiterhin startet
- das ist weiterhin keine notarized Distribution, aber ein guter lokaler Vorcheck fuer spaetere Developer-ID-Signing-Schritte

## Entscheidungen fuer den MVP

- Keine Network-Client-Entitlement ohne konkreten Produktnutzen.
- Keine Automation-, Apple-Events- oder Accessibility-Entitlements.
- Kein Full Disk Access als Standardanforderung.
- Kein privilegierter Helper fuer den MVP.
- Hardened Runtime fuer spaetere Notarization einplanen.
- SwiftPM bleibt fuer die aktuelle Code-/Testentwicklung ausreichend.
- Vor echter Nutzerverteilung braucht das Projekt ein App-Bundle mit Signing-/Entitlements-Strategie.
- Der lokale App-Bundle-Spike ersetzt noch kein Xcode-Archiv und keine notarized Distribution.

## Offene technische Fragen

- Reicht SwiftPM plus manuelles App-Bundling fuer die naechste UI-Automation oder soll ein Xcode-Projekt ergaenzt werden?
- Soll fuer Signing, Entitlements und UI-Tests ein Xcode-Projekt die bevorzugte Route werden?
- Kann App Sandbox aktiv sein, ohne die sichtbaren Startup-Pfade fuer den MVP unbrauchbar zu machen?
- Welche Sensoren brauchen spaeter eine klare Berechtigungs-Erklaerung vor dem ersten Lauf?

## Quellenlage

Apple verlangt fuer notarized Distribution ausserhalb des Mac App Store Developer-ID-Signing, Hardened Runtime und Notarization.
Ein ad-hoc signierter SwiftPM-Debug-Build ist dafuer nicht ausreichend.

Apple beschreibt App Sandbox als Schutz, der Dateisystemzugriff auf Container, App-Groups oder nutzergewaehlte Dateien begrenzt.
Das kann fuer unseren Startup-Sensor relevant werden, weil der Sensor sichtbare Dateien in `~/Library/LaunchAgents`, `/Library/LaunchAgents` und `/Library/LaunchDaemons` liest.

## Entscheidung fuer jetzt

Noch keine Sandbox aktivieren.

Noch kein neues Entitlement hinzufuegen.

Naechster Packaging-Schritt:
Den lokalen App-Bundle-Spike fuer genauere Tests nutzen:

- startet die App wiederholt stabil als echtes `.app`-Bundle?
- funktioniert MenuBarExtra wie erwartet?
- bleiben Startup-`plist`-Pfade ohne Sandbox sichtbar?
- was passiert mit Sandbox?
- kann daraus spaeter UI-Automation stabiler laufen?

## Empfohlener naechster Packaging-Spike

1. Lokales `.app`-Bundle als UI-Automation-Ziel verwenden.
2. Vorerst Store-/Presentation-Tests plus Bundle-Smokes nutzen.
3. Echte macOS-Klickautomation erst nach Sandbox-/Xcode-Projekt-Entscheidung aufbauen.
4. Sandbox einmal bewusst an/aus gegen den Startup-Sensor pruefen.
5. Erst danach entscheiden, ob ein Xcode-Projekt noetig ist.
6. Ergebnis dokumentieren, bevor neue Sensoren mit breiterer System-Sicht gebaut werden.

## UI-Test-Entscheidung

Aktuelle Entscheidung:
Noch keine echte macOS-Klickautomation als Pflicht fuer jeden UI-Schnitt.

Begruendung:

- SwiftPM-Bundling startet lokal stabil, ist aber noch kein vollstaendiges Xcode-UI-Test-Setup.
- Store-/Presentation-Tests decken den wichtigsten Trust-Flow bereits reproduzierbar ab.
- Bundle-Smokes pruefen, dass das lokale App-Artefakt baut, signiert und startet.
- Echte UI-Automation soll nach dem Sandbox-/Xcode-Projekt-Schnitt entschieden werden.

## Vorlaeufiger Distributionspfad

1. Weiterentwicklung bleibt kurzfristig bei SwiftPM.
2. Fuer UI-Automation gibt es jetzt ein lokales `.app`-Bundle unter `.build/app/LocalSecurityTwin.app`.
3. Fuer echte Distribution wird Developer ID plus Hardened Runtime plus Notarization benoetigt.
4. App Sandbox wird nicht pauschal aktiviert, bevor der Startup-Sensor dagegen getestet wurde.
