import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/language.dart';

class TextResultCard extends StatelessWidget {
  final String transcribedText;
  final String translatedText;
  final Language targetLanguage;

  const TextResultCard({
    super.key,
    required this.transcribedText,
    required this.translatedText,
    required this.targetLanguage,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  MdiIcons.textBox,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Results',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Original Text (Transcription)
            if (transcribedText.isNotEmpty) ...[
              _buildTextSection(
                context: context,
                title: 'Original Text (English)',
                text: transcribedText,
                icon: MdiIcons.microphone,
                onCopy: () => _copyToClipboard(context, transcribedText, 'Original text'),
              ),
              const SizedBox(height: 16),
            ],

            // Translated Text
            if (translatedText.isNotEmpty && translatedText != transcribedText) ...[
              _buildTextSection(
                context: context,
                title: 'Translated Text (${targetLanguage.name})',
                text: translatedText,
                icon: MdiIcons.translate,
                onCopy: () => _copyToClipboard(context, translatedText, 'Translated text'),
              ),
            ],

            // Single text when no translation needed
            if (translatedText.isNotEmpty && translatedText == transcribedText && targetLanguage.code == 'en') ...[
              _buildTextSection(
                context: context,
                title: 'Transcribed Text',
                text: translatedText,
                icon: MdiIcons.microphone,
                onCopy: () => _copyToClipboard(context, translatedText, 'Text'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection({
    required BuildContext context,
    required String title,
    required String text,
    required IconData icon,
    required VoidCallback onCopy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              iconSize: 16,
              visualDensity: VisualDensity.compact,
              tooltip: 'Copy to clipboard',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: SelectableText(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}