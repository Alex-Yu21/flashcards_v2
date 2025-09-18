import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_v2/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flashcards_v2/features/auth/domain/entities/session.dart';
import 'package:flashcards_v2/features/auth/domain/repositories/auth_repository.dart';
import 'package:flashcards_v2/features/auth/presentation/providers/auth_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final fa = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(fa);
});

final authControllerProvider = StateNotifierProvider<AuthController, Session>((
  ref,
) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
