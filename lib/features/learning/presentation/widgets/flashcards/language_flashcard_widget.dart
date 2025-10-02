import 'package:flashcards_v2/features/learning/domain/entities/flashcarde.dart';
import 'package:flutter/material.dart';

class LanguageFlashcardWidget extends StatelessWidget {
  const LanguageFlashcardWidget({
    super.key,
    required this.flashcard,
    this.isTurned = false,
    this.color,
    this.textColor,
  });

  final LanguageCardEntity flashcard;
  final bool isTurned;
  final Color? color;
  final Color? textColor;

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    final sw = logicalSize.width;
    final sh = logicalSize.height;

    final cardColor = color ?? Theme.of(context).colorScheme.primaryContainer;
    final txColor =
        textColor ?? Theme.of(context).colorScheme.onPrimaryContainer;

    final hp = sw * 0.05;
    final vp = sh * 0.02;
    final iconSize = sw * 0.05;

    Widget buildFront() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(_capitalize(flashcard.title))),
            IconButton(
              iconSize: iconSize,
              onPressed: () {},
              icon: Icon(Icons.edit, color: txColor),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flashcard.transcription?.toLowerCase() ?? ''),
            IconButton(
              iconSize: iconSize,
              onPressed: () {},
              icon: Icon(Icons.volume_up, color: txColor),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(flashcard.description?.toLowerCase() ?? ''),
      ],
    );

    Widget buildBack() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(_capitalize(flashcard.translation))),
            IconButton(
              iconSize: iconSize,
              onPressed: () {},
              icon: Icon(Icons.edit, color: txColor),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(flashcard.example?.toLowerCase() ?? ''),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Learn more'),
              Icon(Icons.chevron_right, size: iconSize * 0.8),
            ],
          ),
        ),
      ],
    );

    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: hp, vertical: vp),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hp, vertical: vp),
        child: isTurned ? buildBack() : buildFront(),
      ),
    );
  }
}

// TODO VoidCallback? onEdit, VoidCallback? onPlayAudio, VoidCallback? onLearnMore
// TODO Row _buildHeader(String text, VoidCallback? onEdit)
