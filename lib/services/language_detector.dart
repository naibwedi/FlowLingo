class LanguageDetector {
  const LanguageDetector();

  String? detectSourceLanguage(String text) {
    if (text.isEmpty) {
      return null;
    }

    final hasEthiopic = RegExp(r'[\u1200-\u137F]').hasMatch(text);
    if (hasEthiopic) {
      return 'am';
    }

    final hasLatin = RegExp(r'[A-Za-z]').hasMatch(text);
    if (hasLatin) {
      return 'en';
    }

    return null;
  }
}
