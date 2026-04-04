import 'package:flutter/material.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/ui/privacy_screen.dart';
import 'package:flowlingo/ui/settings_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFF6F0E6),
              Color(0xFFECE1CF),
              Color(0xFFE4D8C3),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -30,
                right: -10,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF9E6A3A).withValues(alpha: 0.10),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: 110,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6B7A5B).withValues(alpha: 0.12),
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Chip(label: Text(localizations.onboardingEyebrow)),
                      const SizedBox(height: 20),
                      Text(
                        localizations.appTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        localizations.onboardingTitle,
                        style: theme.textTheme.displaySmall,
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Text(
                          localizations.onboardingBody,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF4A4F49),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.58),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFDCCFB8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              localizations.onboardingSectionTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 18),
                            _FeatureRow(
                              index: '01',
                              title: localizations.onboardingFeatureOneTitle,
                              body: localizations.onboardingFeatureOneBody,
                            ),
                            const SizedBox(height: 16),
                            _FeatureRow(
                              index: '02',
                              title: localizations.onboardingFeatureTwoTitle,
                              body: localizations.onboardingFeatureTwoBody,
                            ),
                            const SizedBox(height: 16),
                            _FeatureRow(
                              index: '03',
                              title: localizations.onboardingFeatureThreeTitle,
                              body: localizations.onboardingFeatureThreeBody,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFDCCFB8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              localizations.onboardingSetupTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            _SetupStep(
                              index: '1',
                              body: localizations.onboardingSetupStepOne,
                            ),
                            const SizedBox(height: 12),
                            _SetupStep(
                              index: '2',
                              body: localizations.onboardingSetupStepTwo,
                            ),
                            const SizedBox(height: 12),
                            _SetupStep(
                              index: '3',
                              body: localizations.onboardingSetupStepThree,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFDCCFB8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              localizations.onboardingPrivacyTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.onboardingPrivacyBody,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations.onboardingFooter,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                );
                              },
                              child: Text(localizations.onboardingButton),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const PrivacyScreen(),
                                  ),
                                );
                              },
                              child: Text(localizations.onboardingPrivacyButton),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.index,
    required this.body,
  });

  final String index;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEE3D1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(index, style: theme.textTheme.labelLarge),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(body, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.index,
    required this.title,
    required this.body,
  });

  final String index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEE3D1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            index,
            style: theme.textTheme.labelLarge?.copyWith(
              color: const Color(0xFF6A583E),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(body, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
