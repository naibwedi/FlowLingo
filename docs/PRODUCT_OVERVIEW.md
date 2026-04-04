# Product Overview

## What FlowLingo Is

FlowLingo is an Android translation keyboard. It lets a user type in any Android text field, preview a translated draft above the keyboard, and manually apply that translated draft before sending.

The current product focus is:

- Android only
- fast translation preview while typing
- clear manual apply flow
- privacy-safe handling of typed text

## Core User Flow

1. Open the app
2. Choose a language pair
3. Read the privacy note
4. Enable `Translation Keyboard` in Android settings
5. Switch to the keyboard inside a text field
6. Type a message
7. Pause briefly to see the translated preview
8. Tap Apply to replace the current draft with the translated version

## Current MVP Scope

Included:

- native Android keyboard service
- Flutter onboarding and settings
- language-pair persistence
- live translation preview through Google Cloud Translation
- manual apply flow
- internal-testing docs and privacy policy

Not included yet:

- premium subscriptions
- offline translation
- multi-provider routing
- Play Store beta rollout materials

## Product Principles

- Typing should stay responsive even if translation fails
- Preview should be helpful, but never auto-send content
- Typed text should not be stored locally
- Setup should be understandable for a first-time tester

## Privacy Summary

- Typed text is sent to Google Cloud Translation only to generate the live preview
- Typed text is not stored in app files, app settings, or logs
- Translation cache is session-only and memory-only

For the full wording, see [PRIVACY_POLICY.md](../PRIVACY_POLICY.md).
