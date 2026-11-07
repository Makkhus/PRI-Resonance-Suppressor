# Building PRI Resonance Suppressor for macOS ARM

This guide explains how to build the PRI Resonance Suppressor plugin for macOS ARM (Apple Silicon).

## Requirements

- macOS 11 (Big Sur) or later with Apple Silicon (M1/M2/M3)
- Xcode 13 or later with Command Line Tools installed
- CMake 3.22 or later

## Installation Steps

### 1. Install Xcode Command Line Tools

If you haven't already:

```bash
xcode-select --install
```

### 2. Install CMake

Using Homebrew (recommended):

```bash
brew install cmake
```

Or download from: https://cmake.org/download/

### 3. Clone the Repository

```bash
git clone https://github.com/pritezza/PRIResonanceSuppressor.git
cd PRIResonanceSuppressor
```

### 4. Clone JUCE Framework

```bash
git clone --depth 1 --branch 8.0.16-security https://github.com/juce-framework/JUCE.git external/JUCE
```

### 5. Configure the Build

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=arm64
```

For universal binary (both Intel and ARM):
```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
```

### 6. Build the Plugin

```bash
cmake --build build --config Release
```

## Installation

After building, the plugins will be located in:

- **AU Plugin**: `build/PRIResonanceSuppressor_artefacts/Release/AU/PRI Resonance Suppressor.component`
- **VST3 Plugin**: `build/PRIResonanceSuppressor_artefacts/Release/VST3/PRI Resonance Suppressor.vst3`

### Install Audio Unit (AU)

```bash
sudo cp -r "build/PRIResonanceSuppressor_artefacts/Release/AU/PRI Resonance Suppressor.component" \
  "/Library/Audio/Plug-Ins/Components/"
```

Or for current user only:
```bash
cp -r "build/PRIResonanceSuppressor_artefacts/Release/AU/PRI Resonance Suppressor.component" \
  "~/Library/Audio/Plug-Ins/Components/"
```

### Install VST3

```bash
sudo cp -r "build/PRIResonanceSuppressor_artefacts/Release/VST3/PRI Resonance Suppressor.vst3" \
  "/Library/Audio/Plug-Ins/VST3/"
```

Or for current user only:
```bash
cp -r "build/PRIResonanceSuppressor_artefacts/Release/VST3/PRI Resonance Suppressor.vst3" \
  "~/Library/Audio/Plug-Ins/VST3/"
```

### Verify Installation

After copying, you may need to:

1. Rescan plugins in your DAW
2. Restart your DAW if it was running

The plugin will appear as **PRI Resonance Suppressor** by **PRITEZZA** in the Dynamics category.

## Troubleshooting

### Gatekeeper Issues

If macOS blocks the plugin due to security settings:

```bash
# For AU
xattr -cr "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"

# For VST3
xattr -cr "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
```

### Build Errors

If you encounter build errors:

1. Make sure Xcode Command Line Tools are installed: `xcode-select -p`
2. Update CMake to the latest version
3. Clean the build directory: `rm -rf build` and try again

### Missing Dependencies

If JUCE fails to configure, ensure you have the required system frameworks:
- CoreFoundation
- CoreAudio
- CoreMIDI
- AudioToolbox
- Accelerate

These should be available by default on macOS.

## Uninstalling

To remove the plugin:

```bash
# Remove AU
sudo rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
rm -rf "~/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"

# Remove VST3
sudo rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
rm -rf "~/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# Remove settings (optional)
rm -rf "~/Library/Application Support/PRITEZZA"
```

## Development

For development builds without link-time optimization (faster compile times):

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DPRI_ENABLE_LTO=OFF
cmake --build build --config Debug
```

To build the development tools (benchmark, tests, etc.):

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=arm64 -DPRI_BUILD_TOOLS=ON
cmake --build build --config Release
```

## License

This plugin is licensed under AGPLv3. See LICENSE file for details.
