# Plan: Project Completion Roadmap

**Generated**: 2026-05-13  
**Estimated Complexity**: High

## Overview

`local-security-twin` ist aktuell ein funktionierender lokaler macOS-Prototyp mit einem echten Sensor, lokaler Baseline, deutscherer UI, App-Bundle-Smokes und Hardened-Runtime-Smoke.

Der Weg zur vervollstaendigten MVP-Version besteht nicht darin, schnell viele Sensoren anzubauen. Der richtige Weg ist:

1. erst die Nutzerfuehrung stabilisieren,
2. dann Packaging, Sandbox und UI-Automation absichern,
3. danach den zweiten Sensor bewusst auswaehlen,
4. erst spaeter echte Guided Actions und Distribution vorbereiten.

Das Ziel ist ein ruhiger Sicherheitsbegleiter, kein lauter Scanner.

## Product Completion Definition

Das Projekt gilt als MVP-fertig, wenn:

- ein normaler Nutzer den Startbildschirm ohne Erklaerung versteht
- mindestens zwei lokale, read-only Sensoren verstaendliche Hinweise liefern
- neue und erwartete Aenderungen nachvollziehbar getrennt sind
- Baseline-/Trust-Entscheidungen bewusst und reversibel wirken
- die App als lokales `.app`-Bundle stabil startet
- Sandbox-/Signing-Entscheidungen dokumentiert und getestet sind
- zentrale UI-Flows automatisiert oder bewusst als manuelle Checks dokumentiert sind
- keine unerklaerten macOS-Rechte angefordert werden
- alle Uebergabe-Dokumente aktuell sind

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

**Goal**: Die App soll fuer normale Nutzer in einem Blick erklaeren, was gerade wichtig ist.

**Demo/Validation**:

- `swift run LocalSecurityTwin`
- oder `.build/app/LocalSecurityTwin.app` nach `./scripts/app-bundle-smoke.sh`
- Manuell pruefen:
  - Startbildschirm ist deutsch
  - neue Aenderungen sind sofort sichtbar
  - bekannte Hinweise wirken nicht wie Panikmeldungen
  - Detailansicht beginnt mit Einordnung, nicht Rohdaten

### Task 1.1: UI-Texte vollstaendig inventarisieren

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features`
  - `Sources/LocalSecurityTwin/App/LocalSecurityTwinApp.swift`
- **Description**: Alle noch englischen Nutzertexte sammeln und in eine kurze Liste in `docs/ui-ux-redesign-notes.md` aufnehmen.
- **Complexity**: 2/10
- **Dependencies**: keine
- **Acceptance Criteria**:
  - Liste der noch offenen Nutzertexte ist dokumentiert
  - interne Code-Namen werden nicht unnoetig umbenannt
- **Validation**:
  - `rg '"[A-Za-z][^"]*"' Sources/LocalSecurityTwin`

### Task 1.2: Dashboard-Story schaerfen

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Dashboard/ContentView.swift`
  - `Sources/LocalSecurityTwin/Features/Dashboard/FindingPresentation.swift`
- **Description**: Startbereich so umbauen, dass er die drei Fragen beantwortet: Was ist neu? Was ist bekannt? Was ist der naechste sichere Schritt?
- **Complexity**: 5/10
- **Dependencies**: Task 1.1
- **Acceptance Criteria**:
  - Dashboard zeigt eine kurze Statuszusammenfassung
  - neue Startup-Aenderungen stehen vor bekannten Hinweisen
  - begrenzte Sichtbarkeit des Sensors wird ruhig erklaert
- **Validation**:
  - `swift test`
  - manueller App-Start

### Task 1.3: Detailansicht als Erklaerfluss gliedern

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Detail/FindingDetailView.swift`
- **Description**: Detailansicht in klare Abschnitte bringen: kurze Einordnung, sichtbare Details, Belege, naechster Schritt.
- **Complexity**: 5/10
- **Dependencies**: Task 1.2
- **Acceptance Criteria**:
  - Nutzer sieht zuerst eine alltagstaugliche Einordnung
  - Belege bleiben sichtbar, aber dominieren nicht die Seite
  - Texte behaupten nicht, dass ein sichtbarer Eintrag aktiv oder gefaehrlich ist
- **Validation**:
  - `swift test`
  - manueller Vergleich gegen Screenshot-Befund in `docs/ui-ux-redesign-notes.md`

### Task 1.4: Ruhigere Severity-Darstellung

**Status**: umgesetzt am 2026-05-13.

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Dashboard/FindingRowView.swift`
  - `Sources/LocalSecurityTwin/Features/Dashboard/FindingPresentation.swift`
- **Description**: Severity nicht als Alarm verkaufen, sondern als Einordnung. Neue Aenderungen duerfen wichtiger wirken als normale bekannte Daemons.
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

**Goal**: Der Nutzer kann Startup-Aenderungen bewusst als erwartet merken, und dieser Flow ist testbar.

**Demo/Validation**:

- App mit vorbereitetem Startup-Diff starten
- Aktion `Als erwartet merken` ausloesen
- pruefen, dass Diff-Hinweise danach verschwinden oder als bekannt eingeordnet werden

### Task 2.1: Testdaten fuer Startup-Diff-App-Start standardisieren

- **Location**:
  - `scripts/`
  - `Tests/LocalSecurityTwinE2ETests`
- **Description**: Einen wiederholbaren Testaufbau fuer lokale Startup-Diffs definieren, ohne echte Systemordner zu veraendern.
- **Complexity**: 5/10
- **Dependencies**: Sprint 1
- **Acceptance Criteria**:
  - Test nutzt temporaere HOME-/Application-Support-Pfade
  - keine echten LaunchAgent-Dateien werden veraendert
- **Validation**:
  - `swift test --filter E2E`

### Task 2.2: App-Bundle als UI-Testziel dokumentieren

- **Location**:
  - `docs/development-workflow.md`
  - `docs/packaging-signing-plan.md`
- **Description**: Festlegen, ob UI-nahe Tests zuerst ueber Bundle-Smoke, XCTest, Accessibility oder manuelle Checkliste laufen.
- **Complexity**: 3/10
- **Dependencies**: Task 2.1
- **Acceptance Criteria**:
  - ein bevorzugter UI-Testpfad ist dokumentiert
  - offener Xcode-Projektbedarf ist klar benannt
- **Validation**:
  - Doku-Review

### Task 2.3: Erster UI-naher Flow-Test

- **Location**:
  - `Tests/LocalSecurityTwinE2ETests`
  - optional `scripts/`
- **Description**: Den wichtigsten Flow testen: Findings geladen, Startup-Diff sichtbar, Merken-Aktion verfuegbar, Folgezustand ruhig.
- **Complexity**: 6/10
- **Dependencies**: Task 2.1, Task 2.2
- **Acceptance Criteria**:
  - Test laeuft reproduzierbar lokal
  - bei fehlender echter UI-Automation existiert mindestens ein Store-/Presentation-naher Ersatztest plus manuelle Checkliste
- **Validation**:
  - `./scripts/checks.sh`

## Sprint 3: Sandbox- und Packaging-Entscheidung

**Goal**: Das Projekt weiss, ob Sandbox fuer den MVP realistisch ist und ob SwiftPM-Bundling reicht.

**Demo/Validation**:

- App startet ohne Sandbox
- App startet mit Sandbox-Testsignatur oder dokumentiertem Gegenbeweis
- Startup-Sensor-Sichtbarkeit wird verglichen

### Task 3.1: Minimale Entitlements-Datei fuer lokale Sandbox-Tests anlegen

- **Location**:
  - neu: `Packaging/LocalSecurityTwin.entitlements`
  - `scripts/build-app-bundle.sh`
- **Description**: Optionales lokales Signing mit Entitlements ermoeglichen, ohne Sandbox standardmaessig zu aktivieren.
- **Complexity**: 5/10
- **Dependencies**: Sprint 2 nicht zwingend, aber empfohlen
- **Acceptance Criteria**:
  - Standard-Bundle bleibt ohne Sandbox
  - Sandbox kann explizit fuer Tests aktiviert werden
  - keine Network-, Accessibility-, Apple-Events- oder Full-Disk-Access-Entitlements
- **Validation**:
  - `codesign -d --entitlements :- .build/app/LocalSecurityTwin.app`

### Task 3.2: Sandbox-Smoke gegen Startup-Sensor

- **Location**:
  - neu: `scripts/sandbox-smoke.sh`
  - `docs/packaging-signing-plan.md`
- **Description**: App mit Sandbox starten und dokumentieren, ob sichtbare Startup-Pfade weiter lesbar sind.
- **Complexity**: 6/10
- **Dependencies**: Task 3.1
- **Acceptance Criteria**:
  - Ergebnis ist eindeutig dokumentiert
  - bei eingeschraenkter Sicht gibt es eine ruhige Sensor-Note oder Produktentscheidung
- **Validation**:
  - `./scripts/sandbox-smoke.sh`
  - `./scripts/checks.sh`

### Task 3.3: SwiftPM-Bundle vs. Xcode-Projekt entscheiden

- **Location**:
  - `docs/packaging-signing-plan.md`
  - optional neues `docs/xcode-project-decision.md`
- **Description**: Entscheiden, ob fuer UI-Tests, Signing und spaetere Distribution ein Xcode-Projekt noetig wird.
- **Complexity**: 4/10
- **Dependencies**: Task 3.2
- **Acceptance Criteria**:
  - Entscheidung mit Gruenden dokumentiert
  - naechster Packaging-Schritt ist eindeutig
- **Validation**:
  - Doku-Review

## Sprint 4: Zweiten Sensor bewusst auswaehlen und bauen

**Goal**: Der MVP bekommt eine zweite lokale Sicht, ohne Rechteumfang unnoetig zu vergroessern.

**Demo/Validation**:

- Dashboard zeigt Hinweise aus zwei Sensoren
- beide Sensoren erklaeren ihre Grenzen
- keine zusaetzlichen macOS-Rechte werden still gefordert

### Task 4.1: Sensor-Kandidaten final bewerten

- **Location**:
  - `docs/next-sensor-selection.md`
- **Description**: Privacy-Permissions-Sichtbarkeit, moderne Background Items und lokale Exposure Checks gegen Kriterien bewerten.
- **Complexity**: 3/10
- **Dependencies**: Sprint 3
- **Acceptance Criteria**:
  - ein Sensor wird fuer MVP 2 ausgewaehlt
  - nicht gewaehlte Kandidaten haben klare Gruende
- **Validation**:
  - Doku-Review

### Task 4.2: Sensor-Design-Plan schreiben

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

- **Location**:
  - `Sources/LocalSecurityTwin/Sensors/<SensorName>/`
  - `Sources/LocalSecurityTwin/Core/Sensors/FindingStore.swift`
  - `Tests/LocalSecurityTwinTests/`
- **Description**: Sensor an bestehenden `FindingSensor`-Vertrag anbinden und in der Pipeline sichtbar machen.
- **Complexity**: 7/10
- **Dependencies**: Task 4.2
- **Acceptance Criteria**:
  - Sensor liefert Findings mit Evidence und Recommendation
  - Sensor erklaert eingeschraenkte Sicht
  - Tests fuer positive, leere und Fehlerfaelle
- **Validation**:
  - `swift test`
  - `./scripts/checks.sh`

### Task 4.4: UI-Gruppierung fuer mehrere Sensoren

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Dashboard`
  - `Sources/LocalSecurityTwin/Features/Detail`
- **Description**: Dashboard so erweitern, dass mehrere Sensorbereiche nicht unuebersichtlich werden.
- **Complexity**: 6/10
- **Dependencies**: Task 4.3
- **Acceptance Criteria**:
  - Nutzer erkennt Quelle und Bedeutung eines Hinweises
  - mehrere Sensoren erzeugen keine lange, flache Rohdatenliste
- **Validation**:
  - `swift test`
  - manueller UI-Smoke

## Sprint 5: Guided Actions ohne Systemrisiko

**Goal**: Empfehlungen werden nuetzlicher, ohne echte Systemaenderungen zu verstecken.

**Demo/Validation**:

- Detailansicht zeigt sichere naechste Schritte
- Aktion erklaert, ob sie nur merkt, oeffnet oder spaeter etwas aendern koennte

### Task 5.1: Aktionsarten definieren

- **Location**:
  - `Sources/LocalSecurityTwin/Core/Policy/`
  - `docs/safety-policy.md`
- **Description**: Klare Typen fuer Aktionen: nur merken, extern oeffnen, Anleitung anzeigen, spaeter validieren.
- **Complexity**: 5/10
- **Dependencies**: Sprint 4
- **Acceptance Criteria**:
  - keine Aktion fuehrt still Systemaenderungen aus
  - jede Aktion hat Consent-Anforderung
- **Validation**:
  - `swift test`

### Task 5.2: Erklaer-Dialog fuer vertrauensrelevante Aktionen

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Detail`
  - `Sources/LocalSecurityTwin/Core/Policy`
- **Description**: Vor dem Merken oder spaeteren Handeln kurz erklaeren, was die App tut und was nicht.
- **Complexity**: 6/10
- **Dependencies**: Task 5.1
- **Acceptance Criteria**:
  - Nutzer bestaetigt bewusst
  - Text vermeidet technische Woerter wie Baseline und Diff
- **Validation**:
  - Store-/Presentation-Test
  - manueller UI-Smoke

### Task 5.3: Policy-Historie sichtbar machen

- **Location**:
  - `Sources/LocalSecurityTwin/Features/Settings/SettingsView.swift`
  - `Sources/LocalSecurityTwin/Core/Policy`
- **Description**: Settings zeigen, welche Entscheidungen lokal gemerkt wurden, mit Reset-Moeglichkeit.
- **Complexity**: 6/10
- **Dependencies**: Task 5.2
- **Acceptance Criteria**:
  - Nutzer kann lokale Entscheidungen sehen und loeschen
  - keine Cloud-Abhaengigkeit
- **Validation**:
  - `swift test`
  - manueller Settings-Smoke

## Sprint 6: Produktreife und Distribution

**Goal**: Die App wird als testbare MVP-App verteilbar, ohne die Sicherheitsgrenzen zu verwischen.

**Demo/Validation**:

- lokales Bundle startet
- Signing-Status ist dokumentiert
- Distribution-Pfad ist reproduzierbar oder bewusst als noch manuell markiert

### Task 6.1: Versionierung und Bundle-Metadaten formalisieren

- **Location**:
  - `scripts/build-app-bundle.sh`
  - optional neu: `Packaging/Info.plist.template`
- **Description**: Version, Bundle-ID, App-Name und Minimum macOS zentral kontrollieren.
- **Complexity**: 4/10
- **Dependencies**: Sprint 3
- **Acceptance Criteria**:
  - keine hart verstreuten Metadaten
  - Bundle-Info bleibt per `plutil` gueltig
- **Validation**:
  - `./scripts/app-bundle-smoke.sh`

### Task 6.2: Developer-ID-Signing-Checkliste erstellen

- **Location**:
  - `docs/packaging-signing-plan.md`
  - optional `docs/distribution-checklist.md`
- **Description**: Voraussetzungen, Befehle und Geheimnisse fuer echte Signierung dokumentieren, ohne Zertifikate ins Repo zu legen.
- **Complexity**: 3/10
- **Dependencies**: Task 6.1
- **Acceptance Criteria**:
  - klarer Unterschied zwischen lokal ad-hoc und echter Distribution
  - keine Secrets oder Zertifikate im Repo
- **Validation**:
  - `./scripts/security-checks.sh`

### Task 6.3: Notarization-Probe vorbereiten

- **Location**:
  - `docs/distribution-checklist.md`
  - optional `scripts/notarization-preflight.sh`
- **Description**: Vorbedingungen und lokale Checks fuer spaetere Notarization dokumentieren.
- **Complexity**: 5/10
- **Dependencies**: Task 6.2
- **Acceptance Criteria**:
  - Notarization wird nicht als Debug-Anforderung missverstanden
  - Preflight prueft Bundle, Signatur, Runtime und fehlende Secrets
- **Validation**:
  - `./scripts/hardened-runtime-smoke.sh`
  - Doku-Review

## Sprint 7: MVP-Abschluss und Beta-Readiness

**Goal**: Das Projekt hat einen klaren, vorzeigbaren MVP-Stand und eine ehrliche Liste bekannter Grenzen.

**Demo/Validation**:

- neue Person kann Repo lesen, App starten und Hauptfluss verstehen
- App erklaert ihre Grenzen in UI und Doku
- Checks laufen gruen

### Task 7.1: README auf echten Stand bringen

- **Location**:
  - `README.md`
- **Description**: README aktualisieren: aktueller Funktionsumfang, Startwege, Checks, Grenzen, naechste Schritte.
- **Complexity**: 3/10
- **Dependencies**: Sprint 6
- **Acceptance Criteria**:
  - keine veralteten Hinweise auf alte Roadmap-Pfade
  - Bundle-Start und SwiftPM-Start sind klar getrennt
- **Validation**:
  - Doku-Review

### Task 7.2: Known-Limits-Dokument schreiben

- **Location**:
  - neues `docs/known-limits.md`
- **Description**: Ehrlich beschreiben, was die App sieht und nicht sieht.
- **Complexity**: 3/10
- **Dependencies**: Sprint 4
- **Acceptance Criteria**:
  - Startup-Sensor-Grenzen sind klar
  - Sandbox-/Rechte-Grenzen sind klar
  - keine ueberzogenen Security-Versprechen
- **Validation**:
  - Review gegen `docs/project-learnings.md`

### Task 7.3: MVP-Release-Checkliste

- **Location**:
  - neues `docs/mvp-release-checklist.md`
- **Description**: Eine konkrete Checkliste fuer einen Beta-Schnitt erstellen.
- **Complexity**: 4/10
- **Dependencies**: Sprint 6, Task 7.1, Task 7.2
- **Acceptance Criteria**:
  - Build-, Test-, Doku-, Security- und Packaging-Schritte sind enthalten
  - klare Stop-Kriterien fuer riskante Veraenderungen
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

Zusaetzlich je nach Sprint:

- Packaging:
  - `./scripts/app-bundle-smoke.sh`
  - `./scripts/hardened-runtime-smoke.sh`
  - spaeter neu: `./scripts/sandbox-smoke.sh`
- UI:
  - Store-/Presentation-Tests
  - manueller App-Smoke
  - spaeter echte UI-Automation
- Sensoren:
  - Tests fuer leere Datenquelle
  - Tests fuer gueltige Daten
  - Tests fuer kaputte/unlesbare Daten
  - Tests fuer eingeschraenkte Sicht

## Documentation Strategy

Die Doku bleibt bewusst in drei Ebenen:

- `docs/session-status.md`: letzter Uebergabestand und naechster Schritt
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

- **Sandbox kann den ersten Sensor entwerten**: Wenn Sandbox die Startup-Pfade unsichtbar macht, muss das Produkt entweder ohne Sandbox starten oder den Sensor anders erklaeren.
- **UI-Automation kann ohne Xcode-Projekt schwer bleiben**: Falls SwiftPM-Bundling nicht reicht, muss ein Xcode-Projekt als bewusstes Packaging-Artefakt ergaenzt werden.
- **Mehr Sensoren koennen die UI wieder unuebersichtlich machen**: Zweiter Sensor erst nach Dashboard-Struktur und Gruppierung.
- **Severity kann Nutzer erschrecken**: Neue Aenderungen sind wichtig, aber nicht automatisch gefaehrlich.
- **Baseline-Sprache ist technisch**: Nutzertexte sollen von "gemerktem Zustand" sprechen, nicht von Baseline oder Diff.
- **Distribution braucht echte Identitaet**: Ad-hoc-Signing ist nur lokal; Developer ID und Notarization bleiben separate Schritte.
- **Keine stillen Systemaenderungen**: Guided Actions duerfen erst nach klarer Policy- und Consent-Schicht kommen.

## Rollback Plan

- UI-Aenderungen:
  - kleine, separate Commits pro View
  - bei Problemen letzten UI-Commit revertieren
- Sensor-Aenderungen:
  - Sensor hinter Pipeline-Registrierung entfernen
  - Tests fuer alten Sensor muessen weiter gruen bleiben
- Packaging-Aenderungen:
  - neue Scripts isoliert halten
  - Standard `swift build` und `swift test` duerfen nicht vom Packaging-Pfad abhaengen
- Sandbox-/Signing-Aenderungen:
  - Sandbox nur explizit aktivieren, nie als stiller Standard
  - Entitlements-Dateien klein und reviewbar halten

## Recommended Execution Order

1. Sprint 1: Orientierung und UX-Fokus
2. Sprint 2: Trust-Flow und UI-nahe Tests
3. Sprint 3: Sandbox- und Packaging-Entscheidung
4. Sprint 4: Zweiten Sensor bewusst auswaehlen und bauen
5. Sprint 5: Guided Actions ohne Systemrisiko
6. Sprint 6: Produktreife und Distribution
7. Sprint 7: MVP-Abschluss und Beta-Readiness

Der naechste konkrete Arbeitsschritt ist Sprint 1, Task 1.1.
