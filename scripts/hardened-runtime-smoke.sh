#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
APP_PATH="$REPO_ROOT/.build/app/LocalSecurityTwin.app"
EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/LocalSecurityTwin"

cd "$REPO_ROOT"

HARDENED_RUNTIME=1 "$SCRIPT_DIR/build-app-bundle.sh"

codesign --verify --deep --strict --verbose=2 "$APP_PATH" >/dev/null

CODESIGN_DETAILS=$(codesign -dv "$APP_PATH" 2>&1 || true)

if ! grep -q "runtime" <<< "$CODESIGN_DETAILS"; then
    echo "Hardened runtime smoke failed: signature does not report runtime option." >&2
    exit 1
fi

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
    echo "Hardened runtime smoke failed: process did not stay alive." >&2
    exit 1
fi

echo "Hardened runtime smoke passed."
