#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)

cd "$REPO_ROOT"

echo "==> Refactor and regression pass"
swift build
swift test

echo "==> Security checks"
"$SCRIPT_DIR/security-checks.sh"

echo "==> End-to-end smoke tests"
"$SCRIPT_DIR/e2e-smoke.sh"

echo "All local checks passed."
