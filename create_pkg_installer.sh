#!/bin/bash
# PRI Resonance Suppressor - PKG Installer Creator
# Creates a professional macOS .pkg installer with GUI wizard

set -e

VERSION="1.0.0"
PRODUCT_NAME="PRI Resonance Suppressor"
IDENTIFIER="com.pritezza.PRIResonanceSuppressor"
PKG_NAME="PRI-Resonance-Suppressor-${VERSION}-macOS"
BUILD_DIR="build/PRIResonanceSuppressor_artefacts/Release"
PKG_ROOT="build/pkg_root"
PKG_SCRIPTS="build/pkg_scripts"
PKG_RESOURCES="build/pkg_resources"
PKG_OUTPUT="build/pkg"

echo "📦 Creating PKG Installer for ${PRODUCT_NAME} v${VERSION}"
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
rm -rf "$PKG_ROOT"
rm -rf "$PKG_SCRIPTS"
rm -rf "$PKG_RESOURCES"
rm -rf "$PKG_OUTPUT"

# Create directory structure
mkdir -p "$PKG_ROOT/Library/Audio/Plug-Ins/Components"
mkdir -p "$PKG_ROOT/Library/Audio/Plug-Ins/VST3"
mkdir -p "$PKG_SCRIPTS"
mkdir -p "$PKG_RESOURCES"
mkdir -p "$PKG_OUTPUT"

# Copy plugins to package root
echo "📦 Copying plugins..."
cp -R "$BUILD_DIR/AU/PRI Resonance Suppressor.component" "$PKG_ROOT/Library/Audio/Plug-Ins/Components/"
cp -R "$BUILD_DIR/VST3/PRI Resonance Suppressor.vst3" "$PKG_ROOT/Library/Audio/Plug-Ins/VST3/"

# Sign the plugins
echo "🔐 Signing plugins..."
codesign --force --deep --sign - --options runtime "$PKG_ROOT/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
codesign --force --deep --sign - --options runtime "$PKG_ROOT/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# Set correct permissions
echo "🔒 Setting permissions..."
chmod -R 755 "$PKG_ROOT/Library"
sudo chown -R root:wheel "$PKG_ROOT/Library" 2>/dev/null || chown -R $(whoami):staff "$PKG_ROOT/Library"

# Create postinstall script
echo "📝 Creating postinstall script..."
cat > "$PKG_SCRIPTS/postinstall" << 'POSTINSTALL'
#!/bin/bash
# Post-installation script

# Remove quarantine attributes
xattr -cr "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component" 2>/dev/null || true
xattr -cr "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3" 2>/dev/null || true

# Re-sign plugins
codesign --force --deep --sign - --options runtime "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component" 2>/dev/null || true
codesign --force --deep --sign - --options runtime "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3" 2>/dev/null || true

# Clear AU cache for the user who ran the installer
USER_HOME=$(eval echo ~${SUDO_USER:-$USER})
rm -rf "$USER_HOME/Library/Caches/AudioUnitCache" 2>/dev/null || true
rm -rf "$USER_HOME/Library/Caches/com.apple.audio.ComponentHelper" 2>/dev/null || true

# Kill audio component processes
killall -9 AudioComponentRegistrar 2>/dev/null || true
killall -9 coreaudiod 2>/dev/null || true

echo "PRI Resonance Suppressor installed successfully!"

exit 0
POSTINSTALL

chmod +x "$PKG_SCRIPTS/postinstall"

# Create welcome text
echo "📄 Creating welcome message..."
cat > "$PKG_RESOURCES/welcome.txt" << 'WELCOME'
Welcome to PRI Resonance Suppressor

This installer will install the PRI Resonance Suppressor audio plugin on your Mac.

What will be installed:
• Audio Unit (AU) plugin
• VST3 plugin
• Universal Binary (Apple Silicon + Intel)

Installation location:
• /Library/Audio/Plug-Ins/Components/
• /Library/Audio/Plug-Ins/VST3/

After installation:
1. Restart your DAW
2. Rescan plugins if needed
3. Look for "PRI Resonance Suppressor" by PRITEZZA

The plugin will appear in:
• Logic Pro: Audio FX → Dynamics
• Other DAWs: Effects → Dynamics
WELCOME

# Create readme text
echo "📄 Creating README..."
cat > "$PKG_RESOURCES/readme.txt" << 'README'
PRI RESONANCE SUPPRESSOR
Version 1.0.0
═══════════════════════════════════════════════════════════════════

SYSTEM REQUIREMENTS
───────────────────────────────────────────────────────────────────
• macOS 11 (Big Sur) or later
• Apple Silicon (M1/M2/M3/M4) or Intel Mac
• Compatible DAW with AU or VST3 support

FEATURES
───────────────────────────────────────────────────────────────────
✓ Smart resonance detection and suppression
✓ Real-time spectrum analyzer
✓ 14 controllable parameters with automation
✓ Delta Listen mode (solo removed frequencies)
✓ Three visual themes (Vintage, Black, Silver)
✓ Resizable UI (50% - 150%)
✓ Stereo processing modes (Linked, L/R, M/S)

QUICK START PRESETS
───────────────────────────────────────────────────────────────────
Vocal De-Essing:
  LOW: 4kHz | HIGH: 10kHz | WIDTH: 1/6 | THRESHOLD: 6dB | DEPTH: 12dB

Acoustic Guitar:
  LOW: 2kHz | HIGH: 8kHz | WIDTH: 1/12 | THRESHOLD: 4dB | DEPTH: 9dB

Overhead Cymbals:
  LOW: 5kHz | HIGH: 15kHz | WIDTH: 1/6 | THRESHOLD: 6dB | DEPTH: 15dB

Mix Polish:
  LOW: 1kHz | HIGH: 16kHz | WIDTH: 1/6 | THRESHOLD: 8dB | DEPTH: 6dB

DAW COMPATIBILITY
───────────────────────────────────────────────────────────────────
✓ Logic Pro (AU)
✓ GarageBand (AU)
✓ Ableton Live (VST3/AU)
✓ FL Studio (VST3/AU)
✓ Reaper (VST3/AU)
✓ Pro Tools 2023.6+ (VST3/AU)
✓ Cubase (VST3)
✓ Studio One (VST3/AU)

PERFORMANCE
───────────────────────────────────────────────────────────────────
• CPU Usage: < 1% (audio processing)
• Latency: 23-93ms (automatically compensated)
• Supported Sample Rates: 11 kHz - 192 kHz

UNINSTALLATION
───────────────────────────────────────────────────────────────────
To uninstall:
1. Delete: /Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component
2. Delete: /Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3
3. Optional: Delete settings in ~/Library/Application Support/PRITEZZA

SUPPORT
───────────────────────────────────────────────────────────────────
GitHub: https://github.com/Makkhus/PRI-Resonance-Suppressor
Original: https://github.com/pritezza/PRIResonanceSuppressor

LICENSE
───────────────────────────────────────────────────────────────────
GNU Affero General Public License v3.0 (AGPLv3)
Copyright (C) 2026 PRITEZZA

This is free software. See LICENSE for details.
README

# Create license text
if [ -f "LICENSE" ]; then
    cp LICENSE "$PKG_RESOURCES/license.txt"
fi

# Create conclusion text
cat > "$PKG_RESOURCES/conclusion.txt" << 'CONCLUSION'
Installation Complete!

PRI Resonance Suppressor has been successfully installed.

Next steps:
1. Restart your DAW
2. Rescan plugins if needed
3. Look for "PRI Resonance Suppressor" by PRITEZZA

For Logic Pro users:
• Open Logic Pro → Preferences → Plug-in Manager
• Click "Reset & Rescan Selection"

The plugin will appear in:
• Logic Pro: Audio FX → Dynamics
• Other DAWs: Effects → Dynamics

Enjoy your new resonance suppressor!
CONCLUSION

# Build the component package
echo "🔨 Building component package..."
pkgbuild --root "$PKG_ROOT" \
    --identifier "$IDENTIFIER" \
    --version "$VERSION" \
    --scripts "$PKG_SCRIPTS" \
    --install-location "/" \
    "$PKG_OUTPUT/component.pkg"

# Create Distribution XML
echo "📝 Creating distribution definition..."
cat > "$PKG_OUTPUT/distribution.xml" << DISTRIBUTION
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="1">
    <title>${PRODUCT_NAME}</title>
    <organization>com.pritezza</organization>
    <domains enable_localSystem="true"/>
    <options customize="never" require-scripts="true" rootVolumeOnly="true" />
    
    <!-- Define documents displayed at various steps -->
    <welcome file="welcome.txt" mime-type="text/plain" />
    <readme file="readme.txt" mime-type="text/plain" />
    <license file="license.txt" mime-type="text/plain" />
    <conclusion file="conclusion.txt" mime-type="text/plain" />
    
    <!-- List all component packages -->
    <pkg-ref id="$IDENTIFIER"/>
    
    <!-- Define the order of installation -->
    <options customize="never" require-scripts="false"/>
    <choices-outline>
        <line choice="default">
            <line choice="$IDENTIFIER"/>
        </line>
    </choices-outline>
    
    <choice id="default"/>
    <choice id="$IDENTIFIER" visible="false">
        <pkg-ref id="$IDENTIFIER"/>
    </choice>
    
    <pkg-ref id="$IDENTIFIER" version="$VERSION" onConclusion="none">component.pkg</pkg-ref>
    
    <!-- System requirements -->
    <domains enable_anywhere="false" enable_currentUserHome="false" enable_localSystem="true"/>
    
    <installation-check script="pm_install_check();"/>
    <script>
    <![CDATA[
    function pm_install_check() {
        if (!(system.compareVersions(system.version.ProductVersion, '11.0') >= 0)) {
            my.result.title = 'Unable to install';
            my.result.message = 'This software requires macOS 11 (Big Sur) or later.';
            my.result.type = 'Fatal';
            return false;
        }
        return true;
    }
    ]]>
    </script>
</installer-gui-script>
DISTRIBUTION

# Build the product package with GUI
echo "🎁 Building final installer package..."
productbuild --distribution "$PKG_OUTPUT/distribution.xml" \
    --resources "$PKG_RESOURCES" \
    --package-path "$PKG_OUTPUT" \
    --version "$VERSION" \
    "$PKG_OUTPUT/${PKG_NAME}.pkg"

# Clean up intermediate files
echo "🧹 Cleaning up..."
rm -f "$PKG_OUTPUT/component.pkg"
rm -f "$PKG_OUTPUT/distribution.xml"

# Get package info
PKG_SIZE=$(du -h "$PKG_OUTPUT/${PKG_NAME}.pkg" | cut -f1)
PKG_PATH="$PKG_OUTPUT/${PKG_NAME}.pkg"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                                                               ║"
echo "║              ✅ PKG INSTALLER CREATED                         ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "📦 Installer Details:"
echo "   Name: ${PKG_NAME}.pkg"
echo "   Size: $PKG_SIZE"
echo "   Location: $PKG_PATH"
echo ""
echo "📋 Installation includes:"
echo "   • Audio Unit (AU) - /Library/Audio/Plug-Ins/Components/"
echo "   • VST3 - /Library/Audio/Plug-Ins/VST3/"
echo "   • Universal Binary (Intel + Apple Silicon)"
echo "   • Automatic cache clearing"
echo "   • Code signing"
echo ""
echo "🎯 Next Steps:"
echo "   1. Test the installer by double-clicking it"
echo "   2. Follow the installation wizard"
echo "   3. Verify installation in Logic Pro or other DAW"
echo "   4. Share the .pkg file for distribution"
echo ""
echo "🌐 Ready for distribution on:"
echo "   • GitHub Releases"
echo "   • Your website"
echo "   • Mac App Store (with proper signing)"
echo "   • Audio software platforms"
echo ""
echo "💡 To sign with Developer ID (for distribution):"
echo "   productsign --sign \"Developer ID Installer: Your Name\" \\"
echo "     \"$PKG_PATH\" \\"
echo "     \"$PKG_OUTPUT/${PKG_NAME}-signed.pkg\""
echo ""
