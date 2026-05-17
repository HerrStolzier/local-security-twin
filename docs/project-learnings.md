# Project Learnings

## Overview

Diese Datei sammelt nur Dinge, die wahrscheinlich auch in späteren Sessions noch wichtig bleiben.
Kurzlebige To-dos gehören nicht hierher, sondern in `docs/session-status.md`.

## Stable Learnings

- Das Projekt soll nach jedem abgeschlossenen Schritt an einem sauberen Übergabepunkt enden können.
- `AGENTS.md` enthält die stabilen Regeln; `docs/session-status.md` enthält den letzten Arbeitsstand.
- `docs/project-learnings.md` ist für dauerhafte Erkenntnisse gedacht, nicht für Tagesnotizen.
- Die Produktlogik soll weiter `local-first`, erklärend und zustimmungsbasiert bleiben.
- Policy vor echter Aktion ist hier keine Nebensache, sondern Kernarchitektur.
- Findings sollen nicht nur Warntexte sein, sondern immer auf gemeinsamer Struktur mit Evidence und Recommendations beruhen.
- Für den aktuellen Projektstand ist eine synchrone Sensor-Pipeline die ruhigere und passendere Basis als vorschnelle Async-Komplexität.
- Der erste echte Sensor sollte auf sichtbaren, risikoarmen lokalen Belegen aufbauen, bevor tiefere Systemintegration dazukommt.
- Kleine lokale JSON-Snapshots in `Application Support` sind eine gute erste Baseline-Form, solange spätere Diff-Logik auf stabilen Kennungen wie Scope plus Pfad aufsetzt.
- Für lokale Dateisystem-Vergleiche müssen Pfade vor der ID-Bildung normalisiert werden, damit macOS-Aliase wie `/var` und `/private/var` nicht falsche Baseline-Diffs erzeugen.
- Für den MVP sollen macOS-Berechtigungen minimal bleiben: normale App-Ausführung und lokaler Application-Support-Speicher reichen aktuell; stärkere Rechte brauchen erst einen konkreten, erklärten Nutzen.
- Der Startup-Sensor darf in Nutzertexten nicht als vollständige Startup- oder Persistenzanalyse verkauft werden; er sieht aktuell nur sichtbare `plist`-Hinweise.
- Moderne macOS-Versionen haben Background Task Management rund um Login Items, LaunchAgents und LaunchDaemons; das sollte später separat geprüft werden.
- Baseline-Probleme sollen sichtbar statt still sein, weil sonst gerade die Vertrauensfunktion der App schwerer nachvollziehbar wird.
- Dasselbe gilt für andere lokale Vertrauensdaten: kaputte Policy- oder SOFA-Cache-Dateien müssen als ruhige Sichtgrenze sichtbar werden, nicht still wie "keine Daten" wirken.
- Ein Baseline-Refresh darf nur als explizite Nutzerentscheidung passieren; normale Sensorläufe dürfen den bekannten Zustand nicht still ersetzen.
- Einfache `.plist`-Details sind nützliche Evidence, bleiben aber Hinweise: sie beweisen weder, dass ein Eintrag aktiv läuft, noch dass er gefährlich ist.
- Die aktuelle App-UI muss für den MVP zuerst deutsch, priorisiert und erklärend werden; eine reine Finding-Liste ohne roten Faden fuehlt sich trotz korrekter Daten unübersichtlich an.
- Für den ersten UI-Schnitt reicht es nicht, Texte zu übersetzen; die App braucht einen Überblick und Gruppen, damit neue Änderungen nicht zwischen bekannten Autostart-Hinweisen untergehen.
- Startup-Details sind für normale Nutzer nur hilfreich, wenn `Label`, Startbefehl, Startverhalten und Hintergrundverhalten vor den Roh-Belegen kurz eingeordnet werden.
- `sfltool dumpbtm` ist relevant für Background Task Management, wirkte im ersten lokalen Test aber nicht robust genug für eine direkte MVP-Datenquelle.
- Der zweite Sensor wurde erst nach Packaging-/Sandbox-Klaerung gewählt; diese Reihenfolge bleibt als Muster sinnvoll, weil Distribution und Sandbox die lokale Sichtbarkeit stark beeinflussen können.
- Der aktuelle SwiftPM-Build ist ein ad-hoc signiertes Executable ohne `.app`-Bundle, Entitlements und TeamIdentifier; für Nutzer-Testbuilds braucht das Projekt einen App-Bundle-/Xcode-Projekt-Spike.
- Ein lokales `.app`-Bundle kann aus dem SwiftPM-Executable erzeugt und ad-hoc signiert werden; das reicht für lokale Start- und UI-Automation-Spikes, aber nicht für echte Distribution.
- Der App-Bundle-Smoke sollte vor echter UI-Automation laufen, weil er zuerst klärt, ob das `.app`-Artefakt überhaupt sauber baut, signiert und startet.
- Die App startet lokal auch mit ad-hoc Hardened-Runtime-Signatur; echte Distribution braucht trotzdem später Developer ID und Notarization.
- Der weitere MVP-Weg wurde in `docs/project-completion-plan.md` als Sprint-Plan umgesetzt; für den nächsten Schnitt ist `docs/mvp-release-checklist.md` massgeblich.
- Nutzertexte sollen möglichst an der Datenquelle geglättet werden, nicht nur in der SwiftUI-Darstellung, weil Findings, Evidence, Recommendations und Sensor-Notizen sonst unterschiedlich klingen.
- Ein Xcode-Projekt wird erst bei konkretem Bedarf angelegt; aktuell reichen SwiftPM plus lokale Bundle-, Sandbox- und Runtime-Smokes für den nächsten MVP-Abschnitt.
- Der zweite MVP-Sensor ist bewusst ein Systemprofil-Sensor: Er liefert lokale Kontextdaten und sichtbare Schutzsignale, darf daraus aber kein Gesamturteil über die Sicherheit des Macs ableiten.
- Optionale Systemschutz-Abfragen wie Gatekeeper oder SIP müssen weich behandelt werden: feste Tool-Pfade, keine Shell, Fehler als Notes statt Crash oder lauter Alarm.
- Geführte Aktionen brauchen eine sichtbare Aktionsart, bevor sie ausgeführt oder gemerkt werden; Nutzer müssen unterscheiden können zwischen lokalem Merken, Anleitung, externem Öffnen und späterem Belegesammeln.
- Distribution bleibt zweistufig: lokale Beta-Smokes dürfen ad-hoc signiert sein, echte Nutzerverteilung braucht später Developer ID, Hardened Runtime, Notarization und Secrets außerhalb des Repos.
- Der MVP-Schnitt braucht eine eigene Known-Limits-Doku, weil die wichtigste Sicherheitsqualität des Produkts darin liegt, sichtbare Belege nicht als vollständige Wahrheit zu verkaufen.
- Das Produktbild wurde am 2026-05-13 geschärft: Die App soll ein kraftvoller Security Buddy mit Punch werden. Ruhige Sprache bleibt wichtig, aber die Verteidigungsambition ist stärker: lokale Beobachtung, echte Threat Intelligence, klare Priorisierung und geführte nächste Schritte.
- LLMs sind für dieses Projekt eher Erklär-, Recherche- und Assistenzschicht, nicht alleinige Sicherheitsinstanz. Sicherheitsentscheidungen brauchen belegbare lokale Daten, kuratierte externe Quellen und nachvollziehbare Regeln.
- Adversarial thinking gehört dauerhaft als defensive Review-Perspektive ins Projekt: Es soll helfen, realistische Missbrauchswege in harmlose Sensorideen, Checklisten, Guided Actions oder dokumentierte Grenzen zu übersetzen, aber nicht in Exploit-Automation.
- Security-Hygiene-Themen wie 2FA, Passwortmanager, VPN, Antivirus/Security-Tools, Firewall, FileVault und System Extensions müssen klar nach Belegtyp getrennt werden: automatisch gesehen, Nutzerangabe, abgeleitet oder nicht prüfbar.
- Jede größere neue Funktion soll ab jetzt eine defensive Black-Hat-Prüfung bekommen: Wie könnte ein Angreifer die Funktion, ihre Daten, ihre Rechte oder ihre Nutzertexte missbrauchen?
- Best-Practice-Monitoring muss lokale Messbarkeit von geführten Buddy-Fragen trennen. Dinge wie 2FA oder Passwort-Hygiene sind wichtig, aber oft nicht direkt lokal beweisbar.
- Der Phase-0-UI-Schnitt hat strukturell geholfen, aber optisch nicht genug. Die App braucht eine echte `BuddyHomeView`: Guardian-Status, Missionen, Aktivitätsfeed und Details erst auf bewusste Auswahl.
- Die gewählte visuelle Richtung ist: freundliche Mac-Health-App plus native Command-Center-Klarheit plus dezente Gamification. Kein Cyberpunk-SIEM als Hauptoberfläche.
- Die Roadmap soll ab 2026-05-14 in größeren Kapiteln bearbeitet werden. Erst ein Kapitel abschliessen, dann das nächste beginnen; der nächste Fokus ist Kapitel 1 `Buddy Home`.
- Die erste echte Buddy-Home-Struktur soll keine Finding automatisch auswählen. Details sind bewusst geöffnete Vertiefung, nicht der Startzustand.
- Missionen sind für dieses Produkt hilfreicher als eine rohe Hinweis-Liste: Sie zeigen Schutzbereiche und Priorität, ohne technische Belege zu verstecken.
- Gamification darf Orientierung geben, aber keine falsche Sicherheitszahl behaupten. Fortschrittsanzeigen müssen deshalb als Produktmetapher vorsichtig bleiben.
- Für den Visual-System-Schnitt sollen Farben semantisch bleiben: Orange für Prüfbedarf, Grün für ruhig/stabil, Blau für beobachtete Orientierung. Farbe ist Bedeutung, nicht Dekoration.
- Die App soll systemadaptive macOS-Materialien nutzen, damit sie in Hell- und Dunkelmodus nativer wirkt und nicht wie ein harter Web-Dashboard-Port.
- Das Produkt darf optisch freundlicher und spielerischer werden als ein klassisches Security-Tool. Gerade weil Cybersecurity schwer wirkt, soll die UI die Schwere abfedern, ohne falsche Sicherheit oder unseriöse Spielmechaniken einzubauen.
- Detailseiten sollen den Nutzer nicht zum Analysten machen. Erst muss die App selbst einordnen: kurze Bedeutung, nächster Schritt, wenige einfache Fakten; Rohdaten und Pfade gehören in nachrangige technische Details.
- Digitaler Fußabdruck passt als späterer Produktarm zum Security Buddy, aber nur als geführter Privacy-Cleanup: priorisieren, Vorlagen erstellen, Fortschritt lokal merken. Keine heimliche Personensuche, keine automatischen Löschanfragen und keine Verarbeitung von Identitätsdokumenten im MVP.
- Für Privacy-Footprint-Cleanup sind vorhandene Quellen eher Verzeichnisse und APIs als fertige Lösung: Data-Broker-Opt-out-Listen, JustDeleteMe, Have I Been Pwned und SimpleLogin können helfen, aber die Buddy-Schicht und die sichere Zustimmung müssen wir selbst bauen.
- Der aktuelle Arbeits-Brand ist `Sento Guard`. Der Name passt besser als `Kito Guard`, weil er im ersten Screening weniger offensichtlich belegt wirkte; trotzdem braucht er vor echter Veröffentlichung eine tiefere Marken-/Domain-/App-Store-Prüfung.
- Die helle Mockup-Richtung ist die neue Leitlinie: freundliche Sidebar, Sento als Buddy-Figur, Statuskarten, Missionen und Activity-Feed. Die dunkle Cyberpunk-Variante bleibt nur Inspirationsquelle, nicht Standardlook.
- Geplante Missionen dürfen in der UI sichtbar sein, müssen aber klar als geplant erscheinen. Besonders `Digitaler Fußabdruck` und `App-Risiken prüfen` dürfen keine echten Prüfungen behaupten, solange dahinter keine Sensoren oder geführte Flows gebaut sind.
- Sento darf als SwiftUI-Prototypfigur sichtbar sein, solange die Figur nicht falsche Sicherheit ausdrückt. Der Charakter muss Produktlogik tragen: priorisieren, erklären, nachfragen und Entscheidungen lokal merken.
- Die sieben Anti-Scheiter-Regeln sind Produktleitplanken: ehrliche Schutzversprechen, Kernloop vor Breite, einfache Handlung, echtes Threat-Matching, frühe macOS-Rechteplanung, Sento als Logik statt Deko und täglicher Nutzen vor Dashboard-Fülle.
- Deutsche Nutzertexte und Dokumentation sollen echte Umlaute verwenden. Umschreibungen wie `fuer`, `pruefen`, `moeglich`, `Aenderung` oder `Bestaetigung` sind nur in technischen Bezeichnern akzeptabel, nicht in sichtbaren Texten.
- Für Kapitel 3 ist SOFA die erste sinnvolle externe Baseline-Quelle für macOS-Update-Awareness. Der Feed muss lokal gecacht werden, der Quellenstand muss sichtbar bleiben, und die UI darf daraus kein vollständiges Sicherheitsurteil ableiten.
- Externe Update-Awareness darf im Live-Produkt nicht heimlich beim Start ins Netzwerk gehen. Bis ein sichtbarer Zustimmungs- oder Aktualisieren-Flow existiert, darf der Sensor nur lokalen Cache nutzen oder eine ehrliche Sichtgrenze anzeigen.
- Der SOFA-Abruf ist als bewusste Nutzeraktion vertretbar: vorher erklären, einmalig online laden, lokal speichern, Quellenstand zeigen und keine Updates installieren oder Systemeinstellungen verändern.
- Nach einer bewussten Online-Aktualisierung braucht die UI einen klaren Nachher-Zustand. Ein still aktualisierter Cache reicht nicht; Banner, Mission, Aktivitätsfeed oder Detailhinweis müssen in einfacher Sprache zeigen, was verglichen wurde und was ausdrücklich nicht verändert wurde.
- Kaputte lokale Persistenz ist in einem Security-Produkt eine Sichtgrenze, kein Nebengeräusch. Policy-Dateien, Baselines und externe Quellen-Caches dürfen weiter robust fehlschlagen, sollen aber ruhig sichtbar machen, welcher Vergleich oder welche gespeicherte Entscheidung gerade nicht genutzt wurde.
- Security-Hygiene darf nicht wie eine interne Belegliste klingen. Die Nutzeroberfläche soll nach praktischen Fähigkeiten gruppieren: was Sento lokal sehen kann, was später als bewusste Frage kommt und was ehrlich offen bleibt.
- Geführte Hygiene-Fragen müssen als Nutzerangabe sichtbar bleiben. Auch lokal gespeicherte Antworten zu 2FA, Passwortmanager oder Recovery Codes sind keine Verifikation und dürfen nicht in einen geprüften Schutzstatus umgedeutet werden.
- FileVault- und Firewall-Status sind geeignete lokale Hygiene-Schutzsignale, solange die App sie nur liest, nie still verändert und sie nicht als vollständige Sicherheitsbewertung verkauft.
- VPN gehört in Sento Guard zuerst als Kontextfrage, nicht als Produktbewertung: Der sinnvolle Einsatz hängt von fremden Netzen, beruflichen Vorgaben und Vertrauensmodell ab, nicht von einem pauschalen Schutzversprechen.
- Das Buddy-Home darf bei schmaleren macOS-Fenstern nicht nur Text umbrechen lassen. Hero, Topbar und spätere Banner brauchen explizite kompakte Layoutvarianten, damit normale Fenstergrößen nicht wie ein gequetschtes Dashboard wirken.

## Workflow Gotchas

- Vor Session-Ende nicht nur Code, sondern auch die Übergabe-Dokumente aktualisieren.
- Ein Schritt ist erst wirklich fertig, wenn die passenden Checks gelaufen sind und der Übergabestand dokumentiert wurde.
- Wenn die Zeit knapp wird, lieber einen kleineren Schnitt fertig dokumentieren als einen großen halb offen lassen.
- Wenn Swift-Concurrency keinen echten Nutzen bringt, lieber die Architektur zuerst einfacher halten und später gezielt erweitern.

## Infra / Build Notes

- Der lokale Standardlauf für Qualität ist `./scripts/checks.sh`.
- Darin stecken Refactor-/Regression-Pass, Security Checks und E2E-Smoke-Tests.
- Ein lokales Entwicklungs-Bundle entsteht mit `./scripts/build-app-bundle.sh` unter `.build/app/LocalSecurityTwin.app`.
- Der lokale App-Bundle-Smoke läuft mit `./scripts/app-bundle-smoke.sh`.
- Der lokale Hardened-Runtime-Smoke läuft mit `./scripts/hardened-runtime-smoke.sh`.
- Die jetzigen E2E-Tests prüfen noch keinen echten UI-Flow, sondern das aktuelle Integrationsfundament.
- Der erste reale Sensor liest aktuell sichtbare `LaunchAgents`- und `LaunchDaemons`-`plist`-Dateien aus dem Dateisystem und interpretiert einfache Felder wie `Label`, `ProgramArguments`, `RunAtLoad` und `KeepAlive`, ohne daraus Aktivität oder Gefahr zu behaupten.
