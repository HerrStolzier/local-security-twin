#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
APP_PATH="$REPO_ROOT/.build/app/LocalSecurityTwin.app"
EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/LocalSecurityTwin"
DEMO_HOME=$(mktemp -d "${TMPDIR:-/tmp}/local-security-twin-sandbox-home.XXXXXX")
LAUNCH_AGENTS_DIR="$DEMO_HOME/Library/LaunchAgents"
BASELINE_DIR="$DEMO_HOME/Library/Application Support/LocalSecurityTwin"

cd "$REPO_ROOT"

APP_SANDBOX=1 "$SCRIPT_DIR/build-app-bundle.sh"

codesign --verify --deep --strict --verbose=2 "$APP_PATH" >/dev/null

if ! codesign -d --entitlements :- "$APP_PATH" 2>/dev/null | grep -q "com.apple.security.app-sandbox"; then
    echo "Sandbox smoke failed: app-sandbox entitlement is missing." >&2
    exit 1
fi

mkdir -p "$LAUNCH_AGENTS_DIR" "$BASELINE_DIR"

cat > "$LAUNCH_AGENTS_DIR/com.example.sandbox-current.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.sandbox-current</string>
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

cleanup() {
    pkill -f "$EXECUTABLE_PATH" >/dev/null 2>&1 || true
}

trap cleanup EXIT

HOME="$DEMO_HOME" "$EXECUTABLE_PATH" &
APP_PID=$!
sleep 3

if ! kill -0 "$APP_PID" >/dev/null 2>&1; then
    echo "Sandbox smoke failed: app process did not stay alive." >&2
    exit 1
fi

echo "Sandbox smoke passed."
echo "Manual visibility check home: $DEMO_HOME"
