# iOS Installer & Distribution Guide

iOS doesn't have traditional "installers" like Windows .exe files. Instead, apps are distributed through several methods:

## Distribution Methods

### 1. App Store (Public Distribution)
**Best for:** Public apps available to all users

**Steps:**
1. Build IPA: `flutter build ipa`
2. Upload via Transporter to App Store Connect
3. Configure app listing (screenshots, description, etc.)
4. Submit for Apple review
5. After approval, users download from App Store

**Pros:** 
- Official distribution channel
- Automatic updates
- Trust and security

**Cons:**
- Requires Apple review (1-3 days)
- $99/year developer fee
- Must follow Apple guidelines

---

### 2. TestFlight (Beta Testing)
**Best for:** Testing with up to 10,000 users before public release

**Steps:**
1. Build IPA: `flutter build ipa`
2. Upload via Transporter as TestFlight build
3. Add testers in App Store Connect
4. Testers install TestFlight app
5. Send public link or invite specific users

**Pros:**
- No Apple review for internal testing
- Up to 10,000 testers
- Crash reports and analytics
- Easy updates

**Cons:**
- Requires Apple Developer account
- TestFlight app required
- 90-day expiration for external testers

---

### 3. Ad-hoc Distribution (Direct Installation)
**Best for:** Testing on specific registered devices

**Steps:**
1. Register device UDIDs in Apple Developer Portal (max 100 devices/year)
2. Create Ad-hoc provisioning profile
3. Build IPA with Ad-hoc profile
4. Install via:
   - Xcode → Window → Devices and Simulators
   - `ios-deploy` command line tool
   - Apple Configurator 2

**Installation via command line:**
```bash
# Install ios-deploy
npm install -g ios-deploy

# Install IPA to connected device
ios-deploy --bundle build/ios/ipa/mycar.ipa
```

**Pros:**
- Direct installation without App Store
- Good for QA testing

**Cons:**
- Device registration required
- Max 100 devices per year
- Requires physical access or device UDID

---

### 4. Enterprise Distribution (Internal Company Use)
**Best for:** Distributing apps within an organization

**Requirements:**
- Apple Developer Enterprise Program ($299/year)
- Cannot submit to App Store

**Steps:**
1. Create Enterprise provisioning profile
2. Build IPA with Enterprise profile
3. Distribute via:
   - Company website (OTA installation)
   - Mobile Device Management (MDM)
   - Direct IPA distribution

**Web-based OTA Installation:**
Create a webpage with download link:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Install MyCar App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <h1>Install MyCar App</h1>
    <a href="itms-services://?action=download-manifest&url=https://yourserver.com/manifest.plist">
        <button>Install App</button>
    </a>
</body>
</html>
```

Create `manifest.plist`:
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

**Pros:**
- Unlimited devices within organization
- No App Store review
- Direct distribution control

**Cons:**
- $299/year Enterprise fee
- Cannot distribute publicly
- Apple can revoke if misused

---

### 5. Sideloading (Alternative Methods)
**Best for:** Personal use or testing without Apple Developer account

**Options:**
- **AltStore** (requires computer)
- **SideStore** (self-hosted AltStore)
- **Sideloadly** (Windows/Mac)
- **Cydia Impactor** (older method)

**Example with AltStore:**
1. Install AltStore on iPhone
2. Build IPA: `flutter build ipa`
3. Open AltStore on computer
4. Connect iPhone and install IPA via AltStore

**Pros:**
- No Apple Developer account needed
- Free for personal use

**Cons:**
- Apps expire in 7 days (need to reinstall)
- Requires computer for installation
- Not suitable for distribution

---

## Quick Start Scripts

### Build for different distributions:

```bash
# App Store / TestFlight
flutter build ipa --release

# Ad-hoc (requires specific provisioning profile)
flutter build ipa --release --export-options-plist ad-hoc-options.plist

# Enterprise (requires enterprise profile)
flutter build ipa --release --export-options-plist enterprise-options.plist
```

### Export options plist for Ad-hoc:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

### Export options plist for Enterprise:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>enterprise</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

## Recommendation

For your MyCar app:
1. **Use TestFlight** for beta testing with friends/family
2. **Submit to App Store** for public distribution
3. **Consider Enterprise** only if distributing within a company

Run the distribution script:
```bash
chmod +x ios_distribution.sh
./ios_distribution.sh
```
