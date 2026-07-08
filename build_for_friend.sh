#!/bin/bash

# Build MyCar app for sharing with friend
# Creates IPA file that can be shared via cloud storage

set -e

echo "📱 Building MyCar for friend..."
echo "================================"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📥 Getting dependencies..."
flutter pub get

# Build IPA
echo "🔨 Building IPA file..."
flutter build ipa --release

IPA_PATH="build/ios/ipa/mycar.ipa"

if [ -f "$IPA_PATH" ]; then
    echo "✅ Build successful!"
    echo "📦 IPA file: $IPA_PATH"
    echo "📊 File size: $(du -h "$IPA_PATH" | cut -f1)"
    echo ""
    echo "📤 How to share with friend:"
    echo "1. Upload the IPA file to:"
    echo "   - Google Drive"
    echo "   - Dropbox"
    echo "   - iCloud Drive"
    echo "   - Telegram"
    echo "   - WeTransfer"
    echo ""
    echo "2. Send the download link to your friend"
    echo ""
    echo "📲 Friend can install via:"
    echo ""
    echo "Option A - TestFlight (Recommended):"
    echo "  - Requires Apple Developer Account (\$99/year)"
    echo "  - Upload IPA via Transporter to App Store Connect"
    echo "  - Invite friend to TestFlight"
    echo "  - Friend installs from TestFlight app"
    echo ""
    echo "Option B - AltStore (Free):"
    echo "  - Friend needs computer with AltServer"
    echo "  - Friend installs AltStore on iPhone"
    echo "  - Friend connects iPhone to computer"
    echo "  - Friend installs IPA via AltStore"
    echo "  - App expires in 7 days (needs reinstall)"
    echo ""
    echo "Option C - Ad-hoc (Apple Developer needed):"
    echo "  - Get friend's device UDID"
    echo "  - Register device in Apple Developer Portal"
    echo "  - Friend installs via Xcode or ios-deploy"
    echo ""
    echo "📖 For detailed instructions, see: share_with_friend.md"
else
    echo "❌ Build failed - IPA file not found"
    exit 1
fi
