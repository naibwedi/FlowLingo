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

    return DropdownButtonFormField<LanguagePair>(
      initialValue: selectedPair,
      decoration: InputDecoration(
        labelText: localizations.targetLanguageLabel,
        border: const OutlineInputBorder(),
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
    );
  }
}
