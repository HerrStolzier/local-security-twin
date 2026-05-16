# Local Security Twin

Local-first macOS security companion für normale Nutzer.

Die App soll lokale Sicherheits- und Privacy-Hinweise ruhig erklären: was sichtbar ist, warum es relevant sein kann und was der nächste sichere Schritt ist. Sie ist kein lauter Scanner und nimmt keine stillen Systemänderungen vor.

## Aktueller Stand

Der aktuelle MVP-Prototyp ist eine SwiftPM-basierte SwiftUI-macOS-App mit:

- Menüleisten-App, Hauptfenster und Settings
- deutschem Dashboard und deutscher Finding-Detailansicht
- lokalem Policy-/Consent-Modell mit gemerkten Entscheidungen
- normalisiertem Finding-Schema mit Evidence und Recommendations
- Sensor-Pipeline mit zwei read-only Sensorbereichen
- Startup-Sensor für sichtbare `LaunchAgents`-/`LaunchDaemons`-`plist`-Dateien
- lokaler Startup-Baseline und bewusstem "als erwartet merken"-Flow
- Systemprofil-Sensor für lokale Basisdaten, Gatekeeper und SIP, ohne neue Rechte
- lokalen Bundle-, Sandbox-, Hardened-Runtime- und Preflight-Smokes

## Was die App bewusst nicht macht

- keine stillen Systemänderungen
- keine Cloud-Pflicht
- kein Full Disk Access im MVP
- keine Accessibility-, Screen-Recording-, Network- oder Apple-Events-Entitlements
- keine echte Notarization ohne Developer-ID-Zugangsdaten
- keine Behauptung, dass sichtbare Hinweise automatisch gefährlich sind

Mehr dazu steht in `docs/known-limits.md`.

## Anforderungen

- macOS 15 oder neuer
- Xcode 26.5 oder kompatible Swift-6-Toolchain
- SwiftPM

## Starten

Direkt aus SwiftPM:

```bash
swift run LocalSecurityTwin
```

Als lokales `.app`-Bundle:

```bash
./scripts/build-app-bundle.sh
open .build/app/LocalSecurityTwin.app
```

Manueller Startup-Diff-Demo-Flow:

```bash
./scripts/start-startup-diff-demo.sh
```

## Checks

Standardlauf vor Commits:

```bash
./scripts/checks.sh
```

Packaging-Smokes:

```bash
./scripts/app-bundle-smoke.sh
./scripts/hardened-runtime-smoke.sh
./scripts/sandbox-smoke.sh
./scripts/notarization-preflight.sh
```

`notarization-preflight.sh` führt keine echte Apple-Notarization aus. Es prüft lokal Bundle, Signatur, Hardened Runtime und Security-Checks.

## Wichtige Doku

- `AGENTS.md`: stabile Projektregeln und Arbeitsweise
- `docs/session-status.md`: aktueller Übergabestand
- `docs/project-learnings.md`: dauerhafte Erkenntnisse
- `docs/project-completion-plan.md`: Sprint-Plan zum MVP
- `docs/known-limits.md`: ehrliche Grenzen der App
- `docs/mvp-release-checklist.md`: Beta-/MVP-Checkliste
- `docs/packaging-signing-plan.md`: Signing, Sandbox und Distribution
- `docs/distribution-checklist.md`: lokaler Beta-Schnitt vs. echte Distribution

## Nächste sinnvolle Schritte

1. Echte macOS-UI-Automation klären.
2. Beta-Schnitt anhand `docs/mvp-release-checklist.md` vorbereiten.
3. Danach erst neue Sensoren planen, mit denselben Grenzen: read-only, erklärend, ohne unnötige Rechte.

## License

MIT
