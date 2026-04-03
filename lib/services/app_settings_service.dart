import 'package:flowlingo/models/language_pair.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  AppSettingsService._();

  static const String _boxName = 'app_settings';
  static const String _languagePairKey = 'language_pair';
  static const String _hapticFeedbackKey = 'haptic_feedback_enabled';
  static const String _soundFeedbackKey = 'sound_feedback_enabled';
  static const String _nativeLanguagePairKey = 'flutter.selected_language_pair';
  static const String _nativeHapticFeedbackKey = 'flutter.haptic_feedback_enabled';
  static const String _nativeSoundFeedbackKey = 'flutter.sound_feedback_enabled';

  static SharedPreferences? _preferences;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
    _preferences = await SharedPreferences.getInstance();
  }

  static Box<String> get _box => Hive.box<String>(_boxName);
  static SharedPreferences get _prefs => _preferences!;

  static LanguagePair getSelectedLanguagePair() {
    return LanguagePair.fromStorageKey(_box.get(_languagePairKey));
  }

  static Future<void> saveSelectedLanguagePair(LanguagePair pair) async {
    await _box.put(_languagePairKey, pair.storageKey);
    await _prefs.setString(_nativeLanguagePairKey, pair.storageKey);
  }

  static bool isHapticFeedbackEnabled() {
    return _box.get(_hapticFeedbackKey, defaultValue: 'true') == 'true';
  }

  static Future<void> saveHapticFeedbackEnabled(bool value) async {
    final storedValue = value.toString();
    await _box.put(_hapticFeedbackKey, storedValue);
    await _prefs.setBool(_nativeHapticFeedbackKey, value);
  }

  static bool isSoundFeedbackEnabled() {
    return _box.get(_soundFeedbackKey, defaultValue: 'false') == 'true';
  }

  static Future<void> saveSoundFeedbackEnabled(bool value) async {
    final storedValue = value.toString();
    await _box.put(_soundFeedbackKey, storedValue);
    await _prefs.setBool(_nativeSoundFeedbackKey, value);
  }
}
