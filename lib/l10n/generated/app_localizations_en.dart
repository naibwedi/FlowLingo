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
      'FlowLingo turns your next message into a polished translated draft before you send it, with a keyboard surface designed to stay calm while you type.';

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
      'Choose the active language pair, confirm where the keyboard will translate, and keep the first-use setup simple enough to finish in a minute.';

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
  String get settingsFeedbackEyebrow => 'Keyboard feel';

  @override
  String get settingsFeedbackTitle => 'Tune keyboard feedback';

  @override
  String get settingsFeedbackBody =>
      'Use subtle vibration and key-click sound only if they help the keyboard feel responsive on your device.';

  @override
  String get settingsHapticTitle => 'Haptic feedback';

  @override
  String get settingsHapticBody =>
      'Adds a light tap sensation for key presses and preview actions.';

  @override
  String get settingsSoundTitle => 'Key sounds';

  @override
  String get settingsSoundBody =>
      'Plays a compact click for typing, delete, space, and enter keys.';

  @override
  String get settingsPlaceholder =>
      'Subscriptions stay out of the first release. This build is focused on a stable, polished translation keyboard experience.';

  @override
  String get targetLanguageLabel => 'Target language';

  @override
  String get languagePickerHint =>
      'Select the pair the keyboard should preview';

  @override
  String get languagePickerBody =>
      'Switching this setting updates the keyboard\'s active target on the next input session.';
}
