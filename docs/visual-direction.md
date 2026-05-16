# Visual Direction

## Zweck

Diese Datei haelt die gewaehlte visuelle Richtung fuer den Security Buddy fest.

Der Screenshot-Test am 2026-05-14 hat gezeigt:
Der erste `Buddy statt Inspector`-Schnitt hat die Struktur verbessert, aber optisch wirkt die App weiterhin wie ein Inspector/Admin-Tool.

Wir brauchen deshalb einen echten visuellen und informationellen Neuschnitt.

## Gewaehlte Richtung

Die App soll eine Mischung aus drei Gefuehlen bekommen:

1. **Friendly Mac Health App**
   - einfach
   - klar
   - ein grosser Zustand
   - eine dominante naechste Aktion
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
   - naechster Verteidigungsschritt
   - sichtbarer Fortschritt fuer Best Practices
   - motivierend, aber nicht kindisch

## Arbeits-Brand

Der aktuelle Arbeitsname fuer die App ist:

`Sento Guard`

Warum diese Richtung passt:

- kurz und merkbar
- freundlich genug fuer normale Nutzer
- wachsam genug fuer Security
- weniger offensichtlich belegt als `Kito Guard` im ersten Screening
- funktioniert auf Deutsch und Englisch ohne harte Aussprache-Huerde

Wichtig:
Das ist noch keine juristische Markenfreigabe. Vor echter Veroeffentlichung braucht `Sento Guard` einen tieferen Check in Markenregistern, App Stores, Domains und Produktdatenbanken.

## Inspirationsquellen

Diese Quellen sind Inspiration, keine Kopiervorlagen:

- Raycast: Command-Center-Klarheit, schnelle Aktionen, native Mac-Anmutung
- CleanMyMac: freundlicher Health-Screen, einfache Statuskommunikation
- Little Snitch / TinyShield: starke Security-Visualisierung fuer spaetere Detailmodi
- Pareto Cyber / gamified Security-Dashboards: Missionen, Risikoebenen, Fortschrittsgefuehl

## Nicht-Richtung

Nicht bauen:

- Cyberpunk-Neon-Hacker-Dashboard als Standardansicht
- SIEM-artige Tabellenlandschaft
- 17 gleich laute Einzelkarten
- dauerhafte Rot/Gelb/Gruen-Alarmoptik
- spielerische Optik, die unserioes oder kindlich wirkt

## Zielbild der Startseite

Die Startseite soll nicht mit Findings beginnen.

Sie soll mit einer Aussage beginnen:

- `Alles ruhig`
- `Bitte kurz pruefen`
- `Dringend empfohlen`

Danach:

- eine kurze Buddy-Nachricht
- ein klarer naechster Schritt
- wenige Missionen oder Schutzbereiche
- technisches Material nur auf Wunsch

## Helles Mockup als neue Leitlinie

Das dunkle Cybersecurity-Mockup bleibt nur als Ideenquelle fuer Charakter, Missionen und Schutzstatus.
Die eigentliche App soll in eine helle, freundliche Richtung gehen:

- linke Sidebar mit Brand und Missionen
- oben ein persoenlicher Buddy-Einstieg
- klare Statuskarten
- fuenf Missionskarten:
  - Autostart verstehen
  - Mac aktuell halten / Mac-Schutzsignale
  - Security-Hygiene
  - Digitaler Fussabdruck
  - App-Risiken pruefen
- Activity-Feed als roter Faden
- spaeter ein Chat-/Hilfe-Einstieg, aber erst wenn dahinter echte Funktion steckt

Nicht uebernehmen:

- dunkler Hauptmodus als Standard
- Neon-Ueberladung
- "0 Bedrohungen" als harte Aussage, solange die App keine echte Bedrohungserkennung hat
- visuelle Elemente, die mehr Sicherheitsgewissheit ausdruecken als die Daten hergeben

## Sento Charakter

Sento soll sichtbar sein, aber nicht nur als Deko.

Der Charakter hat drei Aufgaben:

- Orientierung geben: Der Nutzer erkennt sofort, dass die App ein Buddy ist, kein Rohdaten-Inspector.
- Ton setzen: freundlich, wachsam, ruhig, nicht panisch.
- Produktlogik verkoerpern: Sento erklaert, priorisiert, fragt nach und merkt Entscheidungen lokal.

Aktueller Stand:

- Sento ist als skalierbare SwiftUI-Figur im Code umgesetzt.
- Die Figur nutzt einfache Formen, einen hellen Koerper, leuchtende Augen und ein Schild.
- Das ist ein Prototyp-Charakter, noch kein finales Marken-Asset.

Spaeter:

- echtes Character-Asset oder kleine Illustrationsserie
- mehrere Zustaende wie ruhig, aufmerksam, prueft, braucht Zustimmung
- klare Regel: Der visuelle Zustand darf nur anzeigen, was die App auch fachlich belegen kann.

## Moegliche Startseiten-Struktur

### Oben: Guardian Status

- grosser Schutzstatus
- kurzer Satz in Alltagssprache
- eine primaere Aktion
- optional ein ruhiger Fortschrittsring oder Schutzlevel

Beispiel:

> Dein Mac sieht im lokalen Blick stabil aus. Zwei Schutzbereiche koennen wir als naechstes staerken.

### Mitte: Missionen

Missionen ersetzen Rohlisten.

Beispiele:

- `Autostart verstehen`
- `macOS aktuell halten`
- `FileVault pruefen`
- `Firewall einordnen`
- `Passwort- und 2FA-Check`

Jede Mission hat:

- Status
- kurze Erklaerung
- eine naechste Aktion
- Details nur auf Klick

### Unten oder rechts: Aktivitaetsfeed

Kurze Buddy-Meldungen:

- `17 bekannte Autostart-Hinweise zusammengefasst`
- `2 Systemsignale sichtbar`
- `Keine neue Autostart-Aenderung`

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
Das Thema ist ernst; die Oberflaeche darf diese Schwere abfedern, solange sie weiter ehrlich und vertrauenswuerdig bleibt.

Erlaubt:

- Missionen
- Fortschritt
- Schutzbereiche
- ruhige Badges
- "naechster Verteidigungsschritt"
- freundlichere semantische Farben
- leichte Health-/Gameful-Defender-Anmutung
- Lila als freundlicher Akzent fuer geplante/ruhige Buddy-Bereiche, wenn Gruen auf hellem Grund zu weich wirkt

Nicht erlaubt:

- Angstpunkte
- manipulative Streaks
- Scheinsicherheit durch Score
- Punkte fuer Dinge, die die App nicht sicher messen kann
- bunte Dekoration ohne Bedeutung

## Naechste Design-Iteration

Der erste konkrete UI-Schritt wurde umgesetzt:

1. `BuddyHomeView` ist eine echte Startseite.
2. Die Finding-Liste ist aus der ersten Wahrnehmung entfernt.
3. Findings werden in Missionen und Buddy-Meldungen uebersetzt.
4. Detailansicht erscheint erst nach aktiver Auswahl.
5. Kapitel 2 hat den ersten visuellen Feinschliff: systemadaptive Flaechen, semantische Farben, staerkere Mission-Badges und ruhigere Aktivitaetszeilen.

Naechster Schritt:

1. Kapitel 2b `Sento Guard Shell` mit sichtbarer SwiftUI-Figur manuell ansehen.
2. Pruefen, ob Sento freundlich und wachsam wirkt, ohne kindisch oder zu dekorativ zu werden.
3. Danach entscheiden, ob zuerst ein finales Character-Asset entsteht oder Kapitel 3 `Update Awareness` startet.

## Build-Skills fuer die Umsetzung

Fuer den naechsten UI-Schnitt nutzen wir:

- `build-macos-apps:view-refactor`
- `build-macos-apps:swiftui-patterns`
- danach `build-macos-apps:liquid-glass`

Reihenfolge:
Erst Informationsarchitektur, dann macOS-Struktur, dann visuelle Politur.
