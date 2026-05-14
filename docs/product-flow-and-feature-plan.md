# Product Flow and Feature Plan

## Zweck

Diese Datei beschreibt den roten Faden fuer die App.

Sie beantwortet drei Fragen:

1. Was soll die App fuer den Nutzer sein?
2. Wie benutzt der Nutzer sie im Alltag?
3. Welche Bausteine muessen wir dafuer Schritt fuer Schritt bauen?

## Produktbild

`local-security-twin` soll ein kraftvoller Security Buddy fuer normale Mac-Nutzer werden.

Er soll nicht nur eine Hinweis-Liste sein. Er soll wie ein Verteidiger arbeiten:

- lokal beobachten
- relevante Aenderungen erkennen
- aus Angreifer-Sicht fragen, welche Wege realistisch missbraucht werden koennten
- aktuelle Bedrohungsinformationen einordnen
- wichtige Schutzgewohnheiten sichtbar machen
- einfach erklaeren, was das fuer diesen Mac bedeutet
- mit dem Nutzer zusammen entscheiden
- sichere naechste Schritte fuehren

Wichtig:
Kraftvoll heisst nicht laut, hektisch oder riskant. Kraftvoll heisst: gute Belege, klare Prioritaeten, aktuelle Informationen und handlungsfaehige naechste Schritte.

Ein wichtiger Teil davon ist eine eingebaute Gegenperspektive:
Die App soll beim Planen und Bewerten immer auch fragen: "Wenn ich ein vorsichtiger Angreifer waere, was waere der naheliegende Weg?"
Diese Perspektive ist kein Auftrag fuer echte Angriffe.
Sie ist ein Sicherheitsfilter, damit die App bessere Verteidigungshinweise gibt und keine einfachen Risiken uebersieht.

## Was die App nicht ist

Die App ersetzt kein ganzes Security-Team und auch kein vollstaendiges Antiviren- oder EDR-System.

Sie kann nicht jede Ebene schuetzen:

- Firmware, BIOS und Boot-Kette sind weitgehend ausserhalb der App-Kontrolle.
- Phishing und Social Engineering kann sie nicht sicher verhindern.
- Tiefes Netzwerk-Monitoring, Kernel- oder Endpoint-Security-Funktionen brauchen spaeter starke Rechte und muessen sehr bewusst geplant werden.
- 2FA-, Passwortmanager-, VPN- oder Antivirus-Nutzung kann sie nur dort pruefen, wo macOS oder die jeweilige App verlaessliche lokale Signale liefert.
- Cloud-Konten, Browser-Erweiterungen und externe Security-Produkte koennen ohne Integrationen meist nur als gefuehrte Checkliste bewertet werden.

Die App soll ehrlich bleiben:
Sie sieht nicht alles. Aber was sie sieht, soll sie sehr gut erklaeren und mit aktuellen Bedrohungsdaten verbinden.

## Sicherheitsmodell in Schichten

### 1. Geraet und Firmware

Ziel:
Dem Nutzer erklaeren, dass diese Ebene existiert, aber nicht frueh so tun, als koenne die App sie voll pruefen.

Moegliche spaetere Funktionen:

- Apple-Sicherheitsupdates und Rapid Security Responses erkennen
- bekannte macOS-Update-Risiken erklaeren
- sichere Update-Empfehlungen geben

### 2. macOS und Schutzsignale

Ziel:
Lokale Basis-Schutzsignale verstaendlich machen.

Beispiele:

- macOS-Version
- Gatekeeper
- SIP
- spaeter FileVault, Firewall, Update-Status
- spaeter Treiber-, System-Extension- und Network-Extension-Sichtbarkeit

### 3. Apps und Versionen

Ziel:
Erkennen, ob installierte Software von bekannten realen Schwachstellen betroffen sein koennte.

Moegliche Quellen:

- lokale App-Inventur
- Apple-Update-Daten
- CISA KEV
- NVD
- FIRST EPSS

### 4. Autostart und Persistenz

Ziel:
Zeigen, welche Programme automatisch starten koennen und was sich seit dem bekannten Zustand veraendert hat.

Aktueller Stand:

- sichtbare LaunchAgent-/LaunchDaemon-`plist`-Dateien
- lokale Baseline
- bewusstes Merken erwarteter Aenderungen

Spaeter:

- moderne macOS Background Items
- stabilere Einordnung nach App, Anbieter und Signatur

### 5. Verhalten und Netzwerk

Ziel:
Spaeter erkennen, wenn etwas wirklich auffaellig handelt.

Das ist stark, aber auch riskanter:

- braucht mehr Rechte
- erzeugt mehr Fehlalarme
- muss sehr gut erklaert werden

Deshalb nicht als naechster Bastelschritt.

### 6. Menschliche Angriffe

Ziel:
Der Buddy soll den Nutzer unterstuetzen, aber keine falsche Sicherheit versprechen.

Beispiele:

- einfache Warnungen bei aktuellen Betrugswellen
- kurze Erklaerungen im Chat-Stil
- Checklisten fuer "Was mache ich jetzt?"

### 7. Schutzgewohnheiten und Security-Hygiene

Ziel:
Der Buddy soll nicht nur technische Findings zeigen, sondern auch grundlegende Schutzgewohnheiten greifbar machen.

Beispiele:

- 2FA fuer wichtige Konten als gefuehrte Checkliste
- Passwortmanager-Nutzung als Nutzerentscheidung oder spaetere App-Erkennung
- VPN nur dort empfehlen, wo es wirklich hilft, etwa unsichere Netze, aber nicht als magischer Rundumschutz
- Antivirus-/Security-Tool-Status, wenn ein installiertes Tool lokal erkennbar ist
- macOS-Firewall, FileVault und automatische Updates als lokale Schutzsignale
- Treiber, System Extensions und Network Extensions als spaetere Sichtbarkeitsquelle fuer tiefer eingreifende Software

Wichtig:
Viele dieser Punkte sind zuerst keine automatischen Sensoren, sondern gefuehrte Fragen.
Die App soll ehrlich unterscheiden zwischen "gesehen", "vom Nutzer bestaetigt" und "noch nicht pruefbar".

## Der rote Nutzerfluss

Der Nutzer soll die App nicht wie ein Admin-Dashboard bedienen muessen.

Der Alltag soll so aussehen:

1. Die App laeuft im Hintergrund.
2. Der Buddy meldet sich nur, wenn etwas relevant ist.
3. Die Meldung beginnt mit einer einfachen Aussage:
   - "Alles ruhig."
   - "Es gibt eine neue Aenderung."
   - "Dieses Update ist gerade wichtig."
   - "Diese App koennte betroffen sein."
4. Der Nutzer bekommt eine klare Frage oder Handlung:
   - "Kennst du diese Aenderung?"
   - "Willst du das als erwartet merken?"
   - "Soll ich dir zeigen, wo du das Update startest?"
   - "Soll ich das weiter beobachten?"
5. Technische Details sind erreichbar, aber nicht zuerst sichtbar.
6. Die App merkt Entscheidungen lokal und kann spaeter wieder darauf Bezug nehmen.

## UI-Zielbild

Die Hauptansicht soll eher wie ein Chat oder Aktivitaetsfeed wirken, nicht wie eine lange Liste aus Rohdaten.

Die gewaehlte visuelle Richtung steht in `docs/visual-direction.md`.

Kurzfassung:
Die App soll wie eine Mischung aus freundlicher Mac-Health-App, nativem Command Center und dezent gamifiziertem Verteidiger wirken.
Also: einfach genug fuer normale Nutzer, stark genug fuer einen Security Buddy, aber nicht wie ein Cyberpunk-SIEM.

### Oben

Ein klarer Status:

- `Alles ruhig`
- `Bitte pruefen`
- `Dringend empfohlen`

### Mitte

Buddy-Meldungen in einfacher Sprache:

- was passiert ist
- warum es fuer diesen Mac relevant sein koennte
- was der sichere naechste Schritt ist

### Unten oder seitlich

Nur bei Bedarf:

- technische Belege
- Pfade
- interne Labels
- Rohdetails

Diese Details sind wichtig fuer Vertrauen, sollen aber nicht die erste Nutzererfahrung dominieren.

## Produktbausteine

### A. Lokale Sensoren

Aufgabe:
Der Buddy braucht eigene Augen auf dem Mac.

Aktuell vorhanden:

- Autostart-Hinweise
- Systemprofil-Hinweise

Naechste sinnvolle Sensoren:

- macOS-Update-/Sicherheitsupdate-Status
- installierte Apps und Versionen
- FileVault-/Firewall-Sichtbarkeit, falls ohne zu starke Rechte sinnvoll
- System Extensions, Network Extensions und Login-/Background-Items als eigener spaeterer macOS-Spike
- Security-Tool- und Antivirus-Sichtbarkeit nur als read-only Inventar, nicht als Bewertung fremder Produkte ohne Beleg

### B. Threat-Intelligence-Schicht

Aufgabe:
Der Buddy soll wissen, was draussen gerade relevant ist.

Gute erste Quellen:

- Apple/macOS-Sicherheitsupdate-Daten ueber SOFA
- CISA Known Exploited Vulnerabilities
- FIRST EPSS
- NVD als breitere CVE-Datenbank

Wichtig:
Diese Schicht soll zuerst kuratierte Quellen nutzen, nicht wildes Web-Scraping.

### C. Matching Engine

Aufgabe:
Lokale Fakten mit externen Bedrohungsdaten verbinden.

Beispiele:

- "Dein macOS ist aelter als die Version, die eine aktiv ausgenutzte Luecke schliesst."
- "Diese App-Version koennte zu einer bekannten Schwachstelle passen."
- "Dieser Autostart-Eintrag ist neu, aber nicht automatisch gefaehrlich."

Diese Engine sollte deterministisch sein.
Das heisst: Sie entscheidet nach klaren Regeln und Belegen, nicht nach Bauchgefuehl eines LLM.

### C2. Adversarial Review Layer

Aufgabe:
Der Buddy soll jedes groessere Feature aus Verteidiger- und Angreifer-Sicht pruefen.

Praktisch heisst das:

- Welche einfache Missbrauchskette koennte ein Angreifer versuchen?
- Welche lokalen Signale wuerden diese Kette sichtbar machen?
- Welche Rechte braeuchte die App, um das zu sehen?
- Wie erklaert die App das, ohne Angst zu machen?
- Wo ist eine Checkliste ehrlicher als ein automatischer Sensor?

Grenze:
Diese Ebene beschreibt Risiken und Verteidigung.
Sie liefert keine Schritt-fuer-Schritt-Anleitung fuer echte Angriffe, keine Exploit-Automation und keine verdeckten Tests gegen reale Systeme.
Details stehen in `docs/adversarial-review-and-best-practices.md`.

### D. Buddy Brain

Aufgabe:
Der Buddy erklaert und priorisiert.

Moegliche Wege:

- regelbasierte Texte fuer den Anfang
- lokales LLM spaeter fuer private Erklaerungen
- OpenAI API optional spaeter fuer bessere Sprache und Recherche

Sicherheitsregel:
Das LLM darf nicht die einzige Quelle der Wahrheit sein.
Es bekommt Belege und formuliert sie verstaendlich. Die eigentliche Sicherheitsentscheidung kommt aus Sensoren, Feeds und Regeln.

### E. Aktionen und Begleitung

Aufgabe:
Der Nutzer braucht nicht nur Hinweise, sondern sichere naechste Schritte.

Fruehe Aktionen:

- als erwartet merken
- weiter beobachten
- Erklaerung anzeigen
- System-Einstellungen oeffnen
- Update-Schritte anzeigen

Spaetere Aktionen:

- gefuehrte Checks
- begrenzte Safe-Mode-Validierung
- optionale Erinnerungen

Keine stillen Systemaenderungen.

### F. Lokales Gedaechtnis

Aufgabe:
Die App soll lernen, was auf diesem Mac normal ist.

Aktuell vorhanden:

- lokale Baseline fuer Startup-Items
- lokale Policy-Entscheidungen

Spaeter:

- bekannte Apps
- akzeptierte Risiken
- wiederkehrende Muster
- erledigte Empfehlungen

### G. Best-Practice-Monitoring

Aufgabe:
Der Buddy soll spaeter nicht nur einzelne Findings zeigen, sondern wichtige Sicherheits-Best-Practices ueberwachen oder gefuehrt abfragen.

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

## Bauen, integrieren oder inspirieren lassen

### Direkt bauen

- einfache Buddy-UI
- lokales Policy-/Gedaechtnis-Modell
- Matching Engine
- erklaerende Texte
- sichere Aktionsfuehrung

### Integrieren

- SOFA fuer Apple/macOS-Update-Informationen
- CISA KEV fuer aktiv ausgenutzte Schwachstellen
- FIRST EPSS fuer Ausnutzungswahrscheinlichkeit
- NVD spaeter fuer breitere CVE-Abdeckung

### Als Inspiration nutzen

- Objective-See KnockKnock fuer Persistenz-/Autostart-Denken
- Objective-See LuLu fuer spaetere Netzwerk-Ideen
- osquery/Fleet fuer lokales Inventar-Denken
- Google Santa fuer App-Kontroll- und Vertrauensmodelle
- Nudge fuer einfache Update-Kommunikation
- swiftDialog fuer klare macOS-Dialog-UX

## Naechste Produktphasen

### Phase 0: Buddy statt Inspector

Status:
Erster UI-Schnitt umgesetzt am 2026-05-13.
Weitere visuelle Verfeinerung bleibt sinnvoll.

Screenshot-Review am 2026-05-14:
Der erste Schnitt hat die Struktur verbessert, aber optisch wirkt die App weiterhin wie ein Inspector.
Deshalb braucht Phase 0 jetzt einen echten Redesign-Schnitt, nicht nur weitere Detailaufraeumung.

Ziel:
Die aktuelle App wird weniger wie eine technische Fundliste und mehr wie ein Begleiter.

Aufgaben:

- Dashboard in Buddy-Status umbauen: umgesetzt
- nur die wichtigsten Dinge zuerst zeigen: umgesetzt im ersten Schnitt
- technische Belege einklappbar machen: umgesetzt
- linke Liste zusammenfassen: fuer bekannte Autostart-Hinweise umgesetzt
- eine klare Hauptaktion pro Hinweis zeigen: erste Empfehlung steht jetzt vorne

Offen:

- echte `BuddyHomeView` als Startseite bauen
- linke Finding-Liste aus der ersten Wahrnehmung entfernen oder stark zurueckstufen
- Missionen und Schutzbereiche statt Rohlisten zeigen
- echte Chat-/Feed-Struktur weiter ausbauen
- danach Liquid-Glass-/visueller Feinschliff

### Phase 1: Update-Awareness

Ziel:
Der Buddy erkennt, ob macOS-Sicherheitsupdates fuer diesen Mac relevant sind.

Aufgaben:

- SOFA-Feed lesen und cachen
- lokale macOS-Version dagegen pruefen
- einfache Meldung erzeugen:
  - "Dieses Update ist wichtig"
  - "Du bist aktuell"
  - "Ich kann es gerade nicht pruefen"

Akzeptanzkriterien fuer diesen Baustein:

- Wenn der Feed nicht erreichbar ist, sagt die App das klar und behauptet keinen aktuellen Schutzstatus.
- Wenn der Cache alt ist, wird die Meldung als veraltet markiert.
- Netzwerkzugriff wird als eigene Produktentscheidung sichtbar gemacht.
- Gespeichert werden nur die noetigen Feed-Daten, keine unnoetigen persoenlichen Nutzerdaten.
- Die App kann offline weiter lokale Hinweise erklaeren.

### Phase 1.5: Best-Practice-Grundlage

Ziel:
Der Buddy bekommt eine erste strukturierte Sicht auf Sicherheits-Best-Practices.

Aufgaben:

- Best-Practice-Kategorien in der UI planen
- lokale Checks von Buddy-Fragen trennen
- Rechtebedarf pro Check dokumentieren
- Angreifer-Missbrauchsfaelle pro Check notieren
- ersten lokalen Haertungsblock auswaehlen

Erste Kandidaten:

- FileVault
- Firewall
- Gatekeeper/SIP besser erklaeren
- macOS-Update-Status
- System Extensions / Treiberzustand

### Phase 2: Real Threat Matching

Ziel:
Der Buddy verbindet lokale Daten mit real bekannten Bedrohungen.

Aufgaben:

- CISA KEV importieren
- EPSS als Priorisierungssignal pruefen
- spaeter NVD fuer breitere Abdeckung
- Regeln bauen, wann etwas wirklich relevant fuer diesen Mac ist

### Phase 2b: Security-Hygiene-Checks

Ziel:
Der Buddy fragt und prueft grundlegende Schutzthemen, die fuer normale Nutzer wirklich relevant sind.

Prioritaet:

1. macOS-Firewall, FileVault und automatische Updates, weil sie lokal und verstaendlich sind
2. Passwortmanager- und 2FA-Checklisten, weil echte automatische Pruefung oft kontenabhaengig ist
3. Security-Tool-/Antivirus-Inventar, falls installierte Produkte sauber erkennbar sind
4. VPN-Erklaerung und Entscheidungscheck, aber nur kontextbezogen
5. Treiber, System Extensions und Network Extensions als spaeterer fortgeschrittener Sensor

Akzeptanzkriterien:

- Jede Aussage sagt klar, ob sie automatisch geprueft oder vom Nutzer beantwortet wurde.
- Kein Schutzprodukt wird pauschal als gut oder schlecht bewertet, solange kein konkreter Beleg vorliegt.
- VPN wird nicht als allgemeiner Sicherheitszauber dargestellt.
- 2FA wird fuer wichtige Konten empfohlen, aber die App behauptet ohne Integration nicht, es wirklich verifiziert zu haben.

### Phase 3: App-Inventur

Ziel:
Der Buddy versteht installierte Apps besser.

Aufgaben:

- installierte Apps read-only erfassen
- Bundle-ID, Version, Signaturstatus pruefen
- spaeter Schwachstellen grob matchen

### Phase 4: LLM-Erklaerung optional

Ziel:
Der Buddy kann Belege menschlicher erklaeren.

Optionen:

- lokal: mehr Datenschutz, weniger Leistung und Aktualitaet
- Cloud/OpenAI: bessere Sprache und Recherche, aber Netzwerk und Datenschutzfragen
- hybrid: Regeln und lokale Daten bleiben Kern, LLM ist Erklaer- und Recherchehelfer

### Phase 5: Staerkere Verteidigung

Ziel:
Mehr Punch, aber kontrolliert.

Moegliche spaetere Bereiche:

- Netzwerkhinweise
- Prozess-/Verhaltenshinweise
- Safe-Mode-Validierung
- gefuehrte Haertung
- optional staerkere Rechte, wenn der Nutzen klar ist

## Naechster konkreter Schritt

Der naechste Schritt ist nicht noch ein Sensor.

Der naechste Schritt ist ein echter visueller Redesign-Schnitt:

1. `BuddyHomeView` als Startseite bauen.
2. Guardian-Status, Missionen und Buddy-Meldungen als erste Ebene zeigen.
3. Die aktuelle Finding-Liste in einen Detailmodus verschieben.
4. Autostart-Hinweise als Mission oder Sammelmeldung darstellen, nicht als 17 sichtbare Karten.
5. Danach Screenshot pruefen.
6. Danach erst SOFA-/Update-Awareness als ersten Online-Intelligence-Baustein bauen.

## Sicherheitsleitplanken

- keine stillen Systemaenderungen
- keine dramatischen Behauptungen ohne Beleg
- jede neue groessere Funktion bekommt eine defensive Angreiferpruefung
- LLM nie als alleinige Wahrheit
- externe Feeds transparent und cachebar
- starke Rechte nur mit konkretem Nutzen
- lokale Entscheidungen bleiben sichtbar und ruecksetzbar
- adversarial thinking nur fuer Verteidigung und Produktqualitaet
- keine Exploit-Automation, keine echten Angriffsketten gegen fremde Systeme
- bei Schutzgewohnheiten klar trennen zwischen automatisch gesehen, Nutzerangabe und nicht pruefbar

## Referenzen fuer spaetere Integration

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
