# Privacy Footprint Cleanup

## Zweck

Dieses Dokument beschreibt ein spaeteres Modul fuer den digitalen Fussabdruck.

Es geht nicht um einen weiteren lokalen macOS-Sensor, sondern um gefuehrte Hilfe bei extern sichtbaren persoenlichen Daten:

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
3. Die App bereitet Loesch-, Opt-out- oder Sicherheitsaufgaben vor.
4. Der Nutzer entscheidet bewusst, was gesendet oder erledigt wird.
5. Die App verfolgt lokal den Fortschritt.

## Realistische Quellen

### Data Broker

Moegliche Datenquellen:

- Big Ass Data Broker Opt-Out List
- Optery Open-Source Data Broker Directory
- weitere gepflegte Opt-out-Verzeichnisse, falls Lizenz und Aktualitaet passen

Nutzen:

- Broker-Namen
- Opt-out-Links
- Kontaktwege
- Hinweise zum Prozess

Grenze:
Broker aendern Formulare, verlangen Verifikation oder listen Personen erneut.
Darum ist ein gefuehrter Workflow realistischer als Vollautomatik.

### Alte Accounts

Moegliche Quelle:

- JustDeleteMe

Nutzen:

- direkte Loeschlinks
- Schwierigkeit je Dienst
- Hinweise zum Prozess

Grenze:
Viele Dienste brauchen Login, 2FA oder Supportkontakt.
Die App soll nicht fuer den Nutzer in fremde Accounts einloggen.

### Datenlecks

Moegliche Quelle:

- Have I Been Pwned

Nutzen:

- bekannte Breaches zu E-Mail-Adressen
- Passwort-Pruefung ueber k-Anonymity fuer Pwned Passwords

Grenzen:

- E-Mail-Abfragen brauchen API-Key/Subscription.
- Der Nutzer muss klar verstehen, welche E-Mail abgefragt wird.
- Passwortwerte duerfen nie im Klartext an externe Dienste gesendet werden.

### E-Mail-Aliase

Moegliche Inspiration oder spaetere Integration:

- SimpleLogin
- Proton Pass / Proton Mail Alias-Funktionen
- andere Alias-Anbieter

Nutzen:

- echte E-Mail-Adresse schuetzen
- geleakte Aliase abschalten
- Registrierungen besser trennen

Grenze:
Alias-Dienste sind selbst Vertrauensstellen.
Die App soll das erklaeren und keine einzelne Loesung als magischen Schutz verkaufen.

## Geplanter Nutzerfluss

### 1. Start

Die App fragt nicht automatisch nach persoenlichen Daten.

Stattdessen:

> "Willst du deinen digitalen Fussabdruck pruefen? Du entscheidest, welche Daten wir dafuer verwenden."

Moegliche Eingaben:

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

Erste Prioritaet:

1. aktive Datenlecks und Passwort-/2FA-Risiken
2. alte Accounts mit sensiblen Daten
3. Data-Broker-Listings mit Adresse, Telefonnummer oder Familienbezug
4. Suchergebnisse mit hohem Missbrauchspotenzial
5. kosmetische oder schwer loeschbare Treffer

### 4. Aufgaben

Jede Aufgabe hat lokal einen Status:

- gefunden
- geprueft
- Vorlage vorbereitet
- gesendet
- bestaetigt
- nachfassen
- nicht loeschbar
- bewusst ignoriert

### 5. Vorlagen

Die App kann Hilfstexte vorbereiten:

- DSGVO-Loeschanfrage
- CCPA/CPRA Opt-out oder Delete Request
- KVKK-Loeschanfrage
- allgemeine Account-Loeschanfrage
- Support-Nachricht fuer Datenkorrektur

Wichtig:
Diese Texte sind Vorlagen, keine Rechtsberatung.

## Nicht bauen

- keine heimliche Suche nach dem Nutzer
- keine automatische Massenanfrage an Data Broker
- keine automatische Formularausfuellung auf fremden Seiten im MVP
- keine Speicherung oder Weiterleitung von Ausweisdokumenten
- keine SEO-Manipulation als Kernfeature
- keine Behauptung, dass alle Daten dauerhaft geloescht sind

## Offene Produktfragen

- Soll die App externe Suchmaschinen ueberhaupt direkt anbinden oder nur manuelle Fundstellen verarbeiten?
- Wo speichern wir besonders sensible Eingaben, und braucht es dafuer zusaetzliche lokale Verschluesselung?
- Welche Rechtsraeume starten wir zuerst: EU/DSGVO, USA/CCPA, spaeter KVKK?
- Wie erklaeren wir, dass entfernte Listings wieder auftauchen koennen?
- Wollen wir HIBP erst manuell/importbasiert starten, bevor ein API-Key-Flow gebaut wird?

## Empfehlung

Dieses Modul ist sinnvoll, aber nicht sofort.

Empfohlene Reihenfolge:

1. lokale Buddy-Oberflaeche und Detail-UX stabilisieren
2. Update Awareness bauen
3. Security Hygiene bauen
4. dann Privacy Footprint Cleanup als eigenen Produktarm planen

Grund:
Der digitale Fussabdruck beruehrt sehr persoenliche Daten und externe Dienste.
Das braucht klare Zustimmung, gute Erklaerung und saubere Grenzen.
