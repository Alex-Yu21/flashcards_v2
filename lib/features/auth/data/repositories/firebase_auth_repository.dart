import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_v2/features/auth/domain/entities/auth_status.dart';
import 'package:flashcards_v2/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _fa;
  FirebaseAuthRepository(this._fa);

  @override
  Stream<Object?> get rawUserStream =>
      _fa.authStateChanges().map<Object?>((user) => user);

  @override
  Stream<AuthStatus> get status async* {
    yield AuthStatus.unknown;
    await for (final user in _fa.authStateChanges()) {
      yield (user == null)
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
    }
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await _fa.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signInWithCredential(AuthCredential credential) async {
    await _fa.signInWithCredential(credential);
  }

  @override
  Future<void> signInAnonymously() async {
    await _fa.signInAnonymously();
  }

  @override
  Future<void> linkWithCredential(AuthCredential credential) async {
    final user = _fa.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'User is not sign in',
      );
    }
    await user.linkWithCredential(credential);
  }

  @override
  Future<void> signOut() => _fa.signOut();
}
