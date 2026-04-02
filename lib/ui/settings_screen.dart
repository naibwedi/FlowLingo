import 'package:flutter/material.dart';
import 'package:flowlingo/l10n/generated/app_localizations.dart';
import 'package:flowlingo/models/language_pair.dart';
import 'package:flowlingo/ui/language_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const List<LanguagePair> _pairs = <LanguagePair>[
    LanguagePair(sourceCode: 'en', targetCode: 'am', label: 'English -> Amharic'),
    LanguagePair(sourceCode: 'am', targetCode: 'en', label: 'Amharic -> English'),
    LanguagePair(sourceCode: 'en', targetCode: 'ti', label: 'English -> Tigrinya'),
    LanguagePair(sourceCode: 'ti', targetCode: 'en', label: 'Tigrinya -> English'),
    LanguagePair(sourceCode: 'am', targetCode: 'ti', label: 'Amharic -> Tigrinya'),
  ];

  LanguagePair _selectedPair = _pairs.first;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LanguagePicker(
              pairs: _pairs,
              selectedPair: _selectedPair,
              onChanged: (pair) {
                if (pair == null) {
                  return;
                }
                setState(() {
                  _selectedPair = pair;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(localizations.settingsPlaceholder),
          ],
        ),
      ),
    );
  }
}
