# MVP Release Checklist

## Zweck

Diese Checkliste beschreibt einen ehrlichen Beta-/MVP-Schnitt.

Ein Punkt gilt nur dann als erledigt, wenn der Zustand reproduzierbar ist und die Doku nicht mehr vom Chatverlauf abhaengt.

Der konkrete Ablauf steht in `docs/beta-validation-plan.md`.

## Vor dem Schnitt

- `AGENTS.md` lesen
- `docs/session-status.md` aktualisieren
- `docs/project-learnings.md` pruefen
- `docs/known-limits.md` pruefen
- `README.md` auf Startwege und Grenzen pruefen

## Build und Tests

- `swift build`
- `swift test`
- `./scripts/checks.sh`
- `./scripts/app-bundle-smoke.sh`
- `./scripts/hardened-runtime-smoke.sh`
- `./scripts/sandbox-smoke.sh`
- `./scripts/notarization-preflight.sh`

## UI-Pruefung

Manuell pruefen:

- Dashboard startet deutsch
- Hinweise sind gruppiert
- Detailansicht erklaert zuerst, dann zeigt sie Belege
- Startup-Aenderungen koennen bewusst als erwartet gemerkt werden
- Settings zeigen gemerkte Entscheidungen und erlauben Reset
- Systemprofil-Hinweise klingen nicht wie ein Gesamturteil ueber den Mac

## Security-Grenzen

Stop-Kriterien:

- neue Entitlements ohne dokumentierten Nutzen
- Full Disk Access als Standardanforderung
- automatische Systemaenderung ohne explizite Zustimmung
- Shell-/AppleScript-/privilegierte Ausfuehrung fuer UI-Komfort
- Finding-Texte behaupten Gefahr ohne Beleg
- Zertifikate, Secrets oder echte Nutzerlogs im Repo

## Packaging

- `Packaging/AppMetadata.env` enthaelt korrekte Version und Bundle-ID
- `Packaging/Info.plist.template` erzeugt gueltige Bundle-Metadaten
- lokaler Build ist klar als ad-hoc signiert dokumentiert
- Developer-ID-Distribution ist nicht mit lokalem Debug-Build verwechselt
- Notarization ist vorbereitet, aber ohne echte Credentials nicht Teil des lokalen Standardlaufs

## Bekannte offene Punkte

- echte macOS-UI-Automation fehlt noch
- notarized Release-Artefakt fehlt noch
- Developer-ID-Signing fehlt noch
- moderne Background Items sind noch nicht produktiv abgedeckt
- Privacy-/TCC-Sensor ist bewusst verschoben

## Ergebnis

Ein MVP-Schnitt ist akzeptabel, wenn:

- alle lokalen Checks gruen sind
- README und Known Limits ehrlich sind
- keine neue Berechtigung still eingefuehrt wurde
- der Nutzer die Hauptansicht ohne Chat-Erklaerung versteht
