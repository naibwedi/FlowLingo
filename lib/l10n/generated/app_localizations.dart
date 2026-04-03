import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FlowLingo'**
  String get appTitle;

  /// No description provided for @onboardingEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Android translation keyboard'**
  String get onboardingEyebrow;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Translate while you type.'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'FlowLingo turns your next message into a polished translated draft before you send it, with a keyboard surface designed to stay calm while you type.'**
  String get onboardingBody;

  /// No description provided for @onboardingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'What the first release is built to do'**
  String get onboardingSectionTitle;

  /// No description provided for @onboardingFeatureOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in the conversation'**
  String get onboardingFeatureOneTitle;

  /// No description provided for @onboardingFeatureOneBody.
  ///
  /// In en, this message translates to:
  /// **'Type inside your usual apps without copy-paste or app switching.'**
  String get onboardingFeatureOneBody;

  /// No description provided for @onboardingFeatureTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview before you commit'**
  String get onboardingFeatureTwoTitle;

  /// No description provided for @onboardingFeatureTwoBody.
  ///
  /// In en, this message translates to:
  /// **'Watch a translated draft appear above the keyboard, then apply it when it looks right.'**
  String get onboardingFeatureTwoBody;

  /// No description provided for @onboardingFeatureThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Start simple, stay fast'**
  String get onboardingFeatureThreeTitle;

  /// No description provided for @onboardingFeatureThreeBody.
  ///
  /// In en, this message translates to:
  /// **'English QWERTY input, focused language pairs, and lightweight controls keep the experience clear.'**
  String get onboardingFeatureThreeBody;

  /// No description provided for @onboardingFooter.
  ///
  /// In en, this message translates to:
  /// **'Next step: choose your active language pair, then enable the keyboard from Android settings.'**
  String get onboardingFooter;

  /// No description provided for @onboardingButton.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get onboardingButton;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose the active language pair, confirm where the keyboard will translate, and keep the first-use setup simple enough to finish in a minute.'**
  String get settingsIntro;

  /// No description provided for @settingsActivePairEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Current pair'**
  String get settingsActivePairEyebrow;

  /// No description provided for @settingsActivePairBody.
  ///
  /// In en, this message translates to:
  /// **'The keyboard reads this selection when it opens, so your preview and apply action stay aligned with the app.'**
  String get settingsActivePairBody;

  /// No description provided for @settingsLanguageSectionEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Language pair'**
  String get settingsLanguageSectionEyebrow;

  /// No description provided for @settingsLanguageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what the keyboard should target'**
  String get settingsLanguageSectionTitle;

  /// No description provided for @settingsLanguageSectionBody.
  ///
  /// In en, this message translates to:
  /// **'This selection is stored locally and reused the next time the keyboard opens.'**
  String get settingsLanguageSectionBody;

  /// No description provided for @settingsKeyboardEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Keyboard setup'**
  String get settingsKeyboardEyebrow;

  /// No description provided for @settingsKeyboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable the keyboard in Android'**
  String get settingsKeyboardTitle;

  /// No description provided for @settingsKeyboardBody.
  ///
  /// In en, this message translates to:
  /// **'Open Android keyboard settings, turn on Translation Keyboard, then switch to it inside any text field to test the live preview.'**
  String get settingsKeyboardBody;

  /// No description provided for @settingsKeyboardFootnote.
  ///
  /// In en, this message translates to:
  /// **'Nothing you type is stored in the app. The keyboard only keeps in-memory draft text while the current field is active.'**
  String get settingsKeyboardFootnote;

  /// No description provided for @settingsFeedbackEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Keyboard feel'**
  String get settingsFeedbackEyebrow;

  /// No description provided for @settingsFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Tune keyboard feedback'**
  String get settingsFeedbackTitle;

  /// No description provided for @settingsFeedbackBody.
  ///
  /// In en, this message translates to:
  /// **'Use subtle vibration and key-click sound only if they help the keyboard feel responsive on your device.'**
  String get settingsFeedbackBody;

  /// No description provided for @settingsHapticTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHapticTitle;

  /// No description provided for @settingsHapticBody.
  ///
  /// In en, this message translates to:
  /// **'Adds a light tap sensation for key presses and preview actions.'**
  String get settingsHapticBody;

  /// No description provided for @settingsSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Key sounds'**
  String get settingsSoundTitle;

  /// No description provided for @settingsSoundBody.
  ///
  /// In en, this message translates to:
  /// **'Plays a compact click for typing, delete, space, and enter keys.'**
  String get settingsSoundBody;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions stay out of the first release. This build is focused on a stable, polished translation keyboard experience.'**
  String get settingsPlaceholder;

  /// No description provided for @targetLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Target language'**
  String get targetLanguageLabel;

  /// No description provided for @languagePickerHint.
  ///
  /// In en, this message translates to:
  /// **'Select the pair the keyboard should preview'**
  String get languagePickerHint;

  /// No description provided for @languagePickerBody.
  ///
  /// In en, this message translates to:
  /// **'Switching this setting updates the keyboard\'s active target on the next input session.'**
  String get languagePickerBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
