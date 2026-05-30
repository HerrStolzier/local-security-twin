# Defensive Adversarial Review: Sichtbare Autostart-Hinweise

## Review-Kopf

- **Feature oder Sensor:** Sichtbare Autostart-Hinweise über LaunchAgents und LaunchDaemons
- **Datum:** 2026-05-30
- **Autor:** Codex
- **Betroffene App-Schicht:** Sensor-Pipeline, Finding-Presentation, lokaler Baseline-Store
- **Status:** umgesetzt, Review als Produkt-Routine nachgezogen
- **Sicherheitsmodus:** inspect / explain / recommend

## 1. Nutzerziel

Sento soll beantworten:

`Hat sich seit meinem gemerkten Zustand etwas geändert, das automatisch starten kann?`

Das hilft normalen Mac-Nutzern, neue Hintergrund- oder Autostart-Hinweise bewusst einzuordnen, ohne daraus automatisch Malware zu machen.

## 2. Sichtbare Belege

| Beleg | Quelle | Lokal/extern | Rechtebedarf | Verlässlichkeit |
|---|---|---|---|---|
| `.plist`-Dateien im Nutzer-LaunchAgents-Ordner | `~/Library/LaunchAgents` | lokal | normale App-Ausführung | gut für sichtbare Dateien, aber kein Laufzeitbeweis |
| `.plist`-Dateien in gemeinsamen Launch-Ordnern | `/Library/LaunchAgents`, `/Library/LaunchDaemons` | lokal | normale App-Ausführung, soweit lesbar | gut für sichtbare Dateien, aber unvollständig |
| `Label` | Property-List-Inhalt | lokal | keine Zusatzrechte | nützlich als interner Name, aber nicht automatisch vertrauenswürdig |
| `Program` und `ProgramArguments` | Property-List-Inhalt | lokal | keine Zusatzrechte | nützlich für Erklärung, kann aber technisch oder irreführend sein |
| `RunAtLoad` und `KeepAlive` | Property-List-Inhalt | lokal | keine Zusatzrechte | gutes Startverhalten-Signal, aber kein Aktivitätsbeweis |
| lokaler Baseline-Snapshot | Application Support | lokal | keine Zusatzrechte | gut für Change Detection, manipulierbar wie andere lokale Nutzerdaten |

## 3. Ehrliche Grenze

Der Sensor beweist nicht:

- dass ein Eintrag gerade läuft
- dass ein Eintrag bösartig ist
- dass alle modernen Login- oder Background-Items gesehen wurden
- dass versteckte, privilegierte oder tiefere Persistenz ausgeschlossen ist

Ruhige Produktformulierung:

- `sichtbarer Autostart-Hinweis`
- `seit deinem gemerkten Zustand neu`
- `als erwartet merken`
- nicht: `Malware gefunden`
- nicht: `Mac ist sicher`

## 4. Realistische Missbrauchskette

Defensive Frage:

`Wenn ein Angreifer oder unerwünschtes Tool dauerhaft wieder starten will, welche harmlos lesbaren macOS-Orte können erste Hinweise liefern?`

Sicherer Produkt-Output:

- read-only Inventar sichtbarer Launch-`plist`-Dateien
- lokaler Baseline-Vergleich
- Nutzerentscheidung, ob der aktuelle Zustand erwartet ist
- technische Details erst nach bewusster Auswahl

Nicht bauen:

- keine Anleitung zum Anlegen oder Tarnen von Persistenz
- keine automatische Entfernung von Einträgen
- keine Bewertung als Malware allein wegen Autostart

## 5. Missbrauch gegen den Nutzer

Risiken:

- Ein legitimer Eintrag könnte Angst auslösen.
- Ein technischer Pfad könnte wie eine eindeutige Gefahr wirken.
- Ein Button wie `Entfernen` wäre riskant, solange die App keine sichere Remediation hat.

Begrenzung:

- Die App spricht von Hinweisen und Änderungen, nicht von Angriffen.
- Der erste sichere Schritt ist Einordnung oder lokales Merken, nicht Löschen.
- Technische Details bleiben sichtbar, aber nachrangig.

## 6. Missbrauch gegen das System

Risiken:

- Automatisches Löschen könnte legitime Software beschädigen.
- Mehr Rechte würden die Angriffsfläche erhöhen.
- Ein späterer Safe-Mode-Check könnte versehentlich aktiv in Launch-Services eingreifen.

Begrenzung:

- Der Sensor bleibt read-only.
- Baseline-Refresh passiert nur als explizite Nutzerentscheidung.
- Keine Systemänderung ohne eigene Guided Action und separate Bestätigung.

## 7. Missbrauch gegen die App

Risiken:

- Eine manipulierte Baseline kann Änderungen verstecken oder vortäuschen.
- `.plist`-Felder können irreführende Namen enthalten.
- Pfadvarianten können denselben Eintrag doppelt oder falsch erscheinen lassen.
- Unlesbare oder kaputte `.plist`-Dateien können Sichtgrenzen erzeugen.

Begrenzung:

- Baseline-Probleme müssen sichtbar bleiben.
- Pfade werden normalisiert.
- Rohfelder werden als Belege gezeigt, aber nicht als alleinige Wahrheit behandelt.
- Fehler werden als Sichtgrenze statt als stiller Erfolg behandelt.

## 8. Nutzerentscheidung

Entscheidung:

- `Als erwartet merken`

Art:

- lokale Entscheidung
- reversibel über Settings und spätere erneute Baseline
- keine Systemänderung

Begründung:

- Der Nutzer entscheidet, ob dieser sichtbare Zustand für ihn normal ist.
- Die App darf diesen Zustand nicht still ersetzen, weil sonst die Vertrauensfunktion verloren geht.

## 9. Nicht bauen

Für diesen Schnitt bewusst nicht bauen:

- moderne Background-Task-Management-Auswertung als Produktquelle
- automatische Entfernung oder Deaktivierung von Launch Items
- privilegierte Helper
- Full Disk Access
- Live-Prozessüberwachung
- Signatur- oder Reputation-Matching

Warum:

- Der aktuelle MVP soll rechtearm, erklärend und lokal bleiben.
- Jede stärkere Aktion braucht zuerst eine eigene Rechte-, UX- und Safety-Notiz.

## 10. Ergebnis

Empfohlener nächster sicherer Schritt:

- Diese Review-Form als Muster für neue Sensoren nutzen.
- Für moderne Background Items einen separaten Research-Spike planen, bevor Code entsteht.
- Bei späterer Threat-Context-Arbeit Autostart-Hinweise nur mit klarer Quelle, Confidence und Sichtgrenze anreichern.

Akzeptanzkriterien:

- Nutzertexte bleiben ruhig und behaupten keine Malware.
- Baseline-Änderungen sind nur bewusst möglich.
- Rohbelege und Grenzen bleiben sichtbar.
- Keine neue Berechtigung wird für diesen Sensor verlangt.

Checks:

- `swift test`
- `./scripts/checks.sh`
- nach Dokumentations-/Workflow-Änderungen `python3 scripts/agent_finish.py`
