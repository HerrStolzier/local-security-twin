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

Status: erster Schnitt umgesetzt.

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

- Ein Screenshot muss sofort anders wirken als der aktuelle Inspector. Erster Code-Schnitt ist vorhanden; manuelle Screenshot-Pruefung bleibt sinnvoll.
- Der Nutzer sieht zuerst "Was ist gerade los?" und nicht 17 technische Eintraege. Erfuellt durch Buddy-Home statt Auto-Auswahl der ersten Finding-Details.
- Autostart-Hinweise erscheinen als zusammengefasste Mission oder Meldung. Erfuellt.
- Technische Belege bleiben erreichbar, dominieren aber nicht. Erfuellt durch Detailbereich nach Auswahl.

## Kapitel 2: Visual System

Status: als naechstes.

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

Abnahme:

- UI wirkt wie ein moderner Mac-Buddy, nicht wie ein Admin-Tool.
- Missionen wirken motivierend, aber nicht kindisch.
- Keine Rohdaten-Kartenflut auf der Startseite.

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

## Kapitel 9: Packaging and Trust

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
9. Kapitel 9: Packaging and Trust

Warum diese Reihenfolge:
Erst muss die App verstaendlich und angenehm werden.
Danach lohnt sich mehr Intelligenz, mehr Sensorik und mehr Handlungskraft.
