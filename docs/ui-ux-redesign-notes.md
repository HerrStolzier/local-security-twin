# UI/UX Redesign Notes

## Anlass

Manueller App-Blick am 2026-05-12.

Die technische Basis funktioniert, aber die aktuelle Oberflaeche wirkt noch wie eine Entwickleransicht:

- App-Sprache ist Englisch, obwohl das Produkt fuer diese Phase deutsch und erklaerend sein soll.
- Die Liste ist sehr voll und repetitiv.
- Es gibt keinen klaren roten Faden.
- Nutzer sehen viele Findings, aber keine Priorisierung: Was ist wichtig, was ist normal, was soll ich jetzt tun?
- Detailansicht zeigt Evidence, aber noch keine gefuehrte Einordnung.

## Produktziel fuer die UI

Die App soll nicht wie ein Log-Viewer wirken.

Sie soll wie ein ruhiger Sicherheitsbegleiter wirken:

1. Was wurde gefunden?
2. Warum ist das relevant?
3. Ist es dringend oder nur beobachtenswert?
4. Was ist der sicherste naechste Schritt?
5. Was kann ich als erwartet merken?

## Sprachentscheidung

Die primaere Produktsprache fuer die naechsten MVP-Schritte ist Deutsch.

Englische interne Typen und Code-Namen sind okay.
Nutzertexte in der App sollen deutsch sein.

Beispiele:

- `Findings` -> `Hinweise`
- `Visible Startup Hints` -> `Sichtbare Autostart-Hinweise`
- `Remember as Expected` -> `Als erwartet merken`
- `What happened` -> `Was wurde gefunden?`
- `Why it matters` -> `Warum ist das wichtig?`
- `What to do next` -> `Naechster sicherer Schritt`
- `Evidence` -> `Belege`
- `Recommended actions` -> `Empfohlene Schritte`

## Informationshierarchie

Die App braucht eine Startlogik, bevor einzelne Findings dominieren.

Empfohlene Dashboard-Struktur:

1. Ueberblick oben:
   - Anzahl neuer Aenderungen
   - Anzahl bekannter Autostart-Hinweise
   - Hinweis auf begrenzte Sicht
2. Priorisierte Bereiche:
   - `Neue Aenderungen`
   - `Erwartete / bekannte Hinweise`
   - `Zur Beobachtung`
3. Detailansicht:
   - kurze Einordnung
   - Belege
   - sicherer naechster Schritt
   - Aktion zum Merken nur dort, wo sie Sinn ergibt

## Roter Faden

Jede Ansicht soll implizit diese Geschichte erzaehlen:

> Dein Mac hat sichtbare Autostart-Hinweise. Einige davon sind normal. Wichtig sind vor allem Veraenderungen seit dem gemerkten Zustand. Du kannst erwartete Veraenderungen bewusst merken, ohne dass die App etwas am System veraendert.

## Konkrete UX-Probleme aus dem Screenshot

- Viele Zeilen beginnen fast gleich: `Shared daemon background...`
- Der eigentliche Dateiname ist abgeschnitten oder nur zweitrangig sichtbar.
- Severity-Badges wie `High` wirken alarmierend, obwohl viele Daemons normal sein koennen.
- Detailtitel ist zu lang und wiederholt dieselbe technische Aussage.
- Evidence-Cards sind okay, aber ohne vorherige Priorisierung schwer einzuordnen.
- Empfohlene Aktionen liegen weit unten; der Nutzer sieht zuerst sehr viel Text.

## Empfohlener naechster UX-Schnitt

Vor neuen Sensoren sollte ein UI-/UX-Schnitt kommen:

1. Alle Nutzertexte der aktuellen App auf Deutsch umstellen.
2. Dashboard oben um einen kurzen Statusbereich erweitern.
3. Findings gruppieren:
   - neue Aenderungen zuerst
   - danach sichtbare bekannte Autostart-Hinweise
4. Finding-Titel kuerzen:
   - statt `Shared daemon background startup hint is visible`
   - eher `Systemweiter Autostart-Hinweis`
5. Dateiname und Anbieter/Label staerker hervorheben.
6. Severity visuell ruhiger machen und nicht als Alarm-Label verkaufen.
7. Detailansicht mit einer kurzen Einordnung beginnen:
   - `Das ist wahrscheinlich normal, wenn du diese App kennst.`
   - `Auffaellig ist vor allem, dass es seit dem gemerkten Zustand neu ist.`

## Nicht-Ziel fuer den naechsten Schnitt

- kein neues Security-Scoring-System
- kein neuer Sensor
- keine Systemaenderungen
- keine aggressiven Warnfarben
- keine vollstaendige Design-Neuerfindung

Ziel ist erst einmal Orientierung.
