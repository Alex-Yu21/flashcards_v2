import 'dart:async';

import 'package:flashcards_v2/features/auth/domain/entities/auth_status.dart';
import 'package:flashcards_v2/features/auth/domain/entities/session.dart';
import 'package:flashcards_v2/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<Session> {
  final AuthRepository _repo;
  late final StreamSubscription _sub;

  AuthController(this._repo)
    : super(const Session(status: AuthStatus.unknown)) {
    _sub = _repo.rawUserStream.listen((obj) {
      final dynamic user = obj;
      if (user == null) {
        state = const Session(
          status: AuthStatus.unauthenticated,
          isAnonymous: false,
        );
        return;
      }

      final bool isAnon = (user.isAnonymous as bool?) ?? false;
      if (isAnon) {
        state = Session(
          status: AuthStatus.unauthenticated,
          uid: user.uid as String?,
          isAnonymous: true,
        );
      } else {
        state = Session(
          status: AuthStatus.authenticated,
          uid: user.uid as String?,
          isAnonymous: (user.isAnonymous as bool?) ?? false,
          displayName: user.displayName as String?,
          photoUrl: user.photoURL as String?,
          email: user.email as String?,
        );
      }
    });
  }

  Future<void> signInAnonymously() => _repo.signInAnonymously();
  Future<void> signOut() => _repo.signOut();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// TODO(next): verify mapping — anonymous → unauthenticated(isAnonymous:true), normal login → authenticated
// TODO(soon): add upgrade flow (linkWithCredential email/password, and linkWithProvider for Google)
