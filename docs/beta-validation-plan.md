# Beta Validation Plan

## Ziel

Dieser Plan beschreibt den nächsten Schritt nach der umgesetzten Roadmap.

Es geht jetzt nicht darum, sofort neue Features zu bauen. Es geht darum, den aktuellen MVP ehrlich zu prüfen:

- läuft die App stabil?
- versteht man die App ohne Chat-Erklärung?
- sind die Grenzen klar?
- gibt es einen Beta-Stand, den man verantworten kann?

## Rollen

### Codex

Codex prüft alles, was reproduzierbar und technisch messbar ist:

- Build
- Unit-Tests
- E2E-Smokes
- Security-Checks
- App-Bundle-Smoke
- Hardened-Runtime-Smoke
- Sandbox-Smoke
- Notarization-Preflight
- Doku-Konsistenz

### Nutzer

Du prüfst alles, was echte Nutzerwahrnehmung braucht:

- verstehst du die Startansicht?
- ist die App ruhig genug?
- ist Deutsch und Ton passend?
- findest du den roten Faden?
- ist klar, was wichtig ist und was nicht?
- fuehlt sich ein Button sicher und nachvollziehbar an?

## Phase 1: Technischer Beta-Check

Codex führt aus:

```bash
swift build
swift test
./scripts/checks.sh
./scripts/app-bundle-smoke.sh
./scripts/hardened-runtime-smoke.sh
./scripts/sandbox-smoke.sh
./scripts/notarization-preflight.sh
```

Ergebnis:

- alle Checks grün: weiter zu Phase 2
- ein Check rot: erst fixen, dann erneut prüfen

## Phase 2: App manuell starten

Du startest die App lokal als Bundle:

```bash
./scripts/build-app-bundle.sh
open .build/app/LocalSecurityTwin.app
```

Bitte prüfen:

- startet die App sichtbar?
- wirkt der erste Bildschirm deutsch?
- erkennst du sofort, was die App dir sagen will?
- sind Hinweise gruppiert statt wie eine rohe Liste?
- ist klar, was neu, bekannt oder nur zur Beobachtung ist?

Notiere kurz:

- was ist klar?
- was ist verwirrend?
- welcher Text klingt noch zu technisch?
- wo fehlt Orientierung?

## Phase 3: Startup-Änderung testen

Du startest den vorbereiteten Demo-Flow:

```bash
./scripts/start-startup-diff-demo.sh
```

Bitte prüfen:

- zeigt das Dashboard eine Autostart-Änderung?
- erscheint die Aktion `Als erwartet merken`?
- erklärt der Dialog, dass keine Systemeinstellungen geändert werden?
- wird die Ansicht danach ruhiger?
- ist der Ablauf für dich logisch?

Stop-Kriterium:

Wenn du nicht verstehst, was "als erwartet merken" bedeutet, ist das ein UX-Blocker für Beta.

## Phase 4: Detailansicht prüfen

Du öffnest mehrere Hinweise und prüfst:

- steht zuerst eine einfache Erklärung?
- kommen Belege erst danach?
- ist klar, dass sichtbar nicht automatisch gefährlich heißt?
- klingt der Systemprofil-Hinweis nicht wie ein Gesamturteil über deinen Mac?
- ist der nächste sichere Schritt konkret genug?

Stop-Kriterium:

Wenn ein Finding Angst macht, obwohl nur ein sichtbarer Hinweis vorliegt, muss der Text vor Beta geändert werden.

## Phase 5: Settings und gemerkte Entscheidungen

Du prüfst die Settings:

- siehst du gemerkte Entscheidungen?
- kannst du einzelne Entscheidungen zurücksetzen?
- kannst du alle gemerkten Entscheidungen löschen?
- ist klar, dass alles lokal bleibt?

Stop-Kriterium:

Wenn eine gemerkte Entscheidung nicht sichtbar oder nicht löschbar ist, ist das ein Beta-Blocker.

## Phase 6: Grenzen gegenlesen

Du liest:

- `README.md`
- `docs/known-limits.md`
- `docs/mvp-release-checklist.md`

Bitte prüfen:

- ist klar, was die App kann?
- ist klar, was sie nicht kann?
- wirkt irgendwo ein Sicherheitsversprechen zu groß?
- fehlt ein wichtiger Warnhinweis?

Stop-Kriterium:

Wenn die Doku mehr verspricht als die App wirklich sieht, muss die Doku vor Beta korrigiert werden.

## Phase 7: Entscheidung

Nach den Checks gibt es drei mögliche Ergebnisse.

### Ergebnis A: Beta bereit

Voraussetzungen:

- alle technischen Checks grün
- du verstehst die Hauptansicht ohne Erklärung
- Trust-Flow wirkt sicher
- Known Limits sind ehrlich

Nächster Schritt:

- Beta-Tag oder Release-Branch vorbereiten
- optional Screenshot-/Demo-Doku erstellen

### Ergebnis B: Beta fast bereit

Typisch:

- Checks grün
- aber UI-Texte oder Orientierung brauchen Feinschliff

Nächster Schritt:

- kleine UX-Korrekturen
- danach Phasen 2 bis 6 erneut prüfen

### Ergebnis C: Nicht beta-bereit

Typisch:

- technische Checks rot
- Trust-Flow unklar
- App wirkt weiterhin wie Rohdaten
- Grenzen sind nicht verständlich

Nächster Schritt:

- kein Beta-Schnitt
- Blocker in `docs/session-status.md` dokumentieren
- gezielten Fix-Sprint planen

## Danach

Erst nach dieser Beta-Prüfung entscheiden wir über:

- echte macOS-UI-Automation
- Xcode-Projekt
- Developer-ID-Signing
- neue Sensoren
- Privacy-/TCC-Sensor
- moderne Background Items

## Ergebnisnotizen für den Nutzer

Beim manuellen Test reicht diese kurze Vorlage:

```text
Beta-Test Datum:

Startbild:
- Verstanden:
- Unklar:

Startup-Änderung:
- Flow verstanden: ja/nein
- Text "Als erwartet merken" klar: ja/nein
- Was war unklar:

Detailansicht:
- Wirkt ruhig: ja/nein
- Zu technisch:
- Fehlender nächster Schritt:

Settings:
- Entscheidungen sichtbar: ja/nein
- Reset klar: ja/nein

Known Limits:
- Verspricht die Doku zu viel:
- Fehlt eine Grenze:

Beta-Gefuehl:
- bereit / fast bereit / nicht bereit
- wichtigste Korrektur vor Beta:
```
