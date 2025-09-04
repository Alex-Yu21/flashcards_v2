import 'package:flutter/material.dart';

class LoadView extends StatelessWidget {
  const LoadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: CircularProgressIndicator(),
    );
  }
}
