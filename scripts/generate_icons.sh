#!/bin/bash

# Configuration
MASTER_PNG="Resources/AppIcon.png"
ICONSET_DIR="Resources/AppIcon.iconset"
ICNS_FILE="Resources/AppIcon.icns"

echo "🎨 Creating macOS icon variations from $MASTER_PNG..."

# Ensure iconset directory exists
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

# Explicitly use PNG format to avoid sips warnings
# format: icon_<size>x<size>[@2x].png

# 16x16
sips -z 16 16     "$MASTER_PNG" --out "$ICONSET_DIR/icon_16x16.png" -s format png > /dev/null
sips -z 32 32     "$MASTER_PNG" --out "$ICONSET_DIR/icon_16x16@2x.png" -s format png > /dev/null

# 32x32
sips -z 32 32     "$MASTER_PNG" --out "$ICONSET_DIR/icon_32x32.png" -s format png > /dev/null
sips -z 64 64     "$MASTER_PNG" --out "$ICONSET_DIR/icon_32x32@2x.png" -s format png > /dev/null

# 128x128
sips -z 128 128   "$MASTER_PNG" --out "$ICONSET_DIR/icon_128x128.png" -s format png > /dev/null
sips -z 256 256   "$MASTER_PNG" --out "$ICONSET_DIR/icon_128x128@2x.png" -s format png > /dev/null

# 256x256
sips -z 256 256   "$MASTER_PNG" --out "$ICONSET_DIR/icon_256x256.png" -s format png > /dev/null
sips -z 512 512   "$MASTER_PNG" --out "$ICONSET_DIR/icon_256x256@2x.png" -s format png > /dev/null

# 512x512
sips -z 512 512   "$MASTER_PNG" --out "$ICONSET_DIR/icon_512x512.png" -s format png > /dev/null
sips -z 1024 1024 "$MASTER_PNG" --out "$ICONSET_DIR/icon_512x512@2x.png" -s format png > /dev/null

echo "✨ Converting iconset to .icns format..."
iconutil -c icns "$ICONSET_DIR" -o "$ICNS_FILE"

if [ -f "$ICNS_FILE" ]; then
    echo "✅ AppIcon.icns successfully generated!"
    # Clean up
    rm -rf "$ICONSET_DIR"
else
    echo "❌ Failed to generate .icns file."
    exit 1
fi
