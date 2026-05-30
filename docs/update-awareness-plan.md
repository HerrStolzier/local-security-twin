# Update Awareness Plan

## Zweck

Kapitel 3 soll Sento Guard beibringen, macOS-Sicherheitsupdates ruhig und verständlich einzuordnen.

Das ist der erste kleine Online-Baustein nach den lokalen Sensoren.
Er bleibt trotzdem `local-first`: Die App soll Daten lokal cachen, den Quellenstand zeigen und bei fehlendem Netzwerk ehrlich bleiben.

## Erste Quelle

Für den MVP ist SOFA die passendste erste Quelle:

- Projekt: `https://github.com/macadmins/sofa`
- Einstieg: `https://sofa.macadmins.io/getting-started`
- Feed: `https://sofafeed.macadmins.io/v1/macos_data_feed.json`
- Apple Security Releases als Primärreferenz: `https://support.apple.com/en-us/100100`

SOFA steht für einen maschinenlesbaren Software-Update-Feed aus der MacAdmins-Community.
Praktisch heißt das: Die App bekommt eine saubere JSON-Datei, statt Apple-Update-Seiten selbst erraten oder scrapen zu müssen.

## Relevante Feed-Daten

Für den ersten Schnitt reichen diese Informationen:

- `UpdateHash` als einfacher Hinweis, ob sich der Feed geändert hat
- `OSVersions`
- pro macOS-Hauptversion die aktuellste Version, Buildnummer und Veröffentlichungsdatum
- Security-Info-Link
- CVE-Listen, wenn vorhanden
- aktiv ausgenutzte CVEs, wenn vorhanden

Die App muss tolerant dekodieren.
Fehlende optionale Felder dürfen nicht zum Crash führen, weil der Feed extern ist und sich entwickeln kann.

## Lokale Vergleichsdaten

Die lokale macOS-Version kann über `ProcessInfo.processInfo.operatingSystemVersion` gelesen werden.

Falls die Buildnummer wichtig wird, kann ein kleiner read-only Client für `/usr/bin/sw_vers -buildVersion` ergänzt werden.
Das sollte weich fehlschlagen und nur als fehlende Zusatzinformation sichtbar werden.

## Produktverhalten

Sento soll nur drei einfache Zustände erklären:

- `Du bist nach meinem letzten Quellenstand aktuell.`
- `Es gibt nach meinem letzten Quellenstand ein neueres Sicherheitsupdate.`
- `Ich kann den Update-Stand gerade nicht sicher prüfen.`

Wichtig:
Die App darf nicht sagen, der Mac sei vollständig sicher.
Ein aktuelles macOS ist ein starkes Schutzsignal, aber kein Gesamturteil über den Rechner.

## Cache-Strategie

Der Feed soll lokal gespeichert werden, zum Beispiel in `Application Support`.

Empfohlen:

- letzte erfolgreiche Feed-Antwort speichern
- Abrufzeitpunkt speichern
- `UpdateHash` speichern
- nicht bei jedem Start hart vom Netzwerk abhängig sein
- bei Offline-Zustand den Cache nutzen und klar anzeigen, von wann er ist
- einen eigenen `User-Agent` setzen

★ ʕ ᵔᴥᵔ ʔ Erklaerbaer
Der Cache ist wie ein lokaler Merkzettel.
Wenn das Internet gerade fehlt, weiß Sento noch, was beim letzten erfolgreichen Blick aktuell war, sagt aber ehrlich dazu, dass der Stand alt sein kann.

## Geplanter erster Code-Schnitt

1. Kleinen SOFA-Client bauen, der JSON lädt und dekodiert. Erledigt im ersten Schnitt.
2. Lokalen Cache-Store ergänzen. Erster Cache-Pfad ist vorhanden; automatischer Netzwerkabruf bleibt beim normalen Start deaktiviert.
3. Update-Awareness-Sensor an den bestehenden `FindingSensor`-Vertrag hängen. Erledigt im ersten Schnitt.
4. `SensorPipeline.live()` um den neuen Sensor erweitern. Erledigt im ersten Schnitt.
5. Presentation-Texte für Update-Awareness ergänzen. Erster ruhiger Review-Pfad ist vorhanden.
6. Tests für Dekodierung, Cache-Fallback und einfache Versionsentscheidung schreiben. Erledigt im ersten Schnitt.

Der sichtbare Netzwerkabruf ist jetzt als Nutzeraktion vorhanden.
Die Live-App darf weiterhin nicht heimlich beim Start den SOFA-Feed laden.
Der Abruf läuft abseits des Main Actors, damit die Oberfläche während langsamer Netzantworten nicht einfriert.

Nächster Schritt:
Den Flow visuell in der App prüfen und entscheiden, ob Update-Awareness als eigene Mission sichtbarer werden soll.

## Sicherheits- und UX-Grenzen

- Kein automatisches Installieren von Updates.
- Kein Öffnen von Systemeinstellungen ohne klare Nutzeraktion.
- Kein Schutzscore nur wegen aktueller Version.
- Netzwerkfehler sind kein Risiko-Finding, sondern ein ruhiger Hinweis: Der Quellenstand konnte nicht aktualisiert werden.
- SOFA ist eine kuratierte externe Quelle, aber nicht Apple selbst; Apple-Advisories bleiben als Referenz wichtig.

## Threat Context

Update Awareness ist der erste sinnvolle Kandidat für einen kleinen `ThreatContext`-Baustein.

Der separate Plan liegt in `docs/threat-context-plan.md`.
Wichtig für diesen Sensor:

- SOFA bleibt Zusatzquelle, nicht alleinige Wahrheit.
- Apple Security Releases bleiben die Primärreferenz im technischen Detail.
- aktiv ausgenutzte CVEs dürfen die Wichtigkeit erhöhen, aber nicht als Beweis für eine lokale Kompromittierung erscheinen.
- jeder externe Quellenstand braucht Abrufzeitpunkt, sichtbare Grenze und Cache-Verhalten.

## Abnahmekriterien

- Die App kann ohne Netzwerk mit einem alten Cache sinnvoll starten.
- Der Nutzer sieht, von wann der Update-Stand ist.
- Der Nutzer versteht, ob ein neueres macOS-Sicherheitsupdate relevant sein könnte.
- Die App unterscheidet zwischen lokal gesehenem Systemstand und externer Update-Quelle.
- Tests decken Dekodierung, Versionsvergleich und Cache-Fallback ab.
