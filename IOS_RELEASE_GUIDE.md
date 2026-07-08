# iOS Release Guide (Without Xcode GUI)

## Prerequisites

1. **Mac with Xcode installed** (command line tools required)
   ```bash
   xcode-select --install
   ```

2. **Apple Developer Account** ($99/year)
   - Sign up at https://developer.apple.com

3. **CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

4. **Flutter** (already installed if you're developing)

## Step 1: Configure Bundle Identifier

Your current bundle identifier needs to be unique. Update it in:

**Option A: Via pubspec.yaml (Flutter managed)**
- The bundle ID is automatically set by Flutter based on your project name

**Option B: Manual configuration**
- Open `ios/Runner.xcodeproj/project.pbxproj` 
- Find `PRODUCT_BUNDLE_IDENTIFIER` and change it to something like `com.yourcompany.mycar`

## Step 2: Create Certificates & Provisioning Profiles

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to: Certificates, Identifiers & Profiles
3. Create App ID with your bundle identifier
4. Create Distribution Certificate
5. Create Provisioning Profile for App Store

## Step 3: Build IPA

Run the automated build script:
```bash
chmod +x ios_build.sh
./ios_build.sh
```

Or manually:
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter build ipa
```

The IPA file will be created at: `build/ios/ipa/mycar.ipa`

## Step 4: Upload to App Store Connect

### Option A: Using Transporter (Recommended)
1. Download Transporter from Mac App Store
2. Open Transporter and sign in with your Apple ID
3. Drag the `.ipa` file to Transporter
4. Click "Deliver" to upload

### Option B: Using Command Line
```bash
xcrun altool --upload-app --type ios --file build/ios/ipa/mycar.ipa --username YOUR_APPLE_ID --password YOUR_APP_SPECIFIC_PASSWORD
```

Note: You need to generate an app-specific password at https://appleid.apple.com

## Step 5: Configure in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create a new app with your bundle identifier
3. Fill in:
   - App information
   - Pricing and availability
   - App privacy details
4. Upload screenshots (required sizes)
5. Add app description
6. Submit for review

## Troubleshooting

### "No signing certificate found"
- Make sure you've created a Distribution Certificate in Apple Developer Portal
- Download and install the certificate in your Keychain Access

### "Provisioning profile doesn't include signing certificate"
- Ensure your provisioning profile is linked to the correct certificate
- Re-download the provisioning profile after creating the certificate

### "Bundle identifier conflicts"
- Your bundle ID must be unique across all App Store apps
- Change it to something specific to your company

### Build fails on `pod install`
- Update CocoaPods: `sudo gem install cocoapods`
- Update pods: `pod repo update`

## Version Management

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+2  # versionName+versionCode
```

- `1.0.0` is the version number shown to users
- `2` is the build number (must increase with each release)

## Testing Before Release

Test on a physical device:
```bash
flutter build ios --release
# Then install via Xcode or ios-deploy
```

Or create TestFlight build for internal testing:
```bash
flutter build ipa
# Upload via Transporter as "TestFlight" instead of "App Store"
```
