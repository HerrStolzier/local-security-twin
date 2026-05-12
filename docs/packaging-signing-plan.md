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
- `swift build` erzeugt ein Mach-O-Executable, kein fertiges `.app`-Bundle
- lokaler Debug-Build ist ad-hoc signiert
- `TeamIdentifier` ist nicht gesetzt
- `Info.plist` ist nicht gebunden
- Xcode ist lokal vorhanden: Xcode 26.5, Build 17F42

## Entscheidungen fuer den MVP

- Keine Network-Client-Entitlement ohne konkreten Produktnutzen.
- Keine Automation-, Apple-Events- oder Accessibility-Entitlements.
- Kein Full Disk Access als Standardanforderung.
- Kein privilegierter Helper fuer den MVP.
- Hardened Runtime fuer spaetere Notarization einplanen.
- SwiftPM bleibt fuer die aktuelle Code-/Testentwicklung ausreichend.
- Vor echter Nutzerverteilung braucht das Projekt ein App-Bundle mit Signing-/Entitlements-Strategie.

## Offene technische Fragen

- Reicht SwiftPM plus manuelles App-Bundling fuer den naechsten UI-Test oder soll ein Xcode-Projekt ergaenzt werden?
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
Ein minimaler App-Bundle-/Xcode-Projekt-Spike, der genau prueft:

- startet die App als echtes `.app`-Bundle?
- funktioniert MenuBarExtra wie erwartet?
- bleiben Startup-`plist`-Pfade ohne Sandbox sichtbar?
- was passiert mit Sandbox?
- kann daraus spaeter UI-Automation stabiler laufen?

## Empfohlener naechster Packaging-Spike

1. Minimales Xcode- oder Packaging-Setup evaluieren.
2. Hardened Runtime ohne Ausnahmen testen.
3. Sandbox einmal bewusst an/aus gegen den Startup-Sensor pruefen.
4. Ergebnis dokumentieren, bevor neue Sensoren mit breiterer System-Sicht gebaut werden.

## Vorlaeufiger Distributionspfad

1. Weiterentwicklung bleibt kurzfristig bei SwiftPM.
2. Fuer UI-Automation und Nutzer-Testbuilds wird ein `.app`-Bundle-Spike vorbereitet.
3. Fuer echte Distribution wird Developer ID plus Hardened Runtime plus Notarization benoetigt.
4. App Sandbox wird nicht pauschal aktiviert, bevor der Startup-Sensor dagegen getestet wurde.
