# Workflow Checks

## Standard Check

Nach nicht-trivialen Änderungen:

```bash
python3 scripts/agent_finish.py
```

Dieser Guard-Check prüft die Workflow-Dokumente und führt anschließend den Projektstandard aus:

```bash
./scripts/checks.sh
```

## Direkte Projektchecks

Wenn nur gezielt geprüft werden soll:

```bash
swift test
./scripts/security-checks.sh
./scripts/e2e-smoke.sh
./scripts/build-app-bundle.sh
```

Für Packaging-nahe Änderungen zusätzlich:

```bash
./scripts/app-bundle-smoke.sh
./scripts/sandbox-smoke.sh
./scripts/hardened-runtime-smoke.sh
```

## Pflichtdateien des Guards

- `AGENTS.md`
- `WORKFLOWS.md`
- `KNOWN_ERRORS.md`
- `CHECKS.md`
- `scripts/workflow_check.py`
- `scripts/agent_finish.py`

## Erwartung

Ein Agent soll nach abgeschlossenen Änderungen:

- passende Checks ausführen
- `docs/session-status.md` aktualisieren
- `docs/project-learnings.md` nur bei dauerhaften Erkenntnissen aktualisieren
- Guard-Dokumente aktualisieren, wenn Startbefehle, Outputs, Abhängigkeiten oder Fehlerfälle geändert wurden
- Fehlschläge konkret berichten, statt Erfolg zu behaupten
