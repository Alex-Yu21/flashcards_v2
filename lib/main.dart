import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards_v2/core/theme/theme_controller.dart';
import 'package:flashcards_v2/features/auth/presentation/views/auth_view.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

final theme = ThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CustomTheme?>(
      valueListenable: theme,
      builder: (_, __, ___) {
        return MaterialApp(
          title: 'Just flashcards',
          theme: theme.theme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode,
          home:
              // StreamBuilder(
              //   stream: FirebaseAuth.instance.authStateChanges(),
              //   builder: (ctx, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const LoadView();
              //     }
              //     if (snapshot.hasData) {
              //       return const HomeView();
              //     } else {
              //       return
              const AuthView(),
          // ;
          //     }
          //   },
          // ),
        );
      },
    );
  }
}
