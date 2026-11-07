# PRI Resonance Suppressor - macOS ARM Build

A spectral resonance suppressor audio plugin for macOS, optimized for Apple Silicon (M1/M2/M3).

## What's Changed for macOS

This fork adds macOS ARM support to the original Windows-only plugin:

- ✅ **Audio Unit (AU)** format support - Native macOS plugin format
- ✅ **VST3** format support - Cross-platform standard
- ✅ **Apple Silicon optimization** - Native ARM64 builds
- ✅ **Universal binary support** - Optional Intel + ARM builds
- ✅ **Simple build and install scripts**

## Quick Start

### Prerequisites

1. **macOS 11 (Big Sur) or later** with Apple Silicon
2. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
3. **Homebrew** (recommended for CMake):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. **CMake**:
   ```bash
   brew install cmake
   ```

### Build and Install

```bash
# 1. Clone the repository
git clone https://github.com/pritezza/PRIResonanceSuppressor.git
cd PRIResonanceSuppressor

# 2. Run the build script
./build_macos_arm.sh

# 3. Install the plugins
sudo ./install_macos.sh
```

That's it! The plugin will be available in your DAW after restarting it.

## Manual Build Instructions

If you prefer manual control, see [BUILD_MACOS.md](BUILD_MACOS.md) for detailed instructions.

## Plugin Features

- **Smart resonance detection** - Automatically finds and reduces harsh frequencies
- **Real-time spectrum analyzer** - Visualize input, output, and reduction
- **Flexible controls**:
  - Detection range (LOW/HIGH), width, and threshold
  - Reduction depth, attack, and release
  - Mix control for parallel processing
  - Stereo modes: Linked, L/R, or M/S
- **Three visual themes** - Vintage, Black, and Silver
- **Resizable UI** - 50% to 150% scaling

## DAW Compatibility

Tested and working with:
- **Logic Pro** (AU)
- **Ableton Live** (VST3/AU)
- **FL Studio** (VST3/AU)
- **Reaper** (VST3/AU)
- **Pro Tools** (VST3/AU on 2023.6+)
- **Cubase** (VST3)
- **Studio One** (VST3/AU)

## Installation Locations

### Audio Unit (AU)
- System: `/Library/Audio/Plug-Ins/Components/`
- User: `~/Library/Audio/Plug-Ins/Components/`

### VST3
- System: `/Library/Audio/Plug-Ins/VST3/`
- User: `~/Library/Audio/Plug-Ins/VST3/`

### Settings
- User settings: `~/Library/Application Support/PRITEZZA/PRIResonanceSuppressor.settings`

## Usage Tips

### Quick Setup

1. Insert on a track with harsh frequencies (vocals, guitar, cymbals)
2. Set LOW and HIGH to bracket the problem area
3. Lower THRESHOLD until reduction appears on problem peaks
4. Adjust DEPTH to taste (start around 9-12 dB)
5. Use Δ LISTEN to solo the removed content

### Common Use Cases

**Vocal De-Essing:**
- LOW: 4 kHz, HIGH: 10 kHz
- WIDTH: 1/6 octave
- THRESHOLD: 6 dB, DEPTH: 12 dB

**Acoustic Guitar Harshness:**
- LOW: 2 kHz, HIGH: 8 kHz
- WIDTH: 1/12 octave
- THRESHOLD: 4 dB, DEPTH: 9 dB

**Overhead Cymbal Control:**
- LOW: 5 kHz, HIGH: 15 kHz
- WIDTH: 1/6 octave
- THRESHOLD: 6 dB, DEPTH: 15 dB

**General Mix Polish:**
- LOW: 1 kHz, HIGH: 16 kHz
- WIDTH: 1/6 octave
- THRESHOLD: 8 dB, DEPTH: 6 dB
- MIX: 50%

## Performance

**CPU Usage:**
- Light audio processing (< 1% on M1)
- Analyzer display uses more CPU
- Reduce DISPLAY RATE in settings if needed (30 FPS default)
- Set LINE GLOW to "1 LINE" for lower CPU

**Latency:**
| Resolution | 44.1 kHz | 48 kHz | 96 kHz |
|-----------|----------|--------|--------|
| 1024      | 23 ms    | 21 ms  | 11 ms  |
| 2048      | 46 ms    | 43 ms  | 21 ms  |
| 4096      | 93 ms    | 85 ms  | 43 ms  |

Latency is automatically compensated by your DAW.

## Troubleshooting

### Plugin Not Showing in DAW

1. **Rescan plugins** in your DAW's preferences
2. **Restart the DAW** completely
3. **Check plugin paths** in DAW settings
4. **Remove quarantine flag**:
   ```bash
   xattr -cr "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
   xattr -cr "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
   ```

### Build Errors

**"xcrun: error: invalid active developer path"**
```bash
xcode-select --install
```

**"cmake: command not found"**
```bash
brew install cmake
```

**"JUCE not found"**
```bash
git clone --depth 1 --branch 8.0.16-security https://github.com/juce-framework/JUCE.git external/JUCE
```

### Gatekeeper Blocking Plugin

macOS may block the plugin if built locally. Remove the quarantine:

```bash
# For system installation
sudo xattr -cr "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
sudo xattr -cr "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# For user installation
xattr -cr "$HOME/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
xattr -cr "$HOME/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
```

## Building Universal Binaries

To build for both Intel and Apple Silicon:

```bash
./build_macos_arm.sh Release universal
```

This creates a universal binary that works on both architectures.

## Development

### Debug Builds

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_ARCHITECTURES=arm64 -DPRI_ENABLE_LTO=OFF
cmake --build build --config Debug
```

### Development Tools

Build benchmarks and tests:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=arm64 -DPRI_BUILD_TOOLS=ON
cmake --build build --config Release
```

Tools are built to:
- `build/PRIResonanceSuppressor_artefacts/Release/ConsoleApp/PluginHostTest`
- `build/PRIResonanceSuppressor_artefacts/Release/ConsoleApp/Benchmark`
- `build/PRIResonanceSuppressor_artefacts/Release/ConsoleApp/EditorSnapshot`

## Uninstalling

```bash
# Remove plugins
sudo rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
sudo rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# Or for user installation
rm -rf "$HOME/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
rm -rf "$HOME/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# Remove settings (optional)
rm -rf "$HOME/Library/Application Support/PRITEZZA"
```

## License

Copyright (C) 2026 PRITEZZA

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License version 3 (AGPLv3).

Built with [JUCE](https://juce.com) framework under AGPLv3.

## Credits

- Original plugin: [PRITEZZA](https://github.com/pritezza)
- macOS ARM port: [Your Name]
- Framework: [JUCE](https://github.com/juce-framework/JUCE)

## Links

- [Original Repository](https://github.com/pritezza/PRIResonanceSuppressor)
- [JUCE Framework](https://juce.com)
- [Build Instructions](BUILD_MACOS.md)

## Support

For issues specific to the macOS build, please open an issue on this repository.
For general plugin questions, see the [original repository](https://github.com/pritezza/PRIResonanceSuppressor).
