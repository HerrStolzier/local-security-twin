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
    if [[ -n "${APP_PID:-}" ]]; then
        kill "$APP_PID" >/dev/null 2>&1 || true
    fi
}

trap cleanup EXIT

KNOWN_PIDS=$(pgrep -f "$EXECUTABLE_PATH" || true)
open -n "$APP_PATH"
sleep 3

for pid in ${(f)"$(pgrep -f "$EXECUTABLE_PATH" || true)"}; do
    if ! grep -qx "$pid" <<< "$KNOWN_PIDS"; then
        APP_PID="$pid"
        break
    fi
done

if [[ -z "${APP_PID:-}" ]] || ! kill -0 "$APP_PID" >/dev/null 2>&1; then
    echo "App bundle launch smoke failed: process did not stay alive." >&2
    exit 1
fi

echo "App bundle launch smoke passed."
