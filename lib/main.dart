import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards_v2/app/navigation/router.dart';
import 'package:flashcards_v2/app/theme/theme_controller.dart';
import 'package:flashcards_v2/features/auth/domain/entities/session.dart';
import 'package:flashcards_v2/features/auth/presentation/providers/auth_providers.dart';
import 'package:flashcards_v2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: AppRoot()));
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);

    Session getCurrentSession() => ref.read(authControllerProvider);

    final router = createRouter(
      initial: session,
      currentSession: getCurrentSession,
    );

    return ValueListenableBuilder<CustomTheme?>(
      valueListenable: theme,
      builder: (_, __, ___) {
        return MaterialApp.router(
          title: 'Just flashcards',
          theme: theme.theme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
