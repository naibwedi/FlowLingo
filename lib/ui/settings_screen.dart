import 'package:flutter/material.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/models/language_pair.dart';
import 'package:flowlingo/services/app_settings_service.dart';
import 'package:flowlingo/ui/language_picker.dart';
import 'package:flowlingo/ui/privacy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LanguagePair _selectedPair = AppSettingsService.getSelectedLanguagePair();
  bool _hapticFeedbackEnabled = AppSettingsService.isHapticFeedbackEnabled();
  bool _soundFeedbackEnabled = AppSettingsService.isSoundFeedbackEnabled();

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
                  _SetupBullet(text: localizations.settingsKeyboardStepOne),
                  const SizedBox(height: 10),
                  _SetupBullet(text: localizations.settingsKeyboardStepTwo),
                  const SizedBox(height: 10),
                  _SetupBullet(text: localizations.settingsKeyboardStepThree),
                  const SizedBox(height: 14),
                  Text(
                    localizations.settingsKeyboardFootnote,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SettingsPanel(
              eyebrow: localizations.settingsPrivacyEyebrow,
              title: localizations.settingsPrivacyTitle,
              body: localizations.settingsPrivacyBody,
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyScreen(),
                      ),
                    );
                  },
                  child: Text(localizations.settingsPrivacyButton),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SettingsPanel(
              eyebrow: localizations.settingsFeedbackEyebrow,
              title: localizations.settingsFeedbackTitle,
              body: localizations.settingsFeedbackBody,
              child: Column(
                children: <Widget>[
                  _FeedbackToggleRow(
                    title: localizations.settingsHapticTitle,
                    subtitle: localizations.settingsHapticBody,
                    value: _hapticFeedbackEnabled,
                    onChanged: (value) {
                      setState(() {
                        _hapticFeedbackEnabled = value;
                      });
                      AppSettingsService.saveHapticFeedbackEnabled(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  _FeedbackToggleRow(
                    title: localizations.settingsSoundTitle,
                    subtitle: localizations.settingsSoundBody,
                    value: _soundFeedbackEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundFeedbackEnabled = value;
                      });
                      AppSettingsService.saveSoundFeedbackEnabled(value);
                    },
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

class _SetupBullet extends StatelessWidget {
  const _SetupBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF6A583E),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _FeedbackToggleRow extends StatelessWidget {
  const _FeedbackToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F0E5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0D2BD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
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
