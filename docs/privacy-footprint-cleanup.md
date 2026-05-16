# Privacy Footprint Cleanup

## Zweck

Dieses Dokument beschreibt ein späteres Modul für den digitalen Fußabdruck.

Es geht nicht um einen weiteren lokalen macOS-Sensor, sondern um geführte Hilfe bei extern sichtbaren persönlichen Daten:

- Data Broker
- People-Search-Seiten
- alte Accounts
- Suchergebnisse
- Datenlecks
- E-Mail-Alias- und Passwort-Hygiene

## Produktidee

Der Buddy soll dem Nutzer helfen, weniger angreifbar und weniger sichtbar zu werden.

Praktisch:

1. Der Nutzer gibt freiwillig Suchbegriffe oder Fundstellen ein.
2. Die App sortiert und priorisiert.
3. Die App bereitet Lösch-, Opt-out- oder Sicherheitsaufgaben vor.
4. Der Nutzer entscheidet bewusst, was gesendet oder erledigt wird.
5. Die App verfolgt lokal den Fortschritt.

## Realistische Quellen

### Data Broker

Mögliche Datenquellen:

- Big Ass Data Broker Opt-Out List
- Optery Open-Source Data Broker Directory
- weitere gepflegte Opt-out-Verzeichnisse, falls Lizenz und Aktualität passen

Nutzen:

- Broker-Namen
- Opt-out-Links
- Kontaktwege
- Hinweise zum Prozess

Grenze:
Broker ändern Formulare, verlangen Verifikation oder listen Personen erneut.
Darum ist ein geführter Workflow realistischer als Vollautomatik.

### Alte Accounts

Mögliche Quelle:

- JustDeleteMe

Nutzen:

- direkte Löschlinks
- Schwierigkeit je Dienst
- Hinweise zum Prozess

Grenze:
Viele Dienste brauchen Login, 2FA oder Supportkontakt.
Die App soll nicht für den Nutzer in fremde Accounts einloggen.

### Datenlecks

Mögliche Quelle:

- Have I Been Pwned

Nutzen:

- bekannte Breaches zu E-Mail-Adressen
- Passwort-Prüfung über k-Anonymity für Pwned Passwords

Grenzen:

- E-Mail-Abfragen brauchen API-Key/Subscription.
- Der Nutzer muss klar verstehen, welche E-Mail abgefragt wird.
- Passwortwerte dürfen nie im Klartext an externe Dienste gesendet werden.

### E-Mail-Aliase

Mögliche Inspiration oder spätere Integration:

- SimpleLogin
- Proton Pass / Proton Mail Alias-Funktionen
- andere Alias-Anbieter

Nutzen:

- echte E-Mail-Adresse schützen
- geleakte Aliase abschalten
- Registrierungen besser trennen

Grenze:
Alias-Dienste sind selbst Vertrauensstellen.
Die App soll das erklären und keine einzelne Lösung als magischen Schutz verkaufen.

## Geplanter Nutzerfluss

### 1. Start

Die App fragt nicht automatisch nach persönlichen Daten.

Stattdessen:

> "Willst du deinen digitalen Fußabdruck prüfen? Du entscheidest, welche Daten wir dafür verwenden."

Mögliche Eingaben:

- Name
- E-Mail-Adresse
- Telefonnummer
- alte Usernamen
- manuell eingefuegte Suchergebnisse oder Links

### 2. Sortierung

Der Buddy sortiert Fundstellen in:

- Datenleck
- Data Broker / People Search
- alter Account
- Social-Media-Profil
- Suchergebnis
- unklar

### 3. Priorisierung

Erste Priorität:

1. aktive Datenlecks und Passwort-/2FA-Risiken
2. alte Accounts mit sensiblen Daten
3. Data-Broker-Listings mit Adresse, Telefonnummer oder Familienbezug
4. Suchergebnisse mit hohem Missbrauchspotenzial
5. kosmetische oder schwer löschbare Treffer

### 4. Aufgaben

Jede Aufgabe hat lokal einen Status:

- gefunden
- geprüft
- Vorlage vorbereitet
- gesendet
- bestätigt
- nachfassen
- nicht löschbar
- bewusst ignoriert

### 5. Vorlagen

Die App kann Hilfstexte vorbereiten:

- DSGVO-Löschanfrage
- CCPA/CPRA Opt-out oder Delete Request
- KVKK-Löschanfrage
- allgemeine Account-Löschanfrage
- Support-Nachricht für Datenkorrektur

Wichtig:
Diese Texte sind Vorlagen, keine Rechtsberatung.

## Nicht bauen

- keine heimliche Suche nach dem Nutzer
- keine automatische Massenanfrage an Data Broker
- keine automatische Formularausfuellung auf fremden Seiten im MVP
- keine Speicherung oder Weiterleitung von Ausweisdokumenten
- keine SEO-Manipulation als Kernfeature
- keine Behauptung, dass alle Daten dauerhaft gelöscht sind

## Offene Produktfragen

- Soll die App externe Suchmaschinen überhaupt direkt anbinden oder nur manuelle Fundstellen verarbeiten?
- Wo speichern wir besonders sensible Eingaben, und braucht es dafür zusätzliche lokale Verschluesselung?
- Welche Rechtsraeume starten wir zuerst: EU/DSGVO, USA/CCPA, später KVKK?
- Wie erklären wir, dass entfernte Listings wieder auftauchen können?
- Wollen wir HIBP erst manuell/importbasiert starten, bevor ein API-Key-Flow gebaut wird?

## Empfehlung

Dieses Modul ist sinnvoll, aber nicht sofort.

Empfohlene Reihenfolge:

1. lokale Buddy-Oberfläche und Detail-UX stabilisieren
2. Update Awareness bauen
3. Security Hygiene bauen
4. dann Privacy Footprint Cleanup als eigenen Produktarm planen

Grund:
Der digitale Fußabdruck beruehrt sehr persönliche Daten und externe Dienste.
Das braucht klare Zustimmung, gute Erklärung und saubere Grenzen.
