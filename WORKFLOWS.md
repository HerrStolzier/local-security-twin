# Workflow Register

## Sento Guard Local macOS Workflow

### Zweck

Sento Guard ist eine lokale SwiftPM-basierte macOS-App. Dieser Workflow beschreibt, wie ein Agent Änderungen am Projekt sauber vorbereitet, prüft und übergabefähig macht.

### Start

```bash
swift build
```

Für eine lokal startbare App:

```bash
./scripts/build-app-bundle.sh
open -n .build/app/LocalSecurityTwin.app
```

### Input

- Swift-Quellcode unter `Sources/LocalSecurityTwin`
- Tests unter `Tests/LocalSecurityTwinTests` und `Tests/LocalSecurityTwinE2ETests`
- lokale App-/Packaging-Skripte unter `scripts/`
- Projektübergabe in `docs/session-status.md`

### Output

- gebautes SwiftPM-Executable unter `.build/`
- optionales lokales App-Bundle unter `.build/app/LocalSecurityTwin.app`
- aktualisierte Projekt- und Übergabedokumentation bei abgeschlossenen Schritten

### Wichtige Dateien

- `AGENTS.md`: stabile Projektregeln und Arbeitsweise für Agenten
- `docs/session-status.md`: aktueller Übergabestand nach jedem abgeschlossenen Schritt
- `docs/project-learnings.md`: dauerhafte Erkenntnisse
- `scripts/checks.sh`: Standardcheck für Build, Tests, Security-Checks und E2E-Smokes
- `scripts/agent_finish.py`: Guard-Finish-Check für Agenten
- `CHECKS.md`: menschenlesbare Check-Liste
- `KNOWN_ERRORS.md`: bekannte reale Fehlerbilder und Lösungen

### Abhängigkeiten

- macOS
- SwiftPM / Swift 6 Toolchain
- Python 3 für den Workflow Guard
- lokale Apple-Tools wie `plutil`, `codesign` und `open` für Bundle-Smokes

### Bekannte Fehlerfälle

- Ein kaputter lokaler SOFA-Cache oder kaputte lokale Policy-/Hygiene-Dateien dürfen nicht still verschwinden; die App muss eine ruhige Sichtgrenze melden.
- Echte UI-Klickautomation ist weiterhin nicht als stabiler Standardcheck vorhanden.
- Bundle-/Sandbox-/Hardened-Smokes können an lokalen macOS-Signing- oder Prozessstartbedingungen scheitern und müssen dann konkret gemeldet werden.

### Prüfung

```bash
python3 scripts/agent_finish.py
```

Der Guard ruft den projektweiten Standardcheck auf:

```bash
./scripts/checks.sh
```

### Letzter Review

2026-05-21
