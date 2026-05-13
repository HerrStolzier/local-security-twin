# Known Limits

## Zweck

Diese Datei beschreibt ehrlich, was Local Security Twin aktuell sieht und was nicht.

Das ist wichtig, weil Vertrauen hier nicht aus grossen Versprechen entsteht, sondern aus klaren Grenzen.

## Startup-Sensor

Der Startup-Sensor sieht sichtbare `.plist`-Dateien in:

- `~/Library/LaunchAgents`
- `/Library/LaunchAgents`
- `/Library/LaunchDaemons`

Er kann einfache Felder lesen:

- `Label`
- `Program`
- `ProgramArguments`
- `RunAtLoad`
- `KeepAlive`

Grenzen:

- sichtbar heisst nicht aktiv
- neu heisst nicht gefaehrlich
- verschwunden heisst nicht automatisch problematisch
- moderne Login-/Background-Items sind noch nicht vollstaendig abgedeckt
- `sfltool dumpbtm` ist noch keine robuste Produktquelle

## Systemprofil-Sensor

Der Systemprofil-Sensor liest lokale Basisdaten und optionale Schutzsignale:

- macOS-Version
- Architektur
- Computername, wenn sichtbar
- Gatekeeper-Status, wenn lesbar
- SIP-Status, wenn lesbar

Grenzen:

- er bewertet nicht den ganzen Mac
- ein aktives Schutzsignal beweist nicht vollstaendige Sicherheit
- ein nicht lesbares Schutzsignal ist zuerst eine Sichtgrenze
- optionale Abfragen duerfen fehlschlagen und werden dann ruhig als Note behandelt

## Rechte und Sandbox

Der MVP fordert bewusst keine hohen Rechte an.

Nicht Teil des aktuellen MVP:

- Full Disk Access
- Accessibility
- Screen Recording
- Apple Events
- Network Client
- privilegierte Helper

Sandbox ist lokal testbar, aber nicht Standard. Sie kann Dateisystemsicht beeinflussen und muss vor echter Distribution weiter bewertet werden.

## UI- und Testgrenzen

Aktuell gibt es:

- Unit-Tests
- Store-/Presentation-nahe E2E-Tests
- App-Bundle-Smokes
- Sandbox-Smoke
- Hardened-Runtime-Smoke

Noch offen:

- echte macOS-Klickautomation
- notarized Release-Artefakt
- Developer-ID-signierter Build
- vollstaendige visuelle Regressionstests

## Produktgrenzen

Die App ist ein lokaler Sicherheitsbegleiter, kein Enterprise-SIEM und kein autonomes Reparaturwerkzeug.

Sie soll:

- beobachten
- erklaeren
- lokale Entscheidungen merken
- spaeter begrenzt Belege sammeln

Sie soll nicht:

- Angst erzeugen
- automatisch haerten
- versteckte Aenderungen vornehmen
- mehr Systemzugriff verlangen als noetig
