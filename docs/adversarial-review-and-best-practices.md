# Adversarial Review and Best-Practice Monitoring

## Zweck

Diese Datei ergänzt den Produktplan um zwei feste Perspektiven:

1. Jede neue Idee wird aus Angreiferperspektive geprüft.
2. Der Security Buddy soll später wichtige Sicherheits-Best-Practices aktiv beobachten und erklären.

Das Ziel ist mehr Verteidigungsstaerke, nicht mehr Risiko.

## Black-Hat-Perspektive als Entwicklungsritual

Jede größere Produktidee bekommt vor der Umsetzung eine kurze Gegenpruefung:

> Wenn ein Angreifer diese Funktion sieht, wie könnte er sie gegen den Nutzer, den Mac oder die App selbst verwenden?

Diese Prüfung gehört in Designs, Pull Requests und größere Implementierungsschritte.

## Fragen für jede neue Funktion

### 1. Missbrauch gegen den Nutzer

- Könnte die Funktion Angst erzeugen und den Nutzer zu falschen Klicks treiben?
- Könnte eine Meldung so formuliert sein, dass sie wie Social Engineering wirkt?
- Könnte eine Empfehlung zu einer unsicheren Aktion führen?

### 2. Missbrauch gegen das System

- Fordert die Funktion neue Rechte an?
- Könnte ein Fehler zu stillen Systemänderungen führen?
- Könnte ein Angreifer Eingabedaten manipulieren, damit die App falsche Sicherheit meldet?

### 3. Missbrauch gegen die App

- Könnte ein lokaler Angreifer Baseline-, Policy- oder Cache-Dateien manipulieren?
- Könnte ein externer Feed vergiftet oder veraltet sein?
- Könnte ein LLM durch Prompt Injection oder manipulierte Belege zu falschen Aussagen gebracht werden?

### 4. Datenschutz und Vertrauen

- Werden Daten lokal gehalten, wenn Cloud nicht nötig ist?
- Ist Netzwerkzugriff sichtbar und begründet?
- Kann der Nutzer gespeicherte Entscheidungen sehen und rückgängig machen?

## Ergebnis der Prüfung

Jede relevante Funktion soll eine kurze Antwort haben:

- **Was kann missbraucht werden?**
- **Wie begrenzen wir das?**
- **Welche Rechte braucht die Funktion wirklich?**
- **Welche Nutzerentscheidung ist nötig?**
- **Was darf die Funktion ausdrücklich nicht tun?**

## Wiederholbare Vorlage

Für neue Sensoren und größere Produktfunktionen wird die Review-Frage ab jetzt in einer festen Vorlage beantwortet:

- `docs/adversarial-review-template.md`

Der erste nachgezogene Review für den vorhandenen Autostart-Sensor liegt hier:

- `docs/adversarial-review-startup-autostart.md`

Die Vorlage ist bewusst defensiv.
Sie soll aus Angreiferdenken nur sichere Outputs ableiten: read-only Sensorideen, Checklisten, Guided Actions, dokumentierte Grenzen oder die Entscheidung, etwas noch nicht zu bauen.

## Sicherheitsgrenzen für Angreiferdenken

Erlaubt und gewünscht:

- Threat Modeling
- defensive Missbrauchsanalyse
- sichere Architekturentscheidungen
- sichere Test-Fixtures
- Erklärung von Risiken in Alltagssprache

Nicht Ziel:

- echte Exploit-Entwicklung
- Anleitung zum Umgehen von Schutzmechanismen
- offensive Automatisierung gegen echte Systeme
- heimliche Persistenz-, Netzwerk- oder Rechte-Eskalationslogik

## Best-Practice-Monitoring

Der Security Buddy soll später nicht nur technische Findings zeigen, sondern ein Sicherheitsbild des Alltags aufbauen.

Wichtig:
Nicht jede Best Practice ist direkt messbar. Manche Dinge kann die App prüfen, manche nur erfragen oder erklären.

## Kategorien

### A. Direkt lokal prüfbar

Diese Checks sind gute frühe Kandidaten, weil sie lokal und read-only möglich sein können:

- macOS-Version und Sicherheitsupdate-Stand
- Gatekeeper
- SIP
- Firewall-Status
- FileVault-Status
- sichtbare Autostart-/Background-Items
- installierte Apps und Versionen
- Signaturstatus von Apps
- System Extensions und DriverKit-Erweiterungen
- sichtbare Login Items

### B. Teilweise lokal prüfbar

Diese Checks brauchen vorsichtige Recherche, weil macOS-Sichtbarkeit, Sandbox und Rechte stark mitspielen:

- Antivirus- oder EDR-Programme erkannt und aktuell
- Passwort-Manager installiert
- VPN-App installiert oder VPN-Konfiguration sichtbar
- Browser-Sicherheitszustand und Erweiterungen
- Backup-Hinweise, z. B. Time Machine-Status
- iCloud-/Apple-ID-Sicherheitsstatus, soweit lokal sichtbar

### C. Nur geführt erfragbar

Diese Dinge kann die App oft nicht sicher messen. Sie sollte sie als Checkliste oder Buddy-Frage behandeln:

- Ist Zwei-Faktor-Authentifizierung für wichtige Accounts aktiv?
- Nutzt der Nutzer einen Passwort-Manager wirklich?
- Sind wichtige Accounts mit einzigartigen Passwoertern geschützt?
- Werden Recovery Codes sicher aufbewahrt?
- Ist ein VPN in diesem konkreten Szenario sinnvoll oder eher Scheinsicherheit?
- Gibt es ein aktuelles Backup, das der Nutzer wirklich wiederherstellen kann?

## Priorisierung für die nächsten Schritte

### Phase A: Lokale Mac-Härtung

Erster sinnvoller Block nach dem UI-Roten-Faden:

- macOS-Update-Status
- FileVault
- Firewall
- Gatekeeper/SIP besser darstellen
- sichtbare System Extensions / Treiberzustand

Warum:
Das sind echte Systemschutzthemen und passen zum lokalen Verteidiger.

### Phase B: Account- und Passwort-Hygiene

Zweiter Block:

- Passwort-Manager erkannt oder erfragt
- 2FA-Checkliste für Apple ID, E-Mail, Banking, GitHub, Cloud
- Recovery-Code-Erinnerung

Warum:
Sehr großer Sicherheitsnutzen, aber oft nicht sauber lokal messbar.
Deshalb als geführte Buddy-Frage statt falscher technischer Behauptung.

### Phase C: App- und Threat-Matching

Dritter Block:

- installierte Apps
- App-Versionen
- Signaturstatus
- CISA KEV / EPSS / NVD Matching

Warum:
Hier bekommt der Buddy echten Punch gegen aktuelle Bedrohungen.

### Phase D: Netzwerk und VPN

Vierter Block:

- Firewall erklären
- VPN sinnvoll einordnen
- später Netzwerkhinweise, falls Rechte und Nutzen klar sind

Wichtig:
VPN ist nicht automatisch "mehr Sicherheit".
Der Buddy soll erklären, wann VPN hilft und wann es nur das Vertrauen auf einen anderen Anbieter verschiebt.

## Produktregel

Der Buddy soll Best Practices nicht als starre Checkliste verkaufen.

Er soll sagen:

- "Das schützt dich wahrscheinlich stark."
- "Das ist für manche Situationen sinnvoll."
- "Das kann ich lokal nicht sicher sehen."
- "Das musst du mir einmal beantworten."
- "Das sollten wir später wieder prüfen."

## Nächster konkreter Schritt

Vor dem nächsten technischen Sensor sollte ein kleiner Design-Schnitt entstehen:

1. Welche Best-Practice-Kategorien zeigt die App im Buddy-UI?
2. Welche davon sind lokal messbar?
3. Welche sind nur Buddy-Fragen?
4. Welche Rechte wären nötig?
5. Welche Angreifer-Missbrauchsfälle gibt es?

Danach ist der nächste gute Sensor wahrscheinlich:

- macOS-Update-/Security-Update-Status über SOFA
- danach FileVault-/Firewall-Sichtbarkeit
- danach App-Inventur und Versionen
