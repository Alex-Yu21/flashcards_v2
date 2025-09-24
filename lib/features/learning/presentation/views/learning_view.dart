import 'package:flutter/material.dart';

class LearningView extends StatefulWidget {
  const LearningView({super.key});

  @override
  State<LearningView> createState() => _LearningViewState();
}

class _LearningViewState extends State<LearningView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // CardSwiper(
          //   cardsCount: 10,
          //   cardBuilder:
          //       (
          //         context,
          //         index,
          //         horizontalOffsetPercentage,
          //         verticalOffsetPercentage,
          //       ) => Card(),
          // ),
        ],
      ),
    );
  }
}
 // TODO" спрятать навбар 