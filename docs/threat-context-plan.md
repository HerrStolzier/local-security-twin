# Threat Context Plan

## Zweck

Sento Guard soll lokale Hinweise später mit aktuellen Bedrohungsinformationen verbinden, ohne daraus einen lauten Scanner oder eine Cloud-Pflicht zu machen.

Dieser Plan beschreibt einen kleinen, lokalen Produktpfad für `ThreatContext`.
Er ist kein Auftrag, große STIX-/TAXII-, SIEM- oder Enterprise-TIP-Infrastruktur einzubauen.

## Auslöser

Der nächste sinnvolle Einsatz entsteht dort, wo die App bereits echte lokale Belege hat:

1. macOS-Version und SOFA-Update-Stand
2. aktiv ausgenutzte CVEs aus einer sichtbaren Quelle
3. später installierte Apps und Versionen
4. später Autostart-Hinweise mit Signatur-, Anbieter- oder Reputation-Kontext

## Leitprinzipien

- Threat Context ist Zusatzbeleg, nicht alleinige Wahrheit.
- Externe Quellen brauchen Quelle, Abrufzeitpunkt, Confidence und Sichtgrenze.
- Kein Netzwerkabruf ohne sichtbare Nutzeraktion oder klar dokumentierte Zustimmung.
- Kein Blockieren, Löschen oder Installieren durch Threat Context.
- Kein pauschaler Sicherheits-Score.
- Nutzertexte bleiben alltagssprachlich; Framework-IDs bleiben intern oder in technischen Details.

## Minimales Datenmodell

Ein späteres `ThreatContext`-Modell sollte klein starten:

| Feld | Zweck |
|---|---|
| `id` | stabile lokale Kennung |
| `sourceName` | sichtbarer Quellenname, z. B. SOFA, Apple Security Releases, CISA KEV |
| `sourceURL` | Referenz zur Quelle |
| `fetchedAt` | lokaler Abrufzeitpunkt |
| `validUntil` | vorsichtige Frischegrenze |
| `confidence` | niedrig / unterstützt / stark |
| `appliesTo` | macOS-Version, App-Version, CVE oder lokales Finding |
| `summary` | kurze Nutzererklärung |
| `technicalDetail` | technische Details für Vertiefung |
| `recommendedActionKind` | Anleitung, extern öffnen, lokal merken, begrenzte Belege sammeln |

## Erste Produktanwendung: Update Awareness

Der vorhandene Update-Awareness-Sensor ist der beste erste Kandidat.

Aktueller Stand:

- normale Läufe nutzen nur lokalen Cache
- Online-Refresh ist eine bewusste Nutzeraktion
- SOFA liefert Update-Stand und CVE-Kontext
- aktiv ausgenutzte CVEs beeinflussen bereits die Wichtigkeit

Nächster sinnvoller Dokumentations- und Code-Schnitt:

1. SOFA-Quellenstand als `ThreatContext`-ähnlichen Beleg modellieren.
2. Apple Security Releases als Primärreferenz klar im technischen Detail nennen.
3. `activelyExploitedCVEs` nicht nur als Zähler, sondern als begründenden Kontext zeigen.
4. UI-Text prüfen: `Update prüfen` statt `du bist gefährdet`, solange keine lokale Kompromittierung sichtbar ist.

## Spätere Produktanwendung: App- und CVE-Matching

Erst nach lokaler App-Inventur sinnvoll:

1. installierte App und Version lokal sehen
2. Quelle für bekannte Schwachstelle lesen
3. Version oder Produkt sauber matchen
4. Confidence sichtbar machen
5. genau einen sicheren nächsten Schritt anbieten

Nicht ausreichend:

- nur App-Name ohne Version
- nur CVE-Schwere ohne lokale Betroffenheit
- nur Tool-Präsenz als Sicherheitsbeweis

## Interne Framework-Mappings

Frameworks wie MITRE ATT&CK, D3FEND, NIST CSF, SSVC, EPSS und KEV können helfen, Sensorideen und Priorität intern zu strukturieren.

Sie sollen nicht die erste Nutzeroberfläche dominieren.
Normale Nutzer brauchen:

- was gesehen wurde
- warum es relevant sein kann
- was jetzt sicher zu tun ist
- was Sento nicht sicher weiß

## Nicht bauen

Für den nächsten Schnitt ausdrücklich nicht bauen:

- MISP, OpenCTI oder TAXII-Client im Produkt
- automatische IOC-Blocklisten
- SIEM-Export
- Fleet- oder Enterprise-Agent-Management
- offensive Validation oder Exploit-Prüfung
- automatische Remediation

## Abnahmekriterien

- Threat Context ist immer an lokale Belege oder eine bewusste Nutzeraktion gebunden.
- Jede externe Quelle zeigt Namen, Stand und Grenze.
- Veraltete oder kaputte Quellen werden ruhig sichtbar.
- Empfehlungen bleiben Guided Actions, keine stillen Systemänderungen.
- Tests sichern ab, dass fehlender Kontext kein falsches Risiko-Finding erzeugt.
