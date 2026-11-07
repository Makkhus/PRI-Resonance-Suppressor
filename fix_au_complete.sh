#!/bin/bash
# Complete AU Fix and Installation Script

set -e

echo "🔧 Complete AU Fix and Installation"
echo "===================================="
echo ""

AU_BUILD="build/PRIResonanceSuppressor_artefacts/Release/AU/PRI Resonance Suppressor.component"
AU_SYSTEM="/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
AU_USER="$HOME/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"

# Step 1: Remove quarantine from build
echo "Step 1: Removing quarantine attributes from build..."
xattr -cr "$AU_BUILD" 2>/dev/null || true

# Step 2: Fix permissions
echo "Step 2: Fixing permissions..."
chmod -R 755 "$AU_BUILD"

# Step 3: Re-sign with proper entitlements
echo "Step 3: Code signing AU component..."
codesign --force --deep --sign - --options runtime "$AU_BUILD"

# Step 4: Remove ALL old installations
echo "Step 4: Removing old installations..."
sudo rm -rf "$AU_SYSTEM" 2>/dev/null || true
rm -rf "$AU_USER" 2>/dev/null || true

# Step 5: Clear ALL AU caches
echo "Step 5: Clearing AU caches..."
rm -rf ~/Library/Caches/AudioUnitCache 2>/dev/null || true
rm -rf ~/Library/Caches/com.apple.audio.ComponentHelper 2>/dev/null || true
rm -rf ~/Library/Preferences/com.apple.audio.AudioMIDISetup.plist 2>/dev/null || true
sudo rm -rf /Library/Caches/com.apple.audio* 2>/dev/null || true

# Step 6: Install to SYSTEM location (required for proper AU registration)
echo "Step 6: Installing to system location..."
sudo cp -R "$AU_BUILD" "$AU_SYSTEM"
sudo chown -R root:wheel "$AU_SYSTEM"
sudo chmod -R 755 "$AU_SYSTEM"

# Step 7: Remove quarantine from installed version
echo "Step 7: Removing quarantine from installed plugin..."
sudo xattr -cr "$AU_SYSTEM"

# Step 8: Re-sign installed version
echo "Step 8: Code signing installed plugin..."
sudo codesign --force --deep --sign - --options runtime "$AU_SYSTEM"

# Step 9: Force AU cache rebuild
echo "Step 9: Rebuilding AU cache..."
killall -9 AudioComponentRegistrar 2>/dev/null || true
killall -9 coreaudiod 2>/dev/null || true

# Give system time to rebuild cache
echo "Waiting for system to rebuild AU cache..."
sleep 3

# Step 10: Register with pluginkit (macOS 10.15+)
echo "Step 10: Registering with pluginkit..."
pluginkit -a "$AU_SYSTEM" 2>/dev/null || true
pluginkit -m -v -p com.apple.audio.units-au 2>/dev/null | grep -i resonance || echo "Not yet in pluginkit cache"

# Step 11: Force scan
echo "Step 11: Running validation..."
auval -v aufx Rsup Prtz

echo ""
echo "✅ AU Fix Complete!"
echo ""
echo "If validation still fails:"
echo "1. Restart your Mac (sometimes required for AU registration)"
echo "2. Open Logic Pro → Preferences → Plug-in Manager"
echo "3. Click 'Reset & Rescan Selection'"
echo ""
