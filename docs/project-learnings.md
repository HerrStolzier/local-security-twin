# Project Learnings

## Overview

Diese Datei sammelt nur Dinge, die wahrscheinlich auch in spaeteren Sessions noch wichtig bleiben.
Kurzlebige To-dos gehoeren nicht hierher, sondern in `docs/session-status.md`.

## Stable Learnings

- Das Projekt soll nach jedem abgeschlossenen Schritt an einem sauberen Uebergabepunkt enden koennen.
- `AGENTS.md` enthaelt die stabilen Regeln; `docs/session-status.md` enthaelt den letzten Arbeitsstand.
- `docs/project-learnings.md` ist fuer dauerhafte Erkenntnisse gedacht, nicht fuer Tagesnotizen.
- Die Produktlogik soll weiter `local-first`, erklaerend und zustimmungsbasiert bleiben.
- Policy vor echter Aktion ist hier keine Nebensache, sondern Kernarchitektur.
- Findings sollen nicht nur Warntexte sein, sondern immer auf gemeinsamer Struktur mit Evidence und Recommendations beruhen.
- Fuer den aktuellen Projektstand ist eine synchrone Sensor-Pipeline die ruhigere und passendere Basis als vorschnelle Async-Komplexitaet.
- Der erste echte Sensor sollte auf sichtbaren, risikoarmen lokalen Belegen aufbauen, bevor tiefere Systemintegration dazukommt.
- Kleine lokale JSON-Snapshots in `Application Support` sind eine gute erste Baseline-Form, solange spaetere Diff-Logik auf stabilen Kennungen wie Scope plus Pfad aufsetzt.
- Fuer lokale Dateisystem-Vergleiche muessen Pfade vor der ID-Bildung normalisiert werden, damit macOS-Aliase wie `/var` und `/private/var` nicht falsche Baseline-Diffs erzeugen.
- Fuer den MVP sollen macOS-Berechtigungen minimal bleiben: normale App-Ausfuehrung und lokaler Application-Support-Speicher reichen aktuell; staerkere Rechte brauchen erst einen konkreten, erklaerten Nutzen.
- Der Startup-Sensor darf in Nutzertexten nicht als vollstaendige Startup- oder Persistenzanalyse verkauft werden; er sieht aktuell nur sichtbare `plist`-Hinweise.
- Moderne macOS-Versionen haben Background Task Management rund um Login Items, LaunchAgents und LaunchDaemons; das sollte spaeter separat geprueft werden.
- Baseline-Probleme sollen sichtbar statt still sein, weil sonst gerade die Vertrauensfunktion der App schwerer nachvollziehbar wird.
- Ein Baseline-Refresh darf nur als explizite Nutzerentscheidung passieren; normale Sensorlaeufe duerfen den bekannten Zustand nicht still ersetzen.
- Einfache `.plist`-Details sind nuetzliche Evidence, bleiben aber Hinweise: sie beweisen weder, dass ein Eintrag aktiv laeuft, noch dass er gefaehrlich ist.
- Die aktuelle App-UI muss fuer den MVP zuerst deutsch, priorisiert und erklaerend werden; eine reine Finding-Liste ohne roten Faden fuehlt sich trotz korrekter Daten unuebersichtlich an.
- Fuer den ersten UI-Schnitt reicht es nicht, Texte zu uebersetzen; die App braucht einen Ueberblick und Gruppen, damit neue Aenderungen nicht zwischen bekannten Autostart-Hinweisen untergehen.
- Startup-Details sind fuer normale Nutzer nur hilfreich, wenn `Label`, Startbefehl, Startverhalten und Hintergrundverhalten vor den Roh-Belegen kurz eingeordnet werden.
- `sfltool dumpbtm` ist relevant fuer Background Task Management, wirkte im ersten lokalen Test aber nicht robust genug fuer eine direkte MVP-Datenquelle.

## Workflow Gotchas

- Vor Session-Ende nicht nur Code, sondern auch die Uebergabe-Dokumente aktualisieren.
- Ein Schritt ist erst wirklich fertig, wenn die passenden Checks gelaufen sind und der Uebergabestand dokumentiert wurde.
- Wenn die Zeit knapp wird, lieber einen kleineren Schnitt fertig dokumentieren als einen grossen halb offen lassen.
- Wenn Swift-Concurrency keinen echten Nutzen bringt, lieber die Architektur zuerst einfacher halten und spaeter gezielt erweitern.

## Infra / Build Notes

- Der lokale Standardlauf fuer Qualitaet ist `./scripts/checks.sh`.
- Darin stecken Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests.
- Die jetzigen E2E-Tests pruefen noch keinen echten UI-Flow, sondern das aktuelle Integrationsfundament.
- Der erste reale Sensor liest aktuell sichtbare `LaunchAgents`- und `LaunchDaemons`-`plist`-Dateien aus dem Dateisystem und interpretiert einfache Felder wie `Label`, `ProgramArguments`, `RunAtLoad` und `KeepAlive`, ohne daraus Aktivitaet oder Gefahr zu behaupten.
