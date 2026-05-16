# Security-Hygiene-Plan

## Ziel

Kapitel 4 soll Sento Guard zu einem verständlichen Begleiter für grundlegende Schutzgewohnheiten machen.

Wichtig: Security-Hygiene ist nicht automatisch ein Sensor. Viele sinnvolle Schutzfragen liegen außerhalb dessen, was eine lokale macOS-App ehrlich sehen kann.

Der erste Schnitt muss deshalb vor allem sauber trennen:

- automatisch lokal gesehen
- aus lokalen Signalen abgeleitet
- vom Nutzer bewusst beantwortet
- aktuell nicht prüfbar

## Produktregel

Jede Hygiene-Aussage braucht einen sichtbaren Belegtyp.

Sento darf sagen:

- "Ich habe lokal gesehen, dass Gatekeeper aktiv wirkt."
- "Ich konnte FileVault gerade nicht prüfen."
- "Du hast angegeben, dass du einen Passwortmanager nutzt."
- "Ohne Integration kann ich 2FA für dieses Konto nicht verifizieren."

Sento darf nicht sagen:

- "Deine Accounts sind geschützt", nur weil der Nutzer eine Checkliste geöffnet hat.
- "VPN macht dich sicher", ohne den konkreten Einsatzzweck zu erklären.
- "Du nutzt 2FA", ohne lokale oder externe Belege zu haben.
- "Alles ist gut", wenn ein wichtiger Status nicht lesbar ist.

## Belegtypen

### Automatisch gesehen

Die App konnte den Zustand lokal lesen.

Beispiele:

- Gatekeeper-Status, wenn `spctl` lesbar ist
- SIP-Status, wenn `csrutil status` lesbar ist
- sichtbare macOS-Version und SOFA-Vergleich
- sichtbare Autostart-`plist`-Dateien

Nutzertext:

> Lokal gesehen.

### Abgeleitet

Die App sieht ein Signal, aber nicht die ganze Wahrheit.

Beispiele:

- eine sichtbare VPN-App bedeutet nicht, dass ein VPN aktiv oder sinnvoll ist
- eine Passwortmanager-App bedeutet nicht, dass Passwörter sauber genutzt werden
- eine Security-App bedeutet nicht, dass Schutz aktiv oder korrekt konfiguriert ist

Nutzertext:

> Aus lokalen Hinweisen abgeleitet, nicht vollständig geprüft.

### Nutzerangabe

Der Nutzer beantwortet eine Frage bewusst.

Beispiele:

- "Ich nutze für wichtige Konten 2FA."
- "Ich nutze einen Passwortmanager."
- "Ich habe Recovery Codes sicher abgelegt."

Nutzertext:

> Von dir beantwortet.

### Nicht prüfbar

Die App kann den Zustand aktuell nicht ehrlich sehen.

Beispiele:

- 2FA-Status externer Konten ohne Integration
- Qualität eines VPN-Anbieters
- Vollständigkeit eines Passwortmanagers
- Schutzstatus fremder Security-Tools

Nutzertext:

> Gerade nicht automatisch prüfbar.

## Erster sinnvoller Schnitt

Der erste Kapitel-4-Schnitt sollte noch keine tiefen neuen Rechte verlangen.

Empfohlene Reihenfolge:

1. Hygiene-Modell mit Kategorien und Belegtyp anlegen.
2. Bestehende Signale einsortieren: Gatekeeper, SIP, macOS-Update, Autostart.
3. Geplante Fragen als lokale Checkliste modellieren: 2FA, Passwortmanager, Recovery Codes.
4. UI-Mission `Security-Hygiene` von "Geplant" zu einem echten, aber klar begrenzten Bereich machen.

## Startkategorien

### Mac-Schutz

Automatisch oder teilweise automatisch:

- macOS-Update-Stand
- Gatekeeper
- SIP
- später FileVault
- später Firewall

Vorsicht:

- Gatekeeper und SIP sind Schutzsignale, kein Gesamturteil.
- FileVault und Firewall brauchen eigene Sichtbarkeitsprüfung, bevor sie als automatisch gesehen gelten.

### Account-Schutz

Zuerst geführte Nutzerfragen:

- 2FA für Apple-ID
- 2FA für E-Mail
- 2FA für Banking und wichtige Cloud-Konten
- Recovery Codes sicher abgelegt

Vorsicht:

- Ohne Integration ist das eine Nutzerangabe, kein Beweis.
- Keine Backup-Codes, Passwörter oder Geheimnisse abfragen.

### Passwort-Hygiene

Zuerst geführte Nutzerfragen:

- Passwortmanager vorhanden
- eindeutige Passwörter für wichtige Konten
- alte oder mehrfach verwendete Passwörter werden schrittweise ersetzt

Später eventuell automatisch:

- sichtbare Passwortmanager-App als schwaches lokales Signal
- Breach-Hygiene über eine bewusst konfigurierte externe Quelle

Vorsicht:

- Keine Passwörter im Klartext verarbeiten.
- Keine Passwortqualität behaupten, wenn die App sie nicht sieht.

### Netzwerk und VPN

Zuerst erklären und fragen:

- Nutzt der Nutzer häufig fremde WLANs?
- Ist VPN beruflich vorgeschrieben?
- Geht es um Privatsphäre gegenüber Netzwerkbetreibern oder um Account-Sicherheit?

Vorsicht:

- VPN ist kein magischer Rundumschutz.
- VPN verschiebt Vertrauen oft nur zu einem anderen Anbieter.

### Tiefe Systemsoftware

Späterer Sensor-/Research-Schnitt:

- System Extensions
- Network Extensions
- DriverKit-Erweiterungen
- Security-Tools mit tiefen Rechten

Vorsicht:

- Sichtbarkeit kann zusätzliche macOS-Rechte oder eigene Research-Spikes brauchen.
- Existenz einer Erweiterung ist noch keine Bewertung.

## Akzeptanzkriterien für Kapitel 4

- Jede Hygiene-Karte zeigt ihren Belegtyp.
- Geplante oder nicht prüfbare Bereiche wirken nicht wie echte Prüfungen.
- Nutzerangaben werden lokal gespeichert und klar als Nutzerangabe markiert.
- Es werden keine Passwörter, 2FA-Codes, Recovery Codes oder VPN-Geheimnisse abgefragt.
- Es gibt keine stillen Änderungen an Firewall, FileVault, VPN, Security-Tools oder Extensions.

## Nicht im ersten Schnitt

- keine automatische 2FA-Verifikation
- keine Passwortanalyse
- keine VPN-Bewertung
- keine Veränderung von macOS-Einstellungen
- keine neuen erweiterten macOS-Rechte
- keine externe Breach-Abfrage ohne eigenes Datenschutz-/API-Konzept
