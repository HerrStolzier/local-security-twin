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

## Security-Hygiene-Grenzen

Einige wichtige Schutzthemen sind fuer normale Nutzer sehr relevant, aber lokal nicht immer sicher automatisch pruefbar.

Aktuell noch nicht automatisch verifiziert:

- 2FA fuer Apple-ID, E-Mail, Banking, Social Media oder andere Konten
- Nutzung eines Passwortmanagers
- Qualitaet oder Vollstaendigkeit eines VPN-Schutzes
- Schutzleistung eines Antivirus- oder Security-Tools
- Zustand aller Treiber, System Extensions und Network Extensions

Was das praktisch bedeutet:

- Die App darf diese Themen als gefuehrte Checkliste aufnehmen.
- Sie darf lokale Hinweise nutzen, wenn sie sauber belegbar sind.
- Sie darf aber ohne Integration nicht behaupten, ein Konto sei wirklich mit 2FA geschuetzt.
- Sie darf VPN nicht als Rundumschutz darstellen.
- Sie darf installierte Security-Tools nicht pauschal bewerten, solange nur deren Existenz sichtbar ist.

Spaetere Sensoren fuer diese Bereiche brauchen eine eigene Rechte-, Datenschutz- und Fehlalarm-Pruefung.
