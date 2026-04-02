class TranslationResult {
  const TranslationResult({
    required this.originalText,
    required this.translatedText,
    required this.targetLanguage,
  });

  final String originalText;
  final String translatedText;
  final String targetLanguage;
}
