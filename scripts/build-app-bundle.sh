#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)

CONFIGURATION="${1:-debug}"
PRODUCT_NAME="LocalSecurityTwin"
BUNDLE_NAME="${PRODUCT_NAME}.app"
BUNDLE_IDENTIFIER="com.herrstolzier.LocalSecurityTwin"
BUNDLE_VERSION="0.1.0"
BUILD_ROOT="$REPO_ROOT/.build/app"
ENTITLEMENTS_PATH="$REPO_ROOT/Packaging/LocalSecurityTwin.entitlements"

case "$CONFIGURATION" in
    debug)
        SWIFT_BUILD_FLAGS=()
        ;;
    release)
        SWIFT_BUILD_FLAGS=(-c release)
        ;;
    *)
        echo "Usage: $0 [debug|release]" >&2
        exit 64
        ;;
esac

cd "$REPO_ROOT"

echo "Building $PRODUCT_NAME ($CONFIGURATION)..."
swift build "${SWIFT_BUILD_FLAGS[@]}"

BIN_DIR=$(swift build "${SWIFT_BUILD_FLAGS[@]}" --show-bin-path)
EXECUTABLE="$BIN_DIR/$PRODUCT_NAME"

if [[ ! -x "$EXECUTABLE" ]]; then
    echo "Expected executable not found: $EXECUTABLE" >&2
    exit 66
fi

BUNDLE_PATH="$BUILD_ROOT/$BUNDLE_NAME"
CONTENTS_PATH="$BUNDLE_PATH/Contents"
MACOS_PATH="$CONTENTS_PATH/MacOS"
RESOURCES_PATH="$CONTENTS_PATH/Resources"

rm -rf "$BUNDLE_PATH"
mkdir -p "$MACOS_PATH" "$RESOURCES_PATH"

cp "$EXECUTABLE" "$MACOS_PATH/$PRODUCT_NAME"

cat > "$CONTENTS_PATH/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>de</string>
    <key>CFBundleExecutable</key>
    <string>$PRODUCT_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_IDENTIFIER</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Local Security Twin</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$BUNDLE_VERSION</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
    <key>LSMinimumSystemVersion</key>
    <string>15.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
PLIST

plutil -lint "$CONTENTS_PATH/Info.plist" >/dev/null

if command -v codesign >/dev/null; then
    CODESIGN_OPTIONS=()

    if [[ "${HARDENED_RUNTIME:-0}" == "1" ]]; then
        CODESIGN_OPTIONS=(--options runtime)
    fi

    if [[ "${APP_SANDBOX:-0}" == "1" ]]; then
        if [[ ! -f "$ENTITLEMENTS_PATH" ]]; then
            echo "Expected entitlements not found: $ENTITLEMENTS_PATH" >&2
            exit 66
        fi

        CODESIGN_OPTIONS+=(--entitlements "$ENTITLEMENTS_PATH")
    fi

    codesign --force --sign - "${CODESIGN_OPTIONS[@]}" "$BUNDLE_PATH" >/dev/null
fi

echo "Built app bundle: $BUNDLE_PATH"
