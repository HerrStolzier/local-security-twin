# Roadmap

## Zweck

Diese Datei ist die aktuelle Planungsuebersicht fuer `local-security-twin`.

Sie ersetzt nicht die Detaildokumente, sondern ordnet sie:

- `docs/session-status.md`: aktueller Uebergabestand
- `docs/current-overview.md`: technischer und produktlicher Kurzueberblick
- `docs/ui-ux-redesign-notes.md`: naechster UI-/UX-Schnitt
- `docs/background-task-management-spike.md`: spaeterer macOS-Startup-Spike
- `docs/packaging-signing-plan.md`: spaeterer Distribution-/Signing-Schnitt

## Aktueller Stand

Die App ist ein SwiftPM-basiertes macOS-Projekt mit erster echter lokaler Sicherheitsfunktion.

Vorhanden ist:

- Menueleisten-App, Hauptfenster und Settings
- lokales Consent-/Policy-Modell
- normalisiertes Finding-Schema mit Evidence und Recommendations
- Sensor-Vertrag und synchrone Sensor-Pipeline
- erster Sensor fuer sichtbare Startup-`plist`-Dateien
- lokale Startup-Baseline in Application Support
- Change-Detection fuer neue und verschwundene Startup-Hinweise
- explizites Merken des aktuellen Startup-Zustands als erwartet
- einfache `.plist`-Details als Evidence
- lokale Checks, Security Checks und Smoke-E2E

## Aktuelle Hauptprioritaet

Die naechste Hauptprioritaet ist UI/UX.

Grund:
Der erste manuelle Blick zeigt, dass die App technisch funktioniert, aber fuer normale Nutzer noch keinen klaren roten Faden bietet.

Der naechste Schnitt soll deshalb:

1. Nutzertexte auf Deutsch umstellen.
2. Ein klares Dashboard mit Orientierung bauen.
3. Findings gruppieren und priorisieren.
4. Neue Aenderungen klar von bekannten Hinweisen trennen.
5. Detailansichten mit einer kurzen Einordnung beginnen.
6. Severity ruhiger darstellen, damit normale Daemons nicht wie Panikmeldungen wirken.

Nicht-Ziel dieses Schnitts:

- kein neuer Sensor
- kein neues Security-Scoring-System
- keine Systemaenderungen
- keine neuen macOS-Rechte

## Iteration 1: Deutsche Orientierung fuer den ersten Sensor

Status: umgesetzt am 2026-05-12.

Ziel:
Die App soll beim ersten echten Blick verstaendlich sein.

Umfang:

- `Findings` in der UI zu `Hinweise` machen
- `Evidence` zu `Belege`
- `Recommended actions` zu `Empfohlene Schritte`
- `Remember as Expected` zu `Als erwartet merken`
- lange technische Finding-Titel kuerzen
- Dashboard-Kopf mit kurzer Zusammenfassung ergaenzen
- Liste in sinnvolle Gruppen teilen:
  - `Neue Aenderungen`
  - `Bekannte Autostart-Hinweise`
  - `Zur Beobachtung`

Abnahmekriterium:
Ein normaler Nutzer soll in 10 Sekunden verstehen:

- was die App sieht
- ob etwas neu ist
- was er als naechstes tun kann

## Iteration 2: Startup-Details besser nutzbar machen

Ziel:
Die gelesenen `.plist`-Details sollen nicht wie ein technischer Textblock wirken.

Umfang:

- Dateiname, Label und Programmpfad klar hervorheben
- `RunAtLoad` und `KeepAlive` in Alltagssprache erklaeren
- Detailansicht mit kurzer Einordnung starten
- sichtbar machen, dass ein Hinweis nicht beweist, dass etwas aktiv laeuft oder gefaehrlich ist

Abnahmekriterium:
Die Detailansicht beantwortet zuerst "Was bedeutet das fuer mich?", bevor sie Rohdetails zeigt.

## Iteration 3: UI-nah testen

Ziel:
Der `Als erwartet merken`-Flow soll nicht nur in Domain-Tests funktionieren.

Umfang:

- Store-/ViewModel-nahe Tests erweitern
- pruefen:
  - Startup-Aenderung sichtbar
  - Aktion zum Merken verfuegbar
  - nach dem Merken verschwinden Diff-Hinweise
- falls echte macOS-UI-Automation im SwiftPM-Setup nicht stabil ist, Packaging-/Xcode-Frage dokumentiert lassen

Abnahmekriterium:
Der wichtigste Nutzerfluss ist automatisiert oder bewusst als noch nicht automatisierbar dokumentiert.

## Iteration 4: Background Task Management Spike

Ziel:
Pruefen, ob moderne macOS-Login-/Background-Items eine stabile Quelle fuer einen spaeteren Sensor sind.

Umfang:

- `SMAppService` pruefen
- `sfltool dumpbtm` auf echter macOS-Umgebung untersuchen
- Rechtebedarf und Ausgabeformat bewerten
- keine produktive Integration, solange die Quelle nicht stabil genug ist

Abnahmekriterium:
Eine klare Entscheidung:

- Sensor bauen
- weiter beobachten
- oder bewusst nicht verwenden

## Iteration 5: Naechsten Sensor auswaehlen

Ziel:
Nach UI-Klarheit entscheiden, welche lokale Sicht als naechstes echten Nutzerwert bringt.

Kandidaten:

- moderne Login-/Background-Items
- Privacy-Permissions-Sichtbarkeit
- weitere lokale Exposure Checks

Auswahlkriterien:

- read-only
- ohne Full Disk Access sinnvoll
- leicht erklaerbar
- geringe Fehlalarm-Gefahr
- Evidence statt Behauptungen

## Iteration 6: Packaging, Signing und Sandbox

Ziel:
Vor echter Distribution klaeren, wie die App sauber gebaut, signiert und spaeter notarized wird.

Umfang:

- SwiftPM allein vs. Xcode-Projekt entscheiden
- Hardened Runtime testen
- Sandbox-Auswirkung auf Startup-Sensor pruefen
- keine neuen Entitlements ohne konkreten Nutzen

Abnahmekriterium:
Ein klarer Packaging-Pfad fuer MVP-Testversionen.

## Bewusst spaeter

- echte Guided Actions, die Systemeinstellungen oeffnen oder aendern
- Full Disk Access
- Adminrechte
- privilegierte Helper
- aggressive Live-Validierung
- Cloud-/Online-Intelligence
- vollstaendige macOS-Persistenzabdeckung

## Definition of Done pro Iteration

Eine Iteration ist erst fertig, wenn:

1. Code oder Doku umgesetzt ist
2. passende Tests/Checks gelaufen sind
3. `docs/session-status.md` aktualisiert ist
4. dauerhafte Erkenntnisse in `docs/project-learnings.md` stehen
5. der Stand committed und gepusht ist
