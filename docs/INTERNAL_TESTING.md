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

## Test Matrix

Run the checklist on both:

- One Android emulator
- One physical Android phone

Use at least these three host contexts:

- Chat app: WhatsApp, Telegram, Google Messages, or any SMS/chat field
- Notes or editor: Google Keep, Samsung Notes, or any plain multiline text editor
- Search field: Chrome address bar, Google app search, Play Store search, or another single-line search box

Record the device and host app for every issue. Real device issues take priority over emulator-only polish gaps.

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

## Structured QA Scenarios

### 1. Fresh Install and Enablement

1. Install the APK
2. Open the app
3. Read the privacy note
4. Choose a language pair
5. Enable `Translation Keyboard`
6. Switch to it in a text field

Expected result:

- Onboarding is understandable without outside help
- Keyboard enablement succeeds
- App copy matches what the keyboard actually does

### 2. Typing and IME Controls

Test in each host context:

- Normal typing
- Shift once
- Double-tap shift for caps lock
- Symbols mode
- Backspace tap
- Backspace hold
- Enter, search, or send action depending on field type

Expected result:

- No clipping, layout jumps, or broken key states
- Preview/header height stays usable across apps
- Keys remain responsive and visually stable

### 3. Translation Loop

1. Type a short phrase
2. Pause for about 400 ms
3. Confirm preview appears
4. Tap Apply
5. Delete the text
6. Type the same phrase again

Expected result:

- Preview appears after the pause
- Apply replaces the current draft
- Repeating the same phrase in the same session feels smoother

### 4. Failure Handling

Test at least one failure mode:

- Disable network on emulator or phone
- Use an invalid API key locally if needed for a controlled failure check

Expected result:

- Typing continues normally
- Original text stays intact
- Preview shows the unavailable state without blocking the keyboard

### 5. Settings Persistence

1. Change the language pair
2. Toggle haptics and sound
3. Close and reopen the app
4. Open the keyboard again

Expected result:

- Language pair persists
- Haptic and sound settings persist
- The next input session uses the saved settings

## Bug Report Template

Use this format for every issue:

```md
## QA Bug

- Date:
- Tester:
- Device:
- Android version:
- Environment: Emulator / Physical phone
- Host app:
- Build type: Debug / Release
- Language pair:

### Reproduction steps
1.
2.
3.

### Expected result

### Actual result

### Severity
- Blocker / High / Medium / Low

### Notes
- Screenshots or video:
- Does it reproduce every time:
- Does switching apps or restarting the keyboard change it:
```

## QA Log Template

Keep a running list during the pass:

```md
| ID | Device | Android | Host App | Area | Severity | Status | Summary |
|----|--------|---------|----------|------|----------|--------|---------|
| QA-001 | Pixel emulator | 15 | Chrome search | Preview | Medium | Open | Preview overlaps after long text |
```

## Notes for Testers

- Translation preview is manual. Nothing is auto-sent.
- Typed text is sent to Google Cloud Translation only for live preview.
- Avoid testing with sensitive personal, financial, health, or account information.
