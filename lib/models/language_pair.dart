class LanguagePair {
  const LanguagePair({
    required this.sourceCode,
    required this.targetCode,
    required this.label,
  });

  final String sourceCode;
  final String targetCode;
  final String label;

  String get storageKey => '$sourceCode:$targetCode';

  static const List<LanguagePair> defaults = <LanguagePair>[
    LanguagePair(sourceCode: 'en', targetCode: 'am', label: 'English -> Amharic'),
    LanguagePair(sourceCode: 'am', targetCode: 'en', label: 'Amharic -> English'),
    LanguagePair(sourceCode: 'en', targetCode: 'ti', label: 'English -> Tigrinya'),
    LanguagePair(sourceCode: 'ti', targetCode: 'en', label: 'Tigrinya -> English'),
    LanguagePair(sourceCode: 'am', targetCode: 'ti', label: 'Amharic -> Tigrinya'),
  ];

  static LanguagePair fromStorageKey(String? value) {
    return defaults.firstWhere(
      (pair) => pair.storageKey == value,
      orElse: () => defaults.first,
    );
  }
}
