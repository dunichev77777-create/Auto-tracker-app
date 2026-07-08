#!/bin/bash

# iOS Build Script for Flutter without Xcode GUI
# This script helps build and prepare iOS release

set -e

echo "🚀 Starting iOS build process..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode command line tools not found"
    echo "Install with: xcode-select --install"
    exit 1
fi

# Navigate to iOS directory
cd ios

# Install CocoaPods dependencies
echo "📦 Installing CocoaPods dependencies..."
if command -v pod &> /dev/null; then
    pod install
else
    echo "⚠️  CocoaPods not found. Install with: sudo gem install cocoapods"
    exit 1
fi

# Go back to project root
cd ..

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📥 Getting Flutter dependencies..."
flutter pub get

# Build IPA for release
echo "🔨 Building iOS release IPA..."
flutter build ipa

echo "✅ Build complete!"
echo "📦 IPA file location: build/ios/ipa/mycar.ipa"
echo ""
echo "Next steps:"
echo "1. Download Transporter from Mac App Store"
echo "2. Open Transporter and sign in with your Apple ID"
echo "3. Drag the IPA file to Transporter"
echo "4. Click 'Deliver' to upload to App Store Connect"
echo ""
echo "Or upload via command line with:"
echo "xcrun altool --upload-app --type ios --file build/ios/ipa/mycar.ipa --username YOUR_APPLE_ID --password YOUR_APP_SPECIFIC_PASSWORD"
