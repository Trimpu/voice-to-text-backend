import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../providers/app_state.dart';
import '../models/language.dart';
import '../utils/language_list.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      MdiIcons.translate,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Target Language',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _showLanguageDialog(context, appState),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appState.selectedLanguage.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                appState.selectedLanguage.nativeName,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => LanguageDialog(
        currentLanguage: appState.selectedLanguage,
        onLanguageSelected: (language) {
          appState.setSelectedLanguage(language);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class LanguageDialog extends StatefulWidget {
  final Language currentLanguage;
  final Function(Language) onLanguageSelected;

  const LanguageDialog({
    super.key,
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Language> _filteredLanguages = LanguageList.languages;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterLanguages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLanguages() {
    final query = _searchController.text;
    setState(() {
      _filteredLanguages = LanguageList.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Icon(
                  MdiIcons.translate,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Language',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search languages...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),

            // Language List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredLanguages.length,
                itemBuilder: (context, index) {
                  final language = _filteredLanguages[index];
                  final isSelected = language == widget.currentLanguage;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                      child: Text(
                        language.code.toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(language.name),
                    subtitle: Text(language.nativeName),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => widget.onLanguageSelected(language),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}