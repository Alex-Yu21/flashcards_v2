import 'package:flutter/material.dart';

class LearningView extends StatefulWidget {
  const LearningView({super.key});

  @override
  State<LearningView> createState() => _LearningViewState();
}

class _LearningViewState extends State<LearningView> {
  void onKnow() {}
  void onDontKnow() {}
  void onReveal() {}

  @override
  Widget build(BuildContext context) {
    const iconSize = 50.00;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO прогресс бар
            Center(child: SizedBox(width: 350, height: 100, child: Card())),
            SizedBox(height: 100),
            // TODO заменить плейсхолдер на настоящие карточки
            Center(child: SizedBox(width: 350, height: 200, child: Card())),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: onKnow,
                  child: const Icon(Icons.done, size: iconSize),
                ),
                SizedBox(width: 100),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: onDontKnow,
                  child: const Icon(Icons.close, size: iconSize),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              onPressed: () {},
              child: const Icon(Icons.remove_red_eye, size: iconSize),
            ),

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
      ),
    );
  }
}
