import 'dart:ui';

import 'package:flashcards_v2/features/learning/domain/entities/flashcarde.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class _K {
  static const double stackHeight = 180;
  static const double blurSigma = 2;
  static const Offset backCardOffset = Offset(30, -20);

  static const double buttonWidthRatio = 0.72;
  static const double buttonMinWidth = 240;
  static const double buttonMaxWidth = 420;
  static const double buttonMinHeight = 60;
  static const double buttonPaddingH = 24;
  static const double buttonPaddingV = 16;
  static const double buttonGap = 12;
  static const double iconSize = 28;
  static const double buttonFontSize = 18;
  static const int buttonTextMaxLines = 2;
}

class StartLearningDeckWidget extends StatelessWidget {
  const StartLearningDeckWidget({
    super.key,
    required this.w,
    required this.onTap,
  });

  final double w;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final preview = mockFlashcards;
    final previewCount = 3;

    final targetWidth = (w * _K.buttonWidthRatio).clamp(
      _K.buttonMinWidth,
      _K.buttonMaxWidth,
    );

    return SizedBox(
      height: _K.stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _K.blurSigma,
              sigmaY: _K.blurSigma,
            ),
            child: CardSwiper(
              isDisabled: true,
              numberOfCardsDisplayed: previewCount,
              backCardOffset: _K.backCardOffset,
              cardsCount: previewCount,
              cardBuilder: (context, index, _, __) =>
                  LanguageFlashcardWidget(flashcard: preview[0]),
              padding: EdgeInsets.zero,
            ),
          ),
          Center(
            child: SizedBox(
              width: targetWidth,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(
                    _K.buttonMinWidth,
                    _K.buttonMinHeight,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: _K.buttonPaddingH,
                    vertical: _K.buttonPaddingV,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: _K.buttonFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: _K.iconSize + _K.buttonGap),
                    Expanded(
                      child: Text(
                        'Start learning',
                        textAlign: TextAlign.center,
                        maxLines: _K.buttonTextMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(width: _K.buttonGap),
                    Icon(Icons.play_arrow_rounded, size: _K.iconSize),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<LanguageCardEntity> mockFlashcards = [
  LanguageCardEntity(
    id: 'mock_preview_1',
    title: 'nice to see you',
    transcription: '[welcome back]',
    audioPath: null,
    description: 'goof luck with your study session',
    translation: 'piacere di vederti',
    example: 'See you later! Nice to see you again!',
  ),
];
