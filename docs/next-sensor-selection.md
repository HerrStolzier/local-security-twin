# Next Sensor Selection

## Zweck

Diese Datei haelt die Entscheidung fuer den naechsten lokalen Sensor fest.

## Entscheidung fuer Sprint 4

Der zweite MVP-Sensor wird ein kleiner **Systemprofil-Sensor**.

Er liest nur risikoarme, lokal sichtbare Grunddaten:

- macOS-Version
- Prozessor-/Systemarchitektur
- optional sichtbarer Computername oder Hostname
- optional Gatekeeper-Status, wenn die Abfrage ohne Zusatzrechte stabil gelingt
- optional SIP-Status, wenn die Abfrage ohne Zusatzrechte stabil gelingt

Der Sensor ist bewusst kein vollstaendiger Sicherheitscheck. Er ist ein Kontext-Sensor: Die App kann erklaeren, auf welchem Mac sie laeuft und welche Basis-Schutzsignale lokal sichtbar sind.

## Warum dieser Sensor

Der MVP braucht eine zweite lokale Sicht, aber ohne neue macOS-Rechte und ohne Fehlalarm-Druck.

Der Systemprofil-Sensor passt deshalb am besten:

- read-only
- keine Full-Disk-Access-Anforderung
- gut in Tests simulierbar
- fuer normale Nutzer leicht erklaerbar
- geringe Gefahr, mehr Sicherheit zu behaupten, als wirklich belegt ist
- gute Grundlage fuer spaetere Packaging-, Sandbox- und Guided-Action-Entscheidungen

## Nicht gewaehlt

### Moderne Login- und Background-Items

Vorteil:
Sehr nah am aktuellen Startup-Thema.

Warum nicht jetzt:
Der lokale `sfltool dumpbtm`-Spike war noch nicht robust genug. Ausgabe und Verfuegbarkeit sind als Produktquelle noch zu unsicher.

Status:
Spaeter erneut pruefen, wenn ein stabiler Diagnose-Harness existiert.

### Privacy-Permissions-Sichtbarkeit

Vorteil:
Passt stark zum Produktversprechen Privacy und Vertrauen.

Warum nicht jetzt:
Viele TCC-Daten sind geschuetzt oder ohne Full Disk Access nur lueckenhaft sichtbar. Die App darf nicht so wirken, als saehe sie alle Datenschutzfreigaben, wenn sie das lokal nicht sauber belegen kann.

Status:
Guter spaeterer Kandidat, sobald eine read-only Quelle ohne hohe Rechte sauber belegt ist.

### Weitere lokale Exposure Checks

Vorteil:
Kleine Checks koennen schnell Nutzerwert bringen.

Warum nicht als eigener zweiter Sensor:
Viele Einzelchecks wuerden schnell wie ein lautes Security-Dashboard wirken. Der Systemprofil-Sensor buendelt diese Richtung ruhiger und erklaert Grenzen besser.

Status:
Einzelne Checks koennen spaeter aus dem Systemprofil herausgeloest werden, wenn sie eigenen Nutzerwert haben.

## Auswahlkriterien

Der naechste Sensor muss:

- read-only sein
- ohne Full Disk Access sinnvoll bleiben
- fuer normale Nutzer leicht erklaerbar sein
- geringe Fehlalarm-Gefahr haben
- Evidence liefern, statt nur Behauptungen
- seine Sichtgrenzen ausdruecklich nennen

## Naechster Schritt

`docs/system-profile-sensor-design.md` anlegen und vor der Implementierung festhalten:

- Datenquellen
- Rechtebedarf
- Findings und Evidence
- Fehlerverhalten
- Nutzertexte
- Tests
