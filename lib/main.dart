import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards_v2/auth/presentation/views/auth_view.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just flashcards',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 35, 12, 138),
        ),
      ),
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
  }
}
