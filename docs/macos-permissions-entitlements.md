# macOS Permissions and Entitlements Strategy

## Zweck

Diese Datei beschreibt, welche macOS-Rechte `local-security-twin` im MVP wirklich braucht.

Das Ziel ist einfach:

- so wenig Rechte wie möglich anfragen
- jede Anfrage vorher verständlich erklären
- keine stillen Systemänderungen machen
- lokale Sichtbarkeit zuerst nutzen, bevor tiefere Systemrechte dazukommen

## Grundregel für das MVP

Die App startet als ruhiger lokaler Beobachter.

Sie soll im MVP nur lesen, erklären und Empfehlungen geben. Sie soll keine Systemeinstellungen automatisch verändern, keine Hintergrunddienste installieren und keine erweiterten Rechte anfordern, nur um "mehr zu sehen".

## Rechte, die im MVP nötig sind

### Normale App-Ausführung

Status: nötig.

Wofür:
Die App muss als normale macOS-App starten können, mit Menüleiste, Hauptfenster und Settings.

Was das praktisch bedeutet:
Der Nutzer öffnet die App wie jede andere App. Die App arbeitet erst einmal mit den Informationen, die ein normaler Nutzerprozess sehen darf.

Nutzertext:
`Local Security Twin läuft lokal auf deinem Mac und schaut zuerst nur auf sichtbare Hinweise, die ohne besondere Systemrechte lesbar sind.`

### Lokaler Application-Support-Speicher

Status: nötig.

Wofür:
Die App speichert lokale Entscheidungen und Baselines in `Application Support`.

Was das praktisch bedeutet:
Die App kann sich merken, was der Nutzer erlaubt oder als erwartet markiert hat. Diese Daten bleiben auf dem Mac.

Nutzertext:
`Die App merkt sich deine Entscheidungen lokal auf diesem Mac. Sie braucht dafür keinen Cloud-Zugang.`

## Rechte, die im MVP bewusst nicht nötig sind

### Full Disk Access

Status: nicht nötig für den aktuellen MVP.

Warum nicht:
Der erste Sensor liest sichtbare LaunchAgent- und LaunchDaemon-Dateien. Dafür soll die App nicht pauschal vollen Festplattenzugriff verlangen.

Was das praktisch bedeutet:
Die App sieht weniger als ein stark privilegiertes Security-Tool, bleibt dafür aber ruhiger und vertrauenswürdiger.

Später möglich:
Full Disk Access kann später als optionaler, klar erklärter Modus kommen, wenn ein konkreter Sensor ohne diese Berechtigung keinen echten Nutzen liefern kann.

Nutzertext:
`Ohne vollen Festplattenzugriff sieht die App bewusst nur einen Teil deines Systems. Das ist für den Anfang Absicht, damit sie nicht mehr Zugriff bekommt als nötig.`

### Administratorrechte

Status: nicht nötig für den aktuellen MVP.

Warum nicht:
Der MVP soll beobachten und erklären, nicht reparieren oder Systemdateien verändern.

Was das praktisch bedeutet:
Die App fragt nicht nach deinem Admin-Passwort, nur um Findings anzuzeigen.

Später möglich:
Adminrechte dürfen später nur für einzelne, klar bestätigte Aktionen angefragt werden.

Nutzertext:
`Die App braucht gerade keine Administratorrechte, weil sie nichts an deinem System verändert.`

### Accessibility Permission

Status: nicht nötig für den aktuellen MVP.

Warum nicht:
Die App steuert keine anderen Apps und liest keine UI-Inhalte anderer Programme.

Was das praktisch bedeutet:
Die App kann keine Fenster anderer Apps fernbedienen oder UI-Inhalte auslesen.

Später möglich:
Nur falls später ein klarer, nutzergewollter Guided-Action-Flow entsteht. Für reine Security-Sichtbarkeit ist diese Berechtigung nicht der erste Weg.

Nutzertext:
`Die App braucht keinen Zugriff auf die Bedienung anderer Apps.`

### Screen Recording

Status: nicht nötig.

Warum nicht:
Der MVP analysiert keine Bildschirminhalte.

Was das praktisch bedeutet:
Die App kann und soll nicht sehen, was auf deinem Bildschirm passiert.

Nutzertext:
`Die App nimmt deinen Bildschirm nicht auf und braucht dafür keine Berechtigung.`

### Network Client Access

Status: nicht nötig für den lokalen MVP.

Warum nicht:
Der aktuelle Produktkern ist local-first. Findings, Policy und Baseline funktionieren ohne Cloud.

Was das praktisch bedeutet:
Die App muss für den aktuellen Stand keine Daten an einen Server senden.

Später möglich:
Optionale Updates, Signaturdaten oder externe Tool-Dokumentation dürfen später nur mit klarer Erklärung und sichtbarer Kontrolle kommen.

Nutzertext:
`Der aktuelle Sicherheitscheck funktioniert lokal. Es werden dafür keine Daten hochgeladen.`

### Privileged Helper Tool

Status: nicht nötig für den aktuellen MVP.

Warum nicht:
Ein privilegierter Helper wäre ein starkes Werkzeug. Er passt erst, wenn es eine konkrete, begrenzte und gut erklärte Aktion gibt.

Was das praktisch bedeutet:
Die App installiert keinen heimlichen Hintergrunddienst mit höheren Rechten.

Später möglich:
Nur für einzelne spätere Funktionen, die ohne Helper nicht möglich sind, und nur mit expliziter Zustimmung.

Nutzertext:
`Die App installiert keinen zusätzlichen Systemhelfer mit Sonderrechten.`

## Entitlements für den nächsten technischen Stand

Für den aktuellen SwiftPM-Stand gibt es noch kein eigenes Signing-/Entitlements-Profil im Repo.

Wenn später ein `.entitlements`-File oder ein Xcode-Projekt ergänzt wird, sollte der Startpunkt sehr klein bleiben:

- App Sandbox nur dann aktivieren, wenn Packaging und gewünschte Dateisystem-Sichtbarkeit sauber zusammenpassen
- keine Network-Client-Entitlement für den local-first MVP
- keine Automation- oder Apple-Events-Entitlements
- keine Hardened-Runtime-Ausnahmen ohne dokumentierten Grund

## Entscheidungsregel für neue Rechte

Eine neue Berechtigung darf erst dazukommen, wenn alle vier Fragen klar beantwortet sind:

1. Welcher konkrete Nutzer-Nutzen geht ohne diese Berechtigung verloren?
2. Welche Daten oder Systembereiche werden dadurch zusätzlich sichtbar?
3. Wie erklärt die App das vor der Anfrage in einfacher Sprache?
4. Wie kann der Nutzer die Entscheidung später verstehen oder rückgängig machen?

## Nächster Schritt nach dieser Strategie

Der nächste fachliche Schritt ist ein expliziter `trusted baseline refresh`-Flow.

Das bedeutet:
Der Nutzer kann später bewusst sagen: "Diese Startup-Änderungen sind erwartet, nimm sie als neuen Ausgangspunkt." Die App soll das nicht automatisch tun, weil sonst wichtige Veränderungen still verschwinden könnten.
