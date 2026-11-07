#!/bin/bash
# Build script for PRI Resonance Suppressor on macOS ARM (Apple Silicon)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== PRI Resonance Suppressor Build Script for macOS ARM ===${NC}"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This script is for macOS only${NC}"
    echo "Current OS: $OSTYPE"
    exit 1
fi

# Check if we're on Apple Silicon
ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo -e "${YELLOW}Warning: Running on $ARCH, not arm64${NC}"
    echo "This script is optimized for Apple Silicon but will attempt to build anyway"
fi

# Check for required tools
echo -e "${GREEN}Checking dependencies...${NC}"

if ! command -v cmake &> /dev/null; then
    echo -e "${RED}CMake not found. Please install it:${NC}"
    echo "  brew install cmake"
    exit 1
fi

if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}Xcode not found. Please install Xcode Command Line Tools:${NC}"
    echo "  xcode-select --install"
    exit 1
fi

echo -e "${GREEN}✓ Dependencies OK${NC}"

# Clone JUCE if not present
if [ ! -d "external/JUCE" ]; then
    echo -e "${GREEN}Cloning JUCE framework...${NC}"
    mkdir -p external
    git clone --depth 1 --branch 8.0.16-security https://github.com/juce-framework/JUCE.git external/JUCE
    echo -e "${GREEN}✓ JUCE cloned${NC}"
else
    echo -e "${GREEN}✓ JUCE already present${NC}"
fi

# Configure build
echo -e "${GREEN}Configuring build for ARM64...${NC}"

BUILD_TYPE=${1:-Release}
UNIVERSAL=${2:-no}

if [[ "$UNIVERSAL" == "universal" ]]; then
    echo -e "${YELLOW}Building universal binary (Intel + ARM)${NC}"
    cmake -S . -B build \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
        -DPRI_ENABLE_LTO=ON
else
    echo -e "${YELLOW}Building for ARM64 only${NC}"
    cmake -S . -B build \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_OSX_ARCHITECTURES=arm64 \
        -DPRI_ENABLE_LTO=ON
fi

# Build
echo -e "${GREEN}Building plugin...${NC}"
cmake --build build --config $BUILD_TYPE -j$(sysctl -n hw.ncpu)

echo -e "${GREEN}✓ Build complete!${NC}"
echo ""

# Display output locations
echo -e "${GREEN}=== Build Output ===${NC}"
AU_PATH="build/PRIResonanceSuppressor_artefacts/$BUILD_TYPE/AU/PRI Resonance Suppressor.component"
VST3_PATH="build/PRIResonanceSuppressor_artefacts/$BUILD_TYPE/VST3/PRI Resonance Suppressor.vst3"

if [ -d "$AU_PATH" ]; then
    echo -e "${GREEN}✓ AU Plugin:${NC} $AU_PATH"
else
    echo -e "${YELLOW}⚠ AU Plugin not found${NC}"
fi

if [ -d "$VST3_PATH" ]; then
    echo -e "${GREEN}✓ VST3 Plugin:${NC} $VST3_PATH"
else
    echo -e "${YELLOW}⚠ VST3 Plugin not found${NC}"
fi

echo ""
echo -e "${GREEN}=== Installation ===${NC}"
echo "To install the plugins, run:"
echo ""
echo "  # Install AU (system-wide, requires sudo):"
echo "  sudo cp -r \"$AU_PATH\" \"/Library/Audio/Plug-Ins/Components/\""
echo ""
echo "  # Install AU (user only):"
echo "  cp -r \"$AU_PATH\" \"~/Library/Audio/Plug-Ins/Components/\""
echo ""
echo "  # Install VST3 (system-wide, requires sudo):"
echo "  sudo cp -r \"$VST3_PATH\" \"/Library/Audio/Plug-Ins/VST3/\""
echo ""
echo "  # Install VST3 (user only):"
echo "  cp -r \"$VST3_PATH\" \"~/Library/Audio/Plug-Ins/VST3/\""
echo ""
echo -e "${GREEN}Or run the install script:${NC}"
echo "  sudo ./install_macos.sh"
