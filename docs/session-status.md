# Session Status

## Zweck

Diese Datei ist der offizielle Uebergabepunkt fuer die laufende Arbeit.
Sie muss nach jedem abgeschlossenen Schritt aktualisiert werden.

Ein neuer Agent soll nach `AGENTS.md` immer diese Datei lesen, bevor er weiterarbeitet.

## Letztes Update

- Datum: 2026-05-13
- Bereich: Sprint 4 - zweiter Sensor

## Zuletzt abgeschlossen

- lokales Consent-/Policy-Modell mit Speicherung und Reset-Logik gebaut
- normalisiertes Findings-Schema mit Severity, Confidence, Evidence und Recommendations gebaut
- Detailansicht so erweitert, dass Empfehlungen schon gegen die Policy-Schicht laufen
- lokaler Workflow fuer Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests dokumentiert und angelegt
- gemeinsamer Sensor-Vertrag mit `SensorDescriptor`, `SensorContext`, `SensorRun` und `FindingSensor` gebaut
- Sensor-Pipeline und `FindingStore` gebaut, damit die App echte lokale Findings laden kann
- erster lokaler Sensor fuer sichtbare LaunchAgent-/LaunchDaemon-`plist`-Dateien gebaut
- Tests fuer Sensor-Vertrag, Pipeline-Sortierung und ersten Sensor ergaenzt
- kleine lokale Baseline-Quelle fuer Startup-Items gebaut und in den ersten Sensor eingehakt
- Tests fuer Baseline-Persistenz und Baseline-Initialisierung im Sensor ergaenzt
- Startup-Item-Sensor vergleicht den aktuellen Lauf jetzt gegen den gespeicherten lokalen Baseline-Snapshot
- neue und verschwundene Startup-Items werden jetzt als echte Baseline-Diff-Findings gemeldet
- Pfade fuer Startup-Item-IDs werden normalisiert, damit derselbe Dateipfad nicht wegen macOS-Pfadaliasen doppelt oder falsch verglichen wird
- lokales Git-Repository fuer den Projektordner initialisiert
- MVP-Strategie fuer macOS-Permissions und Entitlements dokumentiert
- bestehendes GitHub-Repository verbunden, Historien zusammengefuehrt und auf `origin/main` gepusht
- kritische Research-/Blindspot-Runde dokumentiert
- Baseline-Store validiert jetzt erwartete `sensorID`
- Baseline-Refresh fuer den aktuellen Startup-Zustand als explizite Domain-Funktion gebaut
- LaunchAgent-Sensor macht Baseline-Probleme als ruhige Sensor-Note sichtbar und behaelt Inventar-Findings bei
- LaunchAgent-Sensor liest einfache `.plist`-Details wie `Label`, `ProgramArguments`, `RunAtLoad` und `KeepAlive`
- Dashboard zeigt bei Startup-Aenderungen eine Aktion zum bewussten Merken des aktuellen Startup-Zustands
- UI-/Policy-Sprache fuer Safe Validation ruhiger gefasst als "Gather More Evidence"
- Doku-Spikes fuer Background Task Management, naechste Sensorwahl und Packaging/Signing angelegt
- aktueller Ueberblick in `docs/current-overview.md` angelegt
- App in isolierter temporaerer HOME-Umgebung mit vorbereitetem Startup-Diff gestartet; sie baute und blieb als GUI-Prozess aktiv, bis der Smoke-Test sie beendete
- manueller UI-Befund dokumentiert: App ist noch englisch, unuebersichtlich und ohne klaren roten Faden
- UI-/UX-Redesign-Notizen in `docs/ui-ux-redesign-notes.md` angelegt
- zentrale Planungsuebersicht in `docs/roadmap.md` angelegt
- Roadmap Iteration 1 umgesetzt: deutsche Hauptnavigation, deutscher Dashboard-Ueberblick, gruppierte Hinweis-Liste und ruhigere Finding-Zeilen
- Detailansicht, Menueleiste und Settings weitgehend auf deutsche Nutzertexte umgestellt
- Finding-Darstellung nutzt jetzt kuerzere, nutzerfreundlichere Titel und trennt neue Aenderungen von bekannten Autostart-Hinweisen
- Roadmap Iteration 2 umgesetzt: Detailansicht zeigt Autostart-Details jetzt als verstaendliche Zusammenfassung mit Datei, internem Namen, Startbefehl, Startverhalten, Hintergrundverhalten und Pfad
- Evidence-Titel und wichtige Evidence-Zusammenfassungen werden nutzerfreundlicher auf Deutsch angezeigt
- Test fuer die Presentation-Logik der Startup-Details ergaenzt
- Roadmap Iteration 3 umgesetzt: Dashboard-Entscheidungen in `DashboardPresentation` gebuendelt und der `Als erwartet merken`-Flow UI-nah ueber Store plus Presentation getestet
- Roadmap Iteration 4 umgesetzt: Background Task Management Spike aktualisiert, `sfltool dumpbtm` lokal geprueft und als noch nicht robuste Produktquelle eingestuft
- Roadmap Iteration 5 umgesetzt: Entscheidung dokumentiert, jetzt keinen zweiten Sensor zu bauen und zuerst Packaging/Signing/Sandbox zu klaeren
- Roadmap Iteration 6 umgesetzt: Packaging-/Signing-Plan konkretisiert; aktueller SwiftPM-Build ist ad-hoc signiertes Executable ohne App-Bundle, Xcode-Projekt oder Entitlements
- lokaler App-Bundle-Spike umgesetzt: `scripts/build-app-bundle.sh` erzeugt `.build/app/LocalSecurityTwin.app` aus dem SwiftPM-Executable
- lokales `.app`-Bundle validiert: `Info.plist` ist gueltig, `codesign --verify --deep --strict` ist erfolgreich, Start-Smoke per `open -n` ist erfolgreich
- App-Bundle-Smoke automatisiert: `scripts/app-bundle-smoke.sh` baut, validiert, startet und beendet das lokale `.app`-Bundle
- Hardened-Runtime-Smoke automatisiert: `scripts/hardened-runtime-smoke.sh` signiert lokal ad-hoc mit Runtime-Option, verifiziert die Signatur und startet die App
- detaillierten Abschlussplan in `docs/project-completion-plan.md` erstellt; er ordnet UX, Trust-Flow, Sandbox/Packaging, zweiten Sensor, Guided Actions, Distribution und MVP-Abschluss in testbare Sprints
- Sprint 1 Task 1.1 umgesetzt: UI-Text-Inventar in `docs/ui-ux-redesign-notes.md` ergaenzt
- auffaellige englische Nutzertexte im ersten Startup-Sensor, Fenster- und Menueleistentitel eingedeutscht
- Severity-/Wichtigkeitslabels ruhiger formuliert: `Zur Info`, `Pruefen`, `Genauer pruefen`
- Sprint 1 Task 1.2 umgesetzt: Dashboard zeigt jetzt eine klarere Headline, naechsten sicheren Schritt und eine ruhige Sichtbarkeitsgrenze
- Sprint 1 Task 1.3 umgesetzt: Detailansicht beginnt jetzt mit einem Erklaerpanel fuer Kurz gesagt, Warum wichtig und Naechster sicherer Schritt
- Sprint 1 Task 1.4 umgesetzt: Wichtigkeits-Badges sind visuell ruhiger und nutzen keine rote Alarmoptik mehr
- Sprint 2 Task 2.1 umgesetzt: wiederholbare Startup-Diff-Fixture in den E2E-Tests angelegt, ohne echte LaunchAgent-Ordner zu veraendern
- Sprint 2 Task 2.2 umgesetzt: UI-Testpfad dokumentiert; vorerst Store-/Presentation-Tests plus Bundle-Smokes, echte Klickautomation nach Sandbox-/Xcode-Entscheidung
- Sprint 2 Task 2.3 umgesetzt: UI-naher E2E-Flow prueft Startup-Diff, verfuegbare Trust-Empfehlung, Dashboard-Aktion und ruhigen Zustand nach `rememberCurrentStartupState`; `scripts/start-startup-diff-demo.sh` startet denselben Flow fuer manuelle UI-Pruefung; echte macOS-Klickautomation bleibt nach Sandbox-/Xcode-Entscheidung offen
- Sprint 3 Task 3.1 umgesetzt: minimale Sandbox-Entitlements angelegt und optionales `APP_SANDBOX=1`-Signing im lokalen Bundle-Script ergaenzt
- Sprint 3 Task 3.2 umgesetzt: `scripts/sandbox-smoke.sh` baut mit Sandbox, prueft Entitlements, startet mit temporaerem HOME und vorbereitetem Startup-Diff; konkrete UI-Sichtbarkeit bleibt bis echter UI-Automation manuell zu pruefen
- Sprint 3 Task 3.3 umgesetzt: Entscheidung dokumentiert, vorerst kein Xcode-Projekt anzulegen; SwiftPM plus Bundle-Scripts bleiben Hauptpfad
- Sprint 4 Task 4.1 umgesetzt: zweiter MVP-Sensor als kleiner Systemprofil-Sensor ausgewaehlt; Privacy-Permissions und moderne Background Items bleiben bewusst spaeter
- Sprint 4 Task 4.2 umgesetzt: Sensor-Design in `docs/system-profile-sensor-design.md` dokumentiert
- Sprint 4 Task 4.3 umgesetzt: `SystemProfileSensor` liest lokale Basisdaten, Gatekeeper und SIP optional read-only und ist in `SensorPipeline.live()` registriert
- Sprint 4 Task 4.4 umgesetzt: Dashboard- und Finding-Presentation-Texte tragen jetzt mehrere Sensorbereiche, statt nur Autostart-Hinweise zu beschreiben
- Sprint 5 Task 5.1 umgesetzt: `PolicyActionKind` unterscheidet lokale Entscheidung, externes Oeffnen, Anleitung und spaeteres Belegesammeln
- Sprint 5 Task 5.2 umgesetzt: Empfehlungsbuttons bestaetigen vor dem Speichern, was lokal passiert und dass keine Systemeinstellung geaendert wird
- Sprint 5 Task 5.3 umgesetzt: Policy-Historie in Settings bleibt sichtbar und resetbar; Labels sind deutscher formuliert
- Sprint 6 Task 6.1 umgesetzt: App-Metadaten und `Info.plist`-Vorlage liegen zentral in `Packaging/`
- Sprint 6 Task 6.2 umgesetzt: `docs/distribution-checklist.md` trennt lokale Beta-Smokes von echter Developer-ID-Distribution
- Sprint 6 Task 6.3 umgesetzt: `scripts/notarization-preflight.sh` prueft Bundle, Signatur, Hardened Runtime und Security-Checks ohne echte Apple-Notarization

## Aktueller Stand in einem Satz

Die App hat zwei lokale read-only Sensorbereiche, klare gefuehrte Empfehlungen und einen reproduzierbareren lokalen Bundle-/Distribution-Preflight.

## Naechster konkreter Schritt

Mit `docs/project-completion-plan.md` fortfahren, konkret Sprint 7, Task 7.1: README auf echten Stand bringen.

## Danach sinnvoll

- spaeter weitere Sensoren wie Privacy Permissions auf denselben Vertrag setzen
- spaeter modernen macOS-Background-Task-Management-Status als eigenen Research-Spike oder Sensor pruefen
- Hardened Runtime und Sandbox-Auswirkungen gegen das lokale `.app`-Bundle testen

## Offene Punkte

- Die aktuellen empfohlenen Aktionen speichern nur Policy-Entscheidungen und fuehren noch keine echten Guided Actions aus.
- E2E ist momentan Smoke-Level, noch keine echte UI-Automation.
- Fuer den aktuellen SwiftPM-Stand gibt es noch kein eigenes Developer-ID-Signing-/Entitlements-Profil im Repo.
- Full Disk Access, Administratorrechte, Accessibility, Screen Recording, Network Client Access und privilegierte Helper sind fuer den aktuellen MVP bewusst nicht noetig.
- Der aktuelle Startup-Sensor deckt nur sichtbare `plist`-Dateien ab; moderne Login-/Background-Items und tatsaechlich geladener Zustand sind noch nicht abgedeckt.
- Die UI-Aktion zum Merken des aktuellen Startup-Zustands ist vorhanden, aber noch nicht mit echter macOS-UI-Automation getestet.
- Die App-Oberflaeche ist jetzt deutlich deutscher und strukturierter; echte macOS-UI-Automation fehlt weiterhin.
- Der wichtigste UI-Flow ist Store-/Presentation-nah getestet; echte macOS-Klickautomation fehlt weiterhin.
- Fuer den `Als erwartet merken`-Flow gibt es jetzt eine feste manuelle Checkliste im Development-Workflow; echte Klickautomation bleibt trotzdem offen.
- Background Task Management ist relevant, aber noch keine robuste Produktquelle fuer den MVP.
- Kein zweiter Sensor ist aktuell ausgewaehlt; diese Entscheidung ist bewusst, nicht vergessen.
- Aktuelles `.app`-Bundle ist fuer Entwicklung und lokale Spikes gut, aber noch kein distributionsnahes, notarized Build-Artefakt.

## Letzte Validierung

- `swift test`
- `./scripts/security-checks.sh`
- `./scripts/e2e-smoke.sh`
- `./scripts/checks.sh`

Alle liefen beim aktuellen Arbeitsstand erfolgreich.

Zusaetzlich am 2026-05-06 erneut ausgefuehrt:

- `./scripts/checks.sh`

Der Lauf war erfolgreich.

Zusaetzlich nach der Baseline-/Refresh-Implementierung:

- `swift test`
- `./scripts/checks.sh`

Die Laeufe waren erfolgreich; `swift test` umfasst jetzt 20 Tests.

Zusaetzlich am 2026-05-12:

- `./scripts/checks.sh`
- isolierter `swift run LocalSecurityTwin`-Smoke mit temporaerer HOME-Umgebung und vorbereitetem Startup-Diff

Der volle Check war erfolgreich. Der App-Smoke bestaetigte Build und Start; ein echter Klick auf die macOS-UI wurde noch nicht automatisiert.

Zusaetzlich nach Roadmap Iteration 1:

- `swift test`

Der Lauf war erfolgreich mit 20 Tests.

Zusaetzlich nach Roadmap Iteration 2:

- `swift test`

Der Lauf war erfolgreich mit 21 Tests.

Zusaetzlich nach Roadmap Iteration 3:

- Store-/Presentation-Test fuer den `Als erwartet merken`-Flow erweitert.

Zusaetzlich nach Roadmap Iteration 4:

- `sw_vers`
- `command -v sfltool`
- `sfltool dumpbtm` zeitbegrenzt manuell geprueft

Zusaetzlich nach Roadmap Iteration 6:

- `swift package describe --type json`
- Suche nach `.xcodeproj`, `.xcworkspace` und `.entitlements`
- `xcodebuild -version`
- `codesign -dv .build/debug/LocalSecurityTwin`

Zusaetzlich nach dem App-Bundle-Spike am 2026-05-13:

- `./scripts/build-app-bundle.sh`
- `plutil -p .build/app/LocalSecurityTwin.app/Contents/Info.plist`
- `codesign -dv .build/app/LocalSecurityTwin.app`
- `codesign --verify --deep --strict --verbose=2 .build/app/LocalSecurityTwin.app`
- Start-Smoke per `open -n .build/app/LocalSecurityTwin.app`

Zusaetzlich nach dem App-Bundle-Smoke-Script:

- `./scripts/app-bundle-smoke.sh`

Zusaetzlich nach dem Hardened-Runtime-Smoke-Script:

- `HARDENED_RUNTIME=1 ./scripts/build-app-bundle.sh`
- `./scripts/hardened-runtime-smoke.sh`

Zusaetzlich nach Sprint 1 Task 1.1:

- `swift test`

Zusaetzlich nach Sprint 1 Task 1.2:

- neuer Presentation-Test fuer Dashboard-Headline, naechsten Schritt und Sichtbarkeitsgrenze

Zusaetzlich nach Sprint 2 Task 2.1:

- E2E-Fixture-Test fuer Startup-Diff und `Als erwartet merken`

Zusaetzlich nach Sprint 2 Task 2.3:

- `swift test --filter E2E`
- `swift test`
- `scripts/start-startup-diff-demo.sh` fuer manuelle UI-Pruefung mit temporaerem HOME

Zusaetzlich nach Sprint 3 Task 3.1:

- `APP_SANDBOX=1 ./scripts/build-app-bundle.sh`
- `codesign -d --entitlements :- .build/app/LocalSecurityTwin.app`

Zusaetzlich nach Sprint 3 Task 3.2:

- `./scripts/sandbox-smoke.sh`

Zusaetzlich nach Sprint 3 Task 3.3:

- `docs/xcode-project-decision.md`

Zusaetzlich nach Sprint 4 Task 4.3/4.4:

- `swift test`
- `./scripts/checks.sh`

Zusaetzlich nach Sprint 5:

- `swift test`

Zusaetzlich nach Sprint 6:

- `./scripts/app-bundle-smoke.sh`
- `./scripts/hardened-runtime-smoke.sh`
- `./scripts/notarization-preflight.sh`

## Letzte externe Recherche

- `docs/research-and-blindspots.md`
- Apple Developer: Service Management
- Apple Developer: Creating Launch Daemons and Agents
- Apple Support: Manage login items and background tasks on Mac
- Apple Developer: App Sandbox und Hardened Runtime
- `docs/background-task-management-spike.md`
- `docs/next-sensor-selection.md`
- `docs/packaging-signing-plan.md`
- `docs/current-overview.md`
- `docs/ui-ux-redesign-notes.md`
- `docs/system-profile-sensor-design.md`
- `docs/roadmap.md`
- `docs/project-completion-plan.md`

## Wenn du hier weitermachst

1. Lies `AGENTS.md`.
2. Lies diese Datei komplett.
3. Lies `docs/project-learnings.md`.
4. Arbeite nur den naechsten klaren Schnitt ab.
5. Aktualisiere diese Datei wieder vor Session-Ende.
