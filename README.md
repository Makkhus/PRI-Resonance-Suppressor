# PRI Resonance Suppressor - macOS Universal Binary

A spectral resonance suppressor audio plugin for macOS, with native support for both **Apple Silicon (M1/M2/M3/M4)** and **Intel Macs**.

This is a fully-functional macOS port of the [original PRI Resonance Suppressor](https://github.com/pritezza/PRIResonanceSuppressor) by PRITEZZA.

## ✅ **Fully Validated & Production Ready**

This plugin has passed **Apple's complete AU validation** with all tests successful:
- ✅ Component registration and identification
- ✅ All 14 parameters working with automation
- ✅ Audio rendering at all sample rates (11 kHz - 192 kHz)
- ✅ Channel layout support (Mono, Stereo, Binaural)
- ✅ Custom Cocoa UI interface
- ✅ MIDI handling
- ✅ Zero audio processing errors

**Validation output:** `AU VALIDATION SUCCEEDED`

## 🎯 What's New in This Fork

- ✅ **Universal Binary** - Works natively on Apple Silicon AND Intel Macs
- ✅ **Audio Unit (AU)** - Native format for Logic Pro, GarageBand, Final Cut Pro
- ✅ **VST3** - Cross-platform compatibility with all major DAWs
- ✅ **Apple-validated** - Passes all AU validation tests
- ✅ **One-command build** - Automated build script handles everything
- ✅ **One-command install** - Automated installer with proper signing
- ✅ **Complete AU fix tools** - Diagnostic and repair scripts included
- ✅ **Comprehensive documentation** - Complete guides for building and using

## 🚀 Quick Start

### Prerequisites

1. **macOS 11 (Big Sur) or later**
2. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
3. **CMake**:
   ```bash
   brew install cmake
   ```

### Build and Create Installer

```bash
# Clone the repository
git clone https://github.com/Makkhus/PRI-Resonance-Suppressor.git
cd PRI-Resonance-Suppressor

# Build universal binary (Apple Silicon + Intel)
./build_macos_arm.sh Release universal

# Create PKG installer
./create_pkg_installer.sh

# The installer will be in: build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg
```

### Install the Plugin

Double-click the `.pkg` file and follow the installation wizard. The installer will:
- ✅ Install Audio Unit (AU) to `/Library/Audio/Plug-Ins/Components/`
- ✅ Install VST3 to `/Library/Audio/Plug-Ins/VST3/`
- ✅ Automatically sign plugins
- ✅ Clear AU cache
- ✅ Set proper permissions

Then restart your DAW and look for **PRI Resonance Suppressor** by PRITEZZA.

### Validate Installation

```bash
# Verify AU plugin passes Apple validation
auval -v aufx Rsup Prtz

# Should output: "AU VALIDATION SUCCEEDED"
```

## 📖 Documentation

- **[PKG_INSTALLER_GUIDE.md](PKG_INSTALLER_GUIDE.md)** - PKG installer creation guide
- **[README.ja.md](README.ja.md)** - Japanese README (original)

## ✨ Features

### Smart Resonance Detection
- Automatically finds and reduces harsh frequencies, ringing, and whistling
- Follows the sound dynamically - no fixed EQ cuts
- Compares every frequency with its neighbors in real-time

### Flexible Controls
- **Detection Range**: Set LOW and HIGH frequency boundaries (25 Hz - 20 kHz)
- **WIDTH**: How narrow a peak must be (1/3 - 1/48 octave)
- **THRESHOLD**: How far a peak must stick out (1 - 20 dB)
- **DEPTH**: Maximum reduction amount (1 - 24 dB)
- **ATTACK/RELEASE**: Speed of reduction (1-200ms / 10-2000ms)

### Visual Feedback
- **Real-time spectrum analyzer** showing input, output, and reduction
- **Three themes**: Vintage, Black, Silver
- **Resizable UI**: 50% to 150% scaling
- **Δ LISTEN mode**: Solo the removed frequencies

### Stereo Processing
- **LINKED**: Same reduction on both channels (default)
- **L/R**: Left and right processed independently
- **M/S**: Mid and side processed independently

## 🎵 Common Use Cases

**Vocal De-Essing:**
```
LOW: 4kHz | HIGH: 10kHz | WIDTH: 1/6 | THRESHOLD: 6dB | DEPTH: 12dB
```

**Acoustic Guitar Harshness:**
```
LOW: 2kHz | HIGH: 8kHz | WIDTH: 1/12 | THRESHOLD: 4dB | DEPTH: 9dB
```

**Overhead Cymbal Control:**
```
LOW: 5kHz | HIGH: 15kHz | WIDTH: 1/6 | THRESHOLD: 6dB | DEPTH: 15dB
```

**General Mix Polish:**
```
LOW: 1kHz | HIGH: 16kHz | WIDTH: 1/6 | THRESHOLD: 8dB | DEPTH: 6dB | MIX: 50%
```

## 🎛️ DAW Compatibility

Tested and working with:
- Logic Pro (AU)
- Ableton Live (VST3/AU)
- FL Studio (VST3/AU)
- Reaper (VST3/AU)
- Pro Tools 2023.6+ (VST3/AU)
- Cubase (VST3)
- Studio One (VST3/AU)

## 📍 Installation Locations

### Audio Unit (AU)
- System: `/Library/Audio/Plug-Ins/Components/`
- User: `~/Library/Audio/Plug-Ins/Components/`

### VST3
- System: `/Library/Audio/Plug-Ins/VST3/`
- User: `~/Library/Audio/Plug-Ins/VST3/`

### Settings
- `~/Library/Application Support/PRITEZZA/PRIResonanceSuppressor.settings`

## 🔧 Build Options

### Universal Binary (Recommended)
```bash
./build_macos_arm.sh Release universal
```
**Best for:** Maximum compatibility - works on Apple Silicon AND Intel Macs

### ARM64 Only Build
```bash
./build_macos_arm.sh
```
**Best for:** Smaller file size, Apple Silicon only

### Debug Build
```bash
./build_macos_arm.sh Debug
```
**Best for:** Development and debugging

## 🐛 Troubleshooting

### Plugin not showing in DAW?

1. **Check installation:**
   ```bash
   ls -la "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
   ls -la "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
   ```

2. **Validate AU:**
   ```bash
   auval -v aufx Rsup Prtz
   # Should show: "AU VALIDATION SUCCEEDED"
   ```

3. **Clear AU cache:**
   ```bash
   rm -rf ~/Library/Caches/AudioUnitCache
   killall -9 AudioComponentRegistrar
   ```

4. **Restart your DAW completely**

5. **For Logic Pro:**
   - Open Logic Pro → Preferences → Plug-in Manager
   - Click "Reset & Rescan Selection"

### Build errors?

1. Verify Xcode tools: `xcode-select -p`
2. Update CMake: `brew upgrade cmake`
3. Clean build: `rm -rf build && ./build_macos_arm.sh Release universal`

See [PKG_INSTALLER_GUIDE.md](PKG_INSTALLER_GUIDE.md) for more troubleshooting.

## 🗑️ Uninstall

```bash
# Remove plugins
sudo rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
sudo rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# Remove settings (optional)
rm -rf "$HOME/Library/Application Support/PRITEZZA"
```

## ⚡ Performance

### Benchmarks (Apple Silicon M1)
- **CPU Usage**: < 1% for audio processing
- **Display Rendering**: 1-3% (adjustable via DISPLAY RATE setting)
- **Cold Open Time**: ~25ms
- **Warm Open Time**: ~12ms
- **Initialization**: < 0.1ms

### Latency (Auto-compensated by DAW)
- **1024 samples**: 23ms @ 44.1kHz, 21ms @ 48kHz
- **2048 samples**: 46ms @ 44.1kHz, 43ms @ 48kHz
- **4096 samples**: 93ms @ 44.1kHz, 85ms @ 48kHz

### Supported Sample Rates
- 11.025 kHz to 192 kHz
- HI-RES FFT mode maintains resolution at higher sample rates

## 📄 License

Copyright (C) 2026 PRITEZZA

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License version 3 (AGPLv3).

Built with [JUCE](https://juce.com) framework under AGPLv3.

## 🙏 Credits

- **Original Plugin**: [PRITEZZA](https://github.com/pritezza)
- **macOS ARM Port**: This fork
- **Framework**: [JUCE](https://github.com/juce-framework/JUCE)

## 🔗 Links

- [Original Repository](https://github.com/pritezza/PRIResonanceSuppressor)
- [JUCE Framework](https://juce.com)
- [Issue Tracker](https://github.com/Makkhus/PRI-Resonance-Suppressor/issues)

## 📸 Screenshots

![PRI Resonance Suppressor](docs/images/hero.gif)

*Real-time resonance detection and suppression*

---

**Made with ❤️ for Apple Silicon**
