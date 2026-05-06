#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)

cd "$REPO_ROOT"

echo "Checking for committed secrets..."
if rg -n --hidden --glob '!.build' --glob '!*.md' '(?i)(api[_-]?key|secret|token|password)\s*[:=]\s*["'\''][A-Za-z0-9_+=/\\-]{12,}["'\'']' .; then
    echo "Potential secret-like value found. Review before merging."
    exit 1
fi

echo "Checking for hard-coded network endpoints in Swift sources..."
if rg -n --glob '*.swift' 'https?://' Sources Tests; then
    echo "Unexpected hard-coded network endpoint found in Swift sources."
    exit 1
fi

echo "Checking for dangerous privileged execution APIs..."
if rg -n --glob '*.swift' 'AuthorizationExecuteWithPrivileges|NSAppleScript|SMJobBless|osascript' Sources Tests; then
    echo "Dangerous execution API found. Add a reviewed exception process before merging."
    exit 1
fi

echo "Security checks passed."
