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
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            indicatorColor: Theme.of(context).colorScheme.primary,
            destinations: destinations
                .map(
                  (d) =>
                      NavigationDestination(icon: Icon(d.icon), label: d.label),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

          // TODO repo+controller+redirect в router вместо StreamBuilder здесь