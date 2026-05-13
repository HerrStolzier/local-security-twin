#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
APP_PATH="$REPO_ROOT/.build/app/LocalSecurityTwin.app"
EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/LocalSecurityTwin"
DEMO_HOME=$(mktemp -d "${TMPDIR:-/tmp}/local-security-twin-demo-home.XXXXXX")
LAUNCH_AGENTS_DIR="$DEMO_HOME/Library/LaunchAgents"
BASELINE_DIR="$DEMO_HOME/Library/Application Support/LocalSecurityTwin"

cd "$REPO_ROOT"

"$SCRIPT_DIR/build-app-bundle.sh"

pkill -f "$EXECUTABLE_PATH" >/dev/null 2>&1 || true

mkdir -p "$LAUNCH_AGENTS_DIR" "$BASELINE_DIR"

cat > "$LAUNCH_AGENTS_DIR/com.local-security-twin.demo-new-startup-item.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local-security-twin.demo-new-startup-item</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/true</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
PLIST

cat > "$BASELINE_DIR/startup-item-baseline.json" <<'JSON'
{
  "capturedAt" : "1970-01-01T00:08:20Z",
  "items" : [

  ],
  "sensorID" : "launch-agent-inventory"
}
JSON

echo "Starting Local Security Twin with prepared startup diff."
echo "Temporary HOME: $DEMO_HOME"
echo "Look for: com.local-security-twin.demo-new-startup-item.plist"
echo "Expected UI: one visible startup change and the action 'Als erwartet merken'."
echo "Stop it with: pkill -f '$EXECUTABLE_PATH'"

HOME="$DEMO_HOME" "$EXECUTABLE_PATH"
