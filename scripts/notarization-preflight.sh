#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
APP_PATH="$REPO_ROOT/.build/app/LocalSecurityTwin.app"

cd "$REPO_ROOT"

HARDENED_RUNTIME=1 "$SCRIPT_DIR/build-app-bundle.sh" release

plutil -lint "$APP_PATH/Contents/Info.plist" >/dev/null
codesign --verify --deep --strict --verbose=2 "$APP_PATH" >/dev/null

CODESIGN_DETAILS=$(codesign -dv "$APP_PATH" 2>&1 || true)

if ! grep -q "runtime" <<< "$CODESIGN_DETAILS"; then
    echo "Expected hardened runtime option in local signature." >&2
    exit 1
fi

"$SCRIPT_DIR/security-checks.sh"

echo "Notarization preflight passed. This does not submit the app to Apple."
