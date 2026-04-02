import 'package:flowlingo/models/language_pair.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettingsService {
  AppSettingsService._();

  static const String _boxName = 'app_settings';
  static const String _languagePairKey = 'language_pair';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  static Box<String> get _box => Hive.box<String>(_boxName);

  static LanguagePair getSelectedLanguagePair() {
    return LanguagePair.fromStorageKey(_box.get(_languagePairKey));
  }

  static Future<void> saveSelectedLanguagePair(LanguagePair pair) {
    return _box.put(_languagePairKey, pair.storageKey);
  }
}
