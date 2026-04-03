import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/services/app_settings_service.dart';
import 'package:flowlingo/services/translation_service.dart';
import 'package:flowlingo/ui/onboarding_screen.dart';

const MethodChannel _translationChannel = MethodChannel('com.app.translation');
const TranslationService _translationService = TranslationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettingsService.initialize();
  _translationChannel.setMethodCallHandler(_handleNativeTranslationRequest);
  runApp(const FlowLingoApp());
}

Future<Map<String, String>> _handleNativeTranslationRequest(MethodCall call) async {
  if (call.method != 'translate') {
    throw MissingPluginException('Method ${call.method} not implemented.');
  }

  final arguments = Map<String, dynamic>.from(call.arguments as Map);
  final text = (arguments['text'] as String? ?? '').trim();
  final targetLang = arguments['targetLang'] as String? ??
      AppSettingsService.getSelectedLanguagePair().targetCode;

  if (text.isEmpty) {
    throw PlatformException(
      code: 'empty-text',
      message: 'Text is required for translation.',
    );
  }

  try {
    final result = await _translationService.translate(text, targetLang);

    return <String, String>{
      'translatedText': result.translatedText,
      'targetLang': result.targetLanguage,
    };
  } on TranslationException catch (error) {
    throw PlatformException(
      code: 'translation-unavailable',
      message: error.message,
    );
  } catch (_) {
    throw PlatformException(
      code: 'translation-unavailable',
      message: 'Translation is temporarily unavailable.',
    );
  }
}

class FlowLingoApp extends StatelessWidget {
  const FlowLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFFF5EFE3);
    const surfaceDim = Color(0xFFE6D9C2);
    const ink = Color(0xFF1C221E);
    const muted = Color(0xFF5D655E);
    const accent = Color(0xFF9E6A3A);
    const accentDeep = Color(0xFF6B7A5B);
    const outline = Color(0xFFD9CCB5);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
      primary: accent,
      secondary: accentDeep,
      surface: surface,
      onSurface: ink,
      outline: outline,
    );

    final baseTextTheme = ThemeData(brightness: Brightness.light).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: surface,
        useMaterial3: true,
        textTheme: baseTextTheme.copyWith(
          displaySmall: baseTextTheme.displaySmall?.copyWith(
            color: ink,
            fontWeight: FontWeight.w700,
            height: 1.05,
            letterSpacing: -1.2,
          ),
          headlineLarge: baseTextTheme.headlineLarge?.copyWith(
            color: ink,
            fontWeight: FontWeight.w700,
            height: 1.08,
            letterSpacing: -1.1,
          ),
          headlineMedium: baseTextTheme.headlineMedium?.copyWith(
            color: ink,
            fontWeight: FontWeight.w700,
            height: 1.12,
            letterSpacing: -0.8,
          ),
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            color: ink,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: baseTextTheme.titleMedium?.copyWith(
            color: ink,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(
            color: muted,
            height: 1.45,
          ),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(
            color: muted,
            height: 1.42,
          ),
          labelLarge: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.72),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: outline),
          ),
        ),
        dividerColor: outline,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.75),
          labelStyle: const TextStyle(
            color: muted,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: const TextStyle(color: muted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: accent, width: 1.4),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: surface,
            minimumSize: const Size.fromHeight(58),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ink,
            side: const BorderSide(color: outline),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surfaceDim,
          selectedColor: accent.withValues(alpha: 0.12),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          labelStyle: const TextStyle(
            color: ink,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
