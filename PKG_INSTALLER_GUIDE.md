# Creating a PKG Installer for PRI Resonance Suppressor

This guide explains how to create a professional `.pkg` installer - the native macOS installer format with a GUI wizard.

## 📦 What is a PKG Installer?

A `.pkg` file is the official macOS installer format used by Apple and professional software. It provides:

- ✅ **Native macOS installer GUI** - Familiar wizard interface
- ✅ **System-level installation** - Proper permissions handling
- ✅ **Welcome/ReadMe/License screens** - Professional presentation
- ✅ **Automatic validation** - macOS checks compatibility
- ✅ **Unattended installation** - Can be scripted with `installer` command
- ✅ **App Store compatible** - With proper signing
- ✅ **Professional appearance** - Users trust .pkg installers

## 🚀 Quick Start

### Create the PKG Installer

```bash
# 1. Build the universal binary
./build_macos_arm.sh Release universal

# 2. Create the PKG installer
./create_pkg_installer.sh
```

**Output:**
```
build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg
```

That's it! Double-click to test the installer.

## 🎨 Installer Flow

When users run your `.pkg`, they'll see:

### 1. **Introduction Screen**
```
Welcome to PRI Resonance Suppressor

This installer will install the PRI Resonance Suppressor 
audio plugin on your Mac.

What will be installed:
• Audio Unit (AU) plugin
• VST3 plugin  
• Universal Binary (Apple Silicon + Intel)
```

### 2. **Read Me Screen**
```
Features, presets, DAW compatibility, system requirements
```

### 3. **License Screen**
```
AGPLv3 license text with Agree/Disagree buttons
```

### 4. **Installation Type**
```
Standard Install on "Macintosh HD"
This will take 15 MB of space on your computer.
```

### 5. **Installation Progress**
```
Installing PRI Resonance Suppressor...
[Progress bar]
Running package scripts...
```

### 6. **Summary Screen**
```
Installation Complete!

Next steps:
1. Restart your DAW
2. Rescan plugins if needed
3. Look for "PRI Resonance Suppressor" by PRITEZZA
```

## 📦 What Gets Installed

```
/Library/Audio/Plug-Ins/
├── Components/
│   └── PRI Resonance Suppressor.component (AU)
└── VST3/
    └── PRI Resonance Suppressor.vst3
```

## 🔧 Post-Install Script

The installer automatically:
1. ✅ Removes quarantine attributes
2. ✅ Re-signs plugins with ad-hoc signature
3. ✅ Clears AU cache
4. ✅ Kills audio component processes
5. ✅ Ensures proper permissions

## 📊 PKG Specifications

| Property | Value |
|----------|-------|
| **Format** | macOS Installer Package |
| **Installation Location** | /Library/Audio/Plug-Ins/ |
| **Requires Admin** | Yes (system-wide install) |
| **Minimum macOS** | 11.0 (Big Sur) |
| **Architecture Check** | Automatic |
| **Size** | ~5-10 MB |

## 🧪 Testing the PKG

### Before Distribution

```bash
# 1. Double-click the .pkg file
open "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg"

# 2. Go through the installer wizard
# 3. Enter your password when prompted
# 4. Complete installation

# 5. Verify files are installed
ls -la "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
ls -la "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"

# 6. Validate AU
auval -v aufx Rsup Prtz
# Should show: "AU VALIDATION SUCCEEDED"

# 7. Test in Logic Pro
# Open Logic Pro → Preferences → Plug-in Manager
# Look for PRI Resonance Suppressor

# 8. Load plugin and test functionality
```

### Unattended Installation (for testing)

```bash
# Install silently (requires sudo)
sudo installer -pkg "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg" -target /

# View installer log
tail -f /var/log/install.log
```

## 🔐 Code Signing

### Ad-hoc Signing (Default)

The script uses ad-hoc signing (`-`) for testing and open-source distribution.

**Good for:**
- Personal use
- Open source projects
- Testing
- Sharing with friends

### Developer ID Signing (Production)

For public distribution, you need an Apple Developer account and certificate.

```bash
# 1. Get your Developer ID Installer certificate from Apple
# 2. Sign the PKG

productsign --sign "Developer ID Installer: Your Name (TEAMID)" \
  "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg" \
  "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS-signed.pkg"

# 3. Verify signature
pkgutil --check-signature "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS-signed.pkg"

# 4. Notarize (submit to Apple)
xcrun notarytool submit "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS-signed.pkg" \
  --apple-id "your@email.com" \
  --team-id "TEAMID" \
  --password "app-specific-password" \
  --wait

# 5. Staple the notarization ticket
xcrun stapler staple "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS-signed.pkg"
```

### Why Sign?

**Without signing:**
- Users see: "PKG is from an unidentified developer"
- Need to right-click → Open to install
- Gatekeeper warnings

**With Developer ID:**
- Installs without warnings
- No right-click needed
- Professional trust indicator
- Required for Mac App Store

## 📦 PKG vs DMG Comparison

| Feature | PKG | DMG |
|---------|-----|-----|
| **Installation** | Guided wizard | Manual drag-and-drop |
| **User Experience** | Native macOS UI | Custom layout |
| **Permissions** | Automatic (sudo) | User handles manually |
| **Uninstall** | Manual or script | Manual or script |
| **Professional** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Simplicity** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Customization** | Limited | High |
| **Size** | Smaller | Larger |
| **Best For** | Production | Development/Beta |

**Recommendation:** Use PKG for final releases, DMG for beta testing.

## 🌐 Distribution

### GitHub Release

```markdown
# Release Notes Template

## PRI Resonance Suppressor v1.0.0

**macOS Installer Package** - Professional installation wizard

### What's New
- Native macOS .pkg installer with GUI wizard
- Universal Binary (Apple Silicon + Intel)
- Audio Unit and VST3 formats
- Fully validated by Apple

### Installation
1. Download PRI-Resonance-Suppressor-1.0.0-macOS.pkg
2. Double-click to open the installer
3. Follow the installation wizard
4. Enter your password when prompted
5. Restart your DAW

### What's Included
✅ Audio Unit (AU) for Logic Pro, GarageBand
✅ VST3 for all major DAWs
✅ Universal binary (M1/M2/M3 + Intel)
✅ Automatic installation to system plugins folder
✅ Post-install cache clearing
✅ Complete documentation

### System Requirements
- macOS 11 (Big Sur) or later
- Apple Silicon or Intel Mac
- Compatible DAW

### Downloads
- [PRI-Resonance-Suppressor-1.0.0-macOS.pkg](link) (10 MB)

### Checksum (SHA256)
```
shasum -a 256 PRI-Resonance-Suppressor-1.0.0-macOS.pkg
```
```

### Website Download Page

Create a download page with:
- Download button for .pkg
- System requirements
- Installation instructions
- Screenshot/video
- Changelog
- Support links

### Audio Software Platforms

Submit to:
- **KVR Audio** - Plugin database
- **Plugin Boutique** - Commercial (if selling)
- **Splice** - If free/freemium
- **VI-Control** - Audio community

## 🔧 Customization

### Change Version

Edit `create_pkg_installer.sh`:
```bash
VERSION="1.0.0"  # Update for each release
```

### Customize Text

Edit the text in these sections:
- `welcome.txt` - Introduction screen
- `readme.txt` - ReadMe screen
- `conclusion.txt` - Final screen

### Add Background Image

For a custom installer background:
```bash
# Add to resources
cp your_background.png "$PKG_RESOURCES/background.png"

# Reference in distribution.xml
<background file="background.png" mime-type="image/png"/>
```

### Modify Installation Location

If you want user-level installation instead of system-wide:
```bash
# Change in create_pkg_installer.sh
PKG_ROOT="build/pkg_root/Users/USERNAME/Library/Audio/Plug-Ins"
```

But system-wide (`/Library/`) is recommended for audio plugins.

## 🐛 Troubleshooting

### "pkg is damaged and can't be opened"

**Solution:** Remove quarantine attribute
```bash
xattr -cr "build/pkg/PRI-Resonance-Suppressor-1.0.0-macOS.pkg"
```

### Installation Fails Silently

**Check the log:**
```bash
tail -f /var/log/install.log
```

### Plugins Not Found After Install

**Verify installation:**
```bash
pkgutil --pkgs | grep pritezza
pkgutil --files com.pritezza.PRIResonanceSuppressor
```

### Need to Reinstall

**Remove package receipt:**
```bash
sudo pkgutil --forget com.pritezza.PRIResonanceSuppressor
```

Then reinstall the .pkg

## 📋 Pre-Release Checklist

- [ ] Universal binary built and tested
- [ ] Both AU and VST3 present
- [ ] auval passes for AU
- [ ] Version number correct in script
- [ ] Welcome text reviewed
- [ ] README text complete
- [ ] License file included
- [ ] PKG builds without errors
- [ ] PKG installs successfully
- [ ] Plugins work in Logic Pro
- [ ] Plugins work in other DAW
- [ ] Uninstall verified
- [ ] Tested on clean Mac
- [ ] Tested on Apple Silicon
- [ ] Tested on Intel (if possible)
- [ ] PKG signed (for production)
- [ ] PKG notarized (for production)

## 🎯 Advanced: Uninstaller PKG

Create a separate uninstaller PKG:

```bash
# Create uninstall package
pkgbuild --nopayload \
  --identifier "com.pritezza.PRIResonanceSuppressor.uninstall" \
  --scripts uninstall_scripts \
  "PRI-Resonance-Suppressor-Uninstaller.pkg"
```

Where `uninstall_scripts/postinstall` contains:
```bash
#!/bin/bash
rm -rf "/Library/Audio/Plug-Ins/Components/PRI Resonance Suppressor.component"
rm -rf "/Library/Audio/Plug-Ins/VST3/PRI Resonance Suppressor.vst3"
rm -rf "$HOME/Library/Application Support/PRITEZZA"
killall -9 AudioComponentRegistrar 2>/dev/null || true
```

## 📚 Additional Resources

- [Apple PKG Documentation](https://developer.apple.com/library/archive/documentation/DeveloperTools/Reference/DistributionDefinitionRef/)
- [pkgbuild Manual](https://ss64.com/osx/pkgbuild.html)
- [productbuild Manual](https://ss64.com/osx/productbuild.html)
- [Code Signing Guide](https://developer.apple.com/developer-id/)

## ✨ Best Practices

1. **Always test on clean system** before distributing
2. **Use semantic versioning** (MAJOR.MINOR.PATCH)
3. **Sign with Developer ID** for production releases
4. **Notarize** all public releases
5. **Provide SHA256 checksum** for verification
6. **Include uninstall instructions** in documentation
7. **Test on both Intel and ARM** if possible
8. **Keep installer size small** (< 20 MB)
9. **Use clear, professional text** in installer screens
10. **Provide support contact** in documentation

## 🎉 Success!

Your PKG installer provides:
- ✅ Professional macOS installer experience
- ✅ Guided installation wizard
- ✅ Automatic system-level installation
- ✅ Built-in documentation
- ✅ macOS compatibility checking
- ✅ Ready for App Store (with signing)

Users will appreciate the polished, professional installation process!

---

**Created for the PRI Resonance Suppressor macOS port**
