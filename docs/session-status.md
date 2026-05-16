# Session Status

## Zweck

Diese Datei ist der offizielle Übergabepunkt für die laufende Arbeit.
Sie muss nach jedem abgeschlossenen Schritt aktualisiert werden.

Ein neuer Agent soll nach `AGENTS.md` immer diese Datei lesen, bevor er weiterarbeitet.

## Letztes Update

- Datum: 2026-05-16
- Bereich: Kapitel 2b Sento Guard Shell

## Zuletzt abgeschlossen

- lokales Consent-/Policy-Modell mit Speicherung und Reset-Logik gebaut
- normalisiertes Findings-Schema mit Severity, Confidence, Evidence und Recommendations gebaut
- Detailansicht so erweitert, dass Empfehlungen schon gegen die Policy-Schicht laufen
- lokaler Workflow für Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests dokumentiert und angelegt
- gemeinsamer Sensor-Vertrag mit `SensorDescriptor`, `SensorContext`, `SensorRun` und `FindingSensor` gebaut
- Sensor-Pipeline und `FindingStore` gebaut, damit die App echte lokale Findings laden kann
- erster lokaler Sensor für sichtbare LaunchAgent-/LaunchDaemon-`plist`-Dateien gebaut
- Tests für Sensor-Vertrag, Pipeline-Sortierung und ersten Sensor ergänzt
- kleine lokale Baseline-Quelle für Startup-Items gebaut und in den ersten Sensor eingehakt
- Tests für Baseline-Persistenz und Baseline-Initialisierung im Sensor ergänzt
- Startup-Item-Sensor vergleicht den aktuellen Lauf jetzt gegen den gespeicherten lokalen Baseline-Snapshot
- neue und verschwundene Startup-Items werden jetzt als echte Baseline-Diff-Findings gemeldet
- Pfade für Startup-Item-IDs werden normalisiert, damit derselbe Dateipfad nicht wegen macOS-Pfadaliasen doppelt oder falsch verglichen wird
- lokales Git-Repository für den Projektordner initialisiert
- MVP-Strategie für macOS-Permissions und Entitlements dokumentiert
- bestehendes GitHub-Repository verbunden, Historien zusammengefuehrt und auf `origin/main` gepusht
- kritische Research-/Blindspot-Runde dokumentiert
- Baseline-Store validiert jetzt erwartete `sensorID`
- Baseline-Refresh für den aktuellen Startup-Zustand als explizite Domain-Funktion gebaut
- LaunchAgent-Sensor macht Baseline-Probleme als ruhige Sensor-Note sichtbar und behält Inventar-Findings bei
- LaunchAgent-Sensor liest einfache `.plist`-Details wie `Label`, `ProgramArguments`, `RunAtLoad` und `KeepAlive`
- Dashboard zeigt bei Startup-Änderungen eine Aktion zum bewussten Merken des aktuellen Startup-Zustands
- UI-/Policy-Sprache für Safe Validation ruhiger gefasst als "Gather More Evidence"
- Doku-Spikes für Background Task Management, nächste Sensorwahl und Packaging/Signing angelegt
- aktueller Überblick in `docs/current-overview.md` angelegt
- App in isolierter temporärer HOME-Umgebung mit vorbereitetem Startup-Diff gestartet; sie baute und blieb als GUI-Prozess aktiv, bis der Smoke-Test sie beendete
- manueller UI-Befund dokumentiert: App ist noch englisch, unübersichtlich und ohne klaren roten Faden
- UI-/UX-Redesign-Notizen in `docs/ui-ux-redesign-notes.md` angelegt
- zentrale Planungsübersicht in `docs/roadmap.md` angelegt
- Roadmap Iteration 1 umgesetzt: deutsche Hauptnavigation, deutscher Dashboard-Überblick, gruppierte Hinweis-Liste und ruhigere Finding-Zeilen
- Detailansicht, Menüleiste und Settings weitgehend auf deutsche Nutzertexte umgestellt
- Finding-Darstellung nutzt jetzt kuerzere, nutzerfreundlichere Titel und trennt neue Änderungen von bekannten Autostart-Hinweisen
- Roadmap Iteration 2 umgesetzt: Detailansicht zeigt Autostart-Details jetzt als verständliche Zusammenfassung mit Datei, internem Namen, Startbefehl, Startverhalten, Hintergrundverhalten und Pfad
- Evidence-Titel und wichtige Evidence-Zusammenfassungen werden nutzerfreundlicher auf Deutsch angezeigt
- Test für die Presentation-Logik der Startup-Details ergänzt
- Roadmap Iteration 3 umgesetzt: Dashboard-Entscheidungen in `DashboardPresentation` gebuendelt und der `Als erwartet merken`-Flow UI-nah über Store plus Presentation getestet
- Roadmap Iteration 4 umgesetzt: Background Task Management Spike aktualisiert, `sfltool dumpbtm` lokal geprüft und als noch nicht robuste Produktquelle eingestuft
- Roadmap Iteration 5 umgesetzt: Entscheidung dokumentiert, jetzt keinen zweiten Sensor zu bauen und zuerst Packaging/Signing/Sandbox zu klären
- Roadmap Iteration 6 umgesetzt: Packaging-/Signing-Plan konkretisiert; aktueller SwiftPM-Build ist ad-hoc signiertes Executable ohne App-Bundle, Xcode-Projekt oder Entitlements
- lokaler App-Bundle-Spike umgesetzt: `scripts/build-app-bundle.sh` erzeugt `.build/app/LocalSecurityTwin.app` aus dem SwiftPM-Executable
- lokales `.app`-Bundle validiert: `Info.plist` ist gültig, `codesign --verify --deep --strict` ist erfolgreich, Start-Smoke per `open -n` ist erfolgreich
- App-Bundle-Smoke automatisiert: `scripts/app-bundle-smoke.sh` baut, validiert, startet und beendet das lokale `.app`-Bundle
- Hardened-Runtime-Smoke automatisiert: `scripts/hardened-runtime-smoke.sh` signiert lokal ad-hoc mit Runtime-Option, verifiziert die Signatur und startet die App
- detaillierten Abschlussplan in `docs/project-completion-plan.md` erstellt; er ordnet UX, Trust-Flow, Sandbox/Packaging, zweiten Sensor, Guided Actions, Distribution und MVP-Abschluss in testbare Sprints
- Sprint 1 Task 1.1 umgesetzt: UI-Text-Inventar in `docs/ui-ux-redesign-notes.md` ergänzt
- auffällige englische Nutzertexte im ersten Startup-Sensor, Fenster- und Menüleistentitel eingedeutscht
- Severity-/Wichtigkeitslabels ruhiger formuliert: `Zur Info`, `Prüfen`, `Genauer prüfen`
- Sprint 1 Task 1.2 umgesetzt: Dashboard zeigt jetzt eine klarere Headline, nächsten sicheren Schritt und eine ruhige Sichtbarkeitsgrenze
- Sprint 1 Task 1.3 umgesetzt: Detailansicht beginnt jetzt mit einem Erklärpanel für Kurz gesagt, Warum wichtig und Nächster sicherer Schritt
- Sprint 1 Task 1.4 umgesetzt: Wichtigkeits-Badges sind visuell ruhiger und nutzen keine rote Alarmoptik mehr
- Sprint 2 Task 2.1 umgesetzt: wiederholbare Startup-Diff-Fixture in den E2E-Tests angelegt, ohne echte LaunchAgent-Ordner zu verändern
- Sprint 2 Task 2.2 umgesetzt: UI-Testpfad dokumentiert; vorerst Store-/Presentation-Tests plus Bundle-Smokes, echte Klickautomation nach Sandbox-/Xcode-Entscheidung
- Sprint 2 Task 2.3 umgesetzt: UI-naher E2E-Flow prüft Startup-Diff, verfügbare Trust-Empfehlung, Dashboard-Aktion und ruhigen Zustand nach `rememberCurrentStartupState`; `scripts/start-startup-diff-demo.sh` startet denselben Flow für manuelle UI-Prüfung; echte macOS-Klickautomation bleibt nach Sandbox-/Xcode-Entscheidung offen
- Sprint 3 Task 3.1 umgesetzt: minimale Sandbox-Entitlements angelegt und optionales `APP_SANDBOX=1`-Signing im lokalen Bundle-Script ergänzt
- Sprint 3 Task 3.2 umgesetzt: `scripts/sandbox-smoke.sh` baut mit Sandbox, prüft Entitlements, startet mit temporärem HOME und vorbereitetem Startup-Diff; konkrete UI-Sichtbarkeit bleibt bis echter UI-Automation manuell zu prüfen
- Sprint 3 Task 3.3 umgesetzt: Entscheidung dokumentiert, vorerst kein Xcode-Projekt anzulegen; SwiftPM plus Bundle-Scripts bleiben Hauptpfad
- Sprint 4 Task 4.1 umgesetzt: zweiter MVP-Sensor als kleiner Systemprofil-Sensor ausgewählt; Privacy-Permissions und moderne Background Items bleiben bewusst später
- Sprint 4 Task 4.2 umgesetzt: Sensor-Design in `docs/system-profile-sensor-design.md` dokumentiert
- Sprint 4 Task 4.3 umgesetzt: `SystemProfileSensor` liest lokale Basisdaten, Gatekeeper und SIP optional read-only und ist in `SensorPipeline.live()` registriert
- Sprint 4 Task 4.4 umgesetzt: Dashboard- und Finding-Presentation-Texte tragen jetzt mehrere Sensorbereiche, statt nur Autostart-Hinweise zu beschreiben
- Sprint 5 Task 5.1 umgesetzt: `PolicyActionKind` unterscheidet lokale Entscheidung, externes Öffnen, Anleitung und späteres Belegesammeln
- Sprint 5 Task 5.2 umgesetzt: Empfehlungsbuttons bestätigen vor dem Speichern, was lokal passiert und dass keine Systemeinstellung geändert wird
- Sprint 5 Task 5.3 umgesetzt: Policy-Historie in Settings bleibt sichtbar und resetbar; Labels sind deutscher formuliert
- Sprint 6 Task 6.1 umgesetzt: App-Metadaten und `Info.plist`-Vorlage liegen zentral in `Packaging/`
- Sprint 6 Task 6.2 umgesetzt: `docs/distribution-checklist.md` trennt lokale Beta-Smokes von echter Developer-ID-Distribution
- Sprint 6 Task 6.3 umgesetzt: `scripts/notarization-preflight.sh` prüft Bundle, Signatur, Hardened Runtime und Security-Checks ohne echte Apple-Notarization
- Sprint 7 Task 7.1 umgesetzt: README auf den echten MVP-Stand gebracht
- Sprint 7 Task 7.2 umgesetzt: `docs/known-limits.md` beschreibt Sensor-, Rechte-, UI- und Produktgrenzen
- Sprint 7 Task 7.3 umgesetzt: `docs/mvp-release-checklist.md` beschreibt den Beta-/MVP-Schnitt
- Beta-Validierungsplan in `docs/beta-validation-plan.md` angelegt; er trennt technische Codex-Checks von manuellen Nutzerpruefungen
- Beta-UI-Blocker aus Nutzer-Screenshot behoben: linke Spalte hat feste Breite, Detailbereich rendert robuster und Sidebar-Inhalt hat Abstand zu den macOS-Fensterknoepfen
- Nutzer-Feedback nach Layout-Fix dokumentiert: Detailansicht ist weiterhin ein Info-Overflow-Problem und als UX-Blocker für den Security-Buddy-Anspruch zu behandeln
- Settings-Test bestanden: gemerkte Entscheidung erscheint und Reset ist sichtbar; UX-Kanten sind Fenstertitel, abgeschnittener Text und technisches Risiko-Label
- Produktbild aktualisiert: Die App soll nicht nur ein ruhiger Beobachter sein, sondern ein kraftvoller Security Buddy mit Punch, der lokale Beobachtungen später mit echter Threat Intelligence verbindet
- roten Produktfaden in `docs/product-flow-and-feature-plan.md` angelegt
- Roadmap und Überblick auf den neuen Fokus "Buddy statt Inspector" aktualisiert
- Phase 0 `Buddy statt Inspector` als ersten UI-Schnitt umgesetzt: Buddy-Status oben, zusammengefasste bekannte Autostart-Hinweise, nächster Schritt vor Belegen, technische Belege einklappbar
- Presentation-/E2E-nahe Tests für Buddy-Status und zusammengefasste bekannte Autostart-Hinweise ergänzt
- Produktfaden erweitert: Der Buddy soll kuenftig auch eine defensive Angreifer-Perspektive nutzen, also realistische Missbrauchswege als Review-Frage betrachten, ohne offensive Funktionen zu bauen
- Security-Hygiene als eigene geplante Schicht dokumentiert: 2FA, Passwortmanager, VPN, Antivirus/Security-Tools, Firewall, FileVault, Treiber/System Extensions und Network Extensions
- Roadmap um Phase 2b `Security-Hygiene und Nutzer-Schutzgewohnheiten` und Phase 2c `Adversarial Review als Produkt-Routine` erweitert
- `docs/safety-policy.md` konkretisiert, dass adversarial thinking nur Verteidigung, Sensorideen, Checklisten, Guided Actions oder dokumentierte Grenzen liefern darf
- `docs/known-limits.md` ergänzt: 2FA, Passwortmanager, VPN, Security-Tools und Extensions sind aktuell noch nicht automatisch verifiziert und dürfen nur ehrlich eingeordnet werden
- Screenshot-Review am 2026-05-14 bestätigt: Der erste `Buddy statt Inspector`-Schnitt hat die Struktur verbessert, aber optisch wirkt die App weiterhin wie ein Inspector/Admin-Tool
- visuelle Richtung festgelegt: freundliche Mac-Health-App plus native Command-Center-Klarheit plus dezente Gameful-Defender-Schicht
- `docs/visual-direction.md` angelegt
- Roadmap in größere Kapitel aufgeteilt
- `docs/chapter-plan.md` angelegt
- Kapitel 1 `Buddy Home` als erster Code-Schnitt umgesetzt: Startansicht ist jetzt Buddy-Home statt Finding-Sidebar
- Guardian-Status, Buddy-Nachricht, Missionen, Aktivitätsfeed und Sichtbarkeitsnotiz sind auf der Startseite sichtbar
- technische Details öffnen erst nach bewusster Auswahl rechts im Detailbereich
- Presentation-Tests für Buddy-Home-Missionen, Aktivitätsmeldungen und ruhigen Leerzustand ergänzt
- manuelle Nutzerabnahme am 2026-05-15: neue Buddy-Home-Ansicht wirkt deutlich ruhiger, übersichtlicher und ansprechender
- Kapitel 2 `Visual System` als erster Schnitt umgesetzt: systemadaptive Hintergrundflaeche, stärkerer Guardian-Status, semantische Statusfarben, Mission-Badges und ruhigere Aktivitätszeilen
- Nutzerfeedback zu Kapitel 2: Farben und Verspieltheit dürfen bewusst höher, weil die freundliche Optik die Schwere des Security-Themas abfedert
- Visual-System-Schnitt entsprechend farbiger gemacht: freundlicher Hintergrund, stärkerer Guardian-Verlauf, farbigere Missionen und Aktivitätszeilen
- Detailseite nach Nutzerfeedback reduziert: rechts stehen jetzt zuerst Kurzurteil, nächster Schritt und wenige einfache Autostart-Fakten; Pfade, plist-Daten und Rohbelege sind nachrangig in technischen Details
- Detailbereich visuell an Buddy-Home angepasst: weicher Hintergrund, Hero-Karte, farbige Akzente je Hinweis-Typ und Material-Karten statt grauer Inspector-Flächen
- Off-topic Research-Runde zu digitalem Fußabdruck eingeordnet und dokumentiert
- `docs/privacy-footprint-cleanup.md` angelegt
- Roadmap, Kapitelplan und Produktfaden um späteres Modul `Digitaler Fußabdruck / Privacy Cleanup` erweitert
- Arbeits-Brand für den Prototyp auf `Sento Guard` gesetzt
- Kapitel 2b `Sento Guard Shell` umgesetzt: linke Brand-/Mission-Sidebar, persönlicher Sento-Hero, fünf Missionskarten, Statuskarten und lokale Datenschutzkarte
- Dashboard-Presentation erweitert um geplante Missionen `Digitaler Fußabdruck` und `App-Risiken prüfen`, ohne echte Prüfungen zu behaupten
- Presentation-Test ergänzt, damit die neuen geplanten Missionen erhalten bleiben
- Sento-Charakter als sichtbare SwiftUI-Prototypfigur gebaut: heller Körper, leuchtende Augen, Schild und ruhiger Schutzring
- Sieben Anti-Scheiter-Regeln im Produktplan dokumentiert: ehrliche Schutzversprechen, Kernloop vor Breite, einfache Handlung, echtes Threat-Matching, frühe macOS-Rechteplanung, Sento als Logik statt Deko und täglicher Nutzen vor Dashboard-Fülle
- Deutsche Nutzertexte und Dokumentation auf echte Umlaute umgestellt; Umschreibungen wie `fuer`, `pruefen`, `moeglich` bleiben nur noch als technische Beispiele/Bezeichner zulässig.

## Aktueller Stand in einem Satz

Die sieben Sprints sind umgesetzt; Kapitel 1 `Buddy Home` ist positiv abgenommen, und Kapitel 2b führt die helle `Sento Guard` Produkt-Shell mit sichtbarem Sento-Charakter ein.

## Nächster konkreter Schritt

Kapitel 2b manuell in der App prüfen: Wir müssen sehen, ob der neue Sento-Charakter freundlich, wachsam und nicht zu dekorativ wirkt.

## Danach sinnvoll

- später weitere Sensoren wie Privacy Permissions auf denselben Vertrag setzen
- Security-Hygiene-Schnitt planen: zuerst entscheiden, welche Punkte automatisch belegbar sind und welche als geführte Checkliste starten
- für neue Sensoren eine kurze adversarial Review-Frage dokumentieren: welche harmlose Verteidigungssicht entsteht aus einer realistischen Missbrauchskette?
- später modernen macOS-Background-Task-Management-Status als eigenen Research-Spike oder Sensor prüfen
- Hardened Runtime und Sandbox-Auswirkungen gegen das lokale `.app`-Bundle testen
- danach SOFA-/Update-Awareness als ersten Online-Intelligence-Baustein bauen

## Offene Punkte

- Die aktuellen empfohlenen Aktionen speichern nur Policy-Entscheidungen und führen noch keine echten Guided Actions aus.
- E2E ist momentan Smoke-Level, noch keine echte UI-Automation.
- Für den aktuellen SwiftPM-Stand gibt es noch kein eigenes Developer-ID-Signing-/Entitlements-Profil im Repo.
- Full Disk Access, Administratorrechte, Accessibility, Screen Recording, Network Client Access und privilegierte Helper sind für den aktuellen MVP bewusst nicht nötig.
- Der aktuelle Startup-Sensor deckt nur sichtbare `plist`-Dateien ab; moderne Login-/Background-Items und tatsaechlich geladener Zustand sind noch nicht abgedeckt.
- Die UI-Aktion zum Merken des aktuellen Startup-Zustands ist vorhanden, aber noch nicht mit echter macOS-UI-Automation getestet.
- Die App-Oberfläche ist jetzt deutlich deutscher und strukturierter; echte macOS-UI-Automation fehlt weiterhin.
- Der wichtigste UI-Flow ist Store-/Presentation-nah getestet; echte macOS-Klickautomation fehlt weiterhin.
- Für den `Als erwartet merken`-Flow gibt es jetzt eine feste manuelle Checkliste im Development-Workflow; echte Klickautomation bleibt trotzdem offen.
- Background Task Management ist relevant, aber noch keine robuste Produktquelle für den MVP.
- Der zweite Sensor ist der vorhandene Systemprofil-Sensor; weitere Sensoren sollten erst nach dem UX-Rote-Faden-Schnitt und der Update-Awareness-Planung folgen.
- Aktuelles `.app`-Bundle ist für Entwicklung und lokale Spikes gut, aber noch kein distributionsnahes, notarized Build-Artefakt.
- Die neue Phase-0-UI ist automatisiert über Presentation-/E2E-nahe Tests abgedeckt; echte visuelle macOS-UI-Automation fehlt weiterhin.
- Security-Hygiene ist geplant, aber noch nicht implementiert; 2FA, Passwortmanager, VPN und Security-Tool-Status dürfen vorerst nicht als automatisch geprüft dargestellt werden.
- Adversarial Review ist als Produkt-Routine dokumentiert, aber noch nicht als wiederholbare Vorlage oder Checkliste im Repo umgesetzt.
- Kapitel 1 ist strukturell umgesetzt und vom Nutzer visuell positiv abgenommen; ein Screenshot-Artefakt wurde im Chat referenziert, war für Codex aber nicht lesbar.
- Kapitel 2 muss die neue Struktur optisch deutlich stärker machen, damit sie nicht weiter wie ein schlichtes Admin-Tool wirkt.
- Kapitel 2 ist technisch umgesetzt, aber noch nicht vom Nutzer visuell abgenommen.
- `Sento Guard` ist nur ein Arbeits-Brand; vor echter Veröffentlichung braucht der Name einen tieferen Marken-, Domain- und App-Store-Check.
- Der Sento-Charakter ist aktuell eine SwiftUI-Prototypfigur, noch kein finales Maskottchen-Asset.
- Die neuen Missionen `Digitaler Fußabdruck` und `App-Risiken prüfen` sind bewusst geplant/visuell vorhanden, aber noch keine echten Sensoren.

## Letzte Validierung

- `swift test` am 2026-05-16 nach Kapitel 2b
- `./scripts/checks.sh` am 2026-05-16 nach Kapitel 2b
- `./scripts/app-bundle-smoke.sh` am 2026-05-16 nach Kapitel 2b
- `./scripts/checks.sh` am 2026-05-16 nach sichtbarem Sento-Charakter
- `./scripts/checks.sh` am 2026-05-16 nach Umlaut-Korrektur
- `./scripts/checks.sh` am 2026-05-16 nach finaler Umlaut-Nachkorrektur
- `swift test`
- `./scripts/security-checks.sh`
- `./scripts/e2e-smoke.sh`
- `./scripts/checks.sh`

Alle liefen beim aktuellen Arbeitsstand erfolgreich.

Zusätzlich am 2026-05-06 erneut ausgeführt:

- `./scripts/checks.sh`

Der Lauf war erfolgreich.

Zusätzlich nach der Baseline-/Refresh-Implementierung:

- `swift test`
- `./scripts/checks.sh`

Die Läufe waren erfolgreich; `swift test` umfasst jetzt 20 Tests.

Zusätzlich am 2026-05-12:

- `./scripts/checks.sh`
- isolierter `swift run LocalSecurityTwin`-Smoke mit temporärer HOME-Umgebung und vorbereitetem Startup-Diff

Der volle Check war erfolgreich. Der App-Smoke bestätigte Build und Start; ein echter Klick auf die macOS-UI wurde noch nicht automatisiert.

Zusätzlich nach Roadmap Iteration 1:

- `swift test`

Der Lauf war erfolgreich mit 20 Tests.

Zusätzlich nach Roadmap Iteration 2:

- `swift test`

Der Lauf war erfolgreich mit 21 Tests.

Zusätzlich nach Roadmap Iteration 3:

- Store-/Presentation-Test für den `Als erwartet merken`-Flow erweitert.

Zusätzlich nach Roadmap Iteration 4:

- `sw_vers`
- `command -v sfltool`
- `sfltool dumpbtm` zeitbegrenzt manuell geprüft

Zusätzlich nach Roadmap Iteration 6:

- `swift package describe --type json`
- Suche nach `.xcodeproj`, `.xcworkspace` und `.entitlements`
- `xcodebuild -version`
- `codesign -dv .build/debug/LocalSecurityTwin`

Zusätzlich nach dem App-Bundle-Spike am 2026-05-13:

- `./scripts/build-app-bundle.sh`
- `plutil -p .build/app/LocalSecurityTwin.app/Contents/Info.plist`
- `codesign -dv .build/app/LocalSecurityTwin.app`
- `codesign --verify --deep --strict --verbose=2 .build/app/LocalSecurityTwin.app`
- Start-Smoke per `open -n .build/app/LocalSecurityTwin.app`

Zusätzlich nach dem App-Bundle-Smoke-Script:

- `./scripts/app-bundle-smoke.sh`

Zusätzlich nach dem Hardened-Runtime-Smoke-Script:

- `HARDENED_RUNTIME=1 ./scripts/build-app-bundle.sh`
- `./scripts/hardened-runtime-smoke.sh`

Zusätzlich nach Sprint 1 Task 1.1:

- `swift test`

Zusätzlich nach Sprint 1 Task 1.2:

- neuer Presentation-Test für Dashboard-Headline, nächsten Schritt und Sichtbarkeitsgrenze

Zusätzlich nach Sprint 2 Task 2.1:

- E2E-Fixture-Test für Startup-Diff und `Als erwartet merken`

Zusätzlich nach Sprint 2 Task 2.3:

- `swift test --filter E2E`
- `swift test`
- `scripts/start-startup-diff-demo.sh` für manuelle UI-Prüfung mit temporärem HOME

Zusätzlich nach Sprint 3 Task 3.1:

- `APP_SANDBOX=1 ./scripts/build-app-bundle.sh`
- `codesign -d --entitlements :- .build/app/LocalSecurityTwin.app`

Zusätzlich nach Sprint 3 Task 3.2:

- `./scripts/sandbox-smoke.sh`

Zusätzlich nach Phase 0 `Buddy statt Inspector`:

- `swift test`
- `./scripts/checks.sh`
- `./scripts/app-bundle-smoke.sh`

Die Läufe waren erfolgreich; `swift test` umfasst jetzt 33 Tests.

Zusätzlich nach der Planerweiterung für Security-Hygiene und adversarial Review:

- `./scripts/checks.sh`

Der Lauf war erfolgreich.

Zusätzlich nach Festlegung der visuellen Richtung am 2026-05-14:

- `./scripts/checks.sh`

Der Lauf war erfolgreich.

Zusätzlich nach Anlegen des Kapitelplans am 2026-05-14:

- `./scripts/checks.sh`

Der Lauf war erfolgreich.

Zusätzlich nach Sprint 3 Task 3.3:

- `docs/xcode-project-decision.md`

Zusätzlich nach Sprint 4 Task 4.3/4.4:

- `swift test`
- `./scripts/checks.sh`

Zusätzlich nach Sprint 5:

- `swift test`

Zusätzlich nach Sprint 6:

- `./scripts/app-bundle-smoke.sh`
- `./scripts/hardened-runtime-smoke.sh`
- `./scripts/notarization-preflight.sh`

Zusätzlich nach Sprint 7:

- `./scripts/checks.sh`
- `./scripts/app-bundle-smoke.sh`
- `./scripts/hardened-runtime-smoke.sh`

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
4. Arbeite nur den nächsten klaren Schnitt ab.
5. Aktualisiere diese Datei wieder vor Session-Ende.
