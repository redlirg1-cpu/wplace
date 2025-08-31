#!/bin/bash
set -e

##############################
# CONFIGURATION
##############################

SCHEME_NAME="WebViewGold"
WORKSPACE="./WebViewGold.xcworkspace"
PROJECT="./WebViewGold.xcodeproj"
SHARED_SCHEME_DIR="$WORKSPACE/xcshareddata/xcschemes"
SCHEME_FILE="$SHARED_SCHEME_DIR/$SCHEME_NAME.xcscheme"

##############################
# 1️⃣ Ensure shared scheme exists
##############################

echo "🔍 Checking if scheme exists in workspace..."
if ! xcodebuild -workspace "$WORKSPACE" -list | grep -q "$SCHEME_NAME"; then
    echo "❌ Scheme $SCHEME_NAME not found in workspace. Copying from project..."
    mkdir -p "$SHARED_SCHEME_DIR"
    cp "$PROJECT/xcshareddata/xcschemes/$SCHEME_NAME.xcscheme" "$SHARED_SCHEME_DIR/"
fi

echo "🗂️ Ensuring shared folder exists..."
mkdir -p "$SHARED_SCHEME_DIR"

echo "✏️ Marking scheme as shared..."
if ! grep -q "<Shared>true</Shared>" "$SCHEME_FILE"; then
    sed -i '' 's#</Scheme>#  <Shared>true</Shared>\n</Scheme>#' "$SCHEME_FILE"
fi

##############################
# 2️⃣ Commit changes to Git
##############################

echo "📦 Adding scheme and other changes to Git..."
git add .

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "🌿 Current branch: $CURRENT_BRANCH"

git commit -m "Trigger Xcode Cloud build" || echo "⚠️ Nothing new to commit."
git push origin "$CURRENT_BRANCH"

##############################
# 3️⃣ Optional: Local test build
##############################

echo "✅ Testing local build..."
xcodebuild -workspace "$WORKSPACE" -scheme "$SCHEME_NAME" -configuration Release clean build

echo "🎉 Changes pushed. If your Xcode Cloud workflow is set to 'On push', the build is now triggered."
echo "🔹 To monitor builds: Xcode → Window → Xcode Cloud → Show Builds"
