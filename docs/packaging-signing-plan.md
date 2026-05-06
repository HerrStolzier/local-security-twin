# Packaging, Signing and Sandbox Plan

## Zweck

Diese Datei beschreibt, was vor einer echten Verteilung der macOS-App geklaert werden muss.

## Kurzfazit

Fuer lokale Entwicklung reicht der aktuelle SwiftPM-Stand.
Vor einer ernsthaften Distribution braucht das Projekt aber einen eigenen Packaging-/Signing-Schnitt.

## Entscheidungen fuer den MVP

- Keine Network-Client-Entitlement ohne konkreten Produktnutzen.
- Keine Automation-, Apple-Events- oder Accessibility-Entitlements.
- Kein Full Disk Access als Standardanforderung.
- Kein privilegierter Helper fuer den MVP.
- Hardened Runtime fuer spaetere Notarization einplanen.

## Offene technische Fragen

- Reicht SwiftPM fuer den naechsten lokalen App-Test weiterhin aus?
- Soll fuer Signing, Entitlements und UI-Tests ein Xcode-Projekt ergaenzt werden?
- Kann App Sandbox aktiv sein, ohne die sichtbaren Startup-Pfade fuer den MVP unbrauchbar zu machen?
- Welche Sensoren brauchen spaeter eine klare Berechtigungs-Erklaerung vor dem ersten Lauf?

## Empfohlener naechster Packaging-Spike

1. Minimales Xcode- oder Packaging-Setup evaluieren.
2. Hardened Runtime ohne Ausnahmen testen.
3. Sandbox einmal bewusst an/aus gegen den Startup-Sensor pruefen.
4. Ergebnis dokumentieren, bevor neue Sensoren mit breiterer System-Sicht gebaut werden.
