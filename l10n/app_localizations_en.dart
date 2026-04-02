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
  String get onboardingTitle => 'Translate while you type';

  @override
  String get onboardingBody =>
      'FlowLingo helps you draft translated messages before you send them.';

  @override
  String get onboardingButton => 'Get started';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholder =>
      'Language, keyboard, and subscription controls will appear here.';

  @override
  String get targetLanguageLabel => 'Target language';
}
