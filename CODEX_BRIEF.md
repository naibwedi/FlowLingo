# KeyLingo — Codex Agent Brief

This document is a complete briefing for an AI coding assistant helping build KeyLingo from scratch. Read it fully before writing any code.

---

## What We Are Building

KeyLingo is an Android translation keyboard app. As the user types in any app (WhatsApp, Telegram, SMS, etc.), their message is translated in real time before they hit send. No copy-pasting. The keyboard integrates at the OS level using Android's `InputMethodService`.

**Primary market:** Ethiopian and Eritrean communities

**Target languages (MVP):** Amharic (`am`) and Tigrinya (`ti`)

**Business model:** Free tier + Premium ($3.99/month via RevenueCat)

**Platform:** Android only. Do not suggest iOS.

---

## Final Tech Stack (decisions are locked, do not re-suggest alternatives)

| Layer | Technology | Why |
| --- | --- | --- |
| Keyboard IME | Kotlin + InputMethodService | Hard requirement — Flutter cannot own the IME lifecycle |
| UI / Settings | Flutter (Dart) | Fast UI, single codebase, good MethodChannel bridge to Kotlin |
| Flutter ↔ Native bridge | MethodChannel | Standard Flutter/Android IPC |
| Translation (primary) | Google Cloud Translation API | 500k free chars/month, permanent free tier, supports all target languages |
| Translation (upgrade) | Azure Translator | $10/1M chars — switch when Google free tier runs out |
| Translation (premium feature) | Lesan AI | Best quality for Amharic/Tigrinya, €20/1M, gated behind paywall |
| Translation trigger | Debounce 400ms after last keystroke | Balances feel vs. API cost |
| Local storage | Hive (Flutter) | Fast key-value, perfect for preferences + vocabulary cache |
| Subscriptions | RevenueCat | Handles Google Play Billing complexity for solo founder |
| Secrets | lib/config/secrets.dart (gitignored) | Never commit API keys |

**Why NOT DeepL:** Does not support Amharic, Tigrinya, Hindi, Bengali, Urdu, Tagalog, or Swahili. Do not suggest it.

---

## Project File Structure

```text
keylingo/
├── android/
│   └── app/
│       ├── src/main/
│       │   ├── kotlin/com/keylingo/
│       │   │   ├── KeyLingoIME.kt          ← InputMethodService (the keyboard)
│       │   │   └── TranslationChannel.kt    ← MethodChannel bridge to Flutter
│       │   ├── res/
│       │   │   ├── xml/
│       │   │   │   └── method.xml           ← IME metadata
│       │   │   └── layout/
│       │   │       └── keyboard_view.xml    ← Keyboard layout XML
│       │   └── AndroidManifest.xml
│       └── build.gradle
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── secrets.dart                     ← gitignored, holds API keys
│   ├── services/
│   │   ├── translation_service.dart         ← Google Cloud Translation API calls
│   │   ├── language_detector.dart           ← Auto-detect input language
│   │   └── subscription_service.dart        ← RevenueCat
│   ├── models/
│   │   ├── language_pair.dart
│   │   └── translation_result.dart
│   └── ui/
│       ├── settings_screen.dart
│       ├── language_picker.dart
│       └── onboarding_screen.dart
├── l10n/
│   ├── app_en.arb
│   └── app_am.arb
├── CLAUDE.md
├── CODEX_BRIEF.md
└── pubspec.yaml
```

---

## Architecture: How Keyboard + Flutter Work Together

```text
User types in any app
        ↓
KeyLingoIME.kt (InputMethodService)
  - Intercepts keystrokes
  - Buffers current input
  - After 400ms debounce → sends text via MethodChannel to Flutter
        ↓
TranslationChannel.kt
  - Receives text from IME
  - Calls Flutter via MethodChannel: "translate" method
        ↓
translation_service.dart (Flutter)
  - Calls Google Cloud Translation REST API
  - Returns translated string
        ↓
TranslationChannel.kt
  - Receives result from Flutter
  - Passes back to KeyLingoIME.kt
        ↓
KeyLingoIME.kt
  - Displays translation above keyboard (suggestion strip)
  - User taps "Send translated" → replaces input with translation
```

**Critical rules:**

- Never log or persist the text the user is typing. Privacy is a core promise.
- The IME layer (Kotlin) owns keystroke capture and suggestion strip display.
- Flutter owns API calls, settings, and business logic.
- They communicate only via MethodChannel — never direct calls.

---

## Google Cloud Translation API Integration

**Endpoint:**

```text
POST https://translation.googleapis.com/language/translate/v2?key={API_KEY}
```

**Request body:**

```json
{
  "q": "Hello, how are you?",
  "target": "am",
  "format": "text"
}
```

**Response:**

```json
{
  "data": {
    "translations": [
      { "translatedText": "ሰላም፣ እንዴት ነህ?", "detectedSourceLanguage": "en" }
    ]
  }
}
```

**Language codes:** Amharic = `am`, Tigrinya = `ti`

**Auto-detect source language:** omit the `source` field — Google detects automatically.

**Store key in `lib/config/secrets.dart`:**

```dart
class Secrets {
  static const String googleTranslateApiKey = 'YOUR_KEY_HERE';
}
```

---

## MVP Build Milestones

### Milestone 1 — Flutter project scaffold

- Run `flutter create keylingo --org com.keylingo`
- Add dependencies to `pubspec.yaml`: `hive`, `hive_flutter`, `http`, `purchases_flutter`, `flutter_localizations`
- Set up `l10n` with English + Amharic ARB files
- Create folder structure as above
- Add `.gitignore` entries for `local.properties`, `secrets.dart`, `*.jks`

### Milestone 2 — Android IME skeleton

- Register `KeyLingoIME` in `AndroidManifest.xml` as a `<service>` with `android.permission.BIND_INPUT_METHOD`
- Create `res/xml/method.xml` with IME metadata
- Implement `KeyLingoIME.kt` extending `InputMethodService`:
  - Override `onCreateInputView()` — return keyboard layout
  - Override `onStartInputView()` — reset state
  - Capture key events and buffer input
  - Debounce 400ms then trigger translation via MethodChannel
- Implement `TranslationChannel.kt` with `MethodChannel("com.keylingo/translation")`

### Milestone 3 — Translation service

- Implement `translation_service.dart`:
  - `Future<TranslationResult> translate(String text, String targetLang)`
  - Uses `http` package to call Google Cloud Translation API
  - Returns `TranslationResult` model
- Implement `language_detector.dart`:
  - Detects Ethiopic script → Amharic/Tigrinya, Latin → English, etc.
  - Falls back to Google auto-detect
- Wire MethodChannel in `main.dart` to handle calls from Kotlin

### Milestone 4 — Settings UI

- `settings_screen.dart`: target language picker, source language toggle, subscription status
- `language_picker.dart`: list of supported language pairs (MVP: 5 pairs)
- `onboarding_screen.dart`: guide user to enable keyboard in Android settings
- Persist settings with Hive

### Milestone 5 — Subscription / Premium

- Set up RevenueCat with Google Play product IDs
- `subscription_service.dart`: check entitlement, purchase, restore
- Free tier: Amharic ↔ English, Tigrinya ↔ English, + 3 more pairs
- Premium gates: expansion languages + Lesan AI quality engine + offline packs

### Milestone 6 — Polish + Play Store

- App icon, splash screen
- Privacy policy (mandatory for keyboard apps — you handle keystrokes)
- Play Store listing: screenshots, description, content rating
- Release build: `flutter build appbundle --release`
- Sign with keystore stored outside repo

---

## Coding Conventions

- **Dart:** `async/await` not raw Futures. No hardcoded user-facing strings — use `l10n/`.
- **Kotlin:** Coroutines for async, not callbacks.
- **No ads anywhere** — this is a key differentiator for the product.
- **No storing user-typed text** — not in logs, not in Hive, not in analytics. Only sent to Google for translation and immediately discarded.
- **Keep it simple** — solo founder project, MVP mindset. No over-engineering.

---

## What NOT To Do

- Do not suggest iOS — Android only
- Do not suggest DeepL — does not support target languages
- Do not add ads
- Do not store or log user-typed messages
- Do not add features beyond the current milestone
- Do not over-abstract — avoid premature patterns, repositories, BLoC, etc. for MVP

---

## Environment Setup Checklist (for the human developer)

Before any code can run:

- [ ] Flutter SDK installed and on PATH
- [ ] `flutter doctor` passes (Android SDK, JDK 17+, Android Studio)
- [ ] Google Cloud project created, Translation API enabled, API key generated
- [ ] `android/local.properties` created with `sdk.dir` path
- [ ] `lib/config/secrets.dart` created with Google API key (gitignored)
- [ ] RevenueCat account created, Android app registered, product IDs configured

---

## Current Status

As of 2026-04-01: No code written yet. CLAUDE.md and CODEX_BRIEF.md exist only.

Next step: Milestone 1 — scaffold Flutter project once Flutter SDK is installed.
