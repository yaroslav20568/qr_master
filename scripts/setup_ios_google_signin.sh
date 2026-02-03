#!/bin/bash

set -e

echo "📝 Setting up Google Sign-In for iOS..."

IOS_DIR="ios/Runner"
GOOGLE_SERVICE_FILE="$IOS_DIR/GoogleService-Info.plist"
INFO_PLIST="$IOS_DIR/Info.plist"

if [ ! -f "$GOOGLE_SERVICE_FILE" ]; then
  echo "⚠️  GoogleService-Info.plist not found at $GOOGLE_SERVICE_FILE"
  echo "📋 Please download it from Firebase Console:"
  echo "   1. Go to https://console.firebase.google.com/"
  echo "   2. Select your project: qr-master-91ec2"
  echo "   3. Go to Project Settings > General"
  echo "   4. Download GoogleService-Info.plist for iOS"
  echo "   5. Place it at: $GOOGLE_SERVICE_FILE"
  exit 1
fi

echo "✅ GoogleService-Info.plist found"

if command -v plutil &> /dev/null; then
  REVERSED_CLIENT_ID=$(plutil -extract REVERSED_CLIENT_ID raw "$GOOGLE_SERVICE_FILE" 2>/dev/null || echo "")
fi

if [ -z "$REVERSED_CLIENT_ID" ] && command -v /usr/libexec/PlistBuddy &> /dev/null; then
  REVERSED_CLIENT_ID=$(/usr/libexec/PlistBuddy -c "Print :REVERSED_CLIENT_ID" "$GOOGLE_SERVICE_FILE" 2>/dev/null || echo "")
fi

if [ -z "$REVERSED_CLIENT_ID" ]; then
  REVERSED_CLIENT_ID=$(grep -A 1 "REVERSED_CLIENT_ID" "$GOOGLE_SERVICE_FILE" | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>.*/\1/' | sed 's/[[:space:]]*//' | head -1)
fi

if [ -z "$REVERSED_CLIENT_ID" ]; then
  echo "❌ Could not extract REVERSED_CLIENT_ID from GoogleService-Info.plist"
  echo "📋 Please check that GoogleService-Info.plist is valid"
  exit 1
fi

echo "✅ REVERSED_CLIENT_ID extracted: $REVERSED_CLIENT_ID"

if grep -q "GOOGLE_REVERSED_CLIENT_ID_PLACEHOLDER" "$INFO_PLIST"; then
  echo "📝 Injecting REVERSED_CLIENT_ID into Info.plist..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|GOOGLE_REVERSED_CLIENT_ID_PLACEHOLDER|$REVERSED_CLIENT_ID|g" "$INFO_PLIST"
  else
    sed -i "s|GOOGLE_REVERSED_CLIENT_ID_PLACEHOLDER|$REVERSED_CLIENT_ID|g" "$INFO_PLIST"
  fi
  echo "✅ REVERSED_CLIENT_ID injected into Info.plist"
else
  echo "ℹ️  Info.plist already has REVERSED_CLIENT_ID or placeholder not found"
fi

echo "✅ Google Sign-In setup completed"
