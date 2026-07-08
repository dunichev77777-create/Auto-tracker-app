# IPA Installation Guide

This guide explains how to install your MyCar app via IPA file to iOS devices.

## Quick Start

1. **Build the IPA:**
   ```bash
   flutter build ipa --release
   ```

2. **Run the installation script:**
   ```bash
   chmod +x install_ipa.sh
   ./install_ipa.sh
   ```

## Installation Methods

### Method 1: ios-deploy (Command Line)

**Best for:** Quick command-line installation

**Prerequisites:**
```bash
# Install Node.js if not already installed
brew install node

# Install ios-deploy
npm install -g ios-deploy
```

**Installation:**
```bash
ios-deploy --bundle build/ios/ipa/mycar.ipa
```

**Requirements:**
- Device must be unlocked
- Device must be trusted on this computer
- Requires Ad-hoc provisioning profile with device UDID registered

---

### Method 2: Xcode (Devices and Simulators)

**Best for:** Visual installation with Xcode installed

**Steps:**
1. Open Xcode
2. Go to `Window` → `Devices and Simulators` (or `⇧⌘2`)
3. Select your connected iOS device
4. Click the `+` button under "Installed Apps"
5. Navigate to and select `build/ios/ipa/mycar.ipa`
6. Click "Open" to install

**Requirements:**
- Xcode installed
- Device unlocked and trusted
- Valid provisioning profile

---

### Method 3: Apple Configurator 2

**Best for:** Managing multiple devices, enterprise deployment

**Steps:**
1. Download Apple Configurator 2 from Mac App Store
2. Connect your iOS device via USB
3. Select the device in Configurator
4. Click `Add` → `Install Apps`
5. Select `build/ios/ipa/mycar.ipa`
6. Click "Install"

**Requirements:**
- Apple Configurator 2 installed
- Device supervision (optional, for enterprise)

---

### Method 4: AltStore (Sideloading)

**Best for:** Personal use without Apple Developer account

**Steps:**
1. Install AltStore on your iPhone from [altstore.io](https://altstore.io)
2. Install AltServer on your Mac
3. Connect iPhone to Mac via USB
4. Open AltStore on your iPhone
5. Tap the `+` button
6. Navigate to and select `build/ios/ipa/mycar.ipa`
7. Enter your Apple ID credentials
8. Wait for installation

**Important Notes:**
- Apps expire after 7 days (must reinstall)
- Requires computer with AltServer for installation
- Free for personal use
- Works without Apple Developer account

---

### Method 5: TestFlight (Beta Distribution)

**Best for:** Beta testing with up to 10,000 users

**Steps:**
1. Build IPA: `flutter build ipa --release`
2. Open Transporter from Mac App Store
3. Sign in with your Apple Developer account
4. Drag the IPA file to Transporter
5. Select "TestFlight" as destination
6. Click "Deliver"
7. Add testers in App Store Connect
8. Testers install TestFlight app and download your app

**Requirements:**
- Apple Developer account ($99/year)
- App configured in App Store Connect
- Testers invited via email or public link

---

### Method 6: Web-based OTA (Enterprise Only)

**Best for:** Enterprise distribution without App Store

**Requirements:**
- Apple Developer Enterprise Program ($299/year)
- Web server for hosting files

**Steps:**

1. **Build with Enterprise profile:**
   ```bash
   flutter build ipa --release --export-options-plist enterprise-export.plist
   ```

2. **Create manifest.plist:**
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>items</key>
       <array>
           <dict>
               <key>assets</key>
               <array>
                   <dict>
                       <key>kind</key>
                       <string>software-package</string>
                       <key>url</key>
                       <string>https://yourserver.com/mycar.ipa</string>
                   </dict>
               </array>
               <key>metadata</key>
               <dict>
                   <key>bundle-identifier</key>
                   <string>com.yourcompany.mycar</string>
                   <key>bundle-version</key>
                   <string>1.0.0</string>
                   <key>kind</key>
                   <string>software</string>
                   <key>title</key>
                   <string>MyCar</string>
               </dict>
           </dict>
       </array>
   </dict>
   </plist>
   ```

3. **Create download webpage:**
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>Install MyCar</title>
       <meta name="viewport" content="width=device-width, initial-scale=1">
       <style>
           body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
           button { padding: 15px 30px; font-size: 18px; background: #007AFF; color: white; border: none; border-radius: 10px; }
       </style>
   </head>
   <body>
       <h1>Install MyCar App</h1>
       <p>Tap the button below to install on your iOS device</p>
       <a href="itms-services://?action=download-manifest&url=https://yourserver.com/manifest.plist">
           <button>Install App</button>
       </a>
   </body>
   </html>
   ```

4. **Host files on your server:**
   - Upload `mycar.ipa`
   - Upload `manifest.plist`
   - Upload the HTML page

5. **Users install by:**
   - Opening the webpage on their iOS device
   - Tapping the "Install App" button
   - Confirming installation

---

## Device Registration (for Ad-hoc)

For Ad-hoc distribution, you must register device UDIDs:

1. Get device UDID:
   - Connect device to Mac
   - Open Xcode → Window → Devices and Simulators
   - Select device → copy identifier
   - Or use: `idevice_id -l` (requires libimobiledevice)

2. Register in Apple Developer Portal:
   - Go to Certificates, Identifiers & Profiles
   - Select "Devices" → "All"
   - Click "+" → Register Device
   - Enter UDID and device name

3. Update provisioning profile:
   - Edit your Ad-hoc provisioning profile
   - Add the new device
   - Download and install the updated profile

---

## Troubleshooting

### "Device is not registered for development"
- Register device UDID in Apple Developer Portal
- Update provisioning profile to include the device
- Rebuild IPA with updated profile

### "Provisioning profile doesn't include signing certificate"
- Ensure your certificate is linked to the provisioning profile
- Re-download the provisioning profile after creating certificate

### "Installation failed" via ios-deploy
- Ensure device is unlocked
- Trust this computer on the device
- Check that device is in development mode

### "App won't open after installation"
- Check that provisioning profile is valid
- Verify bundle identifier matches
- Ensure app is signed correctly

### AltStore installation fails
- Ensure AltServer is running on Mac
- Check that iPhone is connected via USB
- Verify Apple ID credentials are correct
- Try reinstalling AltStore

---

## Build Variants

### Standard Release (App Store/TestFlight):
```bash
flutter build ipa --release
```

### Ad-hoc (specific devices):
```bash
flutter build ipa --release --export-options-plist ad-hoc-export.plist
```

### Enterprise (internal distribution):
```bash
flutter build ipa --release --export-options-plist enterprise-export.plist
```

**Note:** Update `YOUR_TEAM_ID` in the plist files with your actual Apple Developer Team ID from [Apple Developer Portal](https://developer.apple.com/account).

---

## Recommendation

For your MyCar app:
1. **Development/Testing:** Use ios-deploy or Xcode for quick installs
2. **Beta Testing:** Use TestFlight for broader testing
3. **Public Release:** Submit to App Store
4. **Enterprise:** Use OTA web installation if you have Enterprise account

Run the installation script:
```bash
chmod +x install_ipa.sh
./install_ipa.sh
```
