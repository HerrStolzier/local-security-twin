#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
APP_PATH="$REPO_ROOT/.build/app/LocalSecurityTwin.app"
EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/LocalSecurityTwin"

cd "$REPO_ROOT"

"$SCRIPT_DIR/build-app-bundle.sh"

plutil -lint "$APP_PATH/Contents/Info.plist" >/dev/null
codesign --verify --deep --strict --verbose=2 "$APP_PATH" >/dev/null

cleanup() {
    pkill -f "$EXECUTABLE_PATH" >/dev/null 2>&1 || true
}

trap cleanup EXIT

open -n "$APP_PATH"
sleep 3

if ! pgrep -f "$EXECUTABLE_PATH" >/dev/null; then
    echo "App bundle launch smoke failed: process did not stay alive." >&2
    exit 1
fi

echo "App bundle launch smoke passed."
