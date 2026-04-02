import 'package:flutter/material.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/models/language_pair.dart';
import 'package:flowlingo/services/app_settings_service.dart';
import 'package:flowlingo/ui/language_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LanguagePair _selectedPair = AppSettingsService.getSelectedLanguagePair();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.settingsTitle,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Text(
                localizations.settingsIntro,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
            _SettingsPanel(
              eyebrow: localizations.settingsActivePairEyebrow,
              title: _selectedPair.label,
              body: localizations.settingsActivePairBody,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE2D2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _selectedPair.targetCode.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF6A583E),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SettingsPanel(
              eyebrow: localizations.settingsLanguageSectionEyebrow,
              title: localizations.settingsLanguageSectionTitle,
              body: localizations.settingsLanguageSectionBody,
              child: LanguagePicker(
                pairs: LanguagePair.defaults,
                selectedPair: _selectedPair,
                onChanged: (pair) {
                  if (pair == null) {
                    return;
                  }
                  setState(() {
                    _selectedPair = pair;
                  });
                  AppSettingsService.saveSelectedLanguagePair(pair);
                },
              ),
            ),
            const SizedBox(height: 18),
            _SettingsPanel(
              eyebrow: localizations.settingsKeyboardEyebrow,
              title: localizations.settingsKeyboardTitle,
              body: localizations.settingsKeyboardBody,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.settingsKeyboardFootnote,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              localizations.settingsPlaceholder,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.eyebrow,
    required this.title,
    required this.body,
    this.trailing,
    this.child,
  });

  final String eyebrow;
  final String title;
  final String body;
  final Widget? trailing;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.66),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDCCFB8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      eyebrow.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF7A6549),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(body, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                const SizedBox(width: 16),
                trailing!,
              ],
            ],
          ),
          if (child != null) ...<Widget>[
            const SizedBox(height: 18),
            child!,
          ],
        ],
      ),
    );
  }
}
