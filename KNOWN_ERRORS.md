# Known Errors

> **Zweck:** Bekannte Fehler des Security-Twins mit Symptom, Ursache und Loesung.
> **Scope:** Lokale Policy-/Cache-Dateien und riskante Smoke-Skripte.
> **Suchbegriffe:** policy, sofa, cache, pkill, smoke, korrupt
> **Stand:** 2026-07-14

## Kaputte lokale Policy-Datei

### Symptom

Gespeicherte Entscheidungen können nicht gelesen werden.

### Ursache

Die lokale JSON-Datei für Policies ist beschädigt oder entspricht nicht mehr dem erwarteten Schema.

### Lösung

Die App darf die alten Entscheidungen nicht still weiterverwenden. `PolicyStore` setzt die gelesenen Entscheidungen zurück und zeigt eine ruhige lokale Persistenz-Notiz, damit der Nutzer erneut bewusst entscheidet.

## Kaputter lokaler SOFA-Cache

### Symptom

Der macOS-Update-Stand kann nicht aus dem lokalen SOFA-Cache gelesen werden.

### Ursache

Die Cache-Datei fehlt, ist beschädigt oder enthält keinen dekodierbaren SOFA-Feed.

### Lösung

Die App arbeitet ohne SOFA-Vergleich weiter und zeigt eine Sichtgrenze. Ein bewusster Online-Refresh darf den Cache später neu schreiben.

## Breites `pkill -f` in Smoke-Skripten

### Symptom

Smoke-/Demo-Skripte beenden Prozesse über einen Kommandozeilen-Match.

### Ursache

`pkill -f` ist bequem, aber für lokale Entwickler-Skripte unnötig breit.

### Lösung

Smoke-Skripte sollen den konkret gestarteten Prozess per PID beenden. Demo-Skripte sollen manuelles Stoppen erklären, wenn sie bewusst im Vordergrund laufen.
