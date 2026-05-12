# Current Overview

## Kurzstand

`local-security-twin` ist aktuell eine kleine lokale macOS-Sicherheits-App mit einem echten ersten Sensor.

Die App kann:

- sichtbare Startup-`plist`-Dateien in Nutzer- und gemeinsamen Launch-Ordnern finden
- einfache Details aus diesen Dateien lesen
- Findings mit Evidence und Recommendations erzeugen
- einen lokalen bekannten Startup-Zustand speichern
- neue oder verschwundene Startup-Hinweise seit diesem Zustand melden
- den aktuellen Startup-Zustand bewusst als erwartet merken
- lokale Policy-Entscheidungen speichern

## Wichtiges mentales Modell

Die App ist noch kein vollstaendiger macOS-Sicherheitscanner.

Sie ist im Moment eher ein ruhiger lokaler Beobachter:

1. Was ist sichtbar?
2. Was hat sich seit dem gemerkten Zustand geaendert?
3. Wie erklaeren wir das, ohne Panik zu machen?
4. Was darf der Nutzer bewusst als erwartet markieren?

## Hauptfluss

1. `LocalSecurityTwinApp` erstellt `FindingStore` und `PolicyStore`.
2. `FindingStore` ruft die `SensorPipeline` auf.
3. Die Live-Pipeline enthaelt aktuell den `LaunchAgentInventorySensor`.
4. Der Sensor scannt sichtbare Startup-Ordner.
5. Er baut daraus `Finding`-Objekte.
6. `ContentView` zeigt die Findings.
7. `FindingDetailView` zeigt Evidence, Kontext und empfohlene Aktionen.
8. Wenn Startup-Aenderungen sichtbar sind, bietet das Dashboard `Remember as Expected` an.

## Was bewusst begrenzt ist

Der erste Sensor sieht:

- `~/Library/LaunchAgents`
- `/Library/LaunchAgents`
- `/Library/LaunchDaemons`

Er sieht aktuell nicht:

- moderne Login Items vollstaendig
- Background Task Management Status
- tatsaechlich laufende oder geladene Jobs
- System-LaunchAgents unter `/System/Library`
- Signaturen oder Herkunft der Zielprogramme

Das ist fuer den MVP Absicht. Die App soll erst sicher erklaeren, was sie wirklich sieht.

## Aktueller naechster Schritt

Der naechste gute Produkt-Schritt ist:

1. Die aktuelle UI auf Deutsch und klarere Orientierung umbauen.
2. Findings gruppieren und priorisieren, statt nur eine lange Liste zu zeigen.
3. Danach die `Remember as Expected`-UI mit echter macOS-UI-Interaktion testen.
4. Danach entscheiden, ob Background Task Management als Spike oder Sensor folgt.

Die zentrale Planungsuebersicht steht in `docs/roadmap.md`.

## Aktueller UX-Befund

Der erste manuelle Blick auf die App zeigt:

- Die Oberflaeche ist noch Englisch.
- Die Liste ist schwer zu scannen.
- Viele Findings klingen gleich wichtig.
- Es fehlt ein roter Faden: Was ist neu, was ist bekannt, was soll ich tun?
- Die App wirkt noch wie ein technischer Inspector, nicht wie ein ruhiger Sicherheitsbegleiter.

Details stehen in `docs/ui-ux-redesign-notes.md`.

## Aktuelle technische Grenze

Die Domain- und Store-Logik fuer `Remember as Expected` ist getestet.

Was noch fehlt:

- echte SwiftUI-/macOS-UI-Automation fuer den Klickpfad
- ein Packaging-/Signing-Setup, das spaeter stabilere UI-Tests erleichtert
- eine Entscheidung, ob SwiftPM allein reicht oder ein Xcode-Projekt ergaenzt werden soll
