# Creating a DMG Installer for PRI Resonance Suppressor

This guide explains how to create a professional DMG installer for easy distribution of the plugin.

## 🎁 What is a DMG Installer?

A DMG (Disk Image) is the standard macOS distribution format. It provides:
- ✅ Easy drag-and-drop installation
- ✅ Professional presentation
- ✅ Single file distribution
- ✅ Built-in compression
- ✅ Familiar user experience

## 🚀 Quick Start

### Build and Create DMG

```bash
# 1. Build the universal binary
./build_macos_arm.sh Release universal

# 2. Create the DMG installer
./create_installer.sh
```

That's it! The DMG will be created in `build/dmg/`

## 📦 What Gets Included

The DMG contains:

1. **PRI Resonance Suppressor.component** - Audio Unit plugin
2. **PRI Resonance Suppressor.vst3** - VST3 plugin
3. **Install.command** - Automated installer script
4. **Uninstall.command** - Automated uninstaller script
5. **README.txt** - Complete documentation
6. **LICENSE.txt** - License information

## 🎨 DMG Features

### Professional Layout
- Icon view with optimal spacing
- Organized file positioning
- Clean, uncluttered interface
- 600x400 window size

### Install.command Features
- ✅ User-friendly interface
- ✅ Clear installation messages
- ✅ Automatic code signing
- ✅ Cache clearing
- ✅ Permission handling
- ✅ Error checking

### Uninstall.command Features
- ✅ Clean removal of plugins
- ✅ Optional settings removal
- ✅ Cache clearing
- ✅ User confirmation

## 📝 Detailed Steps

### Step 1: Build the Plugin

```bash
# Clean previous builds
rm -rf build

# Build universal binary (Intel + ARM)
./build_macos_arm.sh Release universal
```

**Output:**
```
build/PRIResonanceSuppressor_artefacts/Release/
├── AU/
│   └── PRI Resonance Suppressor.component
└── VST3/
    └── PRI Resonance Suppressor.vst3
```

### Step 2: Create the DMG

```bash
./create_installer.sh
```

**The script will:**
1. ✅ Check if plugins are built
2. ✅ Create staging directory
3. ✅ Copy plugins
4. ✅ Sign plugins with ad-hoc signature
5. ✅ Create Install.command script
6. ✅ Create Uninstall.command script
7. ✅ Copy documentation
8. ✅ Create temporary DMG
9. ✅ Configure DMG appearance
10. ✅ Compress to final DMG

**Output:**
```
build/dmg/PRI-Resonance-Suppressor-1.0.0-macOS.dmg
```

### Step 3: Test the DMG

```bash
# Open the DMG
open "build/dmg/PRI-Resonance-Suppressor-1.0.0-macOS.dmg"

# The DMG will mount showing all contents
# Double-click Install.command to test installation
```

## 🧪 Testing Checklist

### Before Distribution

- [ ] Mount the DMG successfully
- [ ] Run Install.command - installation succeeds
- [ ] Verify AU in `/Library/Audio/Plug-Ins/Components/`
- [ ] Verify VST3 in `/Library/Audio/Plug-Ins/VST3/`
- [ ] Test AU validation: `auval -v aufx Rsup Prtz`
- [ ] Test in Logic Pro/GarageBand
- [ ] Test in other DAWs
- [ ] Run Uninstall.command - removal succeeds
- [ ] Verify plugins are removed
- [ ] Test on different Mac (Intel and/or Apple Silicon)

### File Checks

```bash
# Check DMG size (should be ~5-10 MB)
ls -lh "build/dmg/PRI-Resonance-Suppressor-1.0.0-macOS.dmg"

# Verify universal binary
lipo -info "/Volumes/PRI Resonance Suppressor/PRI Resonance Suppressor.component/Contents/MacOS/PRI Resonance Suppressor"
# Should show: x86_64 arm64

# Check code signature
codesign -dvv "/Volumes/PRI Resonance Suppressor/PRI Resonance Suppressor.component"
```

## 🎯 Distribution

### GitHub Release

1. Go to your repository on GitHub
2. Click **Releases** → **Create a new release**
3. Tag version: `v1.0.0`
4. Release title: `PRI Resonance Suppressor v1.0.0 - macOS Universal`
5. Description:
   ```markdown
   ## PRI Resonance Suppressor v1.0.0
   
   macOS Universal Binary (Apple Silicon + Intel)
   
   ### What's Included
   - Audio Unit (AU) format for Logic Pro, GarageBand
   - VST3 format for Ableton, FL Studio, Reaper, etc.
   - Universal binary (works on M1/M2/M3/M4 and Intel Macs)
   - Fully validated by Apple's auval tool
   
   ### Installation
   1. Download and open the DMG
   2. Double-click Install.command
   3. Restart your DAW
   
   ### System Requirements
   - macOS 11 (Big Sur) or later
   - Apple Silicon or Intel Mac
   - Compatible DAW
   
   ### Changelog
   - Initial macOS release
   - Universal binary support
   - Audio Unit and VST3 formats
   - Apple validation passed
   ```
6. Attach the DMG file
7. Publish release

### Direct Download

Upload to:
- Your website
- Dropbox/Google Drive (get shareable link)
- File hosting service

### Audio Forums

Share on:
- KVR Audio Forums
- Gearspace (formerly Gearslutz)
- VI-Control
- Logic Pro Help
- Reddit r/audioengineering, r/LogicPro

## 🔧 Customization

### Change Version Number

Edit `create_installer.sh`:
```bash
VERSION="1.0.0"  # Change this
```

### Customize DMG Name

Edit `create_installer.sh`:
```bash
DMG_NAME="PRI-Resonance-Suppressor-${VERSION}-macOS"  # Modify this
```

### Add Background Image

1. Create a 600x400 PNG background image
2. Save as `installer_background.png`
3. Uncomment and modify in `create_installer.sh`:
   ```bash
   mkdir "$MOUNT_DIR/.background"
   cp installer_background.png "$MOUNT_DIR/.background/"
   ```

### Customize Window Layout

Edit the AppleScript section in `create_installer.sh`:
```applescript
set bounds of container window to {400, 200, 1000, 600}  # Window position
set icon size of viewOptions to 72  # Icon size
set position of item "Install.command" to {150, 120}  # Item positions
```

## 📊 DMG Specifications

| Property | Value |
|----------|-------|
| **Format** | UDZO (compressed) |
| **Compression** | zlib level 9 (maximum) |
| **Volume Name** | "PRI Resonance Suppressor" |
| **Window Size** | 600x400 pixels |
| **Icon Size** | 72x72 pixels |
| **View** | Icon view |
| **Typical Size** | 5-10 MB |

## 🛠️ Troubleshooting

### DMG Creation Fails

**Problem**: "hdiutil: create failed"
**Solution**: 
```bash
# Clean up any mounted volumes
hdiutil detach "/Volumes/PRI Resonance Suppressor" -force

# Remove old DMG files
rm -rf build/dmg/*.dmg
rm -rf build/installer_staging

# Try again
./create_installer.sh
```

### Plugins Not Found

**Problem**: "Plugins not found. Please build first"
**Solution**:
```bash
# Build the plugins first
./build_macos_arm.sh Release universal

# Then create DMG
./create_installer.sh
```

### AppleScript Errors

**Problem**: AppleScript fails to position items
**Solution**: This is usually harmless. The DMG is still created, just without custom positioning. Users can still access all files.

### Code Signing Issues

**Problem**: "no identity found"
**Solution**: The script uses ad-hoc signing (`-`). For App Store distribution, you'll need a Developer ID certificate.

## 🔐 Code Signing for Distribution

### Ad-hoc Signing (Default)

Good for:
- Personal use
- Sharing with friends
- Open source distribution
- Testing

```bash
codesign --force --deep --sign - --options runtime plugin.component
```

### Developer ID Signing (Official)

Required for:
- Public distribution
- Notarization
- Gatekeeper approval

```bash
# Sign with Developer ID
codesign --force --deep --sign "Developer ID Application: Your Name" --options runtime plugin.component

# Notarize (requires Apple Developer account)
xcrun notarytool submit plugin.component --apple-id your@email.com --team-id TEAMID --password app-specific-password
```

## 📋 Pre-Release Checklist

Before publishing your DMG:

- [ ] Plugin version is correct
- [ ] README.txt is up to date
- [ ] LICENSE.txt is included
- [ ] Both AU and VST3 are present
- [ ] Universal binary verified
- [ ] Install.command works
- [ ] Uninstall.command works
- [ ] Tested on clean system
- [ ] Tested on Apple Silicon
- [ ] Tested on Intel Mac (if possible)
- [ ] auval passes
- [ ] Works in Logic Pro
- [ ] Works in at least one other DAW
- [ ] DMG mounts without errors
- [ ] All documentation is readable

## 🌟 Best Practices

### Naming Convention
```
ProductName-Version-macOS.dmg
PRI-Resonance-Suppressor-1.0.0-macOS.dmg
```

### Version Numbering
- Use semantic versioning: MAJOR.MINOR.PATCH
- Update VERSION in create_installer.sh for each release
- Tag releases in Git: `git tag v1.0.0`

### Documentation
- Keep README.txt concise but complete
- Include quick start guide
- List system requirements
- Provide support contact info

### Testing
- Always test on a clean system
- Test both installation and uninstallation
- Verify in multiple DAWs
- Check both Intel and ARM if possible

## 📚 Additional Resources

- [Apple DMG Documentation](https://developer.apple.com/documentation/)
- [hdiutil Manual](https://ss64.com/osx/hdiutil.html)
- [Code Signing Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

## 🎉 Success!

Your DMG installer provides:
- ✅ Professional distribution package
- ✅ Easy installation for users
- ✅ Complete documentation
- ✅ Clean uninstallation
- ✅ Universal binary support
- ✅ Ready for public release

---

**Created by the PRI Resonance Suppressor macOS port project**
