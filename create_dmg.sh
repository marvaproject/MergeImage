#!/bin/bash
set -e

APP_NAME="Merge Image"
DMG_NAME="MergeImage-v1.0.0-macOS.dmg"
DMG_TMP="temp_dmg"

echo "🔨 Menyiapkan folder untuk DMG..."
rm -rf "$DMG_TMP" "$DMG_NAME"
mkdir -p "$DMG_TMP"

echo "📦 Menyalin aplikasi..."
cp -R "$APP_NAME.app" "$DMG_TMP/"

echo "🔗 Membuat symlink ke /Applications..."
ln -s /Applications "$DMG_TMP/Applications"

echo "🚀 Membuat file DMG..."
hdiutil create -volname "$APP_NAME" \
    -srcfolder "$DMG_TMP" \
    -ov -format UDZO \
    "$DMG_NAME"

rm -rf "$DMG_TMP"
echo "✅ Berhasil membuat '$DMG_NAME'!"
