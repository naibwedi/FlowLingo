# KeyLingo — Claude Code Project Guide

## What This App Is

KeyLingo is an Android translation keyboard app. As users type, their message is translated in real time before they hit send — no copy-pasting required. The keyboard integrates at the OS level using Android's InputMethodService.

## Stack

- **Flutter** — UI, settings screens, premium/subscription flows
- **Android native (Kotlin)** — InputMethodService (the actual keyboard layer; Flutter cannot do this)
- **Google Cloud Translation API** — primary translation API (500k free chars/month, permanent free tier)
- **Azure Translator** — upgrade path when volume exceeds Google free tier ($10/1M chars)
- **Lesan AI** — future premium engine for Amharic/Tigrinya (best quality, €20/1M, no free tier)
- **Hive** — local storage for user preferences and vocabulary cache
- **RevenueCat** — subscription management (free/premium)

## Translation API Upgrade Path

1. **Now (MVP):** Google Cloud Translation — 500k free chars/month, never expires
2. **Growth:** Azure Translator — $10/1M chars (cheapest paid tier)
3. **Premium feature:** Lesan AI — best quality for Amharic/Tigrinya, gated behind paywall

## Target Languages (MVP)

- **Amharic** (am) — Ethiopian, ~60M speakers
- **Tigrinya** (ti) — Ethiopian/Eritrean, ~9M speakers

## Expansion Languages (post-MVP)

- Hindi, Bengali, Urdu — South Asia diaspora
- Arabic — Middle East diaspora
- Indonesian, Tagalog, Vietnamese — Southeast Asia
- Swahili — East Africa
- Spanish, Portuguese — Latin America / diaspora in USA

## Project Structure

```
keylingo/
├── android/
│   └── app/src/main/kotlin/com/keylingo/
│       ├── KeyLingoIME.kt        ← InputMethodService (the keyboard)
│       └── TranslationChannel.kt  ← Flutter ↔ Native bridge (MethodChannel)
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── secrets.dart           ← gitignored, holds API keys
│   ├── services/
│   │   ├── translation_service.dart   ← Google Cloud Translation API calls
│   │   ├── language_detector.dart     ← Auto-detect input language
│   │   └── subscription_service.dart  ← RevenueCat
│   ├── models/
│   │   ├── language_pair.dart
│   │   └── translation_result.dart
│   └── ui/
│       ├── settings_screen.dart
│       ├── language_picker.dart
│       └── onboarding_screen.dart
├── CLAUDE.md  ← this file
├── CODEX_BRIEF.md
└── pubspec.yaml
```

## Key Architecture Decision

The keyboard itself (KeyLingoIME.kt) is pure Android native. Flutter handles all the settings UI and business logic. They communicate via Flutter MethodChannels. When implementing keyboard features, always work in the Kotlin layer. When implementing UI or API calls, work in the Flutter/Dart layer.

## APIs & Keys

- Google Cloud Translation API base URL: `https://translation.googleapis.com/language/translate/v2`
- API key stored in: `lib/config/secrets.dart` (gitignored — never commit this file)
- RevenueCat API key stored in: `lib/config/secrets.dart` (gitignored)

## Coding Conventions

- Dart: follow standard Flutter conventions, use `async/await` not raw Futures
- Kotlin: use coroutines for async, not callbacks
- No hardcoded strings — all user-facing text goes in `lib/l10n/`
- Never log or persist the text the user is typing — privacy is a core promise
- Translation trigger: debounce 400ms after last keystroke (balances feel vs. API cost)

## Business Model

- **Free tier**: Amharic + Tigrinya + 3 more language pairs, unlimited translations, no ads
- **Premium ($3.99/month)**: 10+ languages (expansion list above), Lesan AI quality engine, offline packs
- Managed via RevenueCat

## What NOT To Do

- Do not suggest iOS implementation — Android only for now
- Do not suggest DeepL — does not support Amharic, Tigrinya, Hindi, Bengali, Urdu, Tagalog, Swahili
- Do not add ads anywhere — this is a key differentiator
- Do not store or transmit user-typed messages beyond the translation API call
- Do not over-engineer — this is a solo founder project, keep it simple

## Current Phase

MVP build. Focus: keyboard works, translation works, settings screen works. Nothing else.
