import 'dart:convert';

import 'package:flowlingo/config/secrets.dart';
import 'package:flowlingo/models/translation_result.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  const TranslationService();

  Future<TranslationResult> translate(String text, String targetLang) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      throw const TranslationException('Text is required for translation.');
    }

    if (Secrets.googleTranslateApiKey == 'YOUR_GOOGLE_TRANSLATE_API_KEY') {
      throw const TranslationException(
        'Google Cloud Translation API key is not configured.',
      );
    }

    final uri = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2'
      '?key=${Secrets.googleTranslateApiKey}',
    );

    http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'q': normalizedText,
              'target': targetLang,
              'format': 'text',
            }),
          )
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      throw const TranslationException(
        'Translation service is unavailable. Check your connection and try again.',
      );
    }

    if (response.statusCode != 200) {
      throw TranslationException(
        'Translation request failed with status ${response.statusCode}.',
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'] as Map<String, dynamic>?;
    final translations = data?['translations'] as List<dynamic>?;

    if (translations == null || translations.isEmpty) {
      throw const TranslationException(
        'Translation response did not include a translated result.',
      );
    }

    final firstTranslation = translations.first as Map<String, dynamic>;

    return TranslationResult(
      originalText: normalizedText,
      translatedText: firstTranslation['translatedText'] as String,
      targetLanguage: targetLang,
      detectedSourceLanguage: firstTranslation['detectedSourceLanguage'] as String?,
    );
  }
}

class TranslationException implements Exception {
  const TranslationException(this.message);

  final String message;
}
