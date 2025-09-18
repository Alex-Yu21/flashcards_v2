import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_v2/app/navigation/destinations.dart';
import 'package:flashcards_v2/features/auth/presentation/views/auth_view.dart';
import 'package:flashcards_v2/features/auth/presentation/views/load_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadView();
        }
        if (!snapshot.hasData) {
          return const AuthView();
        }

        return Scaffold(
          body: navigationShell,

          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: cs.surface,
              indicatorColor: cs.primary,
              iconTheme: WidgetStateProperty.resolveWith((states) {
                return IconThemeData(
                  color: states.contains(WidgetState.selected)
                      ? cs.onPrimary
                      : cs.onSurfaceVariant,
                );
              }),
            ),
            child: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              indicatorColor: Theme.of(context).colorScheme.primary,
              destinations: destinations
                  .map(
                    (d) => NavigationDestination(icon: Icon(d.icon), label: ''),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

          // TODO repo+controller+redirect в router вместо StreamBuilder здесь