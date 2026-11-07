# PRI Resonance Suppressor

![PRI Resonance Suppressor Interface](docs/images/hero.gif)

**Professional Spectral Resonance Suppressor for macOS**

[![macOS](https://img.shields.io/badge/macOS-11%2B-blue)](https://www.apple.com/macos/)
[![Universal](https://img.shields.io/badge/Universal-Intel%20%2B%20Apple%20Silicon-green)](https://github.com/Makkhus/PRI-Resonance-Suppressor/releases)
[![License](https://img.shields.io/badge/License-AGPLv3-blue)](LICENSE)
[![Validated](https://img.shields.io/badge/Apple-Validated-brightgreen)](https://github.com/Makkhus/PRI-Resonance-Suppressor)

---

## 📋 About This Release

**Original Plugin:** [PRITEZZA/PRIResonanceSuppressor](https://github.com/pritezza/PRIResonanceSuppressor) (Windows version)

**This Repository:** macOS port with universal binary support (Apple Silicon + Intel)

**Port Author:** FVCKBOI

**Release Info:**
- **Version:** 1.0.0
- **Platform:** macOS 11.0+
- **Architecture:** Universal Binary (arm64 + x86_64)
- **Formats:** Audio Unit (AU) + VST3
- **Status:** Apple AU Validated ✅

---

## 📖 Description

A powerful audio plugin that automatically detects and reduces harsh resonances, ringing frequencies, and unwanted peaks in your audio—all in real-time with visual feedback.

---

## 📥 Download

### [⬇️ Download Latest Release (v1.0.0)](https://github.com/Makkhus/PRI-Resonance-Suppressor/releases/latest)

**System Requirements:**
- macOS 11.0 (Big Sur) or later
- Apple Silicon (M1/M2/M3/M4) or Intel processor
- Compatible DAW with AU or VST3 support

**File Size:** ~10 MB

---

## 🚀 Installation

1. Download `PRI-Resonance-Suppressor-1.0.0-macOS.pkg` from the [Releases page](https://github.com/Makkhus/PRI-Resonance-Suppressor/releases)
2. Double-click the downloaded `.pkg` file
3. Follow the installation wizard
4. Enter your password when prompted
5. Restart your DAW

**Installation Locations:**
- Audio Unit: `/Library/Audio/Plug-Ins/Components/`
- VST3: `/Library/Audio/Plug-Ins/VST3/`

---

## ✨ Features

### Intelligent Resonance Detection
Smart algorithm analyzes your audio spectrum in real-time, identifying narrow peaks that stick out from the surrounding frequencies.

### Dynamic Processing
Unlike static EQ, PRI Resonance Suppressor adapts to your audio—reducing only what's harsh, only when it's harsh.

### Real-Time Visualization
Built-in spectrum analyzer displays input, output, and reduction amount at every frequency, making it easy to see exactly what's being processed.

### Professional Controls
- **14 Automatable Parameters** - Full DAW integration
- **Detection Range** - Set LOW/HIGH frequency boundaries (25 Hz - 20 kHz)
- **Width Control** - Adjust peak narrowness detection (1/3 - 1/48 octave)
- **Threshold** - Set sensitivity (1 - 20 dB)
- **Depth** - Control maximum reduction (1 - 24 dB)
- **Attack/Release** - Shape reduction timing (1-200ms / 10-2000ms)
- **Δ Listen Mode** - Solo what's being removed
- **Stereo Modes** - Linked, L/R, or M/S processing

### Customizable Interface
- Three visual themes (Vintage, Black, Silver)
- Resizable from 50% to 150%
- High-resolution display support

---

## 🎛️ Compatible DAWs

**Fully Tested:**
- Logic Pro (Audio Unit)
- GarageBand (Audio Unit)
- Ableton Live (AU & VST3)
- FL Studio (AU & VST3)
- Reaper (AU & VST3)
- Pro Tools 2023.6+ (AU & VST3)
- Cubase (VST3)
- Studio One (AU & VST3)

Works with any DAW supporting Audio Unit or VST3 plugins.

---

## 🎯 Common Applications

### Vocal Processing
Remove sibilance and harsh resonances while preserving clarity
```
Preset: LOW 4kHz | HIGH 10kHz | THRESHOLD 6dB | DEPTH 12dB
```

### Acoustic Instruments
Tame harshness in guitars, pianos, and strings
```
Preset: LOW 2kHz | HIGH 8kHz | THRESHOLD 4dB | DEPTH 9dB
```

### Drum Overheads
Control ringing cymbals and metallic resonances
```
Preset: LOW 5kHz | HIGH 15kHz | THRESHOLD 6dB | DEPTH 15dB
```

### Mix Bus Processing
Smooth overall harshness for a polished mix
```
Preset: LOW 1kHz | HIGH 16kHz | THRESHOLD 8dB | DEPTH 6dB | MIX 50%
```

---

## 💻 Technical Specifications

**Plugin Formats:**
- Audio Unit (AU) - Native macOS format
- VST3 - Industry standard

**Architecture:**
- Universal Binary (Apple Silicon + Intel)
- Native performance on all Mac processors

**Audio Performance:**
- CPU Usage: < 1% (typical on Apple Silicon)
- Sample Rates: 11.025 kHz - 192 kHz
- Latency: 23-93ms (automatically compensated)
- Bit Depth: 32-bit floating point

**Validation:**
- ✅ Passed Apple's complete AU validation suite
- ✅ Zero audio processing errors
- ✅ Full automation support
- ✅ Professional audio quality

---

## 🐛 Troubleshooting

### Plugin Not Appearing in DAW

1. **Verify Installation:**
   ```bash
   ls /Library/Audio/Plug-Ins/Components/PRI\ Resonance\ Suppressor.component
   ls /Library/Audio/Plug-Ins/VST3/PRI\ Resonance\ Suppressor.vst3
   ```

2. **Validate Audio Unit:**
   ```bash
   auval -v aufx Rsup Prtz
   ```
   Expected output: `AU VALIDATION SUCCEEDED`

3. **Rescan Plugins:**
   - **Logic Pro:** Preferences → Plug-in Manager → Reset & Rescan
   - **Other DAWs:** Check preferences for plugin rescan option

4. **Clear AU Cache:**
   ```bash
   rm -rf ~/Library/Caches/AudioUnitCache
   killall -9 AudioComponentRegistrar
   ```

5. **Restart your DAW completely**

### Still Need Help?

[Open an issue](https://github.com/Makkhus/PRI-Resonance-Suppressor/issues) with:
- macOS version
- DAW name and version
- Output from validation command

---

## 🗑️ Uninstallation

```bash
sudo rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
sudo rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
rm -rf "$HOME/Library/Application Support/PRITEZZA"
```

---

## 📄 License

**GNU Affero General Public License v3.0 (AGPLv3)**

This software is free to use, modify, and distribute under the terms of the AGPLv3 license. See [LICENSE](LICENSE) for full details.

**Third-Party Software:**
- Built with [JUCE Framework](https://juce.com) (AGPLv3)
- See [THIRD_PARTY_NOTICES.txt](THIRD_PARTY_NOTICES.txt) for complete attribution

---

## 🙏 Credits

**Original Plugin:** [PRITEZZA](https://github.com/pritezza/PRIResonanceSuppressor) (Windows version)

**macOS Port:** This repository - Universal Binary for Apple Silicon & Intel

**Framework:** [JUCE](https://juce.com) - Cross-platform audio plugin framework

---

## 🔗 Links

- **[Download Latest Release](https://github.com/Makkhus/PRI-Resonance-Suppressor/releases/latest)**
- **[Report Issues](https://github.com/Makkhus/PRI-Resonance-Suppressor/issues)**
- **[Original Windows Version](https://github.com/pritezza/PRIResonanceSuppressor)**
- **[Source Code](https://github.com/Makkhus/PRI-Resonance-Suppressor)**


---

<div align="center">

**Made with ❤️ for the macOS audio community**

**Fully validated by Apple • Professional quality • Free & Open Source**

[⬇️ Download Now](https://github.com/Makkhus/PRI-Resonance-Suppressor/releases/latest)

</div>
