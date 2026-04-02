import 'package:flutter/material.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/models/language_pair.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    super.key,
    required this.pairs,
    required this.selectedPair,
    required this.onChanged,
  });

  final List<LanguagePair> pairs;
  final LanguagePair selectedPair;
  final ValueChanged<LanguagePair?> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          localizations.targetLanguageLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<LanguagePair>(
          initialValue: selectedPair,
          borderRadius: BorderRadius.circular(22),
          decoration: InputDecoration(
            hintText: localizations.languagePickerHint,
          ),
          items: pairs
              .map(
                (pair) => DropdownMenuItem<LanguagePair>(
                  value: pair,
                  child: Text(pair.label),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
        Text(
          localizations.languagePickerBody,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
