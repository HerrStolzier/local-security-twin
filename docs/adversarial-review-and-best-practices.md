# Adversarial Review and Best-Practice Monitoring

## Zweck

Diese Datei ergaenzt den Produktplan um zwei feste Perspektiven:

1. Jede neue Idee wird aus Angreiferperspektive geprueft.
2. Der Security Buddy soll spaeter wichtige Sicherheits-Best-Practices aktiv beobachten und erklaeren.

Das Ziel ist mehr Verteidigungsstaerke, nicht mehr Risiko.

## Black-Hat-Perspektive als Entwicklungsritual

Jede groessere Produktidee bekommt vor der Umsetzung eine kurze Gegenpruefung:

> Wenn ein Angreifer diese Funktion sieht, wie koennte er sie gegen den Nutzer, den Mac oder die App selbst verwenden?

Diese Pruefung gehoert in Designs, Pull Requests und groessere Implementierungsschritte.

## Fragen fuer jede neue Funktion

### 1. Missbrauch gegen den Nutzer

- Koennte die Funktion Angst erzeugen und den Nutzer zu falschen Klicks treiben?
- Koennte eine Meldung so formuliert sein, dass sie wie Social Engineering wirkt?
- Koennte eine Empfehlung zu einer unsicheren Aktion fuehren?

### 2. Missbrauch gegen das System

- Fordert die Funktion neue Rechte an?
- Koennte ein Fehler zu stillen Systemaenderungen fuehren?
- Koennte ein Angreifer Eingabedaten manipulieren, damit die App falsche Sicherheit meldet?

### 3. Missbrauch gegen die App

- Koennte ein lokaler Angreifer Baseline-, Policy- oder Cache-Dateien manipulieren?
- Koennte ein externer Feed vergiftet oder veraltet sein?
- Koennte ein LLM durch Prompt Injection oder manipulierte Belege zu falschen Aussagen gebracht werden?

### 4. Datenschutz und Vertrauen

- Werden Daten lokal gehalten, wenn Cloud nicht noetig ist?
- Ist Netzwerkzugriff sichtbar und begruendet?
- Kann der Nutzer gespeicherte Entscheidungen sehen und rueckgaengig machen?

## Ergebnis der Pruefung

Jede relevante Funktion soll eine kurze Antwort haben:

- **Was kann missbraucht werden?**
- **Wie begrenzen wir das?**
- **Welche Rechte braucht die Funktion wirklich?**
- **Welche Nutzerentscheidung ist noetig?**
- **Was darf die Funktion ausdruecklich nicht tun?**

## Sicherheitsgrenzen fuer Angreiferdenken

Erlaubt und gewuenscht:

- Threat Modeling
- defensive Missbrauchsanalyse
- sichere Architekturentscheidungen
- sichere Test-Fixtures
- Erklaerung von Risiken in Alltagssprache

Nicht Ziel:

- echte Exploit-Entwicklung
- Anleitung zum Umgehen von Schutzmechanismen
- offensive Automatisierung gegen echte Systeme
- heimliche Persistenz-, Netzwerk- oder Rechte-Eskalationslogik

## Best-Practice-Monitoring

Der Security Buddy soll spaeter nicht nur technische Findings zeigen, sondern ein Sicherheitsbild des Alltags aufbauen.

Wichtig:
Nicht jede Best Practice ist direkt messbar. Manche Dinge kann die App pruefen, manche nur erfragen oder erklaeren.

## Kategorien

### A. Direkt lokal pruefbar

Diese Checks sind gute fruehe Kandidaten, weil sie lokal und read-only moeglich sein koennen:

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

### B. Teilweise lokal pruefbar

Diese Checks brauchen vorsichtige Recherche, weil macOS-Sichtbarkeit, Sandbox und Rechte stark mitspielen:

- Antivirus- oder EDR-Programme erkannt und aktuell
- Passwort-Manager installiert
- VPN-App installiert oder VPN-Konfiguration sichtbar
- Browser-Sicherheitszustand und Erweiterungen
- Backup-Hinweise, z. B. Time Machine-Status
- iCloud-/Apple-ID-Sicherheitsstatus, soweit lokal sichtbar

### C. Nur gefuehrt erfragbar

Diese Dinge kann die App oft nicht sicher messen. Sie sollte sie als Checkliste oder Buddy-Frage behandeln:

- Ist Zwei-Faktor-Authentifizierung fuer wichtige Accounts aktiv?
- Nutzt der Nutzer einen Passwort-Manager wirklich?
- Sind wichtige Accounts mit einzigartigen Passwoertern geschuetzt?
- Werden Recovery Codes sicher aufbewahrt?
- Ist ein VPN in diesem konkreten Szenario sinnvoll oder eher Scheinsicherheit?
- Gibt es ein aktuelles Backup, das der Nutzer wirklich wiederherstellen kann?

## Priorisierung fuer die naechsten Schritte

### Phase A: Lokale Mac-Haertung

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
- 2FA-Checkliste fuer Apple ID, E-Mail, Banking, GitHub, Cloud
- Recovery-Code-Erinnerung

Warum:
Sehr grosser Sicherheitsnutzen, aber oft nicht sauber lokal messbar.
Deshalb als gefuehrte Buddy-Frage statt falscher technischer Behauptung.

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

- Firewall erklaeren
- VPN sinnvoll einordnen
- spaeter Netzwerkhinweise, falls Rechte und Nutzen klar sind

Wichtig:
VPN ist nicht automatisch "mehr Sicherheit".
Der Buddy soll erklaeren, wann VPN hilft und wann es nur das Vertrauen auf einen anderen Anbieter verschiebt.

## Produktregel

Der Buddy soll Best Practices nicht als starre Checkliste verkaufen.

Er soll sagen:

- "Das schuetzt dich wahrscheinlich stark."
- "Das ist fuer manche Situationen sinnvoll."
- "Das kann ich lokal nicht sicher sehen."
- "Das musst du mir einmal beantworten."
- "Das sollten wir spaeter wieder pruefen."

## Naechster konkreter Schritt

Vor dem naechsten technischen Sensor sollte ein kleiner Design-Schnitt entstehen:

1. Welche Best-Practice-Kategorien zeigt die App im Buddy-UI?
2. Welche davon sind lokal messbar?
3. Welche sind nur Buddy-Fragen?
4. Welche Rechte waeren noetig?
5. Welche Angreifer-Missbrauchsfaelle gibt es?

Danach ist der naechste gute Sensor wahrscheinlich:

- macOS-Update-/Security-Update-Status ueber SOFA
- danach FileVault-/Firewall-Sichtbarkeit
- danach App-Inventur und Versionen
