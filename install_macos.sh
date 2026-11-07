#!/bin/bash
# Installation script for PRI Resonance Suppressor on macOS

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== PRI Resonance Suppressor Installer ===${NC}"

BUILD_TYPE=${1:-Release}

AU_SRC="build/PRIResonanceSuppressor_artefacts/$BUILD_TYPE/AU/PRI Resonance Suppressor.component"
VST3_SRC="build/PRIResonanceSuppressor_artefacts/$BUILD_TYPE/VST3/PRI Resonance Suppressor.vst3"

# Check if plugins exist
if [ ! -d "$AU_SRC" ] && [ ! -d "$VST3_SRC" ]; then
    echo -e "${RED}Error: Plugins not found. Please build first:${NC}"
    echo "  ./build_macos_arm.sh"
    exit 1
fi

# Prompt for installation type
echo ""
echo "Choose installation type:"
echo "  1) System-wide (requires sudo, all users)"
echo "  2) Current user only"
echo ""
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        INSTALL_TYPE="system"
        AU_DEST="/Library/Audio/Plug-Ins/Components"
        VST3_DEST="/Library/Audio/Plug-Ins/VST3"
        ;;
    2)
        INSTALL_TYPE="user"
        AU_DEST="$HOME/Library/Audio/Plug-Ins/Components"
        VST3_DEST="$HOME/Library/Audio/Plug-Ins/VST3"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Installing plugins ($INSTALL_TYPE)...${NC}"

# Create directories if needed
if [ "$INSTALL_TYPE" == "user" ]; then
    mkdir -p "$AU_DEST"
    mkdir -p "$VST3_DEST"
fi

# Install AU
if [ -d "$AU_SRC" ]; then
    echo -e "${YELLOW}Installing AU plugin...${NC}"
    
    if [ "$INSTALL_TYPE" == "system" ]; then
        sudo cp -r "$AU_SRC" "$AU_DEST/"
        sudo xattr -cr "$AU_DEST/PRI Resonance Suppressor.component"
    else
        cp -r "$AU_SRC" "$AU_DEST/"
        xattr -cr "$AU_DEST/PRI Resonance Suppressor.component"
    fi
    
    echo -e "${GREEN}✓ AU installed: $AU_DEST/PRI Resonance Suppressor.component${NC}"
fi

# Install VST3
if [ -d "$VST3_SRC" ]; then
    echo -e "${YELLOW}Installing VST3 plugin...${NC}"
    
    if [ "$INSTALL_TYPE" == "system" ]; then
        sudo cp -r "$VST3_SRC" "$VST3_DEST/"
        sudo xattr -cr "$VST3_DEST/PRI Resonance Suppressor.vst3"
    else
        cp -r "$VST3_SRC" "$VST3_DEST/"
        xattr -cr "$VST3_DEST/PRI Resonance Suppressor.vst3"
    fi
    
    echo -e "${GREEN}✓ VST3 installed: $VST3_DEST/PRI Resonance Suppressor.vst3${NC}"
fi

echo ""
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your DAW if it's currently running"
echo "  2. Rescan plugins in your DAW"
echo "  3. Look for 'PRI Resonance Suppressor' by PRITEZZA"
echo ""
echo -e "${YELLOW}Note: If your DAW doesn't see the plugin, you may need to:${NC}"
echo "  - Check your DAW's plugin scan settings"
echo "  - Make sure it scans the correct plugin directories"
echo "  - Run a manual plugin scan/rescan"
