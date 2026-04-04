import 'package:flutter/material.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.privacyTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.privacyIntro,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _PrivacyCard(
              title: localizations.privacyCardOneTitle,
              body: localizations.privacyCardOneBody,
            ),
            const SizedBox(height: 16),
            _PrivacyCard(
              title: localizations.privacyCardTwoTitle,
              body: localizations.privacyCardTwoBody,
            ),
            const SizedBox(height: 16),
            _PrivacyCard(
              title: localizations.privacyCardThreeTitle,
              body: localizations.privacyCardThreeBody,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCCFB8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
