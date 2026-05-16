# Product Flow and Feature Plan

## Zweck

Diese Datei beschreibt den roten Faden für die App.

Sie beantwortet drei Fragen:

1. Was soll die App für den Nutzer sein?
2. Wie benutzt der Nutzer sie im Alltag?
3. Welche Bausteine müssen wir dafür Schritt für Schritt bauen?

## Produktbild

`local-security-twin` soll als Produkt unter dem Arbeitsnamen `Sento Guard` zu einem kraftvollen Security Buddy für normale Mac-Nutzer werden.

Er soll nicht nur eine Hinweis-Liste sein. Er soll wie ein Verteidiger arbeiten:

- lokal beobachten
- relevante Änderungen erkennen
- aus Angreifer-Sicht fragen, welche Wege realistisch missbraucht werden könnten
- aktuelle Bedrohungsinformationen einordnen
- wichtige Schutzgewohnheiten sichtbar machen
- einfach erklären, was das für diesen Mac bedeutet
- mit dem Nutzer zusammen entscheiden
- sichere nächste Schritte führen

Wichtig:
Kraftvoll heißt nicht laut, hektisch oder riskant. Kraftvoll heißt: gute Belege, klare Prioritäten, aktuelle Informationen und handlungsfähige nächste Schritte.

Ein wichtiger Teil davon ist eine eingebaute Gegenperspektive:
Die App soll beim Planen und Bewerten immer auch fragen: "Wenn ich ein vorsichtiger Angreifer wäre, was wäre der naheliegende Weg?"
Diese Perspektive ist kein Auftrag für echte Angriffe.
Sie ist ein Sicherheitsfilter, damit die App bessere Verteidigungshinweise gibt und keine einfachen Risiken übersieht.

## Was die App nicht ist

Die App ersetzt kein ganzes Security-Team und auch kein vollständiges Antiviren- oder EDR-System.

Sie kann nicht jede Ebene schützen:

- Firmware, BIOS und Boot-Kette sind weitgehend außerhalb der App-Kontrolle.
- Phishing und Social Engineering kann sie nicht sicher verhindern.
- Tiefes Netzwerk-Monitoring, Kernel- oder Endpoint-Security-Funktionen brauchen später starke Rechte und müssen sehr bewusst geplant werden.
- 2FA-, Passwortmanager-, VPN- oder Antivirus-Nutzung kann sie nur dort prüfen, wo macOS oder die jeweilige App verlässliche lokale Signale liefert.
- Cloud-Konten, Browser-Erweiterungen und externe Security-Produkte können ohne Integrationen meist nur als geführte Checkliste bewertet werden.

Die App soll ehrlich bleiben:
Sie sieht nicht alles. Aber was sie sieht, soll sie sehr gut erklären und mit aktuellen Bedrohungsdaten verbinden.

## Sicherheitsmodell in Schichten

### 1. Gerät und Firmware

Ziel:
Dem Nutzer erklären, dass diese Ebene existiert, aber nicht früh so tun, als könne die App sie voll prüfen.

Mögliche spätere Funktionen:

- Apple-Sicherheitsupdates und Rapid Security Responses erkennen
- bekannte macOS-Update-Risiken erklären
- sichere Update-Empfehlungen geben

### 2. macOS und Schutzsignale

Ziel:
Lokale Basis-Schutzsignale verständlich machen.

Beispiele:

- macOS-Version
- Gatekeeper
- SIP
- später FileVault, Firewall, Update-Status
- später Treiber-, System-Extension- und Network-Extension-Sichtbarkeit

### 3. Apps und Versionen

Ziel:
Erkennen, ob installierte Software von bekannten realen Schwachstellen betroffen sein könnte.

Mögliche Quellen:

- lokale App-Inventur
- Apple-Update-Daten
- CISA KEV
- NVD
- FIRST EPSS

### 4. Autostart und Persistenz

Ziel:
Zeigen, welche Programme automatisch starten können und was sich seit dem bekannten Zustand verändert hat.

Aktueller Stand:

- sichtbare LaunchAgent-/LaunchDaemon-`plist`-Dateien
- lokale Baseline
- bewusstes Merken erwarteter Änderungen

Später:

- moderne macOS Background Items
- stabilere Einordnung nach App, Anbieter und Signatur

### 5. Verhalten und Netzwerk

Ziel:
Später erkennen, wenn etwas wirklich auffällig handelt.

Das ist stark, aber auch riskanter:

- braucht mehr Rechte
- erzeugt mehr Fehlalarme
- muss sehr gut erklärt werden

Deshalb nicht als nächster Bastelschritt.

### 6. Menschliche Angriffe

Ziel:
Der Buddy soll den Nutzer unterstützen, aber keine falsche Sicherheit versprechen.

Beispiele:

- einfache Warnungen bei aktuellen Betrugswellen
- kurze Erklärungen im Chat-Stil
- Checklisten für "Was mache ich jetzt?"

### 7. Schutzgewohnheiten und Security-Hygiene

Ziel:
Der Buddy soll nicht nur technische Findings zeigen, sondern auch grundlegende Schutzgewohnheiten greifbar machen.

Beispiele:

- 2FA für wichtige Konten als geführte Checkliste
- Passwortmanager-Nutzung als Nutzerentscheidung oder spätere App-Erkennung
- VPN nur dort empfehlen, wo es wirklich hilft, etwa unsichere Netze, aber nicht als magischer Rundumschutz
- Antivirus-/Security-Tool-Status, wenn ein installiertes Tool lokal erkennbar ist
- macOS-Firewall, FileVault und automatische Updates als lokale Schutzsignale
- Treiber, System Extensions und Network Extensions als spätere Sichtbarkeitsquelle für tiefer eingreifende Software

Wichtig:
Viele dieser Punkte sind zuerst keine automatischen Sensoren, sondern geführte Fragen.
Die App soll ehrlich unterscheiden zwischen "gesehen", "vom Nutzer bestätigt" und "noch nicht prüfbar".

### 8. Digitaler Fußabdruck und externe Privatsphäre

Ziel:
Der Buddy soll später auch dort helfen, wo reale Angriffe oft vorbereitet werden:
öffentlich sichtbare persönliche Daten, alte Accounts, Datenlecks und wiederverwendete Kontaktinformationen.

Beispiele:

- Data-Broker- und People-Search-Listings als Aufgaben erfassen
- alte Accounts finden und Löschwege vorbereiten
- Datenlecks priorisieren: Passwort ändern, 2FA aktivieren, Account löschen, Alias ersetzen
- DSGVO-/CCPA-/KVKK-Löschanfragen als Hilfstext vorbereiten
- E-Mail-Alias-Hygiene erklären, zum Beispiel mit SimpleLogin oder vergleichbaren Diensten

Wichtig:
Das ist kein Autopilot.
Die App soll nicht heimlich nach dem Nutzer suchen, keine Löschanfragen automatisch verschicken und keine Identitätsdokumente verwalten.
Der Buddy soll vorbereiten, priorisieren und lokal nachhalten; der Nutzer entscheidet bewusst.

Kritischer Produktpunkt:
Der harte Teil ist nicht nur Textgenerierung, sondern Verifikation, Follow-up, erneute Listings und das Risiko, bei unseriösen Anbietern noch mehr Daten preiszugeben.

## Anti-Scheiter-Regeln

Dieses Projekt kann scheitern, wenn es schöner aussieht, als es wirklich schützt.
Deshalb gelten ab jetzt diese Gegenmassnahmen:

1. **Nicht mehr Schutz versprechen, als belegt ist.**
   Jede Statusaussage muss klar machen, ob sie auf lokal gesehenen Daten, Nutzerangabe, externer Quelle oder Planung beruht.

2. **Kernloop vor Feature-Breite.**
   Neue Module dürfen erst wachsen, wenn der Grundablauf sitzt: Sento sieht etwas, erklärt es einfach, priorisiert es, bietet genau einen nächsten Schritt an und merkt die Entscheidung lokal.

3. **Die App denkt vor, der Nutzer bestätigt.**
   Technische Details bleiben erreichbar, aber Sento muss zuerst Bedeutung und sichere Handlung in Alltagssprache liefern.

4. **Threat Intelligence braucht Relevanz-Matching.**
   Externe Bedrohungsdaten sind erst wertvoll, wenn sie auf macOS-Version, App-Version, lokale Belege oder klare Betroffenheit gemappt werden können.

5. **macOS-Rechte und Packaging früh mitdenken.**
   Jede neue starke Funktion braucht vorher eine Rechte-, Sandbox-, Signing- und Notarization-Notiz, damit der spätere Build nicht blockiert.

6. **Sento ist Produktlogik, nicht Deko.**
   Der Charakter darf freundlich sein, aber seine Aufgabe ist Priorisierung, Erklärung, Rückfrage und Erinnerung. Wenn er nur Schmuck ist, verfehlt er den Zweck.

7. **Täglicher Nutzen vor Dashboard-Fülle.**
   Die App muss regelmäßig eine klare, kurze Lage liefern: ruhig, prüfen oder handeln. Mehr Karten sind nur sinnvoll, wenn sie diese Lage leichter machen.

## Der rote Nutzerfluss

Der Nutzer soll die App nicht wie ein Admin-Dashboard bedienen müssen.

Der Alltag soll so aussehen:

1. Die App läuft im Hintergrund.
2. Der Buddy meldet sich nur, wenn etwas relevant ist.
3. Die Meldung beginnt mit einer einfachen Aussage:
   - "Alles ruhig."
   - "Es gibt eine neue Änderung."
   - "Dieses Update ist gerade wichtig."
   - "Diese App könnte betroffen sein."
4. Der Nutzer bekommt eine klare Frage oder Handlung:
   - "Kennst du diese Änderung?"
   - "Willst du das als erwartet merken?"
   - "Soll ich dir zeigen, wo du das Update startest?"
   - "Soll ich das weiter beobachten?"
5. Technische Details sind erreichbar, aber nicht zuerst sichtbar.
6. Die App merkt Entscheidungen lokal und kann später wieder darauf Bezug nehmen.

## UI-Zielbild

Die Hauptansicht soll eher wie ein Chat oder Aktivitätsfeed wirken, nicht wie eine lange Liste aus Rohdaten.

Die gewählte visuelle Richtung steht in `docs/visual-direction.md`.

Kurzfassung:
Die App soll wie eine Mischung aus freundlicher Mac-Health-App, nativem Command Center und dezent gamifiziertem Verteidiger wirken.
Also: einfach genug für normale Nutzer, stark genug für einen Security Buddy, aber nicht wie ein Cyberpunk-SIEM.

Aktuelle UI-Leitlinie:
Die App orientiert sich an einem hellen `Sento Guard` Mockup mit Sidebar, Buddy-Figur, Statuskarten, Missionen und Aktivitätsfeed. Der dunkle Neon-Look bleibt nur Referenz für Charakterenergie und Schutzsymbolik, nicht für den Standardmodus.

### Oben

Ein klarer Status:

- `Alles ruhig`
- `Bitte prüfen`
- `Dringend empfohlen`

### Mitte

Buddy-Meldungen in einfacher Sprache:

- was passiert ist
- warum es für diesen Mac relevant sein könnte
- was der sichere nächste Schritt ist

### Unten oder seitlich

Nur bei Bedarf:

- technische Belege
- Pfade
- interne Labels
- Rohdetails

Diese Details sind wichtig für Vertrauen, sollen aber nicht die erste Nutzererfahrung dominieren.

## Produktbausteine

### A. Lokale Sensoren

Aufgabe:
Der Buddy braucht eigene Augen auf dem Mac.

Aktuell vorhanden:

- Autostart-Hinweise
- Systemprofil-Hinweise

Nächste sinnvolle Sensoren:

- macOS-Update-/Sicherheitsupdate-Status
- installierte Apps und Versionen
- FileVault-/Firewall-Sichtbarkeit, falls ohne zu starke Rechte sinnvoll
- System Extensions, Network Extensions und Login-/Background-Items als eigener späterer macOS-Spike
- Security-Tool- und Antivirus-Sichtbarkeit nur als read-only Inventar, nicht als Bewertung fremder Produkte ohne Beleg

### B. Threat-Intelligence-Schicht

Aufgabe:
Der Buddy soll wissen, was draussen gerade relevant ist.

Gute erste Quellen:

- Apple/macOS-Sicherheitsupdate-Daten über SOFA
- CISA Known Exploited Vulnerabilities
- FIRST EPSS
- NVD als breitere CVE-Datenbank

Wichtig:
Diese Schicht soll zuerst kuratierte Quellen nutzen, nicht wildes Web-Scraping.

### C. Matching Engine

Aufgabe:
Lokale Fakten mit externen Bedrohungsdaten verbinden.

Beispiele:

- "Dein macOS ist älter als die Version, die eine aktiv ausgenutzte Lücke schließt."
- "Diese App-Version könnte zu einer bekannten Schwachstelle passen."
- "Dieser Autostart-Eintrag ist neu, aber nicht automatisch gefährlich."

Diese Engine sollte deterministisch sein.
Das heißt: Sie entscheidet nach klaren Regeln und Belegen, nicht nach Bauchgefühl eines LLM.

### C2. Adversarial Review Layer

Aufgabe:
Der Buddy soll jedes größere Feature aus Verteidiger- und Angreifer-Sicht prüfen.

Praktisch heißt das:

- Welche einfache Missbrauchskette könnte ein Angreifer versuchen?
- Welche lokalen Signale würden diese Kette sichtbar machen?
- Welche Rechte bräuchte die App, um das zu sehen?
- Wie erklärt die App das, ohne Angst zu machen?
- Wo ist eine Checkliste ehrlicher als ein automatischer Sensor?

Grenze:
Diese Ebene beschreibt Risiken und Verteidigung.
Sie liefert keine Schritt-für-Schritt-Anleitung für echte Angriffe, keine Exploit-Automation und keine verdeckten Tests gegen reale Systeme.
Details stehen in `docs/adversarial-review-and-best-practices.md`.

### D. Buddy Brain

Aufgabe:
Der Buddy erklärt und priorisiert.

Mögliche Wege:

- regelbasierte Texte für den Anfang
- lokales LLM später für private Erklärungen
- OpenAI API optional später für bessere Sprache und Recherche

Sicherheitsregel:
Das LLM darf nicht die einzige Quelle der Wahrheit sein.
Es bekommt Belege und formuliert sie verständlich. Die eigentliche Sicherheitsentscheidung kommt aus Sensoren, Feeds und Regeln.

### E. Aktionen und Begleitung

Aufgabe:
Der Nutzer braucht nicht nur Hinweise, sondern sichere nächste Schritte.

Frühe Aktionen:

- als erwartet merken
- weiter beobachten
- Erklärung anzeigen
- System-Einstellungen öffnen
- Update-Schritte anzeigen

Spätere Aktionen:

- geführte Checks
- begrenzte Safe-Mode-Validierung
- optionale Erinnerungen

Keine stillen Systemänderungen.

### F. Lokales Gedächtnis

Aufgabe:
Die App soll lernen, was auf diesem Mac normal ist.

Aktuell vorhanden:

- lokale Baseline für Startup-Items
- lokale Policy-Entscheidungen

Später:

- bekannte Apps
- akzeptierte Risiken
- wiederkehrende Muster
- erledigte Empfehlungen

### G. Best-Practice-Monitoring

Aufgabe:
Der Buddy soll später nicht nur einzelne Findings zeigen, sondern wichtige Sicherheits-Best-Practices überwachen oder geführt abfragen.

Beispiele:

- macOS-Update-Stand
- FileVault
- Firewall
- Gatekeeper/SIP
- System Extensions und Treiberzustand
- Passwort-Manager
- Zwei-Faktor-Authentifizierung
- Backup-Status
- VPN-Sinnhaftigkeit
- Antivirus-/EDR-Hinweise

Wichtig:
Was die App nicht lokal sicher messen kann, darf sie nicht behaupten.
Solche Themen werden als Buddy-Frage oder Checkliste behandelt.

### H. Privacy-Footprint-Cleanup

Aufgabe:
Der Buddy begleitet einen geführten Cleanup des digitalen Fußabdrucks.

Mögliche Quellen:

- Data-Broker-Verzeichnisse und Opt-out-Listen
- JustDeleteMe für Account-Löschwege
- Have I Been Pwned für Breach-Hygiene, mit klarer API-Key-/Datenschutzgrenze
- SimpleLogin als Vorbild oder spätere Integration für E-Mail-Aliase

Früher MVP-Schnitt:

- lokale Aufgabenliste
- manuelle Fundstellen erfassen
- Lösch-/Opt-out-Vorlagen erzeugen
- Nachfassfristen merken
- Status je Aufgabe sichtbar machen

Nicht bauen:

- automatische Personensuche ohne Zustimmung
- automatische Opt-out-Formular-Automation
- Upload oder Speicherung von Ausweisdokumenten
- SEO-"Begraben" als automatisierte Manipulation
- Rechtsberatung statt klar markierter Vorlage

## Bauen, integrieren oder inspirieren lassen

### Direkt bauen

- einfache Buddy-UI
- lokales Policy-/Gedächtnis-Modell
- Matching Engine
- erklärende Texte
- sichere Aktionsführung

### Integrieren

- SOFA für Apple/macOS-Update-Informationen
- CISA KEV für aktiv ausgenutzte Schwachstellen
- FIRST EPSS für Ausnutzungswahrscheinlichkeit
- NVD später für breitere CVE-Abdeckung
- Have I Been Pwned später für Breach-Hygiene, wenn API-Key-/Datenschutzmodell geklärt ist
- JustDeleteMe-Daten für geführte Account-Löschwege
- Data-Broker-Verzeichnisse für Opt-out-Aufgaben, sofern Lizenz und Pflegezustand passen
- SimpleLogin oder vergleichbare Alias-Dienste als Empfehlung oder spätere optionale Integration

### Als Inspiration nutzen

- Objective-See KnockKnock für Persistenz-/Autostart-Denken
- Objective-See LuLu für spätere Netzwerk-Ideen
- osquery/Fleet für lokales Inventar-Denken
- Google Santa für App-Kontroll- und Vertrauensmodelle
- Nudge für einfache Update-Kommunikation
- swiftDialog für klare macOS-Dialog-UX

## Nächste Produktphasen

### Phase 0: Buddy statt Inspector

Status:
Erster UI-Schnitt umgesetzt am 2026-05-13.
Weitere visuelle Verfeinerung bleibt sinnvoll.

Screenshot-Review am 2026-05-14:
Der erste Schnitt hat die Struktur verbessert, aber optisch wirkt die App weiterhin wie ein Inspector.
Deshalb braucht Phase 0 jetzt einen echten Redesign-Schnitt, nicht nur weitere Detailaufräumung.

Ziel:
Die aktuelle App wird weniger wie eine technische Fundliste und mehr wie ein Begleiter.

Aufgaben:

- Dashboard in Buddy-Status umbauen: umgesetzt
- nur die wichtigsten Dinge zuerst zeigen: umgesetzt im ersten Schnitt
- technische Belege einklappbar machen: umgesetzt
- linke Liste zusammenfassen: für bekannte Autostart-Hinweise umgesetzt
- eine klare Hauptaktion pro Hinweis zeigen: erste Empfehlung steht jetzt vorne

Offen:

- echte `BuddyHomeView` als Startseite bauen
- linke Finding-Liste aus der ersten Wahrnehmung entfernen oder stark zurückstufen
- Missionen und Schutzbereiche statt Rohlisten zeigen
- echte Chat-/Feed-Struktur weiter ausbauen
- danach Liquid-Glass-/visueller Feinschliff

### Phase 1: Update-Awareness

Ziel:
Der Buddy erkennt, ob macOS-Sicherheitsupdates für diesen Mac relevant sind.

Aufgaben:

- SOFA-Feed lesen und cachen
- lokale macOS-Version dagegen prüfen
- einfache Meldung erzeugen:
  - "Dieses Update ist wichtig"
  - "Du bist aktuell"
  - "Ich kann es gerade nicht prüfen"

Akzeptanzkriterien für diesen Baustein:

- Wenn der Feed nicht erreichbar ist, sagt die App das klar und behauptet keinen aktuellen Schutzstatus.
- Wenn der Cache alt ist, wird die Meldung als veraltet markiert.
- Netzwerkzugriff wird als eigene Produktentscheidung sichtbar gemacht.
- Gespeichert werden nur die nötigen Feed-Daten, keine unnötigen persönlichen Nutzerdaten.
- Die App kann offline weiter lokale Hinweise erklären.

### Phase 1.5: Best-Practice-Grundlage

Ziel:
Der Buddy bekommt eine erste strukturierte Sicht auf Sicherheits-Best-Practices.

Aufgaben:

- Best-Practice-Kategorien in der UI planen
- lokale Checks von Buddy-Fragen trennen
- Rechtebedarf pro Check dokumentieren
- Angreifer-Missbrauchsfälle pro Check notieren
- ersten lokalen Härtungsblock auswählen

Erste Kandidaten:

- FileVault
- Firewall
- Gatekeeper/SIP besser erklären
- macOS-Update-Status
- System Extensions / Treiberzustand

### Phase 2: Real Threat Matching

Ziel:
Der Buddy verbindet lokale Daten mit real bekannten Bedrohungen.

Aufgaben:

- CISA KEV importieren
- EPSS als Priorisierungssignal prüfen
- später NVD für breitere Abdeckung
- Regeln bauen, wann etwas wirklich relevant für diesen Mac ist

### Phase 2b: Security-Hygiene-Checks

Ziel:
Der Buddy fragt und prüft grundlegende Schutzthemen, die für normale Nutzer wirklich relevant sind.

Priorität:

1. macOS-Firewall, FileVault und automatische Updates, weil sie lokal und verständlich sind
2. Passwortmanager- und 2FA-Checklisten, weil echte automatische Prüfung oft kontenabhängig ist
3. Security-Tool-/Antivirus-Inventar, falls installierte Produkte sauber erkennbar sind
4. VPN-Erklärung und Entscheidungscheck, aber nur kontextbezogen
5. Treiber, System Extensions und Network Extensions als späterer fortgeschrittener Sensor

Akzeptanzkriterien:

- Jede Aussage sagt klar, ob sie automatisch geprüft oder vom Nutzer beantwortet wurde.
- Kein Schutzprodukt wird pauschal als gut oder schlecht bewertet, solange kein konkreter Beleg vorliegt.
- VPN wird nicht als allgemeiner Sicherheitszauber dargestellt.
- 2FA wird für wichtige Konten empfohlen, aber die App behauptet ohne Integration nicht, es wirklich verifiziert zu haben.

### Phase 3: App-Inventur

Ziel:
Der Buddy versteht installierte Apps besser.

Aufgaben:

- installierte Apps read-only erfassen
- Bundle-ID, Version, Signaturstatus prüfen
- später Schwachstellen grob matchen

### Phase 4: LLM-Erklärung optional

Ziel:
Der Buddy kann Belege menschlicher erklären.

Optionen:

- lokal: mehr Datenschutz, weniger Leistung und Aktualität
- Cloud/OpenAI: bessere Sprache und Recherche, aber Netzwerk und Datenschutzfragen
- hybrid: Regeln und lokale Daten bleiben Kern, LLM ist Erklär- und Recherchehelfer

### Phase 5: Stärkere Verteidigung

Ziel:
Mehr Punch, aber kontrolliert.

Mögliche spätere Bereiche:

- Netzwerkhinweise
- Prozess-/Verhaltenshinweise
- Safe-Mode-Validierung
- geführte Härtung
- optional stärkere Rechte, wenn der Nutzen klar ist

## Nächster konkreter Schritt

Der nächste Schritt ist nicht noch ein Sensor.

Der nächste Schritt ist ein echter visueller Redesign-Schnitt:

1. `BuddyHomeView` als Startseite bauen.
2. Guardian-Status, Missionen und Buddy-Meldungen als erste Ebene zeigen.
3. Die aktuelle Finding-Liste in einen Detailmodus verschieben.
4. Autostart-Hinweise als Mission oder Sammelmeldung darstellen, nicht als 17 sichtbare Karten.
5. Danach Screenshot prüfen.
6. Danach erst SOFA-/Update-Awareness als ersten Online-Intelligence-Baustein bauen.

## Sicherheitsleitplanken

- keine stillen Systemänderungen
- keine dramatischen Behauptungen ohne Beleg
- jede neue größere Funktion bekommt eine defensive Angreiferprüfung
- LLM nie als alleinige Wahrheit
- externe Feeds transparent und cachebar
- starke Rechte nur mit konkretem Nutzen
- lokale Entscheidungen bleiben sichtbar und rücksetzbar
- adversarial thinking nur für Verteidigung und Produktqualität
- keine Exploit-Automation, keine echten Angriffsketten gegen fremde Systeme
- bei Schutzgewohnheiten klar trennen zwischen automatisch gesehen, Nutzerangabe und nicht prüfbar

## Referenzen für spätere Integration

- [CISA Known Exploited Vulnerabilities](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)
- [NVD Vulnerability APIs](https://nvd.nist.gov/developers/vulnerabilities)
- [FIRST EPSS](https://www.first.org/epss/)
- [SOFA for Apple security data](https://sofa.macadmins.io/)
- [SOFA GitHub repository](https://github.com/macadmins/sofa)
- [osquery](https://github.com/osquery/osquery)
- [Fleet](https://github.com/fleetdm/fleet)
- [Objective-See KnockKnock](https://github.com/objective-see/KnockKnock)
- [Google Santa](https://github.com/google/santa)
- [macadmins Nudge](https://github.com/macadmins/nudge)
- [swiftDialog](https://github.com/swiftDialog/swiftDialog)
