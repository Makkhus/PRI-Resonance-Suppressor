#!/bin/bash
# PRI Resonance Suppressor - DMG Installer Creator
# Creates a professional installer DMG for distribution

set -e

VERSION="1.0.0"
PRODUCT_NAME="PRI Resonance Suppressor"
DMG_NAME="PRI-Resonance-Suppressor-${VERSION}-macOS"
BUILD_DIR="build/PRIResonanceSuppressor_artefacts/Release"
STAGING_DIR="build/installer_staging"
DMG_DIR="build/dmg"

echo "🎁 Creating DMG Installer for ${PRODUCT_NAME} v${VERSION}"
echo "================================================================"
echo ""

# Check if plugins are built
if [ ! -d "$BUILD_DIR/AU" ] || [ ! -d "$BUILD_DIR/VST3" ]; then
    echo "❌ Error: Plugins not found. Please build first:"
    echo "   ./build_macos_arm.sh Release universal"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$STAGING_DIR"
rm -rf "$DMG_DIR"
mkdir -p "$STAGING_DIR"
mkdir -p "$DMG_DIR"

# Copy plugins to staging
echo "📦 Copying plugins..."
cp -R "$BUILD_DIR/AU/PRI Resonance Suppressor.component" "$STAGING_DIR/"
cp -R "$BUILD_DIR/VST3/PRI Resonance Suppressor.vst3" "$STAGING_DIR/"

# Sign the plugins
echo "🔐 Signing plugins..."
codesign --force --deep --sign - --options runtime "$STAGING_DIR/PRI Resonance Suppressor.component"
codesign --force --deep --sign - --options runtime "$STAGING_DIR/PRI Resonance Suppressor.vst3"

# Create installer script
echo "📝 Creating installer script..."
cat > "$STAGING_DIR/Install.command" << 'INSTALLER_SCRIPT'
#!/bin/bash
# PRI Resonance Suppressor Installer

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║        PRI RESONANCE SUPPRESSOR - macOS Installer            ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "This installer will copy the plugins to your system."
echo ""
echo "Installation locations:"
echo "  AU:   /Library/Audio/Plug-Ins/Components/"
echo "  VST3: /Library/Audio/Plug-Ins/VST3/"
echo ""
echo "Press ENTER to continue or Ctrl+C to cancel..."
read

echo ""
echo "🔧 Installing plugins..."
echo ""

# Check for sudo
if [ "$EUID" -ne 0 ]; then
    echo "This installer needs administrator privileges."
    echo "You may be prompted for your password."
    echo ""
fi

# Install AU
echo "📦 Installing Audio Unit (AU)..."
sudo rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component" 2>/dev/null || true
sudo cp -R "$SCRIPT_DIR/PRI Resonance Suppressor.component" "/Library/Audio/Plug-Ins/Components/"
sudo xattr -cr "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
sudo codesign --force --deep --sign - --options runtime "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component" 2>/dev/null || true
echo "✅ AU installed"

# Install VST3
echo "📦 Installing VST3..."
sudo rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3" 2>/dev/null || true
sudo cp -R "$SCRIPT_DIR/PRI Resonance Suppressor.vst3" "/Library/Audio/Plug-Ins/VST3/"
sudo xattr -cr "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
sudo codesign --force --deep --sign - --options runtime "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3" 2>/dev/null || true
echo "✅ VST3 installed"

# Clear caches
echo ""
echo "🔄 Clearing Audio Unit cache..."
rm -rf ~/Library/Caches/AudioUnitCache 2>/dev/null || true
killall -9 AudioComponentRegistrar 2>/dev/null || true
killall -9 coreaudiod 2>/dev/null || true

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║                  ✅ INSTALLATION COMPLETE                     ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Restart your DAW"
echo "  2. Rescan plugins if needed"
echo "  3. Look for 'PRI Resonance Suppressor' by PRITEZZA"
echo ""
echo "For Logic Pro:"
echo "  - Open Logic Pro → Preferences → Plug-in Manager"
echo "  - Click 'Reset & Rescan Selection'"
echo ""
echo "The plugin will appear in Audio FX → Dynamics"
echo ""
echo "Press ENTER to close..."
read
INSTALLER_SCRIPT

chmod +x "$STAGING_DIR/Install.command"

# Create uninstaller script
echo "📝 Creating uninstaller script..."
cat > "$STAGING_DIR/Uninstall.command" << 'UNINSTALLER_SCRIPT'
#!/bin/bash
# PRI Resonance Suppressor Uninstaller

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║      PRI RESONANCE SUPPRESSOR - macOS Uninstaller            ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "This will remove PRI Resonance Suppressor from your system."
echo ""
echo "Press ENTER to continue or Ctrl+C to cancel..."
read

echo ""
echo "🗑️  Removing plugins..."
echo ""

# Remove AU
echo "Removing Audio Unit..."
sudo rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
echo "✅ AU removed"

# Remove VST3
echo "Removing VST3..."
sudo rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
echo "✅ VST3 removed"

# Clear caches
echo ""
echo "🔄 Clearing caches..."
rm -rf ~/Library/Caches/AudioUnitCache 2>/dev/null || true
killall -9 AudioComponentRegistrar 2>/dev/null || true

# Ask about settings
echo ""
read -p "Remove settings? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/Library/Application Support/PRITEZZA" 2>/dev/null || true
    echo "✅ Settings removed"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║                ✅ UNINSTALL COMPLETE                          ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Press ENTER to close..."
read
UNINSTALLER_SCRIPT

chmod +x "$STAGING_DIR/Uninstall.command"

# Copy README
echo "📄 Copying documentation..."
cat > "$STAGING_DIR/README.txt" << 'README_TEXT'
═══════════════════════════════════════════════════════════════════
  PRI RESONANCE SUPPRESSOR - macOS Universal Binary
═══════════════════════════════════════════════════════════════════

Version: 1.0.0
Formats: Audio Unit (AU) + VST3
Architecture: Universal (Intel + Apple Silicon)

INSTALLATION
═══════════════════════════════════════════════════════════════════

Double-click "Install.command" and follow the prompts.

The installer will copy the plugins to:
  • /Library/Audio/Plug-Ins/Components/ (Audio Unit)
  • /Library/Audio/Plug-Ins/VST3/

After installation:
  1. Restart your DAW
  2. Rescan plugins if needed
  3. Look for "PRI Resonance Suppressor" by PRITEZZA

For Logic Pro users:
  • Open Logic Pro → Preferences → Plug-in Manager
  • Click "Reset & Rescan Selection"

UNINSTALLATION
═══════════════════════════════════════════════════════════════════

Double-click "Uninstall.command" to remove the plugin.

FEATURES
═══════════════════════════════════════════════════════════════════

✓ Smart resonance detection and suppression
✓ Real-time spectrum analyzer
✓ 14 controllable parameters with automation
✓ Delta Listen mode (solo removed frequencies)
✓ Three visual themes (Vintage, Black, Silver)
✓ Resizable UI (50% - 150%)
✓ Stereo processing modes (Linked, L/R, M/S)
✓ Multiple FFT resolutions (1024/2048/4096)

QUICK START PRESETS
═══════════════════════════════════════════════════════════════════

Vocal De-Essing:
  LOW: 4kHz | HIGH: 10kHz | WIDTH: 1/6 | THRESHOLD: 6dB | DEPTH: 12dB

Acoustic Guitar:
  LOW: 2kHz | HIGH: 8kHz | WIDTH: 1/12 | THRESHOLD: 4dB | DEPTH: 9dB

Overhead Cymbals:
  LOW: 5kHz | HIGH: 15kHz | WIDTH: 1/6 | THRESHOLD: 6dB | DEPTH: 15dB

Mix Polish:
  LOW: 1kHz | HIGH: 16kHz | WIDTH: 1/6 | THRESHOLD: 8dB | DEPTH: 6dB

COMPATIBILITY
═══════════════════════════════════════════════════════════════════

✓ Logic Pro
✓ GarageBand
✓ Ableton Live
✓ FL Studio
✓ Reaper
✓ Pro Tools 2023.6+
✓ Cubase
✓ Studio One

SYSTEM REQUIREMENTS
═══════════════════════════════════════════════════════════════════

• macOS 11 (Big Sur) or later
• Intel Mac or Apple Silicon (M1/M2/M3/M4)
• Compatible DAW with AU or VST3 support

PERFORMANCE
═══════════════════════════════════════════════════════════════════

• CPU Usage: < 1% (audio processing)
• Latency: 23-93ms (automatically compensated)
• Supported Sample Rates: 11 kHz - 192 kHz

LICENSE
═══════════════════════════════════════════════════════════════════

GNU Affero General Public License v3.0 (AGPLv3)
Copyright (C) 2026 PRITEZZA

This is free software: you can redistribute it and/or modify it
under the terms of the AGPLv3. See LICENSE file for details.

LINKS
═══════════════════════════════════════════════════════════════════

GitHub: https://github.com/Makkhus/PRI-Resonance-Suppressor
Original: https://github.com/pritezza/PRIResonanceSuppressor
JUCE Framework: https://juce.com

SUPPORT
═══════════════════════════════════════════════════════════════════

For issues or questions:
  • Open an issue on GitHub
  • Check the documentation in the repository
  • See README_MACOS.md for detailed usage guide

═══════════════════════════════════════════════════════════════════
Made with ❤️ for Apple Silicon
Fully validated by Apple's auval tool
═══════════════════════════════════════════════════════════════════
README_TEXT

# Copy license
if [ -f "LICENSE" ]; then
    cp LICENSE "$STAGING_DIR/LICENSE.txt"
fi

# Create a nice background image placeholder
echo "🎨 Creating installer appearance..."
# Note: A real implementation would create or copy a background image here

# Create the DMG
echo "💿 Creating DMG..."
DMG_TEMP="$DMG_DIR/${DMG_NAME}_temp.dmg"
DMG_FINAL="$DMG_DIR/${DMG_NAME}.dmg"

# Remove old DMGs
rm -f "$DMG_TEMP" "$DMG_FINAL"

# Create temporary DMG
hdiutil create -volname "$PRODUCT_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov -format UDRW \
    "$DMG_TEMP"

# Mount the temporary DMG
echo "📂 Mounting temporary DMG..."
MOUNT_DIR=$(hdiutil attach "$DMG_TEMP" | grep "/Volumes/" | sed 's/.*\/Volumes/\/Volumes/')

# Set up the DMG appearance
if [ -d "$MOUNT_DIR" ]; then
    echo "🎨 Configuring DMG appearance..."
    
    # Create .background folder for custom background (optional)
    # mkdir "$MOUNT_DIR/.background"
    
    # Set icon positions and window properties using AppleScript
    osascript <<EOF
tell application "Finder"
    tell disk "$PRODUCT_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set bounds of container window to {400, 200, 1000, 600}
        
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 72
        set text size of viewOptions to 12
        
        -- Position items
        set position of item "Install.command" to {150, 120}
        set position of item "Uninstall.command" to {450, 120}
        set position of item "README.txt" to {150, 260}
        set position of item "PRI Resonance Suppressor.component" to {300, 260}
        set position of item "PRI Resonance Suppressor.vst3" to {450, 260}
        
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
EOF
fi

# Unmount
echo "📤 Unmounting..."
hdiutil detach "$MOUNT_DIR" -quiet

# Convert to compressed read-only DMG
echo "🗜️  Compressing DMG..."
hdiutil convert "$DMG_TEMP" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$DMG_FINAL"

# Clean up
rm -f "$DMG_TEMP"
rm -rf "$STAGING_DIR"

# Get DMG info
DMG_SIZE=$(du -h "$DMG_FINAL" | cut -f1)

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║               ✅ DMG INSTALLER CREATED                        ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "📦 Installer Details:"
echo "   Name: ${DMG_NAME}.dmg"
echo "   Size: $DMG_SIZE"
echo "   Location: $DMG_FINAL"
echo ""
echo "📋 DMG Contents:"
echo "   • PRI Resonance Suppressor.component (AU)"
echo "   • PRI Resonance Suppressor.vst3 (VST3)"
echo "   • Install.command (installer script)"
echo "   • Uninstall.command (uninstaller script)"
echo "   • README.txt (documentation)"
echo "   • LICENSE.txt (license info)"
echo ""
echo "🎯 Next Steps:"
echo "   1. Test the DMG by mounting it"
echo "   2. Run Install.command to verify installation works"
echo "   3. Share the DMG file for distribution"
echo ""
echo "🌐 Ready for distribution on:"
echo "   • GitHub Releases"
echo "   • Your website"
echo "   • Audio forums"
echo "   • Direct sharing"
echo ""
