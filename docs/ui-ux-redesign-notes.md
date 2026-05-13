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

Sie soll wie ein kraftvoller Security Buddy wirken:

1. Was wurde gefunden?
2. Warum ist das relevant?
3. Ist es dringend oder nur beobachtenswert?
4. Was ist der sicherste naechste Schritt?
5. Was kann ich als erwartet merken?

Der wichtige Wechsel:
Der Ton bleibt ruhig und verstaendlich, aber das Produktbild ist kraftvoller.
Der Buddy soll ein Verteidiger mit Punch werden: Er priorisiert klar, verbindet lokale Beobachtungen spaeter mit echter Threat Intelligence und fuehrt zu konkreten naechsten Schritten.

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

> Ich beobachte deinen Mac, merke mir was normal ist, erkenne relevante Aenderungen und gleiche sie spaeter mit echten Bedrohungsinformationen ab. Wenn etwas wichtig wird, sage ich dir klar, warum es zaehlt und was du als naechstes sicher tun kannst.

## Konkrete UX-Probleme aus dem Screenshot

- Viele Zeilen beginnen fast gleich: `Shared daemon background...`
- Der eigentliche Dateiname ist abgeschnitten oder nur zweitrangig sichtbar.
- Severity-Badges wie `High` wirken alarmierend, obwohl viele Daemons normal sein koennen.
- Detailtitel ist zu lang und wiederholt dieselbe technische Aussage.
- Evidence-Cards sind okay, aber ohne vorherige Priorisierung schwer einzuordnen.
- Empfohlene Aktionen liegen weit unten; der Nutzer sieht zuerst sehr viel Text.

## Nutzerfeedback 2026-05-13

Der Layout-Fix hat die App deutlich lesbarer gemacht, aber die Detailansicht ist weiterhin ein Info-Overflow-Problem.

Aktueller Nutzerbefund:

- Fuer einen Cybersecurity-Buddy ist die Ansicht zu voll.
- Zu viele Belege, technische Details und Buttons erscheinen gleichzeitig.
- Die App wirkt noch zu stark wie ein Inspector.
- Der Nutzer braucht weniger Rohdaten und mehr gefuehrte Einordnung.

UX-Ziel fuer den naechsten Schnitt:

1. zuerst eine sehr kurze Buddy-Zusammenfassung zeigen
2. nur 1 klaren primaeren naechsten Schritt zeigen
3. technische Belege einklappbar oder nachrangig machen
4. Wiederholungen in der linken Liste reduzieren
5. bekannte Autostart-Hinweise staerker zusammenfassen, statt 17 Einzelkarten gleich laut zu zeigen

Produktstatus:

Das ist kein Build-Blocker mehr, aber ein Produkt-/UX-Blocker fuer den Security-Buddy-Anspruch.

Settings-Feedback aus dem manuellen Test:

- Gemerkte Entscheidungen erscheinen korrekt.
- Zuruecksetzen ist vorhanden.
- Der lokale Charakter ist erkennbar.
- Der Fenstertitel ist noch halb Englisch: `Local Security Twin-Einstellungen`.
- Lange Texte werden abgeschnitten und sollten in Settings umbrochen oder gekuerzt werden.
- `Risiko: Erhoeht` klingt noch zu technisch und sollte nutzerfreundlicher erklaert werden.

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

## UI-Text-Inventar 2026-05-13

Sprint 1, Task 1.1 hat die sichtbaren Texte erneut geprueft.

Bereits geglaettet:

- Fenster- und Menueleistentitel sind deutsch.
- Dashboard, Detailansicht, Settings und Menueleiste sind weitgehend deutsch.
- Der Startup-Sensor liefert Finding-, Evidence-, Recommendation- und Sensor-Notiztexte jetzt auf Deutsch.
- Severity-Badges sind ruhiger formuliert: `Zur Info`, `Pruefen`, `Genauer pruefen`.

Bewusst noch technisch oder intern:

- interne IDs wie `launch-agent-inventory`, `baseline-diff`, `plist-details`
- plist-Schluessel wie `Label`, `Program`, `ProgramArguments`, `RunAtLoad`, `KeepAlive`
- Pfade wie `/Library/LaunchAgents`
- Code-Typen und Testnamen

Noch offen fuer spaetere UX-Schnitte:

- Raw-Detailwerte aus `plist`-Dateien koennen noch technischer wirken als die Zusammenfassung.
- Die App braucht weiterhin einen staerkeren roten Faden im Dashboard, besonders wenn spaeter mehrere Sensoren dazukommen.
- Echte UI-Automation fehlt weiterhin; die aktuelle Verbesserung ist in Unit-/Presentation-Tests und manuellen Smokes abzusichern.
