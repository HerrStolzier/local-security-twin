# macOS Permissions and Entitlements Strategy

## Zweck

Diese Datei beschreibt, welche macOS-Rechte `local-security-twin` im MVP wirklich braucht.

Das Ziel ist einfach:

- so wenig Rechte wie moeglich anfragen
- jede Anfrage vorher verstaendlich erklaeren
- keine stillen Systemaenderungen machen
- lokale Sichtbarkeit zuerst nutzen, bevor tiefere Systemrechte dazukommen

## Grundregel fuer das MVP

Die App startet als ruhiger lokaler Beobachter.

Sie soll im MVP nur lesen, erklaeren und Empfehlungen geben. Sie soll keine Systemeinstellungen automatisch veraendern, keine Hintergrunddienste installieren und keine erweiterten Rechte anfordern, nur um "mehr zu sehen".

## Rechte, die im MVP noetig sind

### Normale App-Ausfuehrung

Status: noetig.

Wofuer:
Die App muss als normale macOS-App starten koennen, mit Menueleiste, Hauptfenster und Settings.

Was das praktisch bedeutet:
Der Nutzer oeffnet die App wie jede andere App. Die App arbeitet erst einmal mit den Informationen, die ein normaler Nutzerprozess sehen darf.

Nutzertext:
`Local Security Twin laeuft lokal auf deinem Mac und schaut zuerst nur auf sichtbare Hinweise, die ohne besondere Systemrechte lesbar sind.`

### Lokaler Application-Support-Speicher

Status: noetig.

Wofuer:
Die App speichert lokale Entscheidungen und Baselines in `Application Support`.

Was das praktisch bedeutet:
Die App kann sich merken, was der Nutzer erlaubt oder als erwartet markiert hat. Diese Daten bleiben auf dem Mac.

Nutzertext:
`Die App merkt sich deine Entscheidungen lokal auf diesem Mac. Sie braucht dafuer keinen Cloud-Zugang.`

## Rechte, die im MVP bewusst nicht noetig sind

### Full Disk Access

Status: nicht noetig fuer den aktuellen MVP.

Warum nicht:
Der erste Sensor liest sichtbare LaunchAgent- und LaunchDaemon-Dateien. Dafuer soll die App nicht pauschal vollen Festplattenzugriff verlangen.

Was das praktisch bedeutet:
Die App sieht weniger als ein stark privilegiertes Security-Tool, bleibt dafuer aber ruhiger und vertrauenswuerdiger.

Spaeter moeglich:
Full Disk Access kann spaeter als optionaler, klar erklaerter Modus kommen, wenn ein konkreter Sensor ohne diese Berechtigung keinen echten Nutzen liefern kann.

Nutzertext:
`Ohne vollen Festplattenzugriff sieht die App bewusst nur einen Teil deines Systems. Das ist fuer den Anfang Absicht, damit sie nicht mehr Zugriff bekommt als noetig.`

### Administratorrechte

Status: nicht noetig fuer den aktuellen MVP.

Warum nicht:
Der MVP soll beobachten und erklaeren, nicht reparieren oder Systemdateien veraendern.

Was das praktisch bedeutet:
Die App fragt nicht nach deinem Admin-Passwort, nur um Findings anzuzeigen.

Spaeter moeglich:
Adminrechte duerfen spaeter nur fuer einzelne, klar bestaetigte Aktionen angefragt werden.

Nutzertext:
`Die App braucht gerade keine Administratorrechte, weil sie nichts an deinem System veraendert.`

### Accessibility Permission

Status: nicht noetig fuer den aktuellen MVP.

Warum nicht:
Die App steuert keine anderen Apps und liest keine UI-Inhalte anderer Programme.

Was das praktisch bedeutet:
Die App kann keine Fenster anderer Apps fernbedienen oder UI-Inhalte auslesen.

Spaeter moeglich:
Nur falls spaeter ein klarer, nutzergewollter Guided-Action-Flow entsteht. Fuer reine Security-Sichtbarkeit ist diese Berechtigung nicht der erste Weg.

Nutzertext:
`Die App braucht keinen Zugriff auf die Bedienung anderer Apps.`

### Screen Recording

Status: nicht noetig.

Warum nicht:
Der MVP analysiert keine Bildschirminhalte.

Was das praktisch bedeutet:
Die App kann und soll nicht sehen, was auf deinem Bildschirm passiert.

Nutzertext:
`Die App nimmt deinen Bildschirm nicht auf und braucht dafuer keine Berechtigung.`

### Network Client Access

Status: nicht noetig fuer den lokalen MVP.

Warum nicht:
Der aktuelle Produktkern ist local-first. Findings, Policy und Baseline funktionieren ohne Cloud.

Was das praktisch bedeutet:
Die App muss fuer den aktuellen Stand keine Daten an einen Server senden.

Spaeter moeglich:
Optionale Updates, Signaturdaten oder externe Tool-Dokumentation duerfen spaeter nur mit klarer Erklaerung und sichtbarer Kontrolle kommen.

Nutzertext:
`Der aktuelle Sicherheitscheck funktioniert lokal. Es werden dafuer keine Daten hochgeladen.`

### Privileged Helper Tool

Status: nicht noetig fuer den aktuellen MVP.

Warum nicht:
Ein privilegierter Helper waere ein starkes Werkzeug. Er passt erst, wenn es eine konkrete, begrenzte und gut erklaerte Aktion gibt.

Was das praktisch bedeutet:
Die App installiert keinen heimlichen Hintergrunddienst mit hoeheren Rechten.

Spaeter moeglich:
Nur fuer einzelne spaetere Funktionen, die ohne Helper nicht moeglich sind, und nur mit expliziter Zustimmung.

Nutzertext:
`Die App installiert keinen zusaetzlichen Systemhelfer mit Sonderrechten.`

## Entitlements fuer den naechsten technischen Stand

Fuer den aktuellen SwiftPM-Stand gibt es noch kein eigenes Signing-/Entitlements-Profil im Repo.

Wenn spaeter ein `.entitlements`-File oder ein Xcode-Projekt ergaenzt wird, sollte der Startpunkt sehr klein bleiben:

- App Sandbox nur dann aktivieren, wenn Packaging und gewuenschte Dateisystem-Sichtbarkeit sauber zusammenpassen
- keine Network-Client-Entitlement fuer den local-first MVP
- keine Automation- oder Apple-Events-Entitlements
- keine Hardened-Runtime-Ausnahmen ohne dokumentierten Grund

## Entscheidungsregel fuer neue Rechte

Eine neue Berechtigung darf erst dazukommen, wenn alle vier Fragen klar beantwortet sind:

1. Welcher konkrete Nutzer-Nutzen geht ohne diese Berechtigung verloren?
2. Welche Daten oder Systembereiche werden dadurch zusaetzlich sichtbar?
3. Wie erklaert die App das vor der Anfrage in einfacher Sprache?
4. Wie kann der Nutzer die Entscheidung spaeter verstehen oder rueckgaengig machen?

## Naechster Schritt nach dieser Strategie

Der naechste fachliche Schritt ist ein expliziter `trusted baseline refresh`-Flow.

Das bedeutet:
Der Nutzer kann spaeter bewusst sagen: "Diese Startup-Aenderungen sind erwartet, nimm sie als neuen Ausgangspunkt." Die App soll das nicht automatisch tun, weil sonst wichtige Veraenderungen still verschwinden koennten.
