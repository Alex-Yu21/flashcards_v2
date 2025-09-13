import 'package:flashcards_v2/features/learning/domain/entities/flashcarde.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/dot_status_widget.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/start_learning_deck_widget.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/streak_widget.dart';
import 'package:flutter/material.dart';

// ===== Layout constants =====
const double kHeaderStackHeight = 250;
const double kHeaderHeight = 180;
const double kHeaderPadding = 20;
const double kHeaderTitleFont = 32;
const double kHeaderSubtitleFont = 16;
const double kHeaderTitleBottomGap = 32;

const double kCardTopOffset = 120;
const double kCardSideMargin = 16;
const double kCardHeight = 120;
const double kCardPadding = 20;
const double kMetricLabelSize = 16;
const double kMetricValueSize = 24;
const double kProgressBarHeight = 4;

const double kScreenHorizontalPadding = 20;

const double kLearningSectionHPad = 20;
const double kLearningSectionVPad = 12;
const double kLearningSectionRightPad = 12;
const double kLearningSectionOpacity = 0.20;
const double kLearningSectionRadius = 32;
const double kLearningSectionElevation = 0;
const double kDeckHeightFactor = 0.30;
const double kDeckWidthFactor = 0.90;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: kHeaderStackHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: kHeaderHeight,
                      decoration: BoxDecoration(color: theme.primaryColor),
                      child: const Padding(
                        padding: EdgeInsets.all(kHeaderPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: kHeaderTitleFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Lets, start learning!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: kHeaderSubtitleFont,
                              ),
                            ),
                            SizedBox(height: kHeaderTitleBottomGap),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: kCardTopOffset,
                      left: kCardSideMargin,
                      right: kCardSideMargin,
                      child: SizedBox(
                        width: double.infinity,
                        height: kCardHeight,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(kCardPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Learned today',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: kMetricLabelSize,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {},
                                      child: const Text('your deck'),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      '20 ',
                                      style: TextStyle(
                                        fontSize: kMetricValueSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '/ 50 cards',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: kMetricLabelSize,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  height: kProgressBarHeight,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kScreenHorizontalPadding,
                ),
                child: StreakWidget(),
              ),
              const _LearningSectionMock(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openLearningScreen(BuildContext context) async {}

class _LearningSectionMock extends StatelessWidget {
  const _LearningSectionMock({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: kLearningSectionElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kLearningSectionRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kLearningSectionHPad,
                vertical: kLearningSectionVPad,
              ),
              child: DotStatusWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: kLearningSectionRightPad),
              child: SizedBox(
                height: h * kDeckHeightFactor,
                width: w * kDeckWidthFactor,
                child: StartLearningDeckWidget(
                  w: w,
                  onTap: () {},
                  cards: const <FlashcardEntity>[],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
