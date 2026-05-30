# Defensive Adversarial Review Template

## Zweck

Diese Vorlage macht die defensive Angreiferperspektive wiederholbar.
Sie soll vor größeren Funktionen ausgefüllt werden, bevor Code entsteht oder neue macOS-Rechte eingeplant werden.

Der Review darf keine Exploit-Anleitung werden.
Er endet immer in einem sicheren Produkt-Output:

- read-only Sensoridee
- Nutzer-Checkliste
- sicherere Guided Action
- dokumentierte Grenze
- Entscheidung, die Funktion noch nicht zu bauen

## Review-Kopf

- **Feature oder Sensor:**
- **Datum:**
- **Autor:**
- **Betroffene App-Schicht:**
- **Status:** geplant / in Umsetzung / umgesetzt / nicht bauen
- **Sicherheitsmodus:** inspect / explain / recommend / bounded evidence gathering

## 1. Nutzerziel

Welche konkrete Nutzerfrage beantwortet diese Funktion?

Beispiel:
`Hat sich seit meinem gemerkten Zustand etwas geändert, das automatisch starten kann?`

## 2. Sichtbare Belege

Welche Daten darf Sento lokal oder bewusst extern lesen?

| Beleg | Quelle | Lokal/extern | Rechtebedarf | Verlässlichkeit |
|---|---|---|---|---|
|  |  |  |  |  |

## 3. Ehrliche Grenze

Was kann diese Funktion ausdrücklich nicht beweisen?

- Noch ausfüllen.

Welche Formulierung verhindert falsche Sicherheit oder falschen Alarm?

- Noch ausfüllen.

## 4. Realistische Missbrauchskette

Welche harmlose defensive Frage entsteht aus Angreiferdenken?

Beispiel:
`Wenn Angreifer Persistenz wollen, wo würden sie mit normalen macOS-Rechten zuerst Spuren hinterlassen?`

Nicht beschreiben:

- konkrete Ausführungsschritte für Angriffe
- Umgehung von Schutzmechanismen
- Zielauswahl gegen echte Dritte

## 5. Missbrauch gegen den Nutzer

- Könnte die Meldung Angst erzeugen?
- Könnte die empfohlene Aktion zu einem riskanten Klick führen?
- Könnte ein Angreifer die Sprache der App für Social Engineering nachahmen?
- Welche ruhigere Formulierung ist nötig?

## 6. Missbrauch gegen das System

- Fordert die Funktion neue Rechte an?
- Kann ein Fehler zu stillen Systemänderungen führen?
- Kann eine Guided Action versehentlich Einstellungen ändern?
- Was muss ausdrücklich opt-in bleiben?

## 7. Missbrauch gegen die App

- Können lokale Baseline-, Policy- oder Cache-Dateien manipuliert werden?
- Können externe Quellen vergiftet, veraltet oder unvollständig sein?
- Können Dateinamen, Pfade oder Feed-Inhalte die UI täuschen?
- Welche Validierung oder Sichtgrenze ist nötig?

## 8. Nutzerentscheidung

Welche Entscheidung muss sichtbar und reversibel sein?

- keine Entscheidung nötig
- lokal merken
- Anleitung anzeigen
- extern öffnen
- begrenzte Belege sammeln

Begründung:

- Noch ausfüllen.

## 9. Nicht bauen

Was wird für diesen Schnitt bewusst nicht gebaut?

- Noch ausfüllen.

Warum?

- Noch ausfüllen.

## 10. Ergebnis

Empfohlener nächster sicherer Schritt:

- Noch ausfüllen.

Akzeptanzkriterien:

- Noch ausfüllen.

Checks:

- Noch ausfüllen.
