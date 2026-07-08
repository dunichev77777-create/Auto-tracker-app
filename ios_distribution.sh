#!/bin/bash

# iOS Distribution Script
# Creates different distribution types for iOS app

set -e

echo "🍎 iOS Distribution Options"
echo "============================"
echo ""
echo "Select distribution type:"
echo "1) App Store Release (for public distribution)"
echo "2) TestFlight (for beta testing)"
echo "3) Ad-hoc (for testing on specific devices)"
echo "4) Enterprise (for internal company distribution)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "📱 Building for App Store Release..."
        flutter build ipa --release
        echo "✅ App Store IPA created: build/ios/ipa/mycar.ipa"
        echo "Upload via Transporter to App Store Connect"
        ;;
    2)
        echo "🧪 Building for TestFlight..."
        flutter build ipa --release
        echo "✅ TestFlight IPA created: build/ios/ipa/mycar.ipa"
        echo "Upload via Transporter as TestFlight build"
        ;;
    3)
        echo "📱 Building Ad-hoc distribution..."
        flutter build ipa --release
        echo "✅ Ad-hoc IPA created: build/ios/ipa/mycar.ipa"
        echo "Note: Requires devices registered in Apple Developer Portal"
        echo "Install via Xcode or ios-deploy"
        ;;
    4)
        echo "🏢 Building Enterprise distribution..."
        flutter build ipa --release
        echo "✅ Enterprise IPA created: build/ios/ipa/mycar.ipa"
        echo "Note: Requires Enterprise Developer Account ($299/year)"
        echo "Can be distributed via website, MDM, or directly"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "📋 Next steps:"
echo "1. Open Transporter from Mac App Store"
echo "2. Sign in with your Apple ID"
echo "3. Upload the IPA file"
echo "4. Follow the specific instructions for your distribution type"
