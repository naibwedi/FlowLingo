import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/ui/onboarding_screen.dart';

const MethodChannel _translationChannel = MethodChannel('com.app.translation');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _translationChannel.setMethodCallHandler(_handleNativeTranslationRequest);
  runApp(const FlowLingoApp());
}

Future<Map<String, String>> _handleNativeTranslationRequest(MethodCall call) async {
  if (call.method != 'translate') {
    throw MissingPluginException('Method ${call.method} not implemented.');
  }

  final arguments = Map<String, dynamic>.from(call.arguments as Map);
  final text = (arguments['text'] as String? ?? '').trim();
  final targetLang = arguments['targetLang'] as String? ?? 'am';

  if (text.isEmpty) {
    throw PlatformException(
      code: 'empty-text',
      message: 'Text is required for mock translation.',
    );
  }

  return <String, String>{
    'translatedText': '[mock:$targetLang] $text',
    'targetLang': targetLang,
  };
}

class FlowLingoApp extends StatelessWidget {
  const FlowLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E4F)),
        scaffoldBackgroundColor: const Color(0xFFF7F4EC),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
