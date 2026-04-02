import 'dart:convert';

import 'package:flowlingo/config/secrets.dart';
import 'package:flowlingo/models/translation_result.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  const TranslationService();

  Future<TranslationResult> translate(String text, String targetLang) async {
    final uri = Uri.parse(
      'https://api.cognitive.microsofttranslator.com/translate'
      '?api-version=3.0&to=$targetLang',
    );

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Ocp-Apim-Subscription-Key': Secrets.azureApiKey,
        'Ocp-Apim-Subscription-Region': Secrets.azureRegion,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Map<String, String>>[
        <String, String>{'Text': text},
      ]),
    );

    if (response.statusCode != 200) {
      throw StateError('Translation request failed: ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as List<dynamic>;
    final firstItem = payload.first as Map<String, dynamic>;
    final translations = firstItem['translations'] as List<dynamic>;
    final firstTranslation = translations.first as Map<String, dynamic>;

    return TranslationResult(
      originalText: text,
      translatedText: firstTranslation['text'] as String,
      targetLanguage: firstTranslation['to'] as String,
    );
  }
}
