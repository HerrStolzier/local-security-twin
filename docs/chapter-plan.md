# Chapter Plan

## Zweck

Diese Datei teilt die Roadmap in größere Kapitel.

Jedes Kapitel soll wie ein eigenes kleines Buchkapitel behandelt werden:

- klares Ziel
- klarer Inhalt
- klare Abnahmekriterien
- Umsetzung in mehreren kleinen Commits möglich
- erst abschliessen, wenn Code, UI, Tests und Doku zusammenpassen

## Arbeitsregel

Wir bearbeiten immer ein Kapitel nach dem anderen.

Ein Kapitel ist fertig, wenn:

1. der Nutzerfluss verständlich ist
2. die UI den Inhalt wirklich zeigt
3. technische Details ehrlich bleiben
4. passende Tests oder Smokes laufen
5. `docs/session-status.md` aktualisiert ist
6. dauerhafte Erkenntnisse in `docs/project-learnings.md` stehen
7. der Stand committed und gepusht ist

## Kapitel 1: Buddy Home

Status: erster Schnitt umgesetzt und manuell positiv abgenommen.

Ziel:
Die App bekommt eine echte Startseite.

Nicht mehr:
Sidebar-Finding-Liste als erste Erfahrung.

Stattdessen:

- Guardian-Status oben
- kurze Buddy-Nachricht
- eine klare Hauptaktion
- Missionen und Schutzbereiche
- Aktivitätsfeed
- Details nur nach bewusster Auswahl

Inhalt:

- `BuddyHomeView`
- Mission-Karten
- Schutzstatus
- Buddy-Aktivitätsmeldungen
- Detailmodus für Autostart/Systemhinweise

Umgesetzt:

- Die App startet jetzt mit einer breiten Buddy-Home-Ansicht statt einer Sidebar-Liste.
- Oben steht ein Guardian-Status mit kurzer Buddy-Nachricht und einer Hauptaktion.
- Die lokalen Bereiche werden als Missionen gezeigt: Autostart, Mac-Schutzsignale und geplante Security-Hygiene.
- Buddy-Aktivität fasst zusammen, was gerade lokal sichtbar ist.
- Details öffnen erst nach bewusster Auswahl rechts in einem Detailbereich.
- Bekannte Autostart-Hinweise dominieren nicht mehr als lange Startliste.

Abnahme:

- Ein Screenshot muss sofort anders wirken als der aktuelle Inspector. Erfüllt; Nutzerfeedback am 2026-05-15: ruhiger, übersichtlicher und ansprechender.
- Der Nutzer sieht zuerst "Was ist gerade los?" und nicht 17 technische Einträge. Erfüllt durch Buddy-Home statt Auto-Auswahl der ersten Finding-Details.
- Autostart-Hinweise erscheinen als zusammengefasste Mission oder Meldung. Erfüllt.
- Technische Belege bleiben erreichbar, dominieren aber nicht. Erfüllt durch Detailbereich nach Auswahl.

## Kapitel 2: Visual System

Status: erster Schnitt umgesetzt; Kapitel 2b `Sento Guard Shell` in Arbeit.

Ziel:
Die neue Startseite bekommt eine klare visuelle Sprache.

Richtung:

- friendly Mac health app
- native Mac command center
- dezente Gameful-Defender-Schicht
- kein Cyberpunk-SIEM

Inhalt:

- stabile Layoutregeln
- Typografie und Abstände
- Statusfarben ohne Alarmismus
- Icons und Mission-Badges
- später Liquid-Glass-Feinschliff

Umgesetzt:

- Startseite nutzt jetzt eine ruhigere, systemadaptive Hintergrundflaeche.
- Guardian-Status wirkt stärker wie ein Health-/Defender-Status mit semantischer Farbe.
- Primäre Aktion und nächster Schritt sind klarer gruppiert.
- Missionen haben eigene Icon-Badges, Status-Badges und dezente Fortschrittsbalken.
- Buddy-Aktivität nutzt kompaktere, ruhigere Zeilen mit klarer visueller Gewichtung.
- Die Gestaltung bleibt macOS-nativ und vermeidet Neon-/SIEM-Optik.
- Der Arbeits-Brand für die App ist jetzt `Sento Guard`.
- Die Startseite wird an das helle Mockup angelehnt: linke Navigation, freundlicher Buddy-Status, Missionen, Aktivitätsfeed und spätere Chat-/Hilfe-Andeutung.
- Zwei geplante Missionsbereiche sind sichtbar: `Digitaler Fußabdruck` und `App-Risiken prüfen`, ohne schon echte Prüfungen zu behaupten.

Abnahme:

- UI wirkt stärker wie ein moderner Mac-Buddy, nicht wie ein Admin-Tool. Erster Code-Schnitt umgesetzt; manuelle Sichtpruefung folgt.
- Missionen wirken motivierender, aber nicht kindisch. Erster Schnitt umgesetzt.
- Keine Rohdaten-Kartenflut auf der Startseite. Weiterhin erfüllt durch Buddy-Home-Struktur.

## Kapitel 2b: Sento Guard Shell

Status: Prototyp-Stand für jetzt ausreichend; späteres Asset-/Animationskapitel bleibt offen.

Ziel:
Die App bekommt eine erkennbare Produktidentitaet und einen klareren Einstieg, ohne in dunkle Cyberpunk-Optik oder falsche Sicherheitsversprechen zu kippen.

Richtung:

- Name im Prototyp: `Sento Guard`
- hell, freundlich, macOS-nah
- Buddy/Charakter als Orientierungsfigur
- linke Navigation als ruhiger Produkt-Rahmen
- Missionen als Hauptstruktur
- Activity-Feed als roter Faden

Umgesetzt:

- Sidebar mit `Sento Guard` Branding und Mission-/Buddy-Navigation.
- Hero-Bereich begruesst den Nutzer als Sento Guard.
- Sento ist als sichtbare SwiftUI-Figur mit Körper, Augen und Schild umgesetzt.
- Statuszahlen sind als ruhige Karten sichtbar.
- Missionsraster enthält jetzt Autostart, Mac-Schutz, Security-Hygiene, Digitaler Fußabdruck und App-Risiken.
- Lokale Datenschutzbotschaft ist als eigene Karte sichtbar.

Noch offen:

- finales Maskottchen-/Character-Asset statt SwiftUI-Prototypfigur
- finaler Markencheck für `Sento Guard`
- später echte Navigation hinter den Sidebar-Punkten

Abnahme:

- Lokale Sichtprüfung am 2026-05-16 bestätigt: Die helle Shell wirkt wie ein Buddy-Home statt wie eine rohe Finding-Liste.
- Sento ist als Prototypfigur erkennbar und reicht für den aktuellen Produktfluss.
- Für ein finales Produkt braucht Sento später ein eigenes Character-/Asset-/Animationskapitel.

## Kapitel 3: Update Awareness

Status: erster Sensor-/Cache-Schnitt und sichtbarer Netzwerk-Aktualisieren-Flow umgesetzt; lokale Sichtprüfung am 2026-05-16 als ausreichender Prototyp-Schnitt abgeschlossen.

Ziel:
Der Buddy erkennt, ob macOS-Sicherheitsupdates für diesen Mac relevant sind.

Inhalt:

- SOFA-Feed lesen
- Feed lokal cachen
- lokale macOS-Version vergleichen
- Offline-/Fehlerfall ehrlich anzeigen
- Netzwerkzugriff als Produktentscheidung sichtbar machen

Vorbereitung:

- Detailplan liegt in `docs/update-awareness-plan.md`.
- Erste Quelle soll der öffentliche SOFA-macOS-Feed der MacAdmins sein.
- Die UI darf nur den Stand der letzten erfolgreichen Quelle erklären, nicht pauschal behaupten, der Mac sei vollständig geschützt.

Umgesetzt:

- `UpdateAwarenessSensor` hängt am vorhandenen Sensorvertrag.
- SOFA-JSON kann dekodiert und gegen die lokale macOS-Version verglichen werden.
- Lokaler Cache wird ohne Netzwerk genutzt, falls vorhanden.
- Ohne Cache zeigt die App eine ruhige Sichtgrenze statt eines Alarms.
- Die Startseite bietet `SOFA-Stand aktualisieren` als bewusste Aktion mit Bestätigung vor dem Online-Abruf.
- Normaler App-Start bleibt ohne stillen SOFA-Netzwerkabruf.

Abnahme:

- Buddy kann sagen:
  - "Du bist aktuell"
  - "Dieses Update ist wichtig"
  - "Ich kann es gerade nicht prüfen"
- Kein aktueller Schutzstatus wird behauptet, wenn Feed oder Cache unsicher sind.
- Nach bewusstem `SOFA-Stand aktualisieren` sind Bestätigung, Aktualisierungsbanner, Mission `Update geprüft`, Aktivitätsfeed und Update-Detailbereich sichtbar.

## Kapitel 4: Security Hygiene

Status: begonnen; erster Prototyp-Schnitt umgesetzt.

Ziel:
Der Buddy begleitet grundlegende Sicherheitsgewohnheiten.

Inhalt:

- lokale Checks von Buddy-Fragen trennen
- Belegtyp anzeigen:
  - automatisch gesehen
  - Nutzerangabe
  - abgeleitet
  - nicht prüfbar
- erste lokale Kandidaten:
  - FileVault
  - Firewall
  - Gatekeeper/SIP
  - automatische Updates
  - System Extensions
- geführte Fragen:
  - 2FA
  - Passwortmanager
  - Recovery Codes
  - VPN-Sinnhaftigkeit

Umgesetzt:

- Hygiene-Katalog trennt automatisch sichtbare lokale Signale, Nutzerangaben, abgeleitete Hinweise und aktuell nicht prüfbare Punkte.
- Buddy-Home zeigt `Sicherheitsgewohnheiten` mit klaren Zuständen wie `Erkannt`, `Noch nicht geprüft`, `Später als Frage` und `Bleibt offen`.
- Erste Buddy-Fragen zu Passwortmanager, 2FA, Recovery Codes und VPN-Sinnhaftigkeit speichern Antworten lokal und markieren sie weiterhin als Nutzerangabe.
- macOS-Updates, Gatekeeper, SIP, FileVault und Firewall werden als lokale Schutzsignale eingeordnet, sobald passende Evidence sichtbar ist.

Abnahme:

- Die App behauptet keine 2FA, die sie nicht prüfen kann.
- VPN wird nicht als magischer Rundumschutz verkauft.
- Security-Tools werden nicht pauschal bewertet, solange nur ihre Existenz sichtbar ist.

## Kapitel 5: Threat Intelligence

Status: geplant.

Ziel:
Lokale Fakten werden mit echten Bedrohungsdaten verbunden.

Inhalt:

- CISA KEV
- FIRST EPSS
- später NVD
- Regeln, wann eine externe Bedrohung für diesen Mac relevant ist
- klare Quellenangabe

Abnahme:

- Der Buddy sagt nicht nur "es gibt eine CVE", sondern "das betrifft dich wahrscheinlich / wahrscheinlich nicht, weil ..."
- LLMs dürfen erklären, aber nicht allein entscheiden.
- Quellen und Zeitstand bleiben sichtbar.

## Kapitel 6: App Inventory

Status: geplant.

Ziel:
Der Buddy versteht installierte Apps besser.

Inhalt:

- installierte Apps read-only erfassen
- Bundle-ID
- Version
- Signaturstatus
- später Matching gegen Threat Intelligence

Abnahme:

- App-Inventar ist lokal, nachvollziehbar und ohne übertriebene Rechte.
- Die App bewertet installierte Software nicht ohne Beleg als gefährlich.

## Kapitel 7: Adversarial Review Routine

Status: geplant, als Regel schon dokumentiert.

Ziel:
Jede größere Funktion bekommt eine defensive Angreiferprüfung.

Inhalt:

- wiederholbare Review-Vorlage
- Fragen:
  - Wie könnte das missbraucht werden?
  - Welche Daten oder Rechte sind sensibel?
  - Was darf nie still passieren?
  - Welche Nutzerentscheidung ist nötig?
- Ergebnis in Design-Doku oder PR-Notiz festhalten

Abnahme:

- Neue Sensoren und Online-Funktionen haben eine sichtbare Gegenpruefung.
- Das Ergebnis bleibt defensiv: Sensoridee, Checkliste, sicherere Aktion oder bewusstes Nicht-Bauen.

## Kapitel 8: Guided Actions

Status: geplant.

Ziel:
Der Buddy hilft nicht nur beim Verstehen, sondern führt sichere nächste Schritte aus oder vorbereitet sie.

Inhalt:

- Systemeinstellungen öffnen
- Schritt-für-Schritt-Anleitungen
- lokale Entscheidung merken
- später begrenzte Belege sammeln

Abnahme:

- Keine stillen Systemänderungen.
- Jede Aktion sagt vorher, was passiert.
- Entscheidungen sind sichtbar und rücksetzbar.

## Kapitel 9: Digitaler Fußabdruck

Status: geplant.

Ziel:
Der Buddy hilft später nicht nur beim lokalen Mac, sondern auch beim Reduzieren sichtbarer persönlicher Spuren im Internet.

Nicht als Vollautomatik:
Die App soll keine heimlichen Online-Suchen starten, keine Löschanfragen automatisch versenden und keine Identitätsdokumente verarbeiten.

Stattdessen:

- geführter Privacy-Cleanup-Workflow
- lokale Aufgabenliste
- Quellen und Fundstellen vom Nutzer bestätigen lassen
- Data-Broker-/Opt-out-Anleitungen strukturieren
- Account-Löschungen vorbereiten
- Datenlecks einordnen
- E-Mail-Alias- und Passwortmanager-Hygiene erklären
- DSGVO-/CCPA-/KVKK-Textvorlagen vorbereiten
- Status lokal verfolgen: gefunden, geprüft, Anfrage vorbereitet, gesendet, bestätigt, nachfassen

Mögliche Quellen und Inspiration:

- Data-Broker-Verzeichnisse wie Big Ass Data Broker Opt-Out List und Optery Data Broker Directory
- JustDeleteMe für Account-Löschlinks
- Have I Been Pwned für Breach-Hygiene, mit API-Key-Grenzen für E-Mail-Abfragen
- SimpleLogin als Open-Source-Inspiration für E-Mail-Alias-Hygiene

Abnahme:

- Die App erklärt klar, welche Daten der Nutzer freiwillig eingibt.
- Der Nutzer bestätigt jede externe Suche oder Anfrage bewusst.
- Keine sensiblen personenbezogenen Daten werden ohne ausdrueckliche Zustimmung versendet.
- Der Buddy priorisiert und erklärt, statt blind Formulare abzuarbeiten.
- Rechtliche Vorlagen sind als Hilfstexte gekennzeichnet, nicht als Rechtsberatung.

## Kapitel 10: Packaging and Trust

Status: teilweise vorbereitet.

Ziel:
Die App wird als lokales Mac-Artefakt vertrauenswürdig baubar.

Inhalt:

- App-Bundle
- Hardened Runtime
- Sandbox-Entscheidung
- Developer ID / Notarization später
- UI-Automation-Pfad klären

Abnahme:

- Build- und Smoke-Skripte sind grün.
- Signing-/Sandbox-Grenzen sind dokumentiert.
- Nutzer-Testbuilds haben einen klaren Weg.

## Empfohlene Reihenfolge

1. Kapitel 1: Buddy Home
2. Kapitel 2: Visual System
3. Kapitel 3: Update Awareness
4. Kapitel 4: Security Hygiene
5. Kapitel 7: Adversarial Review Routine
6. Kapitel 5: Threat Intelligence
7. Kapitel 6: App Inventory
8. Kapitel 8: Guided Actions
9. Kapitel 9: Digitaler Fußabdruck
10. Kapitel 10: Packaging and Trust

Warum diese Reihenfolge:
Erst muss die App verständlich und angenehm werden.
Danach lohnt sich mehr Intelligenz, mehr Sensorik und mehr Handlungskraft.
Der digitale Fußabdruck kommt nach den lokalen Grundlagen, weil dort personenbezogene Daten, externe Dienste und rechtliche Workflows beruehrt werden.
