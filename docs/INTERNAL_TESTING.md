# Internal Testing Guide

## Goal

This build is for private Android testing before Play Store beta. The focus is keyboard stability, translation preview quality, and first-use onboarding clarity.

## Prerequisites

- Flutter installed and working
- Android Studio SDK/JDK installed
- `lib/config/secrets.dart` present with a valid Google Cloud Translation API key
- Optional release keystore outside the repo

## Release Signing Setup

1. Copy `android/key.properties.example` to `android/key.properties`
2. Fill in the real keystore path, alias, and passwords
3. Keep `android/key.properties` and the keystore file out of version control

If `android/key.properties` is missing, release builds fall back to debug signing so internal APK/AAB generation still works locally.

## Build Commands (Windows)

From the repo root:

```powershell
C:\flutter\bin\flutter.bat analyze
C:\flutter\bin\flutter.bat test
cmd /c "set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr&& cd android && gradlew.bat app:assembleRelease --console=plain"
C:\flutter\bin\flutter.bat build apk --release
C:\flutter\bin\flutter.bat build appbundle --release
```

## Tester Install Flow

1. Install the generated APK on an Android phone or emulator
2. Open FlowLingo once
3. Pick the active language pair in Settings
4. Read the privacy note before enabling the keyboard
5. Open Android keyboard settings and enable `Translation Keyboard`
6. Switch to `Translation Keyboard` in any text field

## Manual QA Checklist

- Fresh install opens onboarding without a crash
- Settings persist the selected language pair
- Privacy note is visible in the app before keyboard enablement
- Keyboard can be enabled and selected successfully
- Typing works in at least three host apps or field types
- Preview appears after a 400 ms typing pause
- Apply replaces the current draft with the translated result
- Shift, caps lock, symbols, backspace repeat, enter/search/send actions still work
- Translation failures keep typing intact and show the calm unavailable state
- Haptic and sound settings affect the keyboard on the next input session
- No typed content is written to logs or local storage by the app

## Notes for Testers

- Translation preview is manual. Nothing is auto-sent.
- Typed text is sent to Google Cloud Translation only for live preview.
- Avoid testing with sensitive personal, financial, health, or account information.
