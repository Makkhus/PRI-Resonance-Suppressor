# Building PRI Resonance Suppressor

## Prerequisites

- macOS 10.15 or later
- Xcode Command Line Tools
- CMake 3.22 or later

## Quick Start

1. **Clone JUCE framework:**
   ```bash
   git clone --depth 1 --branch 7.0.5 https://github.com/juce-framework/JUCE.git external/JUCE
   ```

2. **Build and create PKG installer:**
   ```bash
   ./build_and_package.sh
   ```

   This script will:
   - Build universal binary (Intel + Apple Silicon)
   - Code sign both AU and VST3 components
   - Validate the AU component
   - Create PKG installer at `build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg`

3. **Test the installer:**
   ```bash
   sudo installer -pkg build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg -target /
   ```

4. **Verify AU validation:**
   ```bash
   auval -v aufx Rsup Prtz
   ```

## Manual Build

If you prefer to build manually:

```bash
# Configure
cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"

# Build
cmake --build build --config Release --parallel

# Sign AU component (IMPORTANT!)
codesign --force --deep --sign - "build/PRIResonanceSuppressor_artefacts/Release/AU/PRIResonanceSuppressor.component"

# Sign VST3 plugin
codesign --force --deep --sign - "build/PRIResonanceSuppressor_artefacts/Release/VST3/PRIResonanceSuppressor.vst3"

# Validate
auval -v aufx Rsup Prtz
```

## Troubleshooting

### AU Validation Fails

If `auval` reports errors like "Cannot get Component's Name strings":

1. **Ensure the AU component is properly signed:**
   ```bash
   codesign --force --deep --sign - "build/PRIResonanceSuppressor_artefacts/Release/AU/PRIResonanceSuppressor.component"
   ```

2. **Verify the signature:**
   ```bash
   codesign --verify --verbose "build/PRIResonanceSuppressor_artefacts/Release/AU/PRIResonanceSuppressor.component"
   ```

3. **Check if the AU is installed:**
   ```bash
   ls -la "/Library/Audio/Plug-Ins/Components/PRIResonanceSuppressor.component"
   ```

### PKG Contains Unsigned Components

The `build_and_package.sh` script ensures all components are properly signed **before** packaging. If you previously created a PKG manually, rebuild using the script:

```bash
rm -rf build
./build_and_package.sh
```

## Plugin Identifiers

- **Manufacturer Code:** `Prtz`
- **Plugin Code:** `Rsup`
- **Bundle ID:** `com.pritezza.PRIResonanceSuppressor`

## Installation Paths

- **AU:** `/Library/Audio/Plug-Ins/Components/PRIResonanceSuppressor.component`
- **VST3:** `/Library/Audio/Plug-Ins/VST3/PRIResonanceSuppressor.vst3`
