#!/bin/bash

# IPA Installation Script
# Installs IPA file to connected iOS device

set -e

echo "📱 IPA Installation Script"
echo "=========================="

# Check if IPA file exists
IPA_PATH="build/ios/ipa/mycar.ipa"
if [ ! -f "$IPA_PATH" ]; then
    echo "❌ IPA file not found at: $IPA_PATH"
    echo "Building IPA first..."
    flutter build ipa --release
fi

echo "📦 IPA file: $IPA_PATH"

# Check for connected devices
echo ""
echo "🔍 Checking for connected iOS devices..."

if command -v idevice_id &> /dev/null; then
    DEVICES=$(idevice_id -l)
    if [ -z "$DEVICES" ]; then
        echo "❌ No iOS devices found via libimobiledevice"
    else
        echo "✅ Found devices:"
        echo "$DEVICES"
    fi
else
    echo "⚠️  libimobiledevice not installed"
    echo "Install with: brew install libimobiledevice"
fi

echo ""
echo "Choose installation method:"
echo "1) ios-deploy (command line tool)"
echo "2) Xcode (Devices and Simulators)"
echo "3) Apple Configurator 2"
echo "4) AltStore (sideloading)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "📥 Installing via ios-deploy..."
        if ! command -v ios-deploy &> /dev/null; then
            echo "❌ ios-deploy not found"
            echo "Install with: npm install -g ios-deploy"
            exit 1
        fi
        ios-deploy --bundle "$IPA_PATH"
        echo "✅ Installation complete!"
        ;;
    2)
        echo "📱 To install via Xcode:"
        echo "1. Open Xcode"
        echo "2. Go to Window → Devices and Simulators"
        echo "3. Select your connected device"
        echo "4. Click '+' under 'Installed Apps'"
        echo "5. Select: $IPA_PATH"
        echo "6. Click 'Open' to install"
        ;;
    3)
        echo "🏢 To install via Apple Configurator 2:"
        echo "1. Download Apple Configurator 2 from Mac App Store"
        echo "2. Connect your iOS device"
        echo "3. Select the device in Configurator"
        echo "4. Click 'Add' → 'Install Apps'"
        echo "5. Select: $IPA_PATH"
        ;;
    4)
        echo "🔄 To install via AltStore:"
        echo "1. Install AltStore on your iPhone (altstore.io)"
        echo "2. Install AltServer on your Mac"
        echo "3. Connect iPhone to Mac"
        echo "4. Open AltStore on iPhone"
        echo "5. Tap the '+' button"
        echo "6. Select: $IPA_PATH"
        echo "Note: App expires in 7 days, requires reinstall"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "⚠️  Important notes:"
echo "- Device must be registered in Apple Developer Portal for Ad-hoc builds"
echo "- For TestFlight/App Store builds, use Transporter instead"
echo "- AltStore works without Apple Developer account but apps expire"
