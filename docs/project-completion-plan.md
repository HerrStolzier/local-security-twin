# Plan: Project Completion Roadmap

**Generated**: 2026-05-13  
**Estimated Complexity**: High

## Overview

`local-security-twin` ist aktuell ein funktionierender lokaler macOS-Prototyp mit einem echten Sensor, lokaler Baseline, deutscherer UI, App-Bundle-Smokes und Hardened-Runtime-Smoke.

Der Weg zur vervollstaendigten MVP-Version besteht nicht darin, schnell viele Sensoren anzubauen. Der richtige Weg ist:

1. erst die Nutzerfuehrung stabilisieren,
2. dann Packaging, Sandbox und UI-Automation absichern,
3. danach den zweiten Sensor bewusst auswählen,
4. erst später echte Guided Actions und Distribution vorbereiten.

Das Ziel ist ein ruhiger Sicherheitsbegleiter, kein lauter Scanner.

## Product Completion Definition

Das Projekt gilt als MVP-fertig, wenn:

- ein normaler Nutzer den Startbildschirm ohne Erklärung versteht
- mindestens zwei lokale, read-only Sensoren verständliche Hinweise liefern
- neue und erwartete Änderungen nachvollziehbar getrennt sind
- Baseline-/Trust-Entscheidungen bewusst und reversibel wirken
- die App als lokales `.app`-Bundle stabil startet
- Sandbox-/Signing-Entscheidungen dokumentiert und getestet sind
- zentrale UI-Flows automatisiert oder bewusst als manuelle Checks dokumentiert sind
- keine unerklärten macOS-Rechte angefordert werden
- alle Übergabe-Dokumente aktuell sind

## Prerequisites

- macOS 15 oder neuer
- Xcode 26.5 oder kompatible Swift-6-Toolchain
- Zugriff auf das GitHub-Repo `HerrStolzier/local-security-twin`
- Lokale App-Smokes:
  - `./scripts/build-app-bundle.sh`
  - `./scripts/app-bundle-smoke.sh`
  - `./scripts/hardened-runtime-smoke.sh`
- Standard-Checks:
  - `./scripts/checks.sh`

## Sprint 1: Orientierung und UX-Fokus

**Status**: umgesetzt am 2026-05-13.

**Goal**: Die App soll für normale Nutzer in einem Blick erklären, was gerade wichtig ist.

**Demo/Validation**:

- `swift run LocalSecurityTwin`
- oder `.build/app/LocalSecurityTwin.app` nach `./scripts/app-bundle-smoke.sh`
- Manuell prüfen:
  - Startbildschirm ist deutsch
  - neue Änderungen sind sofort sichtbar
  - bekannte Hinweise wirken nicht wie Panikmeldungen
  - Detailansicht beginnt mit Einordnung, nicht Rohdaten

### Task 1.1: UI-Texte vollständig inventarisieren

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features`
  - `Sources/LocalSecurityTwin/App/LocalSecurityTwinApp.swift`
- **Description**: Alle noch englischen Nutzertexte sammeln und in eine kurze Liste in `docs/ui-ux-redesign-notes.md` aufnehmen.
- **Complexity**: 2/10
- **Dependencies**: keine
- **Acceptance Criteria**:
  - Liste der noch offenen Nutzertexte ist dokumentiert
  - interne Code-Namen werden nicht unnötig umbenannt
- **Validation**:
  - `rg '"[A-Za-z][^"]*"' Sources/LocalSecurityTwin`

### Task 1.2: Dashboard-Story schaerfen

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Dashboard/ContentView.swift`
  - `Sources/LocalSecurityTwin/Features/Dashboard/FindingPresentation.swift`
- **Description**: Startbereich so umbauen, dass er die drei Fragen beantwortet: Was ist neu? Was ist bekannt? Was ist der nächste sichere Schritt?
- **Complexity**: 5/10
- **Dependencies**: Task 1.1
- **Acceptance Criteria**:
  - Dashboard zeigt eine kurze Statuszusammenfassung
  - neue Startup-Änderungen stehen vor bekannten Hinweisen
  - begrenzte Sichtbarkeit des Sensors wird ruhig erklärt
- **Validation**:
  - `swift test`
  - manueller App-Start

### Task 1.3: Detailansicht als Erklärfluss gliedern

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Detail/FindingDetailView.swift`
- **Description**: Detailansicht in klare Abschnitte bringen: kurze Einordnung, sichtbare Details, Belege, nächster Schritt.
- **Complexity**: 5/10
- **Dependencies**: Task 1.2
- **Acceptance Criteria**:
  - Nutzer sieht zuerst eine alltagstaugliche Einordnung
  - Belege bleiben sichtbar, aber dominieren nicht die Seite
  - Texte behaupten nicht, dass ein sichtbarer Eintrag aktiv oder gefährlich ist
- **Validation**:
  - `swift test`
  - manueller Vergleich gegen Screenshot-Befund in `docs/ui-ux-redesign-notes.md`

### Task 1.4: Ruhigere Severity-Darstellung

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Dashboard/FindingRowView.swift`
  - `Sources/LocalSecurityTwin/Features/Dashboard/FindingPresentation.swift`
- **Description**: Severity nicht als Alarm verkaufen, sondern als Einordnung. Neue Änderungen dürfen wichtiger wirken als normale bekannte Daemons.
- **Complexity**: 4/10
- **Dependencies**: Task 1.2
- **Acceptance Criteria**:
  - normale Autostart-Hinweise wirken beobachtenswert, nicht akut
  - verschwundene Items bleiben niedrig priorisiert
  - neue Items sind erkennbar, ohne rote Alarmoptik
- **Validation**:
  - `swift test`
  - visueller Smoke

## Sprint 2: Trust-Flow und UI-nahe Tests

**Status**: umgesetzt am 2026-05-13.

**Goal**: Der Nutzer kann Startup-Änderungen bewusst als erwartet merken, und dieser Flow ist testbar.

**Demo/Validation**:

- App mit vorbereitetem Startup-Diff starten
- Aktion `Als erwartet merken` ausloesen
- prüfen, dass Diff-Hinweise danach verschwinden oder als bekannt eingeordnet werden

### Task 2.1: Testdaten für Startup-Diff-App-Start standardisieren

**Status**: umgesetzt am 2026-05-13 als Store-/Presentation-naher E2E-Test. Echte macOS-Klickautomation bleibt nach Sandbox-/Xcode-Entscheidung offen.

- **Location**:
  - `scripts/`
  - `Tests/LocalSecurityTwinE2ETests`
- **Description**: Einen wiederholbaren Testaufbau für lokale Startup-Diffs definieren, ohne echte Systemordner zu verändern.
- **Complexity**: 5/10
- **Dependencies**: Sprint 1
- **Acceptance Criteria**:
  - Test nutzt temporäre HOME-/Application-Support-Pfade
  - keine echten LaunchAgent-Dateien werden verändert
- **Validation**:
  - `swift test --filter E2E`

### Task 2.2: App-Bundle als UI-Testziel dokumentieren

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `docs/development-workflow.md`
  - `docs/packaging-signing-plan.md`
- **Description**: Festlegen, ob UI-nahe Tests zuerst über Bundle-Smoke, XCTest, Accessibility oder manuelle Checkliste laufen.
- **Complexity**: 3/10
- **Dependencies**: Task 2.1
- **Acceptance Criteria**:
  - ein bevorzugter UI-Testpfad ist dokumentiert
  - offener Xcode-Projektbedarf ist klar benannt
- **Validation**:
  - Doku-Review

### Task 2.3: Erster UI-naher Flow-Test

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Tests/LocalSecurityTwinE2ETests`
  - `scripts/start-startup-diff-demo.sh`
- **Description**: Den wichtigsten Flow testen: Findings geladen, Startup-Diff sichtbar, Merken-Aktion verfügbar, Folgezustand ruhig.
- **Complexity**: 6/10
- **Dependencies**: Task 2.1, Task 2.2
- **Acceptance Criteria**:
  - Test läuft reproduzierbar lokal
  - bei fehlender echter UI-Automation existiert mindestens ein Store-/Presentation-naher Ersatztest plus manuelle Checkliste
- **Validation**:
  - `./scripts/checks.sh`

## Sprint 3: Sandbox- und Packaging-Entscheidung

**Status**: umgesetzt am 2026-05-13.

**Goal**: Das Projekt weiss, ob Sandbox für den MVP realistisch ist und ob SwiftPM-Bundling reicht.

**Demo/Validation**:

- App startet ohne Sandbox
- App startet mit Sandbox-Testsignatur oder dokumentiertem Gegenbeweis
- Startup-Sensor-Sichtbarkeit wird verglichen

### Task 3.1: Minimale Entitlements-Datei für lokale Sandbox-Tests anlegen

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Packaging/LocalSecurityTwin.entitlements`
  - `scripts/build-app-bundle.sh`
- **Description**: Optionales lokales Signing mit Entitlements ermöglichen, ohne Sandbox standardmaessig zu aktivieren.
- **Complexity**: 5/10
- **Dependencies**: Sprint 2 nicht zwingend, aber empfohlen
- **Acceptance Criteria**:
  - Standard-Bundle bleibt ohne Sandbox
  - Sandbox kann explizit für Tests aktiviert werden
  - keine Network-, Accessibility-, Apple-Events- oder Full-Disk-Access-Entitlements
- **Validation**:
  - `codesign -d --entitlements :- .build/app/LocalSecurityTwin.app`

### Task 3.2: Sandbox-Smoke gegen Startup-Sensor

**Status**: umgesetzt am 2026-05-13 als Sandbox-Start-Smoke mit vorbereitetem Startup-Diff. Automatisierte UI-Sichtbarkeitspruefung bleibt bis zur echten UI-Automation offen.

- **Location**:
  - `scripts/sandbox-smoke.sh`
  - `docs/packaging-signing-plan.md`
- **Description**: App mit Sandbox starten und dokumentieren, ob sichtbare Startup-Pfade weiter lesbar sind.
- **Complexity**: 6/10
- **Dependencies**: Task 3.1
- **Acceptance Criteria**:
  - Ergebnis ist eindeutig dokumentiert
  - bei eingeschränkter Sicht gibt es eine ruhige Sensor-Note oder Produktentscheidung
- **Validation**:
  - `./scripts/sandbox-smoke.sh`
  - `./scripts/checks.sh`

### Task 3.3: SwiftPM-Bundle vs. Xcode-Projekt entscheiden

**Status**: umgesetzt am 2026-05-13. Entscheidung: vorerst kein Xcode-Projekt; SwiftPM plus Bundle-Scripts bleiben Hauptpfad.

- **Location**:
  - `docs/packaging-signing-plan.md`
  - `docs/xcode-project-decision.md`
- **Description**: Entscheiden, ob für UI-Tests, Signing und spätere Distribution ein Xcode-Projekt nötig wird.
- **Complexity**: 4/10
- **Dependencies**: Task 3.2
- **Acceptance Criteria**:
  - Entscheidung mit Gründen dokumentiert
  - nächster Packaging-Schritt ist eindeutig
- **Validation**:
  - Doku-Review

## Sprint 4: Zweiten Sensor bewusst auswählen und bauen

**Status**: in Arbeit seit 2026-05-13.

**Goal**: Der MVP bekommt eine zweite lokale Sicht, ohne Rechteumfang unnötig zu vergroessern.

**Demo/Validation**:

- Dashboard zeigt Hinweise aus zwei Sensoren
- beide Sensoren erklären ihre Grenzen
- keine zusätzlichen macOS-Rechte werden still gefordert

### Task 4.1: Sensor-Kandidaten final bewerten

**Status**: umgesetzt am 2026-05-13. Gewählt wurde ein kleiner Systemprofil-Sensor; Privacy-Permissions und moderne Background Items bleiben bewusst später.

- **Location**:
  - `docs/next-sensor-selection.md`
- **Description**: Privacy-Permissions-Sichtbarkeit, moderne Background Items und lokale Exposure Checks gegen Kriterien bewerten.
- **Complexity**: 3/10
- **Dependencies**: Sprint 3
- **Acceptance Criteria**:
  - ein Sensor wird für MVP 2 ausgewählt
  - nicht gewählte Kandidaten haben klare Gründe
- **Validation**:
  - Doku-Review

### Task 4.2: Sensor-Design-Plan schreiben

**Status**: umgesetzt am 2026-05-13 in `docs/system-profile-sensor-design.md`.

- **Location**:
  - neues `docs/<sensor-name>-design.md`
- **Description**: Datenquelle, Rechtebedarf, Evidence, Finding-Texte, Fehlalarme und Tests vor Implementierung festlegen.
- **Complexity**: 4/10
- **Dependencies**: Task 4.1
- **Acceptance Criteria**:
  - Sensor bleibt read-only
  - klare Nutzertexte und Grenzen sind vorab formuliert
- **Validation**:
  - Review gegen `docs/safety-policy.md`

### Task 4.3: Sensor minimal implementieren

**Status**: umgesetzt am 2026-05-13. `SystemProfileSensor` liest lokale Basisdaten, Gatekeeper und SIP optional read-only und ist in der Live-Pipeline registriert.

- **Location**:
  - `Sources/LocalSecurityTwin/Sensors/<SensorName>/`
  - `Sources/LocalSecurityTwin/Core/Sensors/FindingStore.swift`
  - `Tests/LocalSecurityTwinTests/`
- **Description**: Sensor an bestehenden `FindingSensor`-Vertrag anbinden und in der Pipeline sichtbar machen.
- **Complexity**: 7/10
- **Dependencies**: Task 4.2
- **Acceptance Criteria**:
  - Sensor liefert Findings mit Evidence und Recommendation
  - Sensor erklärt eingeschränkte Sicht
  - Tests für positive, leere und Fehlerfälle
- **Validation**:
  - `swift test`
  - `./scripts/checks.sh`

### Task 4.4: UI-Gruppierung für mehrere Sensoren

**Status**: umgesetzt am 2026-05-13. Dashboard-Texte und System-Finding-Darstellung sind nicht mehr nur auf Autostart-Hinweise zugeschnitten.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Dashboard`
  - `Sources/LocalSecurityTwin/Features/Detail`
- **Description**: Dashboard so erweitern, dass mehrere Sensorbereiche nicht unübersichtlich werden.
- **Complexity**: 6/10
- **Dependencies**: Task 4.3
- **Acceptance Criteria**:
  - Nutzer erkennt Quelle und Bedeutung eines Hinweises
  - mehrere Sensoren erzeugen keine lange, flache Rohdatenliste
- **Validation**:
  - `swift test`
  - manueller UI-Smoke

## Sprint 5: Guided Actions ohne Systemrisiko

**Status**: umgesetzt am 2026-05-13.

**Goal**: Empfehlungen werden nützlicher, ohne echte Systemänderungen zu verstecken.

**Demo/Validation**:

- Detailansicht zeigt sichere nächste Schritte
- Aktion erklärt, ob sie nur merkt, öffnet oder später etwas ändern könnte

### Task 5.1: Aktionsarten definieren

**Status**: umgesetzt am 2026-05-13. `PolicyActionKind` trennt lokale Entscheidung, externes Öffnen, Anleitung und späteres Belegesammeln.

- **Location**:
  - `Sources/LocalSecurityTwin/Core/Policy/`
  - `docs/safety-policy.md`
- **Description**: Klare Typen für Aktionen: nur merken, extern öffnen, Anleitung anzeigen, später validieren.
- **Complexity**: 5/10
- **Dependencies**: Sprint 4
- **Acceptance Criteria**:
  - keine Aktion führt still Systemänderungen aus
  - jede Aktion hat Consent-Anforderung
- **Validation**:
  - `swift test`

### Task 5.2: Erklär-Dialog für vertrauensrelevante Aktionen

**Status**: umgesetzt am 2026-05-13. Empfehlungsbuttons zeigen vor dem Speichern eine kurze Bestätigung, was lokal passiert und was nicht.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Detail`
  - `Sources/LocalSecurityTwin/Core/Policy`
- **Description**: Vor dem Merken oder späteren Handeln kurz erklären, was die App tut und was nicht.
- **Complexity**: 6/10
- **Dependencies**: Task 5.1
- **Acceptance Criteria**:
  - Nutzer bestätigt bewusst
  - Text vermeidet technische Woerter wie Baseline und Diff
- **Validation**:
  - Store-/Presentation-Test
  - manueller UI-Smoke

### Task 5.3: Policy-Historie sichtbar machen

**Status**: bereits vorhanden und am 2026-05-13 geglättet. Settings zeigen gemerkte Entscheidungen mit Reset; Labels sind deutscher.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Settings/SettingsView.swift`
  - `Sources/LocalSecurityTwin/Core/Policy`
- **Description**: Settings zeigen, welche Entscheidungen lokal gemerkt wurden, mit Reset-Möglichkeit.
- **Complexity**: 6/10
- **Dependencies**: Task 5.2
- **Acceptance Criteria**:
  - Nutzer kann lokale Entscheidungen sehen und löschen
  - keine Cloud-Abhängigkeit
- **Validation**:
  - `swift test`
  - manueller Settings-Smoke

## Sprint 6: Produktreife und Distribution

**Status**: umgesetzt am 2026-05-13.

**Goal**: Die App wird als testbare MVP-App verteilbar, ohne die Sicherheitsgrenzen zu verwischen.

**Demo/Validation**:

- lokales Bundle startet
- Signing-Status ist dokumentiert
- Distribution-Pfad ist reproduzierbar oder bewusst als noch manuell markiert

### Task 6.1: Versionierung und Bundle-Metadaten formalisieren

**Status**: umgesetzt am 2026-05-13. App-Metadaten und `Info.plist`-Vorlage liegen in `Packaging/`.

- **Location**:
  - `scripts/build-app-bundle.sh`
  - optional neu: `Packaging/Info.plist.template`
- **Description**: Version, Bundle-ID, App-Name und Minimum macOS zentral kontrollieren.
- **Complexity**: 4/10
- **Dependencies**: Sprint 3
- **Acceptance Criteria**:
  - keine hart verstreuten Metadaten
  - Bundle-Info bleibt per `plutil` gültig
- **Validation**:
  - `./scripts/app-bundle-smoke.sh`

### Task 6.2: Developer-ID-Signing-Checkliste erstellen

**Status**: umgesetzt am 2026-05-13 in `docs/distribution-checklist.md`.

- **Location**:
  - `docs/packaging-signing-plan.md`
  - optional `docs/distribution-checklist.md`
- **Description**: Voraussetzungen, Befehle und Geheimnisse für echte Signierung dokumentieren, ohne Zertifikate ins Repo zu legen.
- **Complexity**: 3/10
- **Dependencies**: Task 6.1
- **Acceptance Criteria**:
  - klarer Unterschied zwischen lokal ad-hoc und echter Distribution
  - keine Secrets oder Zertifikate im Repo
- **Validation**:
  - `./scripts/security-checks.sh`

### Task 6.3: Notarization-Probe vorbereiten

**Status**: umgesetzt am 2026-05-13 mit `scripts/notarization-preflight.sh`.

- **Location**:
  - `docs/distribution-checklist.md`
  - optional `scripts/notarization-preflight.sh`
- **Description**: Vorbedingungen und lokale Checks für spätere Notarization dokumentieren.
- **Complexity**: 5/10
- **Dependencies**: Task 6.2
- **Acceptance Criteria**:
  - Notarization wird nicht als Debug-Anforderung missverstanden
  - Preflight prüft Bundle, Signatur, Runtime und fehlende Secrets
- **Validation**:
  - `./scripts/hardened-runtime-smoke.sh`
  - Doku-Review

## Sprint 7: MVP-Abschluss und Beta-Readiness

**Status**: umgesetzt am 2026-05-13.

**Goal**: Das Projekt hat einen klaren, vorzeigbaren MVP-Stand und eine ehrliche Liste bekannter Grenzen.

**Demo/Validation**:

- neue Person kann Repo lesen, App starten und Hauptfluss verstehen
- App erklärt ihre Grenzen in UI und Doku
- Checks laufen grün

### Task 7.1: README auf echten Stand bringen

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `README.md`
- **Description**: README aktualisieren: aktueller Funktionsumfang, Startwege, Checks, Grenzen, nächste Schritte.
- **Complexity**: 3/10
- **Dependencies**: Sprint 6
- **Acceptance Criteria**:
  - keine veralteten Hinweise auf alte Roadmap-Pfade
  - Bundle-Start und SwiftPM-Start sind klar getrennt
- **Validation**:
  - Doku-Review

### Task 7.2: Known-Limits-Dokument schreiben

**Status**: umgesetzt am 2026-05-13 in `docs/known-limits.md`.

- **Location**:
  - neues `docs/known-limits.md`
- **Description**: Ehrlich beschreiben, was die App sieht und nicht sieht.
- **Complexity**: 3/10
- **Dependencies**: Sprint 4
- **Acceptance Criteria**:
  - Startup-Sensor-Grenzen sind klar
  - Sandbox-/Rechte-Grenzen sind klar
  - keine überzogenen Security-Versprechen
- **Validation**:
  - Review gegen `docs/project-learnings.md`

### Task 7.3: MVP-Release-Checkliste

**Status**: umgesetzt am 2026-05-13 in `docs/mvp-release-checklist.md`.

- **Location**:
  - neues `docs/mvp-release-checklist.md`
- **Description**: Eine konkrete Checkliste für einen Beta-Schnitt erstellen.
- **Complexity**: 4/10
- **Dependencies**: Sprint 6, Task 7.1, Task 7.2
- **Acceptance Criteria**:
  - Build-, Test-, Doku-, Security- und Packaging-Schritte sind enthalten
  - klare Stop-Kriterien für riskante Veränderungen
- **Validation**:
  - `./scripts/checks.sh`
  - `./scripts/app-bundle-smoke.sh`
  - `./scripts/hardened-runtime-smoke.sh`

## Testing Strategy

Jeder Sprint endet mit:

- `swift build`
- `swift test`
- `./scripts/security-checks.sh`
- `./scripts/e2e-smoke.sh`
- bevorzugt komplett: `./scripts/checks.sh`

Zusätzlich je nach Sprint:

- Packaging:
  - `./scripts/app-bundle-smoke.sh`
  - `./scripts/hardened-runtime-smoke.sh`
  - später neu: `./scripts/sandbox-smoke.sh`
- UI:
  - Store-/Presentation-Tests
  - manueller App-Smoke
  - später echte UI-Automation
- Sensoren:
  - Tests für leere Datenquelle
  - Tests für gültige Daten
  - Tests für kaputte/unlesbare Daten
  - Tests für eingeschränkte Sicht

## Documentation Strategy

Die Doku bleibt bewusst in drei Ebenen:

- `docs/session-status.md`: letzter Übergabestand und nächster Schritt
- `docs/project-learnings.md`: dauerhafte Erkenntnisse
- thematische Detaildokumente:
  - `docs/ui-ux-redesign-notes.md`
  - `docs/packaging-signing-plan.md`
  - `docs/next-sensor-selection.md`
  - `docs/safety-policy.md`

Nach jedem Sprint:

1. `docs/session-status.md` aktualisieren.
2. Neue dauerhafte Erkenntnisse in `docs/project-learnings.md` aufnehmen.
3. Falls ein Themenbereich betroffen ist, das passende Detaildokument aktualisieren.
4. `./scripts/checks.sh` laufen lassen.
5. Commit und Push.

## Potential Risks & Gotchas

- **Sandbox kann den ersten Sensor entwerten**: Wenn Sandbox die Startup-Pfade unsichtbar macht, muss das Produkt entweder ohne Sandbox starten oder den Sensor anders erklären.
- **UI-Automation kann ohne Xcode-Projekt schwer bleiben**: Falls SwiftPM-Bundling nicht reicht, muss ein Xcode-Projekt als bewusstes Packaging-Artefakt ergänzt werden.
- **Mehr Sensoren können die UI wieder unübersichtlich machen**: Zweiter Sensor erst nach Dashboard-Struktur und Gruppierung.
- **Severity kann Nutzer erschrecken**: Neue Änderungen sind wichtig, aber nicht automatisch gefährlich.
- **Baseline-Sprache ist technisch**: Nutzertexte sollen von "gemerktem Zustand" sprechen, nicht von Baseline oder Diff.
- **Distribution braucht echte Identitaet**: Ad-hoc-Signing ist nur lokal; Developer ID und Notarization bleiben separate Schritte.
- **Keine stillen Systemänderungen**: Guided Actions dürfen erst nach klarer Policy- und Consent-Schicht kommen.

## Rollback Plan

- UI-Änderungen:
  - kleine, separate Commits pro View
  - bei Problemen letzten UI-Commit revertieren
- Sensor-Änderungen:
  - Sensor hinter Pipeline-Registrierung entfernen
  - Tests für alten Sensor müssen weiter grün bleiben
- Packaging-Änderungen:
  - neue Scripts isoliert halten
  - Standard `swift build` und `swift test` dürfen nicht vom Packaging-Pfad abhängen
- Sandbox-/Signing-Änderungen:
  - Sandbox nur explizit aktivieren, nie als stiller Standard
  - Entitlements-Dateien klein und reviewbar halten

## Recommended Execution Order

1. Sprint 1: Orientierung und UX-Fokus
2. Sprint 2: Trust-Flow und UI-nahe Tests
3. Sprint 3: Sandbox- und Packaging-Entscheidung
4. Sprint 4: Zweiten Sensor bewusst auswählen und bauen
5. Sprint 5: Guided Actions ohne Systemrisiko
6. Sprint 6: Produktreife und Distribution
7. Sprint 7: MVP-Abschluss und Beta-Readiness

Die sieben Sprints sind umgesetzt. Der nächste konkrete Arbeitsschritt ist kein weiterer Roadmap-Sprint, sondern ein Beta-Schnitt nach `docs/mvp-release-checklist.md` und danach die Entscheidung über echte macOS-UI-Automation.
