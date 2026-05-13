#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)

CONFIGURATION="${1:-debug}"
METADATA_PATH="$REPO_ROOT/Packaging/AppMetadata.env"
INFO_PLIST_TEMPLATE="$REPO_ROOT/Packaging/Info.plist.template"

if [[ ! -f "$METADATA_PATH" ]]; then
    echo "Expected app metadata not found: $METADATA_PATH" >&2
    exit 66
fi

source "$METADATA_PATH"

BUNDLE_NAME="${PRODUCT_NAME}.app"
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

if [[ ! -f "$INFO_PLIST_TEMPLATE" ]]; then
    echo "Expected Info.plist template not found: $INFO_PLIST_TEMPLATE" >&2
    exit 66
fi

sed \
    -e "s|@PRODUCT_NAME@|$PRODUCT_NAME|g" \
    -e "s|@APP_DISPLAY_NAME@|$APP_DISPLAY_NAME|g" \
    -e "s|@BUNDLE_IDENTIFIER@|$BUNDLE_IDENTIFIER|g" \
    -e "s|@BUNDLE_VERSION@|$BUNDLE_VERSION|g" \
    -e "s|@BUNDLE_BUILD@|$BUNDLE_BUILD|g" \
    -e "s|@APP_CATEGORY@|$APP_CATEGORY|g" \
    -e "s|@MINIMUM_MACOS_VERSION@|$MINIMUM_MACOS_VERSION|g" \
    "$INFO_PLIST_TEMPLATE" > "$CONTENTS_PATH/Info.plist"

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
