# Visual Direction

## Zweck

Diese Datei hält die gewählte visuelle Richtung für den Security Buddy fest.

Der Screenshot-Test am 2026-05-14 hat gezeigt:
Der erste `Buddy statt Inspector`-Schnitt hat die Struktur verbessert, aber optisch wirkt die App weiterhin wie ein Inspector/Admin-Tool.

Wir brauchen deshalb einen echten visuellen und informationellen Neuschnitt.

## Gewählte Richtung

Die App soll eine Mischung aus drei Gefühlen bekommen:

1. **Friendly Mac Health App**
   - einfach
   - klar
   - ein großer Zustand
   - eine dominante nächste Aktion
   - normale Nutzer verstehen sofort, ob etwas wichtig ist

2. **Native Mac Command Center**
   - schnell
   - ruhig
   - macOS-nativ
   - wenig visuelles Rauschen
   - gute Tastatur- und Mausbedienung

3. **Gameful Defender Layer**
   - Missionen statt Rohlisten
   - Schutzfortschritt statt reiner Warnungen
   - nächster Verteidigungsschritt
   - sichtbarer Fortschritt für Best Practices
   - motivierend, aber nicht kindisch

## Arbeits-Brand

Der aktuelle Arbeitsname für die App ist:

`Sento Guard`

Warum diese Richtung passt:

- kurz und merkbar
- freundlich genug für normale Nutzer
- wachsam genug für Security
- weniger offensichtlich belegt als `Kito Guard` im ersten Screening
- funktioniert auf Deutsch und Englisch ohne harte Aussprache-Hürde

Wichtig:
Das ist noch keine juristische Markenfreigabe. Vor echter Veröffentlichung braucht `Sento Guard` einen tieferen Check in Markenregistern, App Stores, Domains und Produktdatenbanken.

## Inspirationsquellen

Diese Quellen sind Inspiration, keine Kopiervorlagen:

- Raycast: Command-Center-Klarheit, schnelle Aktionen, native Mac-Anmutung
- CleanMyMac: freundlicher Health-Screen, einfache Statuskommunikation
- Little Snitch / TinyShield: starke Security-Visualisierung für spätere Detailmodi
- Pareto Cyber / gamified Security-Dashboards: Missionen, Risikoebenen, Fortschrittsgefühl

## Nicht-Richtung

Nicht bauen:

- Cyberpunk-Neon-Hacker-Dashboard als Standardansicht
- SIEM-artige Tabellenlandschaft
- 17 gleich laute Einzelkarten
- dauerhafte Rot/Gelb/Grün-Alarmoptik
- spielerische Optik, die unseriös oder kindlich wirkt

## Zielbild der Startseite

Die Startseite soll nicht mit Findings beginnen.

Sie soll mit einer Aussage beginnen:

- `Alles ruhig`
- `Bitte kurz prüfen`
- `Dringend empfohlen`

Danach:

- eine kurze Buddy-Nachricht
- ein klarer nächster Schritt
- wenige Missionen oder Schutzbereiche
- technisches Material nur auf Wunsch

## Helles Mockup als neue Leitlinie

Das dunkle Cybersecurity-Mockup bleibt nur als Ideenquelle für Charakter, Missionen und Schutzstatus.
Die eigentliche App soll in eine helle, freundliche Richtung gehen:

- linke Sidebar mit Brand und Missionen
- oben ein persönlicher Buddy-Einstieg
- klare Statuskarten
- fünf Missionskarten:
  - Autostart verstehen
  - Mac aktuell halten / Mac-Schutzsignale
  - Security-Hygiene
  - Digitaler Fußabdruck
  - App-Risiken prüfen
- Activity-Feed als roter Faden
- später ein Chat-/Hilfe-Einstieg, aber erst wenn dahinter echte Funktion steckt

Nicht übernehmen:

- dunkler Hauptmodus als Standard
- Neon-Überladung
- "0 Bedrohungen" als harte Aussage, solange die App keine echte Bedrohungserkennung hat
- visuelle Elemente, die mehr Sicherheitsgewissheit ausdrücken als die Daten hergeben

## Sento Charakter

Sento soll sichtbar sein, aber nicht nur als Deko.

Der Charakter hat drei Aufgaben:

- Orientierung geben: Der Nutzer erkennt sofort, dass die App ein Buddy ist, kein Rohdaten-Inspector.
- Ton setzen: freundlich, wachsam, ruhig, nicht panisch.
- Produktlogik verkörpern: Sento erklärt, priorisiert, fragt nach und merkt Entscheidungen lokal.

Aktueller Stand:

- Sento ist als skalierbare SwiftUI-Figur im Code umgesetzt.
- Die Figur nutzt einfache Formen, einen hellen Körper, leuchtende Augen und ein Schild.
- Das ist ein Prototyp-Charakter, noch kein finales Marken-Asset.

Später:

- echtes Character-Asset oder kleine Illustrationsserie
- mehrere Zustände wie ruhig, aufmerksam, prüft, braucht Zustimmung
- klare Regel: Der visuelle Zustand darf nur anzeigen, was die App auch fachlich belegen kann.

## Mögliche Startseiten-Struktur

### Oben: Guardian Status

- großer Schutzstatus
- kurzer Satz in Alltagssprache
- eine primäre Aktion
- optional ein ruhiger Fortschrittsring oder Schutzlevel

Beispiel:

> Dein Mac sieht im lokalen Blick stabil aus. Zwei Schutzbereiche können wir als nächstes stärken.

### Mitte: Missionen

Missionen ersetzen Rohlisten.

Beispiele:

- `Autostart verstehen`
- `macOS aktuell halten`
- `FileVault prüfen`
- `Firewall einordnen`
- `Passwort- und 2FA-Check`

Jede Mission hat:

- Status
- kurze Erklärung
- eine nächste Aktion
- Details nur auf Klick

### Unten oder rechts: Aktivitätsfeed

Kurze Buddy-Meldungen:

- `17 bekannte Autostart-Hinweise zusammengefasst`
- `2 Systemsignale sichtbar`
- `Keine neue Autostart-Änderung`

## Detailmodus

Details bleiben wichtig, aber sie sind nicht die Hauptansicht.

Detailmodus zeigt:

- technische Belege
- Pfade
- plist-Details
- konkrete Sensorgrenzen
- Power-User-Informationen

Der Nutzer geht bewusst dorthin.

## Gamification-Regeln

Gamification soll Verhalten erleichtern, nicht Druck erzeugen.

Nach Nutzerfeedback vom 2026-05-15 darf die App bewusst farbiger und etwas verspielter wirken.
Grund:
Das Thema ist ernst; die Oberfläche darf diese Schwere abfedern, solange sie weiter ehrlich und vertrauenswürdig bleibt.

Erlaubt:

- Missionen
- Fortschritt
- Schutzbereiche
- ruhige Badges
- "nächster Verteidigungsschritt"
- freundlichere semantische Farben
- leichte Health-/Gameful-Defender-Anmutung
- Lila als freundlicher Akzent für geplante/ruhige Buddy-Bereiche, wenn Grün auf hellem Grund zu weich wirkt

Nicht erlaubt:

- Angstpunkte
- manipulative Streaks
- Scheinsicherheit durch Score
- Punkte für Dinge, die die App nicht sicher messen kann
- bunte Dekoration ohne Bedeutung

## Nächste Design-Iteration

Der erste konkrete UI-Schritt wurde umgesetzt:

1. `BuddyHomeView` ist eine echte Startseite.
2. Die Finding-Liste ist aus der ersten Wahrnehmung entfernt.
3. Findings werden in Missionen und Buddy-Meldungen übersetzt.
4. Detailansicht erscheint erst nach aktiver Auswahl.
5. Kapitel 2 hat den ersten visuellen Feinschliff: systemadaptive Flächen, semantische Farben, stärkere Mission-Badges und ruhigere Aktivitätszeilen.

Aktueller Übergang:

1. Kapitel 2b `Sento Guard Shell` wurde am 2026-05-16 lokal sichtbar geprüft.
2. Sento wirkt als Prototyp freundlich und wachsam genug für den aktuellen Produktfluss.
3. Ein finales Character-Asset bleibt später nötig; als nächstes startet fachlich Kapitel 3 `Update Awareness`.

## Build-Skills für die Umsetzung

Für den nächsten UI-Schnitt nutzen wir:

- `build-macos-apps:view-refactor`
- `build-macos-apps:swiftui-patterns`
- danach `build-macos-apps:liquid-glass`

Reihenfolge:
Erst Informationsarchitektur, dann macOS-Struktur, dann visuelle Politur.
