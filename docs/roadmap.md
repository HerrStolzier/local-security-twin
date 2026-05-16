# Roadmap

## Zweck

Diese Datei ist die aktuelle Planungsübersicht für `local-security-twin`.

Sie ersetzt nicht die Detaildokumente, sondern ordnet sie:

- `docs/session-status.md`: aktueller Übergabestand
- `docs/chapter-plan.md`: grobe Kapitel, die nacheinander fertiggestellt werden
- `docs/current-overview.md`: technischer und produktlicher Kurzueberblick
- `docs/product-flow-and-feature-plan.md`: roter Faden, Produktbild und Feature-Bausteine
- `docs/visual-direction.md`: gewählte visuelle Richtung für den Buddy-Redesign-Schnitt
- `docs/adversarial-review-and-best-practices.md`: Black-Hat-Gegenpruefung und Best-Practice-Monitoring
- `docs/privacy-footprint-cleanup.md`: späteres Modul für digitalen Fußabdruck, Data Broker, alte Accounts und Breach-Hygiene
- `docs/project-completion-plan.md`: detaillierter Weg vom aktuellen Prototyp zum MVP
- `docs/ui-ux-redesign-notes.md`: nächster UI-/UX-Schnitt
- `docs/background-task-management-spike.md`: späterer macOS-Startup-Spike
- `docs/packaging-signing-plan.md`: späterer Distribution-/Signing-Schnitt

## Aktueller Stand

Die App ist ein SwiftPM-basiertes macOS-Projekt mit erster echter lokaler Sicherheitsfunktion.

Vorhanden ist:

- Menüleisten-App, Hauptfenster und Settings
- lokales Consent-/Policy-Modell
- normalisiertes Finding-Schema mit Evidence und Recommendations
- Sensor-Vertrag und synchrone Sensor-Pipeline
- erster Sensor für sichtbare Startup-`plist`-Dateien
- lokale Startup-Baseline in Application Support
- Change-Detection für neue und verschwundene Startup-Hinweise
- explizites Merken des aktuellen Startup-Zustands als erwartet
- einfache `.plist`-Details als Evidence
- lokale Checks, Security Checks und Smoke-E2E

## Aktuelle Hauptpriorität

Die grobe Arbeit wird ab jetzt über Kapitel geplant:

- `docs/chapter-plan.md`

Die bisherige technische Umsetzungsreihenfolge steht im detaillierten Abschlussplan:

- `docs/project-completion-plan.md`

Die nächste Hauptpriorität ist jetzt der rote Produktfaden:

- `docs/product-flow-and-feature-plan.md`

Grund:
Der erste manuelle Blick zeigt, dass die App technisch funktioniert, aber noch wie ein Inspector wirkt. Das Ziel ist groesser: ein kraftvoller Security Buddy, der mit dem Nutzer zusammenarbeitet und bei real relevanten Risiken Punch hat.

Kapitel 1 ist als erster Code-Schnitt umgesetzt:

- Kapitel 1: `Buddy Home`

Das bedeutet:

1. die Startansicht führt jetzt über Buddy-Status statt Finding-Liste
2. eine Hauptmeldung und ein nächster Schritt stehen vorne
3. Autostart- und Systemsignale erscheinen als Missionen und Aktivitätsmeldungen
4. technische Belege erscheinen erst nach bewusster Auswahl

Das nächste Kapitel ist deshalb:

- Kapitel 2: `Visual System`
- Kapitel 2b: `Sento Guard Shell`

Der nächste Schnitt soll:

1. die neue Buddy-Home-Struktur visuell stärker machen
2. Status, Missionen und Aktivität klarer gewichten
3. eine moderne Mac-Buddy-Oberfläche schaffen, die nicht wie ein Admin-Inspector wirkt
4. dezente Gameful-Defender-Elemente einfuehren, ohne falsche Sicherheitswerte zu behaupten
5. später Online-Intelligence wie SOFA, CISA KEV und EPSS anbinden
6. LLM-Erklärungen erst als Erklärhilfe planen, nicht als alleinige Wahrheit
7. Security-Hygiene-Themen wie 2FA, Passwortmanager, VPN, Antivirus/Security-Tools, Firewall, FileVault und System Extensions als eigene, ehrlich begrenzte Schicht planen
8. eine feste adversarial Review-Perspektive nutzen: "Welche realistische Angriffskette würde ein Verteidiger hier sichtbar machen wollen?"
9. später digitalen Fußabdruck als geführten Privacy-Cleanup aufnehmen, aber nicht als heimliche Vollautomatik
10. die App als `Sento Guard` Produkt-Shell sichtbar machen, ohne schon finale Markenfreigabe zu behaupten

Nicht-Ziel dieses Schnitts:

- kein neuer Sensor
- keine Systemänderungen
- keine neuen macOS-Rechte
- keine wilde Web-Recherche ohne kuratierte Quellen
- keine LLM-Entscheidungen ohne belegbare lokale oder externe Daten
- keine Exploit-Automation und keine offensiven Tests gegen reale Systeme
- keine pauschalen Versprechen zu 2FA, VPN, Antivirus oder Passwortmanagern, wenn die App es nicht lokal oder per Integration belegen kann
- keine automatische Personensuche, keine automatischen Löschanfragen und keine Verarbeitung von Identitätsdokumenten ohne bewusste Produktentscheidung

## Neue Phasen nach dem roten Faden

### Phase 0: Buddy statt Inspector

Status: erster Schnitt umgesetzt am 2026-05-13; echter Redesign-Schnitt nach Screenshot-Review am 2026-05-14 nötig.

Ziel:
Die aktuelle UI zeigt zuerst "Was bedeutet das für mich?" und erst danach Rohdetails.

Umfang:

- Dashboard als Buddy-Status
- Aktivitätsfeed oder Chat-ähnliche Meldungen
- eine klare Hauptaktion pro Meldung
- technische Details einklappbar
- wiederholte Autostart-Hinweise zusammenfassen

Umgesetzt:

- Dashboard beginnt mit Buddy-Status statt reiner Übersicht
- bekannte Autostart-Hinweise bekommen eine Zusammenfassung vor den Einzelzeilen
- Detailansicht zeigt den nächsten Schritt vor den technischen Belegen
- technische Belege sind einklappbar
- weitere Empfehlungen sind nachrangig einklappbar

Nächster Schritt:
`BuddyHomeView` bauen:

- Guardian-Status oben
- Missionen und Schutzbereiche statt Finding-Liste als erste Ebene
- Buddy-Meldungen als Aktivitätsfeed
- technische Details nur nach bewusster Auswahl
- danach visueller Feinschliff mit macOS-nativen Patterns und später Liquid Glass

### Phase 1: Update-Awareness

Status: geplant.

Ziel:
Die App erkennt, ob macOS-Sicherheitsupdates für diesen Mac relevant sind.

Erste Quelle:

- SOFA von macadmins

### Phase 1.5: Best-Practice-Grundlage

Status: geplant.

Ziel:
Der Buddy prüft nicht nur technische Einzelhinweise, sondern begleitet wichtige Sicherheits-Best-Practices.

Erster Schnitt:

- lokale Checks von Buddy-Fragen trennen
- Rechtebedarf je Check dokumentieren
- defensive Angreiferprüfung je Check ergaenzen
- erste Kandidaten priorisieren: macOS-Updates, FileVault, Firewall, Gatekeeper/SIP, System Extensions

Nicht-Ziel:

- 2FA für externe Accounts ungeprueft behaupten
- VPN pauschal als sicher verkaufen
- Antivirus-/EDR-Status ohne klare lokale Belege bewerten

### Phase 2: Real Threat Matching

Status: geplant.

Ziel:
Lokale Fakten mit echten Bedrohungsdaten verbinden.

Erste Quellen:

- CISA Known Exploited Vulnerabilities
- FIRST EPSS
- später NVD

### Phase 2b: Security-Hygiene und Nutzer-Schutzgewohnheiten

Status: geplant.

Ziel:
Die App macht grundlegende Schutzthemen sichtbar, ohne mehr zu behaupten als sie wirklich prüfen kann.

Erste Reihenfolge:

1. macOS-Firewall, FileVault und automatische Updates als lokale Schutzsignale prüfen
2. 2FA und Passwortmanager als geführte Checklisten starten
3. VPN mit klarer Alltagserklaerung einordnen: hilfreich in bestimmten Netzen, kein kompletter Schutz
4. installierte Security-/Antivirus-Tools nur als Inventar zeigen, solange keine verlässliche Produktintegration besteht
5. Treiber, System Extensions und Network Extensions als eigenen macOS-Rechte-/Sichtbarkeits-Spike planen

Akzeptanzkriterien:

- Jeder Check zeigt den Belegtyp: automatisch gesehen, Nutzerangabe oder nicht prüfbar.
- Die App bleibt lokal-first und fragt keine sensiblen Kontodaten ab.
- Hinweise bleiben handlungsorientiert: "was bedeutet das?", "warum wichtig?", "was kannst du jetzt tun?"
- Keine stillen Änderungen an Firewall, FileVault, VPN, Security-Tools oder Extensions.

### Phase 2c: Adversarial Review als Produkt-Routine

Status: geplant.

Ziel:
Jeder neue Sicherheitsbaustein bekommt vor Umsetzung eine kurze Gegenperspektive:
Wie würde ein Angreifer das Thema praktisch ausnutzen, und welches harmlose Verteidigungssignal kann die App daraus ableiten?

Regeln:

- Nur Verteidigungsfragen, keine Exploit-Anleitungen.
- Keine echten Angriffe, keine fremden Ziele, keine destruktiven Tests.
- Ergebnis ist eine bessere Sensor-/UX-Entscheidung oder eine ehrliche Grenze in `docs/known-limits.md`.
- Hohe Rechte werden erst vorgeschlagen, wenn der Nutzen konkret und verständlich ist.

### Phase 2d: Digitaler Fußabdruck und Privacy Cleanup

Status: geplant.

Ziel:
Der Buddy soll später helfen, öffentlich sichtbare personenbezogene Spuren zu reduzieren und echte Risiken daraus verständlich zu priorisieren.

Erste Bausteine:

1. Data-Broker- und People-Search-Treffer als vom Nutzer bestätigte Aufgabenliste erfassen
2. alte Accounts mit JustDeleteMe-ähnlichen Quellen in Löschaufgaben verwandeln
3. Breach-Hygiene über Have I Been Pwned oder manuelle Importliste einordnen
4. Lösch- und Opt-out-Textvorlagen für DSGVO, CCPA/CPRA und optional KVKK vorbereiten
5. E-Mail-Alias-Hygiene mit SimpleLogin/Proton/Für-später-Integrationen als Empfehlung führen

Kritische Grenzen:

- Keine heimliche Suche nach Name, Telefonnummer oder E-Mail.
- Keine automatischen Löschanfragen.
- Keine Identitätsdokumente in der App speichern oder weiterleiten.
- Keine SEO-Manipulation als Produktkern.
- Rechtliche Texte sind Hilfen, keine Rechtsberatung.

Akzeptanzkriterien:

- Jede externe Abfrage braucht bewusste Zustimmung.
- Die App zeigt den Status lokal: gefunden, geprüft, vorbereitet, gesendet, bestätigt, nachfassen.
- Der Buddy priorisiert nach Risiko: Datenlecks und Account-Sicherheit zuerst, kosmetische Suchergebnisse später.
- Der Nutzer sieht immer, welche Daten an wen gehen könnten.

### Phase 3: App-Inventur

Status: geplant.

Ziel:
Installierte Apps und Versionen verstehen, damit externe Schwachstelleninfos wirklich auf diesen Mac bezogen werden können.

### Phase 4: Optionales Buddy Brain

Status: geplant.

Ziel:
Ein lokales oder cloudbasiertes LLM hilft beim Erklären, aber nicht beim unbelegten Entscheiden.

### Phase 5: Stärkere Verteidigung

Status: später.

Ziel:
Mehr Handlungskraft durch Netzwerk-, Prozess-, Safe-Mode- oder Härtungsfunktionen, aber nur mit klarer Zustimmung und sauberem Rechtekonzept.

## Fester Entwicklungscheck: Angreiferperspektive

Ab jetzt soll jede größere Funktion eine defensive Black-Hat-Prüfung bekommen.

Kurzformat:

1. Wie könnte das missbraucht werden?
2. Welche Daten oder Rechte wären besonders sensibel?
3. Wie verhindern wir stille Systemänderungen oder falsche Sicherheit?
4. Was muss der Nutzer bewusst bestätigen?
5. Was darf das Feature ausdruecklich nicht tun?

## Iteration 1: Deutsche Orientierung für den ersten Sensor

Status: umgesetzt am 2026-05-12.

Ziel:
Die App soll beim ersten echten Blick verständlich sein.

Umfang:

- `Findings` in der UI zu `Hinweise` machen
- `Evidence` zu `Belege`
- `Recommended actions` zu `Empfohlene Schritte`
- `Remember as Expected` zu `Als erwartet merken`
- lange technische Finding-Titel kuerzen
- Dashboard-Kopf mit kurzer Zusammenfassung ergaenzen
- Liste in sinnvolle Gruppen teilen:
  - `Neue Änderungen`
  - `Bekannte Autostart-Hinweise`
  - `Zur Beobachtung`

Abnahmekriterium:
Ein normaler Nutzer soll in 10 Sekunden verstehen:

- was die App sieht
- ob etwas neu ist
- was er als nächstes tun kann

## Iteration 2: Startup-Details besser nutzbar machen

Status: umgesetzt am 2026-05-12.

Ziel:
Die gelesenen `.plist`-Details sollen nicht wie ein technischer Textblock wirken.

Umfang:

- Dateiname, Label und Programmpfad klar hervorheben
- `RunAtLoad` und `KeepAlive` in Alltagssprache erklären
- Detailansicht mit kurzer Einordnung starten
- sichtbar machen, dass ein Hinweis nicht beweist, dass etwas aktiv läuft oder gefährlich ist

Abnahmekriterium:
Die Detailansicht beantwortet zuerst "Was bedeutet das für mich?", bevor sie Rohdetails zeigt.

## Iteration 3: UI-nah testen

Status: umgesetzt am 2026-05-12 als Store-/Presentation-naher Test. Echte macOS-Klickautomation bleibt später offen.

Ziel:
Der `Als erwartet merken`-Flow soll nicht nur in Domain-Tests funktionieren.

Umfang:

- Store-/ViewModel-nahe Tests erweitern
- prüfen:
  - Startup-Änderung sichtbar
  - Aktion zum Merken verfügbar
  - nach dem Merken verschwinden Diff-Hinweise
- falls echte macOS-UI-Automation im SwiftPM-Setup nicht stabil ist, Packaging-/Xcode-Frage dokumentiert lassen

Abnahmekriterium:
Der wichtigste Nutzerfluss ist automatisiert oder bewusst als noch nicht automatisierbar dokumentiert.

## Iteration 4: Background Task Management Spike

Status: umgesetzt am 2026-05-12 als erster lokaler Spike. Entscheidung: noch keinen produktiven Sensor auf `sfltool dumpbtm` bauen.

Ziel:
Prüfen, ob moderne macOS-Login-/Background-Items eine stabile Quelle für einen späteren Sensor sind.

Umfang:

- `SMAppService` prüfen
- `sfltool dumpbtm` auf echter macOS-Umgebung untersuchen
- Rechtebedarf und Ausgabeformat bewerten
- keine produktive Integration, solange die Quelle nicht stabil genug ist

Abnahmekriterium:
Eine klare Entscheidung:

- Sensor bauen
- weiter beobachten
- oder bewusst nicht verwenden

## Iteration 5: Nächsten Sensor auswählen

Status: umgesetzt am 2026-05-12. Entscheidung: noch keinen neuen Sensor bauen; zuerst Packaging/Signing/Sandbox klären.

Ziel:
Nach UI-Klarheit entscheiden, welche lokale Sicht als nächstes echten Nutzerwert bringt.

Kandidaten:

- moderne Login-/Background-Items
- Privacy-Permissions-Sichtbarkeit
- weitere lokale Exposure Checks

Auswahlkriterien:

- read-only
- ohne Full Disk Access sinnvoll
- leicht erklärbar
- geringe Fehlalarm-Gefahr
- Evidence statt Behauptungen

## Iteration 6: Packaging, Signing und Sandbox

Status: umgesetzt am 2026-05-12 als Packaging-Spike. Entscheidung: SwiftPM bleibt kurzfristig für Entwicklung; vor Nutzer-Testbuilds braucht es einen App-Bundle-/Xcode-Projekt-Spike.

Ziel:
Vor echter Distribution klären, wie die App sauber gebaut, signiert und später notarized wird.

Umfang:

- SwiftPM allein vs. Xcode-Projekt entscheiden
- Hardened Runtime testen
- Sandbox-Auswirkung auf Startup-Sensor prüfen
- keine neuen Entitlements ohne konkreten Nutzen

Abnahmekriterium:
Ein klarer Packaging-Pfad für MVP-Testversionen.

## Bewusst später

- echte Guided Actions, die Systemeinstellungen öffnen oder ändern
- Full Disk Access
- Adminrechte
- privilegierte Helper
- aggressive Live-Validierung
- Cloud-/Online-Intelligence
- vollständige macOS-Persistenzabdeckung

## Definition of Done pro Iteration

Eine Iteration ist erst fertig, wenn:

1. Code oder Doku umgesetzt ist
2. passende Tests/Checks gelaufen sind
3. `docs/session-status.md` aktualisiert ist
4. dauerhafte Erkenntnisse in `docs/project-learnings.md` stehen
5. der Stand committed und gepusht ist
