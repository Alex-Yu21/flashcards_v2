import 'dart:math' as math;
import 'dart:ui';

import 'package:flashcards_v2/features/learning/domain/entities/flashcarde.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class _K {
  static const double stackHeight = 180;
  static const double blurSigma = 3;
  static const int cardsOnScreen = 3;
  static const int cardsPreviewCount = 3;
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
    required this.cards,
    this.isLoading = false,
    this.errorText,
    this.placeholder,
  });

  final double w;
  final VoidCallback onTap;
  final List<FlashcardEntity> cards;
  final bool isLoading;
  final String? errorText;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final preview = dummyFlashcards;
    final hasPreview = preview.isNotEmpty && !isLoading;
    final previewCount = math.min(preview.length, _K.cardsPreviewCount);

    final targetWidth = (w * _K.buttonWidthRatio).clamp(
      _K.buttonMinWidth,
      _K.buttonMaxWidth,
    );

    return SizedBox(
      height: _K.stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (hasPreview)
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _K.blurSigma,
                sigmaY: _K.blurSigma,
              ),
              child: CardSwiper(
                isDisabled: true,
                numberOfCardsDisplayed: _K.cardsOnScreen,
                backCardOffset: _K.backCardOffset,
                cardsCount: previewCount,
                cardBuilder: (context, index, _, __) =>
                    FlashcardWidget(flashcard: preview[index]),
                padding: EdgeInsets.zero,
              ),
            ),
          if (!hasPreview && !isLoading && placeholder != null)
            Center(child: placeholder!),
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
          if (errorText != null && errorText!.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final List<FlashcardEntity> dummyFlashcards = [
  FlashcardEntity(
    id: '1',
    title: 'cane',
    transcription: '[ˈka.ne]',
    audioPath: null,
    description: 'животное',
    translation: 'собака',
    example: 'Il cane corre nel parco.',
  ),
  FlashcardEntity(
    id: '2',
    title: 'gatto',
    transcription: '[ˈɡat.to]',
    audioPath: null,
    description: 'животное',
    translation: 'кот',
    example: 'Il gatto dorme sul divano.',
  ),
  FlashcardEntity(
    id: '3',
    title: 'casa',
    transcription: '[ˈka.sa]',
    audioPath: null,
    description: 'место, где ты живёшь',
    translation: 'дом',
    example: 'La mia casa è grande e luminosa.',
  ),
  FlashcardEntity(
    id: '4',
    title: 'libro',
    transcription: '[ˈli.bro]',
    audioPath: null,
    description: 'читаешь это',
    translation: 'книга',
    example: 'Sto leggendo un libro interessante.',
  ),
  FlashcardEntity(
    id: '5',
    title: 'amico',
    transcription: '[aˈmi.ko]',
    audioPath: null,
    description: 'человек, которому доверяешь',
    translation: 'друг',
    example: 'Il mio amico vive a Roma.',
  ),
  FlashcardEntity(
    id: '6',
    title: 'mela',
    transcription: '[ˈme.la]',
    audioPath: null,
    description: 'красный фрукт',
    translation: 'яблоко',
    example: 'Mangio una mela ogni giorno.',
  ),
  FlashcardEntity(
    id: '7',
    title: 'scuola',
    transcription: '[ˈskwo.la]',
    audioPath: null,
    description: 'место учёбы',
    translation: 'школа',
    example: 'I bambini vanno a scuola ogni mattina.',
  ),
  FlashcardEntity(
    id: '8',
    title: 'sole',
    transcription: '[ˈso.le]',
    audioPath: null,
    description: 'на небе днём',
    translation: 'солнце',
    example: 'Il sole splende alto nel cielo.',
  ),
  FlashcardEntity(
    id: '9',
    title: 'acqua',
    transcription: '[ˈak.kwa]',
    audioPath: null,
    description: 'пьёшь это',
    translation: 'вода',
    example: 'Bevo molta acqua durante il giorno.',
  ),
  FlashcardEntity(
    id: '10',
    title: 'tempo',
    transcription: '[ˈtɛm.po]',
    audioPath: null,
    description: 'идёт всегда',
    translation: 'время / погода (по контексту)',
    example: 'Non ho molto tempo libero.',
  ),
];
