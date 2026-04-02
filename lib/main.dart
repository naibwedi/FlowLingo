import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/ui/onboarding_screen.dart';

void main() {
  runApp(const FlowLingoApp());
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
