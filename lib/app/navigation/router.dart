import 'package:flashcards_v2/app/navigation/destinations.dart';
import 'package:flashcards_v2/app/navigation/layout_scaffold.dart';
import 'package:flashcards_v2/features/auth/domain/entities/auth_status.dart';
import 'package:flashcards_v2/features/auth/domain/entities/session.dart';
import 'package:flashcards_v2/features/auth/presentation/views/auth_view.dart';
import 'package:flashcards_v2/features/auth/presentation/views/load_view.dart';
import 'package:flashcards_v2/features/learning/presentation/views/collections_view.dart';
import 'package:flashcards_v2/features/learning/presentation/views/home_view.dart';
import 'package:flashcards_v2/features/learning/presentation/views/learning_view.dart';
import 'package:flashcards_v2/features/learning/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter({
  required Session initial,
  required Session Function() currentSession,
}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final String initialLocation = switch (initial.status) {
    AuthStatus.authenticated => Routes.homeView,
    AuthStatus.unauthenticated => Routes.authView,
    AuthStatus.unknown => Routes.loadView,
  };

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,

    redirect: (context, state) {
      final s = currentSession();
      final loc = state.matchedLocation;

      if (s.status == AuthStatus.unknown) {
        if (loc != Routes.loadView) return Routes.loadView;
        return null;
      }

      if (s.status == AuthStatus.unauthenticated) {
        if (s.isAnonymous) {
          return null;
        } else {
          return (loc == Routes.authView) ? null : Routes.authView;
        }
      }

      if (s.status == AuthStatus.authenticated) {
        if (loc == Routes.authView || loc == Routes.loadView) {
          return Routes.homeView;
        }
        return null;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: Routes.loadView,
        builder: (context, state) => const LoadView(),
      ),
      GoRoute(
        path: Routes.authView,
        builder: (context, state) => const AuthView(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              //TODO add routes
              GoRoute(
                path: Routes.homeView,
                builder: (context, state) => const HomeView(),
                routes: [
                  GoRoute(
                    path: Routes.learningView,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const LearningView(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.categoriesView,
                builder: (context, state) => const CategoriesView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.collectionsView,
                builder: (context, state) => const CollectionsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profileView,
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
// TODO: real screens

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('CategoriesView'));
  }
}

// TODO(next): Add deep-link cases and ensure guest can open them directly
