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
- Der zweite Sensor wurde erst nach Packaging-/Sandbox-Klaerung gewaehlt; diese Reihenfolge bleibt als Muster sinnvoll, weil Distribution und Sandbox die lokale Sichtbarkeit stark beeinflussen koennen.
- Der aktuelle SwiftPM-Build ist ein ad-hoc signiertes Executable ohne `.app`-Bundle, Entitlements und TeamIdentifier; fuer Nutzer-Testbuilds braucht das Projekt einen App-Bundle-/Xcode-Projekt-Spike.
- Ein lokales `.app`-Bundle kann aus dem SwiftPM-Executable erzeugt und ad-hoc signiert werden; das reicht fuer lokale Start- und UI-Automation-Spikes, aber nicht fuer echte Distribution.
- Der App-Bundle-Smoke sollte vor echter UI-Automation laufen, weil er zuerst klaert, ob das `.app`-Artefakt ueberhaupt sauber baut, signiert und startet.
- Die App startet lokal auch mit ad-hoc Hardened-Runtime-Signatur; echte Distribution braucht trotzdem spaeter Developer ID und Notarization.
- Der weitere MVP-Weg wurde in `docs/project-completion-plan.md` als Sprint-Plan umgesetzt; fuer den naechsten Schnitt ist `docs/mvp-release-checklist.md` massgeblich.
- Nutzertexte sollen moeglichst an der Datenquelle geglaettet werden, nicht nur in der SwiftUI-Darstellung, weil Findings, Evidence, Recommendations und Sensor-Notizen sonst unterschiedlich klingen.
- Ein Xcode-Projekt wird erst bei konkretem Bedarf angelegt; aktuell reichen SwiftPM plus lokale Bundle-, Sandbox- und Runtime-Smokes fuer den naechsten MVP-Abschnitt.
- Der zweite MVP-Sensor ist bewusst ein Systemprofil-Sensor: Er liefert lokale Kontextdaten und sichtbare Schutzsignale, darf daraus aber kein Gesamturteil ueber die Sicherheit des Macs ableiten.
- Optionale Systemschutz-Abfragen wie Gatekeeper oder SIP muessen weich behandelt werden: feste Tool-Pfade, keine Shell, Fehler als Notes statt Crash oder lauter Alarm.
- Gefuehrte Aktionen brauchen eine sichtbare Aktionsart, bevor sie ausgefuehrt oder gemerkt werden; Nutzer muessen unterscheiden koennen zwischen lokalem Merken, Anleitung, externem Oeffnen und spaeterem Belegesammeln.
- Distribution bleibt zweistufig: lokale Beta-Smokes duerfen ad-hoc signiert sein, echte Nutzerverteilung braucht spaeter Developer ID, Hardened Runtime, Notarization und Secrets ausserhalb des Repos.
- Der MVP-Schnitt braucht eine eigene Known-Limits-Doku, weil die wichtigste Sicherheitsqualitaet des Produkts darin liegt, sichtbare Belege nicht als vollstaendige Wahrheit zu verkaufen.
- Das Produktbild wurde am 2026-05-13 geschaerft: Die App soll ein kraftvoller Security Buddy mit Punch werden. Ruhige Sprache bleibt wichtig, aber die Verteidigungsambition ist staerker: lokale Beobachtung, echte Threat Intelligence, klare Priorisierung und gefuehrte naechste Schritte.
- LLMs sind fuer dieses Projekt eher Erklaer-, Recherche- und Assistenzschicht, nicht alleinige Sicherheitsinstanz. Sicherheitsentscheidungen brauchen belegbare lokale Daten, kuratierte externe Quellen und nachvollziehbare Regeln.
- Adversarial thinking gehoert dauerhaft als defensive Review-Perspektive ins Projekt: Es soll helfen, realistische Missbrauchswege in harmlose Sensorideen, Checklisten, Guided Actions oder dokumentierte Grenzen zu uebersetzen, aber nicht in Exploit-Automation.
- Security-Hygiene-Themen wie 2FA, Passwortmanager, VPN, Antivirus/Security-Tools, Firewall, FileVault und System Extensions muessen klar nach Belegtyp getrennt werden: automatisch gesehen, Nutzerangabe, abgeleitet oder nicht pruefbar.
- Jede groessere neue Funktion soll ab jetzt eine defensive Black-Hat-Pruefung bekommen: Wie koennte ein Angreifer die Funktion, ihre Daten, ihre Rechte oder ihre Nutzertexte missbrauchen?
- Best-Practice-Monitoring muss lokale Messbarkeit von gefuehrten Buddy-Fragen trennen. Dinge wie 2FA oder Passwort-Hygiene sind wichtig, aber oft nicht direkt lokal beweisbar.
- Der Phase-0-UI-Schnitt hat strukturell geholfen, aber optisch nicht genug. Die App braucht eine echte `BuddyHomeView`: Guardian-Status, Missionen, Aktivitaetsfeed und Details erst auf bewusste Auswahl.
- Die gewaehlte visuelle Richtung ist: freundliche Mac-Health-App plus native Command-Center-Klarheit plus dezente Gamification. Kein Cyberpunk-SIEM als Hauptoberflaeche.
- Die Roadmap soll ab 2026-05-14 in groesseren Kapiteln bearbeitet werden. Erst ein Kapitel abschliessen, dann das naechste beginnen; der naechste Fokus ist Kapitel 1 `Buddy Home`.
- Die erste echte Buddy-Home-Struktur soll keine Finding automatisch auswaehlen. Details sind bewusst geoeffnete Vertiefung, nicht der Startzustand.
- Missionen sind fuer dieses Produkt hilfreicher als eine rohe Hinweis-Liste: Sie zeigen Schutzbereiche und Prioritaet, ohne technische Belege zu verstecken.
- Gamification darf Orientierung geben, aber keine falsche Sicherheitszahl behaupten. Fortschrittsanzeigen muessen deshalb als Produktmetapher vorsichtig bleiben.
- Fuer den Visual-System-Schnitt sollen Farben semantisch bleiben: Orange fuer Pruefbedarf, Gruen fuer ruhig/stabil, Blau fuer beobachtete Orientierung. Farbe ist Bedeutung, nicht Dekoration.
- Die App soll systemadaptive macOS-Materialien nutzen, damit sie in Hell- und Dunkelmodus nativer wirkt und nicht wie ein harter Web-Dashboard-Port.

## Workflow Gotchas

- Vor Session-Ende nicht nur Code, sondern auch die Uebergabe-Dokumente aktualisieren.
- Ein Schritt ist erst wirklich fertig, wenn die passenden Checks gelaufen sind und der Uebergabestand dokumentiert wurde.
- Wenn die Zeit knapp wird, lieber einen kleineren Schnitt fertig dokumentieren als einen grossen halb offen lassen.
- Wenn Swift-Concurrency keinen echten Nutzen bringt, lieber die Architektur zuerst einfacher halten und spaeter gezielt erweitern.

## Infra / Build Notes

- Der lokale Standardlauf fuer Qualitaet ist `./scripts/checks.sh`.
- Darin stecken Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests.
- Ein lokales Entwicklungs-Bundle entsteht mit `./scripts/build-app-bundle.sh` unter `.build/app/LocalSecurityTwin.app`.
- Der lokale App-Bundle-Smoke laeuft mit `./scripts/app-bundle-smoke.sh`.
- Der lokale Hardened-Runtime-Smoke laeuft mit `./scripts/hardened-runtime-smoke.sh`.
- Die jetzigen E2E-Tests pruefen noch keinen echten UI-Flow, sondern das aktuelle Integrationsfundament.
- Der erste reale Sensor liest aktuell sichtbare `LaunchAgents`- und `LaunchDaemons`-`plist`-Dateien aus dem Dateisystem und interpretiert einfache Felder wie `Label`, `ProgramArguments`, `RunAtLoad` und `KeepAlive`, ohne daraus Aktivitaet oder Gefahr zu behaupten.
