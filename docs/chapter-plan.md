# Chapter Plan

## Zweck

Diese Datei teilt die Roadmap in groessere Kapitel.

Jedes Kapitel soll wie ein eigenes kleines Buchkapitel behandelt werden:

- klares Ziel
- klarer Inhalt
- klare Abnahmekriterien
- Umsetzung in mehreren kleinen Commits moeglich
- erst abschliessen, wenn Code, UI, Tests und Doku zusammenpassen

## Arbeitsregel

Wir bearbeiten immer ein Kapitel nach dem anderen.

Ein Kapitel ist fertig, wenn:

1. der Nutzerfluss verstaendlich ist
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
- Aktivitaetsfeed
- Details nur nach bewusster Auswahl

Inhalt:

- `BuddyHomeView`
- Mission-Karten
- Schutzstatus
- Buddy-Aktivitaetsmeldungen
- Detailmodus fuer Autostart/Systemhinweise

Umgesetzt:

- Die App startet jetzt mit einer breiten Buddy-Home-Ansicht statt einer Sidebar-Liste.
- Oben steht ein Guardian-Status mit kurzer Buddy-Nachricht und einer Hauptaktion.
- Die lokalen Bereiche werden als Missionen gezeigt: Autostart, Mac-Schutzsignale und geplante Security-Hygiene.
- Buddy-Aktivitaet fasst zusammen, was gerade lokal sichtbar ist.
- Details oeffnen erst nach bewusster Auswahl rechts in einem Detailbereich.
- Bekannte Autostart-Hinweise dominieren nicht mehr als lange Startliste.

Abnahme:

- Ein Screenshot muss sofort anders wirken als der aktuelle Inspector. Erfuellt; Nutzerfeedback am 2026-05-15: ruhiger, uebersichtlicher und ansprechender.
- Der Nutzer sieht zuerst "Was ist gerade los?" und nicht 17 technische Eintraege. Erfuellt durch Buddy-Home statt Auto-Auswahl der ersten Finding-Details.
- Autostart-Hinweise erscheinen als zusammengefasste Mission oder Meldung. Erfuellt.
- Technische Belege bleiben erreichbar, dominieren aber nicht. Erfuellt durch Detailbereich nach Auswahl.

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
- Typografie und Abstaende
- Statusfarben ohne Alarmismus
- Icons und Mission-Badges
- spaeter Liquid-Glass-Feinschliff

Umgesetzt:

- Startseite nutzt jetzt eine ruhigere, systemadaptive Hintergrundflaeche.
- Guardian-Status wirkt staerker wie ein Health-/Defender-Status mit semantischer Farbe.
- Primaere Aktion und naechster Schritt sind klarer gruppiert.
- Missionen haben eigene Icon-Badges, Status-Badges und dezente Fortschrittsbalken.
- Buddy-Aktivitaet nutzt kompaktere, ruhigere Zeilen mit klarer visueller Gewichtung.
- Die Gestaltung bleibt macOS-nativ und vermeidet Neon-/SIEM-Optik.
- Der Arbeits-Brand fuer die App ist jetzt `Sento Guard`.
- Die Startseite wird an das helle Mockup angelehnt: linke Navigation, freundlicher Buddy-Status, Missionen, Aktivitaetsfeed und spaetere Chat-/Hilfe-Andeutung.
- Zwei geplante Missionsbereiche sind sichtbar: `Digitaler Fussabdruck` und `App-Risiken pruefen`, ohne schon echte Pruefungen zu behaupten.

Abnahme:

- UI wirkt staerker wie ein moderner Mac-Buddy, nicht wie ein Admin-Tool. Erster Code-Schnitt umgesetzt; manuelle Sichtpruefung folgt.
- Missionen wirken motivierender, aber nicht kindisch. Erster Schnitt umgesetzt.
- Keine Rohdaten-Kartenflut auf der Startseite. Weiterhin erfuellt durch Buddy-Home-Struktur.

## Kapitel 2b: Sento Guard Shell

Status: erster Code-Schnitt umgesetzt.

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
- Statuszahlen sind als ruhige Karten sichtbar.
- Missionsraster enthaelt jetzt Autostart, Mac-Schutz, Security-Hygiene, Digitaler Fussabdruck und App-Risiken.
- Lokale Datenschutzbotschaft ist als eigene Karte sichtbar.

Noch offen:

- echtes Maskottchen-/Charakter-Asset statt SF-Symbol-Platzhalter
- finaler Markencheck fuer `Sento Guard`
- visuelle manuelle Abnahme durch Nutzer
- spaeter echte Navigation hinter den Sidebar-Punkten

## Kapitel 3: Update Awareness

Status: geplant.

Ziel:
Der Buddy erkennt, ob macOS-Sicherheitsupdates fuer diesen Mac relevant sind.

Inhalt:

- SOFA-Feed lesen
- Feed lokal cachen
- lokale macOS-Version vergleichen
- Offline-/Fehlerfall ehrlich anzeigen
- Netzwerkzugriff als Produktentscheidung sichtbar machen

Abnahme:

- Buddy kann sagen:
  - "Du bist aktuell"
  - "Dieses Update ist wichtig"
  - "Ich kann es gerade nicht pruefen"
- Kein aktueller Schutzstatus wird behauptet, wenn Feed oder Cache unsicher sind.

## Kapitel 4: Security Hygiene

Status: geplant.

Ziel:
Der Buddy begleitet grundlegende Sicherheitsgewohnheiten.

Inhalt:

- lokale Checks von Buddy-Fragen trennen
- Belegtyp anzeigen:
  - automatisch gesehen
  - Nutzerangabe
  - abgeleitet
  - nicht pruefbar
- erste lokale Kandidaten:
  - FileVault
  - Firewall
  - Gatekeeper/SIP
  - automatische Updates
  - System Extensions
- gefuehrte Fragen:
  - 2FA
  - Passwortmanager
  - Recovery Codes
  - VPN-Sinnhaftigkeit

Abnahme:

- Die App behauptet keine 2FA, die sie nicht pruefen kann.
- VPN wird nicht als magischer Rundumschutz verkauft.
- Security-Tools werden nicht pauschal bewertet, solange nur ihre Existenz sichtbar ist.

## Kapitel 5: Threat Intelligence

Status: geplant.

Ziel:
Lokale Fakten werden mit echten Bedrohungsdaten verbunden.

Inhalt:

- CISA KEV
- FIRST EPSS
- spaeter NVD
- Regeln, wann eine externe Bedrohung fuer diesen Mac relevant ist
- klare Quellenangabe

Abnahme:

- Der Buddy sagt nicht nur "es gibt eine CVE", sondern "das betrifft dich wahrscheinlich / wahrscheinlich nicht, weil ..."
- LLMs duerfen erklaeren, aber nicht allein entscheiden.
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
- spaeter Matching gegen Threat Intelligence

Abnahme:

- App-Inventar ist lokal, nachvollziehbar und ohne uebertriebene Rechte.
- Die App bewertet installierte Software nicht ohne Beleg als gefaehrlich.

## Kapitel 7: Adversarial Review Routine

Status: geplant, als Regel schon dokumentiert.

Ziel:
Jede groessere Funktion bekommt eine defensive Angreiferpruefung.

Inhalt:

- wiederholbare Review-Vorlage
- Fragen:
  - Wie koennte das missbraucht werden?
  - Welche Daten oder Rechte sind sensibel?
  - Was darf nie still passieren?
  - Welche Nutzerentscheidung ist noetig?
- Ergebnis in Design-Doku oder PR-Notiz festhalten

Abnahme:

- Neue Sensoren und Online-Funktionen haben eine sichtbare Gegenpruefung.
- Das Ergebnis bleibt defensiv: Sensoridee, Checkliste, sicherere Aktion oder bewusstes Nicht-Bauen.

## Kapitel 8: Guided Actions

Status: geplant.

Ziel:
Der Buddy hilft nicht nur beim Verstehen, sondern fuehrt sichere naechste Schritte aus oder vorbereitet sie.

Inhalt:

- Systemeinstellungen oeffnen
- Schritt-fuer-Schritt-Anleitungen
- lokale Entscheidung merken
- spaeter begrenzte Belege sammeln

Abnahme:

- Keine stillen Systemaenderungen.
- Jede Aktion sagt vorher, was passiert.
- Entscheidungen sind sichtbar und ruecksetzbar.

## Kapitel 9: Digitaler Fussabdruck

Status: geplant.

Ziel:
Der Buddy hilft spaeter nicht nur beim lokalen Mac, sondern auch beim Reduzieren sichtbarer persoenlicher Spuren im Internet.

Nicht als Vollautomatik:
Die App soll keine heimlichen Online-Suchen starten, keine Loeschanfragen automatisch versenden und keine Identitaetsdokumente verarbeiten.

Stattdessen:

- gefuehrter Privacy-Cleanup-Workflow
- lokale Aufgabenliste
- Quellen und Fundstellen vom Nutzer bestaetigen lassen
- Data-Broker-/Opt-out-Anleitungen strukturieren
- Account-Loeschungen vorbereiten
- Datenlecks einordnen
- E-Mail-Alias- und Passwortmanager-Hygiene erklaeren
- DSGVO-/CCPA-/KVKK-Textvorlagen vorbereiten
- Status lokal verfolgen: gefunden, geprueft, Anfrage vorbereitet, gesendet, bestaetigt, nachfassen

Moegliche Quellen und Inspiration:

- Data-Broker-Verzeichnisse wie Big Ass Data Broker Opt-Out List und Optery Data Broker Directory
- JustDeleteMe fuer Account-Loeschlinks
- Have I Been Pwned fuer Breach-Hygiene, mit API-Key-Grenzen fuer E-Mail-Abfragen
- SimpleLogin als Open-Source-Inspiration fuer E-Mail-Alias-Hygiene

Abnahme:

- Die App erklaert klar, welche Daten der Nutzer freiwillig eingibt.
- Der Nutzer bestaetigt jede externe Suche oder Anfrage bewusst.
- Keine sensiblen personenbezogenen Daten werden ohne ausdrueckliche Zustimmung versendet.
- Der Buddy priorisiert und erklaert, statt blind Formulare abzuarbeiten.
- Rechtliche Vorlagen sind als Hilfstexte gekennzeichnet, nicht als Rechtsberatung.

## Kapitel 10: Packaging and Trust

Status: teilweise vorbereitet.

Ziel:
Die App wird als lokales Mac-Artefakt vertrauenswuerdig baubar.

Inhalt:

- App-Bundle
- Hardened Runtime
- Sandbox-Entscheidung
- Developer ID / Notarization spaeter
- UI-Automation-Pfad klaeren

Abnahme:

- Build- und Smoke-Skripte sind gruen.
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
9. Kapitel 9: Digitaler Fussabdruck
10. Kapitel 10: Packaging and Trust

Warum diese Reihenfolge:
Erst muss die App verstaendlich und angenehm werden.
Danach lohnt sich mehr Intelligenz, mehr Sensorik und mehr Handlungskraft.
Der digitale Fussabdruck kommt nach den lokalen Grundlagen, weil dort personenbezogene Daten, externe Dienste und rechtliche Workflows beruehrt werden.
