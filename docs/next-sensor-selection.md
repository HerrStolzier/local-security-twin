# Next Sensor Selection

## Zweck

Diese Datei haelt die Kriterien fuer den naechsten lokalen Sensor fest.

## Entscheidung fuer jetzt

Noch keinen zweiten Sensor bauen, bevor Baseline-Refresh, UI-Sprache und Startup-Item-Details stabil sind.

## Kandidaten

### Moderne Login- und Background-Items

Vorteil:
Sehr nah am aktuellen Startup-Thema.

Risiko:
Quelle und Stabilitaet muessen erst ueber den Background-Task-Management-Spike geprueft werden.

Status:
Interessant, aber noch nicht sofort implementieren.

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

## Auswahlkriterien

Der naechste Sensor muss:

- read-only sein
- ohne Full Disk Access sinnvoll bleiben
- fuer normale Nutzer leicht erklaerbar sein
- geringe Fehlalarm-Gefahr haben
- Evidence liefern, statt nur Behauptungen
