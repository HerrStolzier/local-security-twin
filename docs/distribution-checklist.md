# Distribution Checklist

## Zweck

Diese Checkliste trennt lokale Entwicklungsbuilds von echter Verteilung.

Aktuell baut das Projekt ein lokales `.app`-Bundle mit ad-hoc Signatur. Das ist gut für Entwicklung, Smoke-Tests und interne Spikes. Es ist noch kein notarized Release für normale Nutzer.

## Lokaler Beta-Schnitt

Vor einem lokalen Beta-Schnitt:

- `./scripts/checks.sh`
- `./scripts/app-bundle-smoke.sh`
- `./scripts/hardened-runtime-smoke.sh`
- `./scripts/notarization-preflight.sh`
- `docs/session-status.md` aktualisieren
- `docs/known-limits.md` prüfen

## Developer-ID-Distribution

Für echte Verteilung außerhalb des Mac App Store braucht das Projekt später:

- Apple Developer Team
- Developer-ID-Application-Zertifikat im lokalen Keychain
- stabile Bundle-ID aus `Packaging/AppMetadata.env`
- Hardened Runtime
- Notarization mit Apple Notary Service
- kein Zertifikat, kein Passwort und kein API-Key im Repo

## Was nicht ins Repo gehört

- `.p12`-Zertifikate
- Private Keys
- Notary API Keys
- App-spezifische Passwoerter
- Team-Geheimnisse
- reale Nutzer-Logs

## Preflight statt Notarization

`scripts/notarization-preflight.sh` führt keine echte Notarization aus.

Der Preflight prüft nur lokal:

- Bundle baut
- `Info.plist` ist gültig
- Code-Signatur ist prüfbar
- Hardened Runtime ist sichtbar
- Security-Checks finden keine offensichtlichen Repo-Probleme

Erst wenn echte Developer-ID-Zugangsdaten vorhanden sind, wird daraus ein richtiger Notarization-Schritt.
