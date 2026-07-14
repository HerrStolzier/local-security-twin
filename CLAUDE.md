# CLAUDE.md

## Projekt

`local-security-twin` (App: Sento Guard)

Local-first macOS-Sicherheits-App für normale Nutzer.
Die App soll Privacy, Security-Härtung und kontrollierte Validierung in einer verständlichen Oberfläche verbinden.

## Zielbild

Die App soll wie ein ruhiger Sicherheitsbegleiter wirken:

- sie beobachtet das lokale System
- erklärt Risiken in einfacher Sprache
- schlägt sichere nächste Schritte vor
- merkt sich erlaubte Entscheidungen
- führt später begrenzte Safe-Mode-Validierungen aus

## Produktidee in einem Satz

Ein lokaler Sicherheits-Zwilling für den Mac, der mitdenkt wie Privacy-Experte, Security-Experte und vorsichtiger Angreifer, aber für normale Menschen verständlich bleibt.

## Wichtige Referenzen

- Plan-Datei: `docs/local-security-twin-plan.md`
- Geplantes Repo: `https://github.com/HerrStolzier/local-security-twin`

## Aktueller Stand

- SwiftPM-macOS-Skeleton ist vorhanden und baut.
- Menüleisten-App, Hauptfenster und Settings sind angelegt.
- Consent-/Policy-Modell mit lokaler Speicherung ist vorhanden.
- Ein normalisiertes Findings-Schema mit Evidence- und Recommendation-Feldern ist vorhanden.
- Ein gemeinsamer Sensor-Vertrag und eine Sensor-Pipeline sind vorhanden.
- Ein erster lokaler Sensor für sichtbare Startup-Item-`plist`-Dateien ist vorhanden.
- Lokale Qualitäts-Skripte für Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests sind vorhanden.
- Der nächste fachliche Schritt ist jetzt eine kleine lokale Baseline-Quelle für spätere Change-Detection.

## Grundhaltung des Projekts

- `local-first` als Standard
- `erklären vor handeln`
- keine stillen Systemänderungen
- Zustimmung des Nutzers ist zentral
- Beweise sind wichtiger als dramatische Warnungen

## Architektur-Richtung

- native macOS-App
- primär Menüleisten-App, aber mit einer Haupt-App, die geöffnet werden kann
- `SwiftUI` zuerst
- `AppKit` nur für nötige Systemintegration
- orchestrator-first statt alles selbst neu bauen

Das bedeutet praktisch:
Vorhandene Open-Source-Fähigkeiten können später eingebunden werden, aber die eigene App ist die verständliche Hülle, Policy-Schicht und Erklär-Ebene.

## Build und Tests

```bash
swift build
swift test
./scripts/checks.sh
```

`./scripts/checks.sh` ist der Projektstandard für Build, Tests, Security-Checks und E2E-Smokes; er läuft auch über `python3 scripts/agent_finish.py`.

## Wichtige Inspirationsquellen

- `Lynis`
- `osquery` / `Fleet`
- `Objective-See`-Tools wie `LuLu`, `KnockKnock`, `BlockBlock`
- `Shannon` von Keygraph als Inspiration für proof-basierte Validierung

Wichtig:
`Shannon` ist hier nur eine Langfrist-Inspiration für Orchestrierung und Validierung.
Dieses Projekt ist kein Web-Pentester und soll nicht früh in eine aggressive Offensive-Engine kippen.

## Was zuerst wichtig ist

1. App-Skeleton anlegen
2. Policy- und Consent-Modell bauen
3. Sensor-Vertrag und Findings-Schema definieren
4. Baseline für lokale Sichtbarkeit bauen
5. Erst dann externe Tool-Integration

## Dokumentations-Standard für Übergaben

Dieses Projekt soll immer so dokumentiert werden, dass eine Session nach jedem erledigten Schritt sicher beendet werden kann.

Das bedeutet:

- nach jedem abgeschlossenen Arbeitsschritt muss `docs/session-status.md` aktualisiert werden
- dauerhafte Erkenntnisse gehören in `docs/project-learnings.md`
- `CLAUDE.md` enthält nur stabile Regeln, Leitplanken und den offiziellen Read-First-Kontext
- ein neuer Agent soll seine Orientierung immer in dieser Reihenfolge holen:
  1. `CLAUDE.md`
  2. `docs/session-status.md`
  3. `docs/project-learnings.md`
  4. danach erst Code und Detaildateien

Praktisch heißt das:

- `docs/session-status.md` sagt: wo wurde aufgehört, was ist fertig, was ist als Nächstes dran
- `docs/project-learnings.md` sagt: was wir dauerhaft über das Projekt gelernt haben
- dadurch darf keine Session davon abhängen, dass man den Chatverlauf kennt

## Definition of Done pro Schritt

Ein Schritt gilt in diesem Projekt erst dann als sauber abgeschlossen, wenn:

1. die eigentliche Änderung umgesetzt ist
2. die passenden Checks gelaufen sind
3. `docs/session-status.md` auf den neuen Stand gebracht wurde
4. bei neuen dauerhaften Erkenntnissen auch `docs/project-learnings.md` aktualisiert wurde
5. nach nicht-trivialen Änderungen der lokale Workflow Guard gelaufen ist:

   ```bash
   python3 scripts/agent_finish.py
   ```

Wenn Zeit knapp ist, wird lieber der fachliche Schnitt kleiner gehalten.
Wichtig ist nicht, möglichst viel in einer Session zu schaffen.
Wichtig ist, dass nach jedem Stopp ein anderer Agent sauber weiterarbeiten kann.

## Vibe Workflow Guard

Dieses Projekt nutzt den lokalen Vibe Workflow Guard.

- `WORKFLOWS.md` beschreibt startbare und prüfbare Projekt-Workflows.
- `CHECKS.md` beschreibt Standard- und Spezialchecks.
- `KNOWN_ERRORS.md` sammelt verstandene wiederkehrende Fehlerbilder.
- `scripts/workflow_check.py` prüft die Guard-Struktur.
- `scripts/agent_finish.py` führt Guard-Check plus Projektstandard `./scripts/checks.sh` aus.

Wenn Startbefehle, Outputs, Abhängigkeiten oder bekannte Fehlerfälle geändert werden, müssen die Guard-Dateien im selben Arbeitsschritt aktualisiert werden.

## Nicht aus Versehen in die falsche Richtung laufen

- Nicht wie ein Enterprise-SIEM planen
- Nicht sofort autonome Angriffe bauen
- Nicht zuerst Vollautomatik oder "Self-Healing" priorisieren
- Nicht mehr macOS-Rechte anfragen als für den nächsten echten Nutzen nötig

## Sicherheitsgrenzen

Für MVP gilt:

- keine echten destruktiven Angriffe
- keine stillen Systemhärtungen
- keine versteckten Änderungen
- keine Cloud-Pflicht
- Sensoren bleiben read-only
- keine erweiterten macOS-Rechte ohne klaren nächsten Nutzen

Spätere Live-Validierung darf nur als `Safe Mode` kommen:

- klar erklärt
- stark begrenzt
- explizit bestätigt
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
- unvollständige Sichtbarkeit ohne hohe Rechte
- Tool-Integration mit Packaging- und Lizenzfragen
- Ranking guter Findings ohne laute Fehlalarme
- Safe-Mode-Ideen, die versehentlich zu riskant werden

## Empfehlung für den nächsten Agent

Wenn du hier weiterarbeitest, lies zuerst `docs/session-status.md`.
Danach beginne mit dem nächsten offenen Schritt aus `Sprint 1` bzw. dem Übergabestand.

Aktuell ist der empfohlene Fokus:

- kleine lokale Baseline-Quelle für den ersten Sensor
- danach Change-Detection für Startup-Items
- danach die macOS-Permissions-/Entitlements-Strategie für MVP
- dabei weiter lokal-first, erklärend und ohne stille Systemänderungen bleiben

Vor Session-Ende immer die Übergabe-Dokumente aktualisieren.

## Abschluss

Nicht-triviale Arbeit endet mit dem Standardabschluss:

```bash
python3 scripts/agent_finish.py --auto-claims
```

Der Stop-Hook erzwingt das. Schlaegt der Check fehl, ist die Arbeit nicht fertig.
Die technischen Projektchecks stehen versioniert in `.agents/project_check` -
nicht im Guard-Script. Aendert sich der Check, aendert sich diese Datei.

## Belegpflicht

Keine Behauptung ohne lokale Evidenz. Belegbare Claim-Typen:
`file`, `external_source`, `skipped_verification`, `command`.
Siehe `scripts/claim_check.py`.

## Doku darf nicht luegen

Jeder Pfad, den WORKFLOWS.md / CHECKS.md / KNOWN_ERRORS.md in Backticks nennen,
muss existieren. `scripts/doc_drift_check.py` erzwingt das bei jedem Abschluss.

Pfad umbenannt oder geloescht? Doku mitziehen. Laufzeit-Artefakt (Build-Output,
Log, Modell-ID)? Zeile nach `.agents/doc_paths_ignore`.
