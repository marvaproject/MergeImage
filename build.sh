#!/bin/bash
set -e

APP_NAME="Merge Image"
BUNDLE_DIR="$APP_NAME.app"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
CACHE_DIR=".module-cache"

echo "🔨 Menyiapkan direktori aplikasi..."
rm -rf "$BUNDLE_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"
mkdir -p "$CACHE_DIR"

echo "🚀 Mengompilasi Swift binary..."
swiftc \
    -O \
    -target x86_64-apple-macos12.0 \
    -module-cache-path "$CACHE_DIR" \
    -parse-as-library \
    Sources/Models/MergeConfiguration.swift \
    Sources/Models/ImageItem.swift \
    Sources/Extensions/Color+NSColor.swift \
    Sources/Services/ImageMergerService.swift \
    Sources/Views/ImageListView.swift \
    Sources/Views/ControlsView.swift \
    Sources/Views/CanvasPreviewView.swift \
    Sources/Views/ContentView.swift \
    Sources/main.swift \
    -o "$MACOS_DIR/MergeImage"

echo "📄 Menyalin Info.plist dan Icon..."
cp Info.plist "$CONTENTS_DIR/Info.plist"
if [ -f "AppIcon.icns" ]; then
    cp AppIcon.icns "$RESOURCES_DIR/AppIcon.icns"
fi

echo "✨ Mengatur izin eksekusi..."
chmod +x "$MACOS_DIR/MergeImage"

echo "🎉 Sukses! '$BUNDLE_DIR' siap digunakan."
