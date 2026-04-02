// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FlowLingo';

  @override
  String get onboardingEyebrow => 'Android translation keyboard';

  @override
  String get onboardingTitle => 'Translate while you type.';

  @override
  String get onboardingBody =>
      'FlowLingo gives your next message a translation-ready draft before you send it, with a calm keyboard surface built for everyday chat.';

  @override
  String get onboardingSectionTitle => 'What the first release is built to do';

  @override
  String get onboardingFeatureOneTitle => 'Stay in the conversation';

  @override
  String get onboardingFeatureOneBody =>
      'Type inside your usual apps without copy-paste or app switching.';

  @override
  String get onboardingFeatureTwoTitle => 'Preview before you commit';

  @override
  String get onboardingFeatureTwoBody =>
      'Watch a translated draft appear above the keyboard, then apply it when it looks right.';

  @override
  String get onboardingFeatureThreeTitle => 'Start simple, stay fast';

  @override
  String get onboardingFeatureThreeBody =>
      'English QWERTY input, focused language pairs, and lightweight controls keep the experience clear.';

  @override
  String get onboardingFooter =>
      'Next step: choose your active language pair, then enable the keyboard from Android settings.';

  @override
  String get onboardingButton => 'Open settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsIntro =>
      'Set the active language pair for the keyboard, confirm what the preview will target, and keep the first-use flow easy to follow.';

  @override
  String get settingsActivePairEyebrow => 'Current pair';

  @override
  String get settingsActivePairBody =>
      'The keyboard reads this selection when it opens, so your preview and apply action stay aligned with the app.';

  @override
  String get settingsLanguageSectionEyebrow => 'Language pair';

  @override
  String get settingsLanguageSectionTitle =>
      'Choose what the keyboard should target';

  @override
  String get settingsLanguageSectionBody =>
      'This selection is stored locally and reused the next time the keyboard opens.';

  @override
  String get settingsKeyboardEyebrow => 'Keyboard setup';

  @override
  String get settingsKeyboardTitle => 'Enable the keyboard in Android';

  @override
  String get settingsKeyboardBody =>
      'Open Android keyboard settings, turn on Translation Keyboard, then switch to it inside any text field to test the live preview.';

  @override
  String get settingsKeyboardFootnote =>
      'Nothing you type is stored in the app. The keyboard only keeps in-memory draft text while the current field is active.';

  @override
  String get settingsPlaceholder =>
      'Subscription controls and provider setup will be added after the keyboard flow is finalized.';

  @override
  String get targetLanguageLabel => 'Target language';

  @override
  String get languagePickerHint =>
      'Select the pair the keyboard should preview';

  @override
  String get languagePickerBody =>
      'Switching this setting updates the keyboard\'s active target on the next input session.';
}
