# Firebase Distribution · PoC

This project demonstrates how to integrate **Firebase App Distribution** into an iOS app with **minimal configuration**, avoiding the use of tools like `Fastlane` (and its Ruby dependencies).
The goal is to keep the setup **lightweight and CI/CD-friendly**.

---

## What's Required?

To distribute via Firebase, only a few things are needed:

1. Firebase CLI installed (also required in the CI/CD environment)
2. A registered Firebase project with a matching **Bundle ID**
3. A **secure Firebase CI token** for authentication during upload

> ⚠️ You **do not need** to add any Firebase SDKs or packages to your iOS app!

---

## 🚀 Step 1: Create and Configure a Firebase Project

Open https://console.firebase.google.com/projectcreate
Create a project and register your iOS app with the correct **Bundle ID**.

---

## Step 2: Install and Update Firebase CLI

```sh
# Check if Firebase CLI is already installed
which firebase

# Upgrade if already installed
curl -sL firebase.tools | upgrade=true bash

# Install Firebase CLI (if not installed)
curl -sL https://firebase.tools | bash
```

---

## Step 3: Authenticate

```sh
# Interactive login
firebase login

# For CI/CD: generate a reusable token
firebase login:ci
# Example output:
# ✔  Success! Use this token to login on a CI server:
# 1//0fbIv2iwfGVL-L9IrkKx2rtf_wNxs-XZ5vu4ISSq__yuQSexKAdKwlsiYEa4Q
```

> 💡 Store the token as `FB_TOKEN` in a `.env` file or secure secret store

---

## Step 4: Build the IPA

```sh
#!/bin/bash

APP_NAME="FBDistributionPoC"
XC_PROJ_NAME="$APP_NAME.xcodeproj"
XC_PROJ_SCHEMA="FBDistributionPoC"
XC_PROJ_CONFIG="Release"
BUILD_OUTPUT="./build"
ARCHIVE="$BUILD_OUTPUT/$APP_NAME.xcarchive"

# Clean previous builds
xcodebuild clean -project "$XC_PROJ_NAME" -scheme "$XC_PROJ_SCHEMA" -configuration "$XC_PROJ_CONFIG"

# Archive the app
xcodebuild archive \
  -project "$XC_PROJ_NAME" \
  -scheme "$XC_PROJ_SCHEMA" \
  -archivePath "$ARCHIVE" \
  -configuration "$XC_PROJ_CONFIG" \
  -destination 'generic/platform=iOS'

# Export IPA from the archive
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE" \
  -exportOptionsPlist ./ExportOptions.plist \
  -exportPath "$BUILD_OUTPUT" \
  -allowProvisioningUpdates
```

Make sure you have a valid `ExportOptions.plist`. For example:

```xml
<plist version="1.0">
<dict>
  <key>method</key>
  <string>ad-hoc</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>stripSwiftSymbols</key>
  <true/>
  <key>compileBitcode</key>
  <false/>
</dict>
</plist>
```

---

## Step 5: Upload `.ipa` to Firebase Distribution

```sh
firebase appdistribution:distribute "$IPA_FILE" \
    --app "$FB_APP_ID" \
    --release-notes-file "$RELEASE_NOTES_FILE" \
    --groups "$FB_TESTER_GROUP" \
    --token "$FB_TOKEN"
```

---

## Recommended: Use a `.env` file

Keep sensitive and project-specific values out of your script:

```env
FB_TOKEN=1//abc123secure
FB_APP_ID=1:1234567890:ios:abcdef123456
FB_TESTER_GROUP=internal-testers
RELEASE_NOTES_FILE=release_notes.txt
IPA_FILE=./build/FBDistributionPoC.ipa
```

Then source the file in your script:

```sh
source .env
```

