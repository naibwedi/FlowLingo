# FlowLingo

FlowLingo is an Android-first translation keyboard built with a native Kotlin IME and a Flutter app shell. The keyboard lets users type in any Android text field, preview a translated draft above the keyboard, and apply that draft before sending.

The current build is focused on MVP keyboard infrastructure and a live translation loop:
- native Android `InputMethodService` keyboard
- Flutter onboarding and settings UI
- persisted language-pair selection
- Google Cloud Translation preview over a native/Flutter bridge
- polished keyboard layout with shift, caps lock, symbols, repeat backspace, and action-key icons
- tester-facing privacy note and internal-testing docs

## Stack

- Android keyboard: Kotlin + `InputMethodService`
- App UI: Flutter
- Native bridge: `MethodChannel`
- Local settings: Hive
- Subscriptions: `purchases_flutter` / RevenueCat
- Translation backend: Google Cloud Translation API

## Current State

Implemented:
- Flutter app scaffold with localization
- onboarding screen and settings screen
- language-pair persistence
- native IME registration and keyboard lifecycle
- debounced preview pipeline from native to Flutter
- live Google translation for preview/apply
- keyboard preview panel and production-style visual polish

Not implemented yet:
- premium entitlements and paywall flow
- offline translation
- Play Store release assets and public policy hosting

## Project Structure

```text
flowlingo/
├── android/app/src/main/kotlin/com/flowlingo/
│   ├── AppApplication.kt
│   ├── AppImeService.kt
│   ├── MainActivity.kt
│   └── TranslationChannel.kt
├── android/app/src/main/res/
│   ├── layout/keyboard_view.xml
│   ├── values/
│   ├── drawable/
│   └── xml/method.xml
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── services/
│   └── ui/
├── l10n/
├── test/
├── CLAUDE.md
└── CODEX_BRIEF.md
```

## How It Works

1. The user types inside any Android app.
2. `AppImeService` captures the current in-memory draft.
3. After a 400 ms pause, the IME sends the draft to Flutter through `com.app.translation`.
4. Flutter calls Google Cloud Translation and returns the translated result.
5. The native preview panel shows the candidate above the keyboard.
6. The user taps the apply action to replace the typed draft with the preview.

Important privacy rule:
- typed text is not stored in Hive, files, or logs
- current input only lives in memory during the active keyboard session

## Getting Started

### Requirements

- Flutter SDK installed
- Android Studio with Android SDK
- JDK 17+
- Android emulator or physical Android device
- Google Cloud project with Translation API enabled

### Install dependencies

```powershell
C:\flutter\bin\flutter.bat pub get
```

### Configure translation secrets

Create `lib/config/secrets.dart` with a valid Google Cloud Translation API key:

```dart
class Secrets {
  const Secrets._();

  static const String googleTranslateApiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
}
```

### Run the Flutter app

```powershell
C:\flutter\bin\flutter.bat run
```

### Enable the keyboard

1. Install and open the app on an Android emulator or phone.
2. Open Android Settings.
3. Go to keyboard/input settings.
4. Enable `Translation Keyboard`.
5. Switch to it in any text field.

### Read the privacy note

Before enabling the keyboard, testers should review:

- [Privacy policy](./PRIVACY_POLICY.md)
- [Internal testing guide](./docs/INTERNAL_TESTING.md)

The keyboard sends the current in-memory draft to Google Cloud Translation for live preview. FlowLingo does not store typed text locally.

## Internal Testing Builds

Use `android/key.properties.example` as the template for a local signing file:

1. Copy it to `android/key.properties`
2. Fill in your real keystore details
3. Keep both the keystore and `android/key.properties` outside version control

If `android/key.properties` is missing, release builds fall back to debug signing so local internal testing can still proceed.

Build commands:

```powershell
C:\flutter\bin\flutter.bat analyze
C:\flutter\bin\flutter.bat test
cmd /c "set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr&& cd android && gradlew.bat app:assembleRelease --console=plain"
C:\flutter\bin\flutter.bat build apk --release
C:\flutter\bin\flutter.bat build appbundle --release
```

## Verification

Static checks used during development:

```powershell
C:\flutter\bin\flutter.bat analyze
C:\flutter\bin\flutter.bat test
cmd /c "set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr&& cd android && gradlew.bat app:assembleDebug --console=plain"
cmd /c "set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr&& cd android && gradlew.bat app:assembleRelease --console=plain"
C:\flutter\bin\flutter.bat build apk --release
C:\flutter\bin\flutter.bat build appbundle --release
```

## Secrets

Do not commit:
- `android/local.properties`
- `android/key.properties`
- `lib/config/secrets.dart`
- signing keys / `*.jks`

## Next Major Step

Run internal Android testing, collect onboarding and keyboard QA feedback, and fix release blockers before monetization work.
