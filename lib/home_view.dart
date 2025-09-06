import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final h = 600.0;
    final w = 300.0;
    final cs = Theme.of(context).colorScheme;
    final pXS = 8.0;
    final pS = 12.0;
    final pM = 15.0;
    final pL = 24.0;
    const url = '';

    // TODO url

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 18,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: pM, vertical: pXS),
                child: _header(context, h, url),
              ),
            ),
            SizedBox(height: pL),

            const Flexible(
              flex: 24,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Placeholder(),
              ),
            ),
            SizedBox(height: pL),

            Flexible(
              flex: 64,
              child: _bottomSheet(
                context: context,
                h: h,
                w: w,
                pS: pS,
                pM: pM,
                learningTap: () => _openLearningScreen(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, double h, String? url) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today’s\ndashboard'),
        CircleAvatar(
          radius: h * 0.028,
          backgroundImage: (url != null && url.isNotEmpty)
              ? NetworkImage(url)
              : null,
          child: (url == null || url.isEmpty) ? const Icon(Icons.person) : null,
        ),
      ],
    );
  }

  Widget _bottomSheet({
    required BuildContext context,
    required double h,
    required double w,
    required double pS,
    required double pM,
    required VoidCallback learningTap,
  }) {
    // final state = context.read<FlashcardCubit>().state;
    // final List<FlashcardEntity> cards = state is FlashcardsLoaded
    //     ? state.flashcards
    //     : const <FlashcardEntity>[];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha((0.2 * 255).round()),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: pS, vertical: pM),
          //   child: BlocListener<StatisticsCubit, StatisticsState>(
          //     listenWhen: (prev, curr) => prev != curr,
          //     listener: (context, state) {
          //       int val(CardCategory c) => state.currentCounts[c] ?? 0;

          //       context.read<StatusOverviewCubit>().update(
          //         newWords: val(CardCategory.newWords),
          //         learning: val(CardCategory.learning),
          //         reviewing: val(CardCategory.reviewing),
          //         mastered: val(CardCategory.mastered),
          //       );
          //     },
          //     child: const StatusOverviewWidget(),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(right: pM),
            child: SizedBox(
              height: h * 0.30,
              width: w * 0.90,
              // child: StartLearningCardSwiperWidget(
              //   w: w,
              //   onTap: learningTap,
              //   cards: cards,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLearningScreen(BuildContext context) async {
    // final statsCubit = context.read<StatisticsCubit>();

    // await Navigator.of(context).push(bottomUpRoute(const LearningView()));
    // statsCubit.refresh();
  }
}
