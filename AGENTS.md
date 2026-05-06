# AGENTS.md

## Projekt

`local-security-twin`

Local-first macOS-Sicherheits-App fuer normale Nutzer.
Die App soll Privacy, Security-Haertung und kontrollierte Validierung in einer verstaendlichen Oberflaeche verbinden.

## Zielbild

Die App soll wie ein ruhiger Sicherheitsbegleiter wirken:

- sie beobachtet das lokale System
- erklaert Risiken in einfacher Sprache
- schlaegt sichere naechste Schritte vor
- merkt sich erlaubte Entscheidungen
- fuehrt spaeter begrenzte Safe-Mode-Validierungen aus

## Produktidee in einem Satz

Ein lokaler Sicherheits-Zwilling fuer den Mac, der mitdenkt wie Privacy-Experte, Security-Experte und vorsichtiger Angreifer, aber fuer normale Menschen verstaendlich bleibt.

## Wichtige Referenzen

- Plan-Datei: `/Users/clawdkent/Desktop/projekte-codex/local-security-twin-plan.md`
- Geplantes Repo: `https://github.com/HerrStolzier/local-security-twin`

## Aktueller Stand

- SwiftPM-macOS-Skeleton ist vorhanden und baut.
- Menueleisten-App, Hauptfenster und Settings sind angelegt.
- Consent-/Policy-Modell mit lokaler Speicherung ist vorhanden.
- Ein normalisiertes Findings-Schema mit Evidence- und Recommendation-Feldern ist vorhanden.
- Ein gemeinsamer Sensor-Vertrag und eine Sensor-Pipeline sind vorhanden.
- Ein erster lokaler Sensor fuer sichtbare Startup-Item-`plist`-Dateien ist vorhanden.
- Lokale Qualitaets-Skripte fuer Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests sind vorhanden.
- Der naechste fachliche Schritt ist jetzt eine kleine lokale Baseline-Quelle fuer spaetere Change-Detection.

## Grundhaltung des Projekts

- `local-first` als Standard
- `erklaeren vor handeln`
- keine stillen Systemaenderungen
- Zustimmung des Nutzers ist zentral
- Beweise sind wichtiger als dramatische Warnungen

## Architektur-Richtung

- native macOS-App
- primaer Menueleisten-App, aber mit oeffenbarer Haupt-App
- `SwiftUI` zuerst
- `AppKit` nur fuer noetige Systemintegration
- orchestrator-first statt alles selbst neu bauen

Das bedeutet praktisch:
Vorhandene Open-Source-Faehigkeiten koennen spaeter eingebunden werden, aber die eigene App ist die verstaendliche Huelle, Policy-Schicht und Erklaer-Ebene.

## Wichtige Inspirationsquellen

- `Lynis`
- `osquery` / `Fleet`
- `Objective-See`-Tools wie `LuLu`, `KnockKnock`, `BlockBlock`
- `Shannon` von Keygraph als Inspiration fuer proof-basierte Validierung

Wichtig:
`Shannon` ist hier nur eine Langfrist-Inspiration fuer Orchestrierung und Validierung.
Dieses Projekt ist kein Web-Pentester und soll nicht frueh in eine aggressive Offensive-Engine kippen.

## Was zuerst wichtig ist

1. App-Skeleton anlegen
2. Policy- und Consent-Modell bauen
3. Sensor-Vertrag und Findings-Schema definieren
4. Baseline fuer lokale Sichtbarkeit bauen
5. Erst dann externe Tool-Integration

## Dokumentations-Standard fuer Uebergaben

Dieses Projekt soll immer so dokumentiert werden, dass eine Session nach jedem erledigten Schritt sicher beendet werden kann.

Das bedeutet:

- nach jedem abgeschlossenen Arbeitsschritt muss `docs/session-status.md` aktualisiert werden
- dauerhafte Erkenntnisse gehoeren in `docs/project-learnings.md`
- `AGENTS.md` enthaelt nur stabile Regeln, Leitplanken und den offiziellen Read-First-Kontext
- ein neuer Agent soll seine Orientierung immer in dieser Reihenfolge holen:
  1. `AGENTS.md`
  2. `docs/session-status.md`
  3. `docs/project-learnings.md`
  4. danach erst Code und Detaildateien

Praktisch heisst das:

- `docs/session-status.md` sagt: wo wurde aufgehoert, was ist fertig, was ist als Naechstes dran
- `docs/project-learnings.md` sagt: was wir dauerhaft ueber das Projekt gelernt haben
- dadurch darf keine Session davon abhaengen, dass man den Chatverlauf kennt

## Definition of Done pro Schritt

Ein Schritt gilt in diesem Projekt erst dann als sauber abgeschlossen, wenn:

1. die eigentliche Aenderung umgesetzt ist
2. die passenden Checks gelaufen sind
3. `docs/session-status.md` auf den neuen Stand gebracht wurde
4. bei neuen dauerhaften Erkenntnissen auch `docs/project-learnings.md` aktualisiert wurde

Wenn Zeit knapp ist, wird lieber der fachliche Schnitt kleiner gehalten.
Wichtig ist nicht, moeglichst viel in einer Session zu schaffen.
Wichtig ist, dass nach jedem Stopp ein anderer Agent sauber weiterarbeiten kann.

## Nicht aus Versehen in die falsche Richtung laufen

- Nicht wie ein Enterprise-SIEM planen
- Nicht sofort autonome Angriffe bauen
- Nicht zuerst Vollautomatik oder "Self-Healing" priorisieren
- Nicht mehr macOS-Rechte anfragen als fuer den naechsten echten Nutzen noetig

## Sicherheitsgrenzen

Fuer MVP gilt:

- keine echten destruktiven Angriffe
- keine stillen Systemhaertungen
- keine versteckten Aenderungen
- keine Cloud-Pflicht

Spaetere Live-Validierung darf nur als `Safe Mode` kommen:

- klar erklaert
- stark begrenzt
- explizit bestaetigt
- mit Lab-/Harness-Denken statt blindem Trial-and-Error

## UX-Leitlinien

- ruhig statt alarmistisch
- klar statt jargonlastig
- pro Finding:
  - was ist passiert
  - warum ist das relevant
  - was kann ich jetzt tun

Die App soll Vertrauen aufbauen, nicht Angst erzeugen.

## Technische Stolpersteine

- macOS-Berechtigungen und Entitlements
- unvollstaendige Sichtbarkeit ohne hohe Rechte
- Tool-Integration mit Packaging- und Lizenzfragen
- Ranking guter Findings ohne laute Fehlalarme
- Safe-Mode-Ideen, die versehentlich zu riskant werden

## Empfehlung fuer den naechsten Agent

Wenn du hier weiterarbeitest, lies zuerst `docs/session-status.md`.
Danach beginne mit dem naechsten offenen Schritt aus `Sprint 1` bzw. dem Uebergabestand.

Aktuell ist der empfohlene Fokus:

- kleine lokale Baseline-Quelle fuer den ersten Sensor
- danach Change-Detection fuer Startup-Items
- danach die macOS-Permissions-/Entitlements-Strategie fuer MVP
- dabei weiter lokal-first, erklaerend und ohne stille Systemaenderungen bleiben

Vor Session-Ende immer die Uebergabe-Dokumente aktualisieren.
