#!/bin/bash

# Configuration
APP_NAME="ZshrcManager"
BUNDLE_ID="com.xingyc.zshrc-manager"
DIST_DIR="dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
DMG_NAME="$DIST_DIR/$APP_NAME.dmg"

echo "🚀 Starting packaging process..."

# 1. Clean and build
echo "🔨 Building release binary..."
swift build -c release

# 2. Setup Directory Structure
echo "📁 Creating .app bundle structure..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# 3. Copy Binary
echo "📄 Copying executable..."
cp ".build/release/$APP_NAME" "$APP_BUNDLE/Contents/MacOS/"

# 4. Copy Info.plist
echo "📄 Copying Info.plist..."
if [ -f "Resources/Info.plist" ]; then
    cp "Resources/Info.plist" "$APP_BUNDLE/Contents/"
else
    echo "⚠️ Info.plist not found, using default fallback..."
    cat <<EOF > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon.icns</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
</dict>
</plist>
EOF
fi

# 4.5 Copy Icon
echo "🖼️ Copying app icon..."
if [ -f "Resources/AppIcon.icns" ]; then
    cp "Resources/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/"
else
    echo "⚠️ AppIcon.icns not found! Generating now..."
    chmod +x scripts/generate_icons.sh
    ./scripts/generate_icons.sh
    cp "Resources/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/"
fi

# 5. Build DMG
echo "📦 Generating DMG installer..."
rm -f "$DMG_NAME"
hdiutil create -volname "$APP_NAME" -srcfolder "$APP_BUNDLE" -ov -format UDZO "$DMG_NAME"

echo "✅ Packaging complete!"
echo "📍 Location: $DMG_NAME"
