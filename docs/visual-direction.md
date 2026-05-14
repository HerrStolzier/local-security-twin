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

Erlaubt:

- Missionen
- Fortschritt
- Schutzbereiche
- ruhige Badges
- "naechster Verteidigungsschritt"

Nicht erlaubt:

- Angstpunkte
- manipulative Streaks
- Scheinsicherheit durch Score
- Punkte fuer Dinge, die die App nicht sicher messen kann

## Naechste Design-Iteration

Der naechste konkrete UI-Schritt ist:

1. `BuddyHomeView` als echte Startseite bauen.
2. Die linke Finding-Liste aus der ersten Wahrnehmung entfernen oder stark zurueckstufen.
3. Findings in wenige Missionen und Buddy-Meldungen uebersetzen.
4. Detailansicht nur nach aktiver Auswahl zeigen.
5. Danach Screenshot pruefen.
6. Danach erst Liquid-Glass-/visueller Feinschliff.

## Build-Skills fuer die Umsetzung

Fuer den naechsten UI-Schnitt nutzen wir:

- `build-macos-apps:view-refactor`
- `build-macos-apps:swiftui-patterns`
- danach `build-macos-apps:liquid-glass`

Reihenfolge:
Erst Informationsarchitektur, dann macOS-Struktur, dann visuelle Politur.
