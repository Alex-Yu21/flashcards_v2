import 'package:flashcards_v2/app/navigation/destinations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.createCardView);
        },
        backgroundColor: cs.primary,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 32, color: cs.onPrimary),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: cs.surface,
          indicatorColor: cs.primary,

          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? cs.onPrimary : cs.onSurfaceVariant,
            );
          }),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,

          destinations: [
            for (final d in destinations)
              NavigationDestination(icon: Icon(d.icon), label: d.label),
          ],
        ),
      ),
    );
  }
}
