# Next Sensor Selection

## Zweck

Diese Datei hält die Entscheidung für den nächsten lokalen Sensor fest.

## Entscheidung für Sprint 4

Der zweite MVP-Sensor wird ein kleiner **Systemprofil-Sensor**.

Er liest nur risikoarme, lokal sichtbare Grunddaten:

- macOS-Version
- Prozessor-/Systemarchitektur
- optional sichtbarer Computername oder Hostname
- optional Gatekeeper-Status, wenn die Abfrage ohne Zusatzrechte stabil gelingt
- optional SIP-Status, wenn die Abfrage ohne Zusatzrechte stabil gelingt

Der Sensor ist bewusst kein vollständiger Sicherheitscheck. Er ist ein Kontext-Sensor: Die App kann erklären, auf welchem Mac sie läuft und welche Basis-Schutzsignale lokal sichtbar sind.

## Warum dieser Sensor

Der MVP braucht eine zweite lokale Sicht, aber ohne neue macOS-Rechte und ohne Fehlalarm-Druck.

Der Systemprofil-Sensor passt deshalb am besten:

- read-only
- keine Full-Disk-Access-Anforderung
- gut in Tests simulierbar
- für normale Nutzer leicht erklärbar
- geringe Gefahr, mehr Sicherheit zu behaupten, als wirklich belegt ist
- gute Grundlage für spätere Packaging-, Sandbox- und Guided-Action-Entscheidungen

## Nicht gewählt

### Moderne Login- und Background-Items

Vorteil:
Sehr nah am aktuellen Startup-Thema.

Warum nicht jetzt:
Der lokale `sfltool dumpbtm`-Spike war noch nicht robust genug. Ausgabe und Verfügbarkeit sind als Produktquelle noch zu unsicher.

Status:
Später erneut prüfen, wenn ein stabiler Diagnose-Harness existiert.

### Privacy-Permissions-Sichtbarkeit

Vorteil:
Passt stark zum Produktversprechen Privacy und Vertrauen.

Warum nicht jetzt:
Viele TCC-Daten sind geschützt oder ohne Full Disk Access nur lückenhaft sichtbar. Die App darf nicht so wirken, als saehe sie alle Datenschutzfreigaben, wenn sie das lokal nicht sauber belegen kann.

Status:
Guter späterer Kandidat, sobald eine read-only Quelle ohne hohe Rechte sauber belegt ist.

### Weitere lokale Exposure Checks

Vorteil:
Kleine Checks können schnell Nutzerwert bringen.

Warum nicht als eigener zweiter Sensor:
Viele Einzelchecks würden schnell wie ein lautes Security-Dashboard wirken. Der Systemprofil-Sensor buendelt diese Richtung ruhiger und erklärt Grenzen besser.

Status:
Einzelne Checks können später aus dem Systemprofil herausgeloest werden, wenn sie eigenen Nutzerwert haben.

## Auswahlkriterien

Der nächste Sensor muss:

- read-only sein
- ohne Full Disk Access sinnvoll bleiben
- für normale Nutzer leicht erklärbar sein
- geringe Fehlalarm-Gefahr haben
- Evidence liefern, statt nur Behauptungen
- seine Sichtgrenzen ausdruecklich nennen

## Nächster Schritt

`docs/system-profile-sensor-design.md` anlegen und vor der Implementierung festhalten:

- Datenquellen
- Rechtebedarf
- Findings und Evidence
- Fehlerverhalten
- Nutzertexte
- Tests
