# Next Sensor Selection

## Zweck

Diese Datei haelt die Kriterien fuer den naechsten lokalen Sensor fest.

## Entscheidung fuer jetzt

Noch keinen zweiten Sensor bauen, bevor Baseline-Refresh, UI-Sprache und Startup-Item-Details stabil sind.

Update 2026-05-12:
Nach UI-Iteration und Background-Task-Management-Spike bleibt diese Entscheidung bestehen.

Der naechste Sensor wird bewusst noch nicht implementiert.
Stattdessen soll zuerst Packaging/Signing geklaert werden, weil Sandbox, App-Bundle-Form und spaetere UI-Automation die Sensor-Strategie beeinflussen koennen.

## Kandidaten

### Moderne Login- und Background-Items

Vorteil:
Sehr nah am aktuellen Startup-Thema.

Risiko:
Quelle und Stabilitaet muessen erst ueber den Background-Task-Management-Spike geprueft werden.

Status:
Interessant, aber noch nicht sofort implementieren. Der erste lokale `sfltool dumpbtm`-Test war nicht robust genug fuer eine direkte Produktquelle.

### Privacy-Permissions-Sichtbarkeit

Vorteil:
Passt stark zum Produktversprechen Privacy und Vertrauen.

Risiko:
Viele TCC-Daten sind geschuetzt oder nur mit hohen Rechten vollstaendig sichtbar. Die App darf hier nicht so tun, als saehe sie alles.

Status:
Guter Kandidat, wenn eine read-only Quelle ohne Full Disk Access sauber gefunden wird.

### Weitere lokale Exposure Checks

Vorteil:
Kann klein und risikoarm bleiben.

Risiko:
Zu viele kleine Checks koennen wie ein lautes Security-Dashboard wirken.

Status:
Nur auswaehlen, wenn der Nutzerwert in einem Satz erklaerbar ist.

## Aktuelle Priorisierung

1. Kein neuer Sensor in der naechsten Iteration.
2. Packaging/Signing/Sandbox klaeren.
3. Danach erneut entscheiden:
   - Wenn Sandbox/Distribution die Startup-Sicht stark begrenzt, Sensor-Strategie anpassen.
   - Wenn Packaging stabil ist, Privacy-Permissions-Sichtbarkeit als naechsten Research-Kandidaten pruefen.
   - Background Task Management erst wieder aufgreifen, wenn ein stabiler Diagnose-Harness existiert.

## Auswahlkriterien

Der naechste Sensor muss:

- read-only sein
- ohne Full Disk Access sinnvoll bleiben
- fuer normale Nutzer leicht erklaerbar sein
- geringe Fehlalarm-Gefahr haben
- Evidence liefern, statt nur Behauptungen

## Entscheidung

Fuer den aktuellen MVP ist der naechste fachliche Schritt kein neuer Sensor.

Naechster Schritt:
`docs/packaging-signing-plan.md` konkretisieren und einen kleinen Packaging-/Sandbox-Spike durchfuehren.
