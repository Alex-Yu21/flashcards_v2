import 'package:flashcards_v2/app/navigation/destinations.dart';
import 'package:flashcards_v2/features/auth/presentation/providers/auth_providers.dart';
import 'package:flashcards_v2/features/learning/domain/entities/flashcarde.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/dot_status_widget.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/start_learning_deck_widget.dart';
import 'package:flashcards_v2/features/learning/presentation/widgets/streak_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const double kPad = 20;
const kPad20 = EdgeInsets.symmetric(horizontal: kPad);

const double kHeaderStackHeight = 250;
const double kHeaderHeight = 180;
const double kHeaderTitleBottomGap = 32;

const double kCardTopOffset = 120;
const double kCardHeight = 132;
const double kProgressBarHeight = 4;

const double kLearningSectionRadius = 32;
const double kLearningSectionElevation = 0;
const double kDeckHeightFactor = 0.25;
const double kDeckWidthFactor = 0.90;

const double kAvatarSize = 56;
const double kAvatarBorderWidth = 2;

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final double avatarTop = (kCardTopOffset - kAvatarSize) / 2;

    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      color: cs.onPrimary,
      fontWeight: FontWeight.bold,
    );
    final subtitleStyle = theme.textTheme.bodyLarge?.copyWith(
      color: cs.onPrimary,
    );
    final metricLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: cs.onSurfaceVariant,
    );
    final metricValueStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: kHeaderStackHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: kHeaderHeight,
                    color: theme.primaryColor,
                    child: Padding(
                      padding: kPad20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.displayName != null
                                ? 'Hi, ${session.displayName}'
                                : 'Hi, student',
                            style: titleStyle,
                          ),
                          const SizedBox(height: 4),
                          Text("Let's start learning!", style: subtitleStyle),
                          const SizedBox(height: kHeaderTitleBottomGap),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: avatarTop,
                    right: kPad,
                    child: _Avatar(
                      size: kAvatarSize,
                      borderWidth: kAvatarBorderWidth,
                      image: session.photoUrl,
                    ),
                  ),

                  Positioned(
                    top: kCardTopOffset,
                    left: kPad,
                    right: kPad,
                    child: SizedBox(
                      width: double.infinity,
                      height: kCardHeight,
                      child: Card(
                        child: Padding(
                          padding: kPad20,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    'Learned today',
                                    style: metricLabelStyle,
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
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text('20 ', style: metricValueStyle),
                                  Text('/ 50 cards', style: metricLabelStyle),
                                ],
                              ),
                              Spacer(),
                              Container(
                                // TODO LinearProgressIndicator
                                width: double.infinity,
                                height: kProgressBarHeight,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(height: kPad),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            const Padding(padding: kPad20, child: StreakWidget()),
            Spacer(),
            const _LearningSectionMock(),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.size, required this.borderWidth, this.image});

  final double size;
  final double borderWidth;
  final String? image;
  // final String? initials;
  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.white.withValues(alpha: 0.35);
    final bgFallback = Colors.white.withValues(alpha: 0.15);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: image != null
          ? Image.network(image!, fit: BoxFit.cover)
          : ColoredBox(
              color: bgFallback,
              child: Center(
                child: Text(
                  'Y',
                  style: TextStyle(
                    fontSize: size / 3,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
    );
  }
}

class _LearningSectionMock extends StatelessWidget {
  const _LearningSectionMock({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    return Padding(
      padding: kPad20,
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
            const Padding(padding: kPad20, child: DotStatusWidget()),
            Padding(
              padding: const EdgeInsets.only(right: kPad),
              child: SizedBox(
                height: h * kDeckHeightFactor,
                width: w * kDeckWidthFactor,
                child: StartLearningDeckWidget(
                  w: w,
                  onTap: () {
                    context.go('${Routes.homeView}/${Routes.learningView}');
                  },
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
