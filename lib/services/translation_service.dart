import 'dart:collection';
import 'dart:convert';

import 'package:flowlingo/config/secrets.dart';
import 'package:flowlingo/models/translation_result.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  const TranslationService();

  static const int _maxSessionCacheEntries = 64;

  static final LinkedHashMap<String, TranslationResult> _sessionCache =
      LinkedHashMap<String, TranslationResult>();
  static final Map<String, Future<TranslationResult>> _inFlightRequests =
      <String, Future<TranslationResult>>{};

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

    final cacheKey = '$targetLang::$normalizedText';
    final cachedResult = _sessionCache[cacheKey];
    if (cachedResult != null) {
      return cachedResult;
    }

    final inFlight = _inFlightRequests[cacheKey];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _performTranslate(
      text: normalizedText,
      targetLang: targetLang,
      cacheKey: cacheKey,
    );
    _inFlightRequests[cacheKey] = request;

    try {
      return await request;
    } finally {
      _inFlightRequests.remove(cacheKey);
    }
  }

  Future<TranslationResult> _performTranslate({
    required String text,
    required String targetLang,
    required String cacheKey,
  }) async {
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
              'q': text,
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
    final result = TranslationResult(
      originalText: text,
      translatedText: firstTranslation['translatedText'] as String,
      targetLanguage: targetLang,
      detectedSourceLanguage: firstTranslation['detectedSourceLanguage'] as String?,
    );
    if (_sessionCache.length >= _maxSessionCacheEntries) {
      _sessionCache.remove(_sessionCache.keys.first);
    }
    _sessionCache[cacheKey] = result;
    return result;
  }
}

class TranslationException implements Exception {
  const TranslationException(this.message);

  final String message;
}
