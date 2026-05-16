# UI/UX Redesign Notes

## Anlass

Manueller App-Blick am 2026-05-12.

Die technische Basis funktioniert, aber die aktuelle Oberfläche wirkt noch wie eine Entwickleransicht:

- App-Sprache ist Englisch, obwohl das Produkt für diese Phase deutsch und erklärend sein soll.
- Die Liste ist sehr voll und repetitiv.
- Es gibt keinen klaren roten Faden.
- Nutzer sehen viele Findings, aber keine Priorisierung: Was ist wichtig, was ist normal, was soll ich jetzt tun?
- Detailansicht zeigt Evidence, aber noch keine geführte Einordnung.

## Produktziel für die UI

Die App soll nicht wie ein Log-Viewer wirken.

Sie soll wie ein kraftvoller Security Buddy wirken:

1. Was wurde gefunden?
2. Warum ist das relevant?
3. Ist es dringend oder nur beobachtenswert?
4. Was ist der sicherste nächste Schritt?
5. Was kann ich als erwartet merken?

Der wichtige Wechsel:
Der Ton bleibt ruhig und verständlich, aber das Produktbild ist kraftvoller.
Der Buddy soll ein Verteidiger mit Punch werden: Er priorisiert klar, verbindet lokale Beobachtungen später mit echter Threat Intelligence und führt zu konkreten nächsten Schritten.

## Sprachentscheidung

Die primäre Produktsprache für die nächsten MVP-Schritte ist Deutsch.

Englische interne Typen und Code-Namen sind okay.
Nutzertexte in der App sollen deutsch sein.

Beispiele:

- `Findings` -> `Hinweise`
- `Visible Startup Hints` -> `Sichtbare Autostart-Hinweise`
- `Remember as Expected` -> `Als erwartet merken`
- `What happened` -> `Was wurde gefunden?`
- `Why it matters` -> `Warum ist das wichtig?`
- `What to do next` -> `Nächster sicherer Schritt`
- `Evidence` -> `Belege`
- `Recommended actions` -> `Empfohlene Schritte`

## Informationshierarchie

Die App braucht eine Startlogik, bevor einzelne Findings dominieren.

Empfohlene Dashboard-Struktur:

1. Überblick oben:
   - Anzahl neuer Änderungen
   - Anzahl bekannter Autostart-Hinweise
   - Hinweis auf begrenzte Sicht
2. Priorisierte Bereiche:
   - `Neue Änderungen`
   - `Erwartete / bekannte Hinweise`
   - `Zur Beobachtung`
3. Detailansicht:
   - kurze Einordnung
   - Belege
   - sicherer nächster Schritt
   - Aktion zum Merken nur dort, wo sie Sinn ergibt

## Roter Faden

Jede Ansicht soll implizit diese Geschichte erzaehlen:

> Ich beobachte deinen Mac, merke mir was normal ist, erkenne relevante Änderungen und gleiche sie später mit echten Bedrohungsinformationen ab. Wenn etwas wichtig wird, sage ich dir klar, warum es zaehlt und was du als nächstes sicher tun kannst.

## Konkrete UX-Probleme aus dem Screenshot

- Viele Zeilen beginnen fast gleich: `Shared daemon background...`
- Der eigentliche Dateiname ist abgeschnitten oder nur zweitrangig sichtbar.
- Severity-Badges wie `High` wirken alarmierend, obwohl viele Daemons normal sein können.
- Detailtitel ist zu lang und wiederholt dieselbe technische Aussage.
- Evidence-Cards sind okay, aber ohne vorherige Priorisierung schwer einzuordnen.
- Empfohlene Aktionen liegen weit unten; der Nutzer sieht zuerst sehr viel Text.

## Nutzerfeedback 2026-05-13

Der Layout-Fix hat die App deutlich lesbarer gemacht, aber die Detailansicht ist weiterhin ein Info-Overflow-Problem.

Aktueller Nutzerbefund:

- Für einen Cybersecurity-Buddy ist die Ansicht zu voll.
- Zu viele Belege, technische Details und Buttons erscheinen gleichzeitig.
- Die App wirkt noch zu stark wie ein Inspector.
- Der Nutzer braucht weniger Rohdaten und mehr geführte Einordnung.

UX-Ziel für den nächsten Schnitt:

1. zuerst eine sehr kurze Buddy-Zusammenfassung zeigen
2. nur 1 klaren primären nächsten Schritt zeigen
3. technische Belege einklappbar oder nachrangig machen
4. Wiederholungen in der linken Liste reduzieren
5. bekannte Autostart-Hinweise stärker zusammenfassen, statt 17 Einzelkarten gleich laut zu zeigen

Produktstatus:

Das ist kein Build-Blocker mehr, aber ein Produkt-/UX-Blocker für den Security-Buddy-Anspruch.

## Buddy-Home-Schnitt 2026-05-14

Kapitel 1 setzt die Startstruktur bewusst um:

- Start ist jetzt ein Buddy-Home, keine automatisch geöffnete Finding-Detailansicht.
- Guardian-Status, kurze Buddy-Nachricht und eine Hauptaktion stehen oben.
- Missionen ersetzen die Rohdatenliste als erste Orientierung.
- Buddy-Aktivität fasst sichtbare lokale Ereignisse kurz zusammen.
- Details und Belege bleiben erreichbar, aber erst nach bewusster Auswahl.

Damit ist der rote Faden besser, aber die visuelle Gestaltung ist noch nicht fertig.
Kapitel 2 muss daraus jetzt eine wirklich moderne, ruhige und kraftvolle Mac-Oberfläche machen.

## Detailseiten-Schnitt 2026-05-15

Nutzerfeedback:
Die rechte Detailseite war nach dem Öffnen wieder zu nah am alten Problem:
zu viele technische Informationen, zu viel Denkarbeit beim Nutzer.

Neue Richtung:

- zuerst ein kurzes Buddy-Urteil
- danach ein klarer nächster Schritt
- für Autostart nur wenige einfache Fakten:
  - erkannte Datei
  - was das im Alltag bedeutet
  - warum es Hinweis statt Alarm ist
- Pfade, plist-Daten und Rohbelege bleiben erreichbar, aber nur in technischen Details

Produktregel:
Ein Cybersecurity-Buddy darf technische Belege haben, aber er soll die Last der Einordnung nicht an den Nutzer weiterreichen.

Visuelle Folge:
Die Detailseite darf nicht wie ein anderer Inspector wirken.
Sie soll denselben Buddy-Look wie die Startseite nutzen: weiche Flächen, semantische Akzentfarbe, kurze Hero-Zone und nachrangige technische Details.

Settings-Feedback aus dem manuellen Test:

- Gemerkte Entscheidungen erscheinen korrekt.
- Zurücksetzen ist vorhanden.
- Der lokale Charakter ist erkennbar.
- Der Fenstertitel ist noch halb Englisch: `Local Security Twin-Einstellungen`.
- Lange Texte werden abgeschnitten und sollten in Settings umbrochen oder gekuerzt werden.
- `Risiko: Erhöht` klingt noch zu technisch und sollte nutzerfreundlicher erklärt werden.

## Empfohlener nächster UX-Schnitt

Vor neuen Sensoren sollte ein UI-/UX-Schnitt kommen:

1. Alle Nutzertexte der aktuellen App auf Deutsch umstellen.
2. Dashboard oben um einen kurzen Statusbereich erweitern.
3. Findings gruppieren:
   - neue Änderungen zuerst
   - danach sichtbare bekannte Autostart-Hinweise
4. Finding-Titel kuerzen:
   - statt `Shared daemon background startup hint is visible`
   - eher `Systemweiter Autostart-Hinweis`
5. Dateiname und Anbieter/Label stärker hervorheben.
6. Severity visuell ruhiger machen und nicht als Alarm-Label verkaufen.
7. Detailansicht mit einer kurzen Einordnung beginnen:
   - `Das ist wahrscheinlich normal, wenn du diese App kennst.`
   - `Auffällig ist vor allem, dass es seit dem gemerkten Zustand neu ist.`

## Nicht-Ziel für den früheren Aufräum-Schnitt

- kein neues Security-Scoring-System
- kein neuer Sensor
- keine Systemänderungen
- keine aggressiven Warnfarben

Der Screenshot-Test am 2026-05-14 hat gezeigt:
Nur Orientierung reicht nicht. Die App braucht jetzt eine echte Design-Neuerfindung der Startansicht.

## UI-Text-Inventar 2026-05-13

Sprint 1, Task 1.1 hat die sichtbaren Texte erneut geprüft.

Bereits geglättet:

- Fenster- und Menüleistentitel sind deutsch.
- Dashboard, Detailansicht, Settings und Menüleiste sind weitgehend deutsch.
- Der Startup-Sensor liefert Finding-, Evidence-, Recommendation- und Sensor-Notiztexte jetzt auf Deutsch.
- Severity-Badges sind ruhiger formuliert: `Zur Info`, `Prüfen`, `Genauer prüfen`.

Bewusst noch technisch oder intern:

- interne IDs wie `launch-agent-inventory`, `baseline-diff`, `plist-details`
- plist-Schluessel wie `Label`, `Program`, `ProgramArguments`, `RunAtLoad`, `KeepAlive`
- Pfade wie `/Library/LaunchAgents`
- Code-Typen und Testnamen

Noch offen für spätere UX-Schnitte:

- Raw-Detailwerte aus `plist`-Dateien können noch technischer wirken als die Zusammenfassung.
- Die App braucht weiterhin einen stärkeren roten Faden im Dashboard, besonders wenn später mehrere Sensoren dazukommen.
- Echte UI-Automation fehlt weiterhin; die aktuelle Verbesserung ist in Unit-/Presentation-Tests und manuellen Smokes abzusichern.

## Phase-0-Umsetzung 2026-05-13

Erster Schnitt für `Buddy statt Inspector` ist umgesetzt.

Geändert:

- Dashboard beginnt jetzt mit einem Buddy-Status wie `Bitte kurz prüfen`, `Alles ruhig` oder `Zur Beobachtung`.
- Die Hauptaktion steht oben und richtet sich nach dem Zustand, z. B. `Neue Änderung ansehen`.
- Bekannte Autostart-Hinweise werden zuerst zusammengefasst, statt sofort alle Einzelzeilen gleich laut zu zeigen.
- Detailansicht zeigt den nächsten Schritt vor den technischen Belegen.
- Technische Belege sind einklappbar.
- Weitere Empfehlungen sind einklappbar und nicht mehr gleichrangig mit dem ersten Schritt.

Noch offen:

- manueller Screenshot-Check
- prüfen, ob die neue Summary wirklich weniger überlädt
- langfristig eine echte Chat-/Feed-Form statt klassischer Listenstruktur entwerfen

## Visuelle Richtung 2026-05-14

Die gewählte Richtung ist:

- freundliche Mac-Health-App
- native Command-Center-Klarheit
- dezente Gamification als Verteidiger-Schicht

Inspiration:

- Raycast für schnelle, native Mac-Klarheit
- CleanMyMac für freundliche Health-/Status-Kommunikation
- Little Snitch/TinyShield nur für spätere Power-User-Details
- gamified Security-Dashboards für Missionen, Schutzbereiche und Fortschritt

Wichtig:
Die App soll nicht wie ein Cyberpunk-Neon-Hacker-Dashboard aussehen.
Gamification bedeutet hier Missionen, Fortschritt und nächste Verteidigungsschritte, nicht Spielzeugoptik.

Nächster UX-Schritt:

1. echte `BuddyHomeView` bauen
2. Guardian-Status oben
3. Missionen statt Rohlisten
4. Aktivitätsfeed statt Sidebar-Dominanz
5. Details nur auf bewusste Auswahl
6. danach Liquid-Glass-Feinschliff
