#!/bin/bash
# AU Debug and Fix Script

echo "🔍 Diagnosing Audio Unit Issues..."
echo ""

AU_BUILD="build/PRIResonanceSuppressor_artefacts/Release/AU/PRI Resonance Suppressor.component"

# 1. Check Info.plist
echo "1. Checking Info.plist AudioComponents..."
echo "=========================================="
plutil -p "$AU_BUILD/Contents/Info.plist" | grep -A 20 "AudioComponents"
echo ""

# 2. Check if it's in proper location
echo "2. Checking installed location..."
echo "=========================================="
if [ -d "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component" ]; then
    echo "✅ Found in system location"
    ls -la "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
else
    echo "❌ Not found in system location"
fi
echo ""

# 3. Check for quarantine
echo "3. Checking quarantine attributes..."
echo "=========================================="
xattr -l "$AU_BUILD"
echo ""

# 4. Check permissions
echo "4. Checking permissions..."
echo "=========================================="
ls -la "$AU_BUILD/Contents/MacOS/"
echo ""

# 5. Validate signature
echo "5. Checking code signature..."
echo "=========================================="
codesign -dvv "$AU_BUILD" 2>&1 | head -20
echo ""

# 6. Check if binary is loadable
echo "6. Checking if binary is loadable..."
echo "=========================================="
file "$AU_BUILD/Contents/MacOS/PRI Resonance Suppressor"
echo ""

# 7. Check for AU registration
echo "7. Checking AU registration cache..."
echo "=========================================="
pluginkit -m -v -p com.apple.audio.units-au 2>/dev/null | grep -i "resonance" || echo "Not found in pluginkit cache"
echo ""

# 8. Try direct validation
echo "8. Running auval validation..."
echo "=========================================="
auval -v aufx Rsup Prtz
