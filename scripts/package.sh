#!/bin/bash

# Configuration
APP_NAME="ZshrcManager"
if [ "$DEBUG" = "1" ]; then
    APP_NAME="ZshrcManager-Debug"
    BUILD_CONFIG="debug"
    SWIFT_BUILD_FLAGS=""
else
    BUILD_CONFIG="release"
    SWIFT_BUILD_FLAGS="-c release"
fi

BUNDLE_ID="com.xingyc.zshrc-manager"
DIST_DIR="dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
DMG_NAME="$DIST_DIR/$APP_NAME.dmg"

echo "🚀 Starting packaging process ($BUILD_CONFIG)..."

# 1. Clean and build
echo "🔨 Building binary ($BUILD_CONFIG, Universal)..."
swift build $SWIFT_BUILD_FLAGS --arch arm64 --arch x86_64

# 2. Setup Directory Structure
echo "📁 Creating .app bundle structure..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# 3. Copy Binary
echo "📄 Copying universal executable..."
# The destination executable name must match the CFBundleExecutable in Info.plist
# Actually we change it to APP_NAME which is ZshrcManager-Debug in debug mode
BIN_SOURCE=".build/apple/Products/$(echo $BUILD_CONFIG | sed 's/./\U&/')/ZshrcManager"
# Fallback for lowercase folder names or different SPM structures
if [ ! -f "$BIN_SOURCE" ]; then
    BIN_SOURCE=".build/apple/Products/$BUILD_CONFIG/ZshrcManager"
fi

if [ ! -f "$BIN_SOURCE" ]; then
    echo "❌ Error: Could not find binary at $BIN_SOURCE"
    exit 1
fi

cp "$BIN_SOURCE" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
codesign -s - "$APP_BUNDLE/Contents/MacOS/$APP_NAME" || true

# 4. Handle Info.plist
echo "📄 Copying Info.plist..."
TEMPLATE_PLIST="Resources/Info.plist"
DEST_PLIST="$APP_BUNDLE/Contents/Info.plist"

if [ -f "$TEMPLATE_PLIST" ]; then
    cp "$TEMPLATE_PLIST" "$DEST_PLIST"
    # Update CFBundleExecutable in the plist if in debug mode
    if [ "$DEBUG" = "1" ]; then
        /usr/libexec/PlistBuddy -c "Set :CFBundleExecutable $APP_NAME" "$DEST_PLIST"
        /usr/libexec/PlistBuddy -c "Set :CFBundleName $APP_NAME" "$DEST_PLIST"
    fi
else
    echo "⚠️ Info.plist not found, using default fallback..."
    cat <<EOF > "$DEST_PLIST"
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
    <string>12.0</string>
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
    
# 4.6 Copy Scripts
echo "📜 Copying scripts to Resources..."
mkdir -p "$APP_BUNDLE/Contents/Resources/scripts"
cp scripts/*.sh "$APP_BUNDLE/Contents/Resources/scripts/"
chmod +x "$APP_BUNDLE/Contents/Resources/scripts/"*.sh

echo "🖼️ Copying UI resources..."
if [ -d "Sources/ZshrcManager/Resources" ]; then
    cp -R "Sources/ZshrcManager/Resources/"* "$APP_BUNDLE/Contents/Resources/" || true
fi

# 5. Build Styled DMG
echo "📦 Generating styled DMG installer..."
# Detach any existing mounts to avoid conflicts
hdiutil detach "/Volumes/$APP_NAME" -force 2>/dev/null || true
rm -f "$DMG_NAME"

STAGING_DIR="$DIST_DIR/dmg_staging"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Copy App
cp -R "$APP_BUNDLE" "$STAGING_DIR/"

# Create Applications symlink
ln -s /Applications "$STAGING_DIR/Applications"

# Add background image
mkdir "$STAGING_DIR/.background"
BG_FILENAME="bg_$(date +%s).png"
cp "Resources/dmg-background.png" "$STAGING_DIR/.background/$BG_FILENAME"

# Create a temporary read-write DMG
TEMP_DMG="$DIST_DIR/temp.dmg"
rm -f "$TEMP_DMG"
hdiutil create -srcfolder "$STAGING_DIR" -volname "$APP_NAME" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW "$TEMP_DMG"

# Mount DMG
echo "📍 Mounting temporary DMG for styling..."
DEVICE=$(hdiutil attach -readwrite -noverify "$TEMP_DMG" | egrep '^/dev/' | sed 1q | awk '{print $1}')
sleep 5

# Apply Styling via AppleScript
echo "🎨 Applying custom styles and positioning..."
osascript <<EOF
tell application "Finder"
    tell disk "$APP_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 900, 900}
        set theViewOptions to icon view options of container window
        set icon size of theViewOptions to 160
        set background picture of theViewOptions to file ".background:$BG_FILENAME"
        set arrangement of theViewOptions to not arranged
        set position of item "$APP_NAME.app" to {220, 610}
        set position of item "Applications" to {580, 610}
        update without registering applications
        delay 2
        close
    end tell
end tell
EOF

# Finalize DMG
echo "🔒 Finalizing and compressing DMG..."
sync
# Try to detach multiple times if busy
for i in {1..5}; do
    hdiutil detach "$DEVICE" -force && break
    echo "⚠️ Disk busy, retrying in 2 seconds..."
    sleep 2
done

hdiutil convert "$TEMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$DMG_NAME"
rm -f "$TEMP_DMG"
rm -rf "$STAGING_DIR"

echo "✅ Styled DMG packaging complete!"
echo "📍 Location: $DMG_NAME"
