import 'package:flutter/material.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    const double k20 = 20;
    const kPad20 = EdgeInsets.symmetric(horizontal: k20);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: k20, vertical: 8),
        child: Column(children: [const Center(child: Text('CategoriesView'))]),
      ),
    );
  }
}
