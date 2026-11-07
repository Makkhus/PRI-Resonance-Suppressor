#!/bin/bash
# Complete build and packaging script for PRI Resonance Suppressor
# This script builds the plugin as a universal binary and creates a PKG installer

set -e  # Exit on error

echo "========================================"
echo "PRI Resonance Suppressor Build & Package"
echo "========================================"

# Configuration
BUILD_TYPE="Release"
PLUGIN_NAME="PRIResonanceSuppressor"
VERSION="1.0.0"
BUILD_DIR="build"
PKG_DIR="${BUILD_DIR}/pkg"
PKG_ROOT="${PKG_DIR}/root"
AU_INSTALL_DIR="/Library/Audio/Plug-Ins/Components"
VST3_INSTALL_DIR="/Library/Audio/Plug-Ins/VST3"

# Clean previous build
echo ""
echo "Cleaning previous build..."
# Change permissions to allow deletion if previous build exists
if [ -d "${BUILD_DIR}" ]; then
    echo "Removing old build directory (may require sudo for signed files)..."
    find "${BUILD_DIR}" -type d -exec chmod u+rwx {} + 2>/dev/null || true
    find "${BUILD_DIR}" -type f -exec chmod u+rw {} + 2>/dev/null || true
    rm -rf "${BUILD_DIR}" 2>/dev/null || {
        echo "Warning: Could not remove build directory with normal permissions."
        echo "Please run: sudo rm -rf ${BUILD_DIR}"
        echo "Then run this script again."
        exit 1
    }
fi
mkdir -p "${BUILD_DIR}"

# Configure with CMake for universal binary
echo ""
echo "Configuring CMake for universal binary (Intel + Apple Silicon)..."
cmake -B "${BUILD_DIR}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    -DPRI_ENABLE_LTO=ON

# Build the plugin
echo ""
echo "Building ${PLUGIN_NAME}..."
cmake --build "${BUILD_DIR}" --config "${BUILD_TYPE}" --parallel

# Verify the builds exist
# Note: The actual plugin name has spaces: "PRI Resonance Suppressor"
AU_BUNDLE="${BUILD_DIR}/${PLUGIN_NAME}_artefacts/${BUILD_TYPE}/AU/PRI Resonance Suppressor.component"
VST3_BUNDLE="${BUILD_DIR}/${PLUGIN_NAME}_artefacts/${BUILD_TYPE}/VST3/PRI Resonance Suppressor.vst3"

if [ ! -d "${AU_BUNDLE}" ]; then
    echo "ERROR: AU component not found at ${AU_BUNDLE}"
    exit 1
fi

if [ ! -d "${VST3_BUNDLE}" ]; then
    echo "ERROR: VST3 plugin not found at ${VST3_BUNDLE}"
    exit 1
fi

# Verify architectures
echo ""
echo "Verifying universal binary architectures..."
AU_BINARY="${AU_BUNDLE}/Contents/MacOS/PRI Resonance Suppressor"
VST3_BINARY="${VST3_BUNDLE}/Contents/MacOS/PRI Resonance Suppressor"

echo "AU architectures:"
lipo -info "${AU_BINARY}"

echo "VST3 architectures:"
lipo -info "${VST3_BINARY}"

# Code sign the components (ad-hoc signing for local development)
echo ""
echo "Code signing AU component..."
codesign --force --deep --sign - "${AU_BUNDLE}"

echo "Code signing VST3 plugin..."
codesign --force --deep --sign - "${VST3_BUNDLE}"

# Verify code signatures
echo ""
echo "Verifying code signatures..."
codesign --verify --verbose "${AU_BUNDLE}"
codesign --verify --verbose "${VST3_BUNDLE}"

# Test AU validation
echo ""
echo "Testing AU validation..."
echo "Running: auval -v aufx Rsup Prtz"
if auval -v aufx Rsup Prtz; then
    echo "✓ AU validation PASSED"
else
    echo "✗ AU validation FAILED"
    exit 1
fi

# Create PKG installer structure
echo ""
echo "Creating PKG installer structure..."
mkdir -p "${PKG_ROOT}${AU_INSTALL_DIR}"
mkdir -p "${PKG_ROOT}${VST3_INSTALL_DIR}"

# Copy signed components to PKG root
cp -R "${AU_BUNDLE}" "${PKG_ROOT}${AU_INSTALL_DIR}/"
cp -R "${VST3_BUNDLE}" "${PKG_ROOT}${VST3_INSTALL_DIR}/"

# Create the PKG installer
PKG_OUTPUT="${PKG_DIR}/PRI-Resonance-Suppressor-${VERSION}-macOS.pkg"

echo ""
echo "Building PKG installer..."
pkgbuild \
    --root "${PKG_ROOT}" \
    --identifier "com.pritezza.PRIResonanceSuppressor.pkg" \
    --version "${VERSION}" \
    --install-location "/" \
    "${PKG_OUTPUT}"

# Verify PKG was created
if [ -f "${PKG_OUTPUT}" ]; then
    echo ""
    echo "========================================"
    echo "✓ BUILD AND PACKAGING SUCCESSFUL"
    echo "========================================"
    echo ""
    echo "PKG installer created at:"
    echo "  ${PKG_OUTPUT}"
    echo ""
    echo "File size:"
    ls -lh "${PKG_OUTPUT}" | awk '{print "  " $5}'
    echo ""
    echo "To verify the PKG contents:"
    echo "  pkgutil --payload-files ${PKG_OUTPUT}"
    echo ""
    echo "To install for testing:"
    echo "  sudo installer -pkg ${PKG_OUTPUT} -target /"
    echo ""
else
    echo "ERROR: PKG file was not created"
    exit 1
fi
