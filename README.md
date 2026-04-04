# FlowLingo

![FlowLingo app preview](./image.png)

FlowLingo is an Android translation keyboard that lets users draft translated messages directly inside any text field. It combines a native Kotlin IME for keyboard behavior with a Flutter app shell for onboarding, privacy guidance, and settings.

## What It Does

- translates drafts inside Android text fields
- shows a live translated preview after a short pause
- lets the user apply the translated draft manually
- keeps typing responsive even when translation is unavailable

## Current MVP

- native Android keyboard built with `InputMethodService`
- Flutter onboarding, settings, and privacy screens
- live translation preview through Google Cloud Translation
- language-pair persistence
- keyboard support for shift, caps lock, symbols, and repeat backspace

## Privacy

FlowLingo does not store typed text in local files, app settings, or logs. The active draft exists only in memory during the current keyboard session. Translation requests are sent only to generate the preview shown to the user.

Read the full policy in [PRIVACY_POLICY.md](./PRIVACY_POLICY.md).

## Getting Started

### Requirements

- Flutter SDK
- Android Studio with Android SDK
- JDK 17+
- Android emulator or physical Android device
- Google Cloud project with Translation API enabled

### Configure the API key

Create `lib/config/secrets.dart` locally:

```dart
class Secrets {
  const Secrets._();

  static const String googleTranslateApiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
}
```

### Install dependencies

```powershell
C:\flutter\bin\flutter.bat pub get
```

### Run the app

```powershell
C:\flutter\bin\flutter.bat run
```

### Enable the keyboard

1. Open the app on an Android device or emulator.
2. Go to Android keyboard or input settings.
3. Enable `Translation Keyboard`.
4. Switch to it inside any text field.

## Internal Testing

- [Product overview](./docs/PRODUCT_OVERVIEW.md)
- [Internal testing guide](./docs/INTERNAL_TESTING.md)
- [QA bug template](./docs/QA_BUG_TEMPLATE.md)

## Notes

Do not commit:

- `android/local.properties`
- `android/key.properties`
- `lib/config/secrets.dart`
- signing keys / `*.jks`
