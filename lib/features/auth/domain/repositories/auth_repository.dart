import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_v2/features/auth/domain/entities/auth_status.dart';

abstract class AuthRepository {
  Stream<Object?> get rawUserStream;

  Stream<AuthStatus> get status;

  Future<void> signUpWithEmail(String email, String password);

  Future<void> signInWithCredential(AuthCredential credential);

  Future<void> signInAnonymously();

  Future<void> linkWithCredential(AuthCredential credential);

  //TODO Выход ui(очистит гостя/обычного пользователя)
  Future<void> signOut();
}
