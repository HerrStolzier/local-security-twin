# Beta Validation Plan

## Ziel

Dieser Plan beschreibt den naechsten Schritt nach der umgesetzten Roadmap.

Es geht jetzt nicht darum, sofort neue Features zu bauen. Es geht darum, den aktuellen MVP ehrlich zu pruefen:

- laeuft die App stabil?
- versteht man die App ohne Chat-Erklaerung?
- sind die Grenzen klar?
- gibt es einen Beta-Stand, den man verantworten kann?

## Rollen

### Codex

Codex prueft alles, was reproduzierbar und technisch messbar ist:

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

Du pruefst alles, was echte Nutzerwahrnehmung braucht:

- verstehst du die Startansicht?
- ist die App ruhig genug?
- ist Deutsch und Ton passend?
- findest du den roten Faden?
- ist klar, was wichtig ist und was nicht?
- fuehlt sich ein Button sicher und nachvollziehbar an?

## Phase 1: Technischer Beta-Check

Codex fuehrt aus:

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

- alle Checks gruen: weiter zu Phase 2
- ein Check rot: erst fixen, dann erneut pruefen

## Phase 2: App manuell starten

Du startest die App lokal als Bundle:

```bash
./scripts/build-app-bundle.sh
open .build/app/LocalSecurityTwin.app
```

Bitte pruefen:

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

## Phase 3: Startup-Aenderung testen

Du startest den vorbereiteten Demo-Flow:

```bash
./scripts/start-startup-diff-demo.sh
```

Bitte pruefen:

- zeigt das Dashboard eine Autostart-Aenderung?
- erscheint die Aktion `Als erwartet merken`?
- erklaert der Dialog, dass keine Systemeinstellungen geaendert werden?
- wird die Ansicht danach ruhiger?
- ist der Ablauf fuer dich logisch?

Stop-Kriterium:

Wenn du nicht verstehst, was "als erwartet merken" bedeutet, ist das ein UX-Blocker fuer Beta.

## Phase 4: Detailansicht pruefen

Du oeffnest mehrere Hinweise und pruefst:

- steht zuerst eine einfache Erklaerung?
- kommen Belege erst danach?
- ist klar, dass sichtbar nicht automatisch gefaehrlich heisst?
- klingt der Systemprofil-Hinweis nicht wie ein Gesamturteil ueber deinen Mac?
- ist der naechste sichere Schritt konkret genug?

Stop-Kriterium:

Wenn ein Finding Angst macht, obwohl nur ein sichtbarer Hinweis vorliegt, muss der Text vor Beta geaendert werden.

## Phase 5: Settings und gemerkte Entscheidungen

Du pruefst die Settings:

- siehst du gemerkte Entscheidungen?
- kannst du einzelne Entscheidungen zuruecksetzen?
- kannst du alle gemerkten Entscheidungen loeschen?
- ist klar, dass alles lokal bleibt?

Stop-Kriterium:

Wenn eine gemerkte Entscheidung nicht sichtbar oder nicht loeschbar ist, ist das ein Beta-Blocker.

## Phase 6: Grenzen gegenlesen

Du liest:

- `README.md`
- `docs/known-limits.md`
- `docs/mvp-release-checklist.md`

Bitte pruefen:

- ist klar, was die App kann?
- ist klar, was sie nicht kann?
- wirkt irgendwo ein Sicherheitsversprechen zu gross?
- fehlt ein wichtiger Warnhinweis?

Stop-Kriterium:

Wenn die Doku mehr verspricht als die App wirklich sieht, muss die Doku vor Beta korrigiert werden.

## Phase 7: Entscheidung

Nach den Checks gibt es drei moegliche Ergebnisse.

### Ergebnis A: Beta bereit

Voraussetzungen:

- alle technischen Checks gruen
- du verstehst die Hauptansicht ohne Erklaerung
- Trust-Flow wirkt sicher
- Known Limits sind ehrlich

Naechster Schritt:

- Beta-Tag oder Release-Branch vorbereiten
- optional Screenshot-/Demo-Doku erstellen

### Ergebnis B: Beta fast bereit

Typisch:

- Checks gruen
- aber UI-Texte oder Orientierung brauchen Feinschliff

Naechster Schritt:

- kleine UX-Korrekturen
- danach Phasen 2 bis 6 erneut pruefen

### Ergebnis C: Nicht beta-bereit

Typisch:

- technische Checks rot
- Trust-Flow unklar
- App wirkt weiterhin wie Rohdaten
- Grenzen sind nicht verstaendlich

Naechster Schritt:

- kein Beta-Schnitt
- Blocker in `docs/session-status.md` dokumentieren
- gezielten Fix-Sprint planen

## Danach

Erst nach dieser Beta-Pruefung entscheiden wir ueber:

- echte macOS-UI-Automation
- Xcode-Projekt
- Developer-ID-Signing
- neue Sensoren
- Privacy-/TCC-Sensor
- moderne Background Items

## Ergebnisnotizen fuer den Nutzer

Beim manuellen Test reicht diese kurze Vorlage:

```text
Beta-Test Datum:

Startbild:
- Verstanden:
- Unklar:

Startup-Aenderung:
- Flow verstanden: ja/nein
- Text "Als erwartet merken" klar: ja/nein
- Was war unklar:

Detailansicht:
- Wirkt ruhig: ja/nein
- Zu technisch:
- Fehlender naechster Schritt:

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
