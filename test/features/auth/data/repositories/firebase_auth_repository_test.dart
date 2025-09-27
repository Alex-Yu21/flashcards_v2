import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flashcards_v2/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:flashcards_v2/features/auth/domain/entities/auth_status.dart';
import 'package:flashcards_v2/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthRepository repo;

  setUp(() {
    mockAuth = MockFirebaseAuth(signedIn: false);
    repo = FirebaseAuthRepository(mockAuth);
  });

  group('auth stream', () {
    test(
      'should go unknown -> unauthenticated -> authenticated after anonymous sign in',
      () async {
        final q = StreamQueue<AuthStatus>(repo.status);
        expect(await q.next, AuthStatus.unknown);
        expect(await q.next, AuthStatus.unauthenticated);
        await repo.signInAnonymously();
        expect(await q.next, AuthStatus.authenticated);
        await q.cancel();
      },
    );

    test(
      'should go unknown -> unauthenticated -> authenticated after email sign up',
      () async {
        final expectation = expectLater(
          repo.status,
          emitsInOrder([
            AuthStatus.unknown,
            AuthStatus.unauthenticated,
            AuthStatus.authenticated,
          ]),
        );
        await repo.signUpWithEmail('a@example.com', 'pw-123456');
        await expectation;
      },
    );

    test(
      'should go unknown -> unauthenticated -> authenticated after signInWithCredential',
      () async {
        final cred = EmailAuthProvider.credential(
          email: 'b@example.com',
          password: 'pw-123456',
        );
        final expectation = expectLater(
          repo.status,
          emitsInOrder([
            AuthStatus.unknown,
            AuthStatus.unauthenticated,
            AuthStatus.authenticated,
          ]),
        );
        await repo.signInWithCredential(cred);
        await expectation;
      },
    );

    test('should end up unauthenticated after signOut', () async {
      final q = StreamQueue<AuthStatus>(repo.status);
      expect(await q.next, AuthStatus.unknown);
      expect(await q.next, AuthStatus.unauthenticated);
      await repo.signInAnonymously();
      expect(await q.next, AuthStatus.authenticated);
      await repo.signOut();
      expect(await q.next, AuthStatus.unauthenticated);
      await q.cancel();
    });
  });

  group('rawUserStream', () {
    test('should proxy authStateChanges: null then User', () async {
      final expectation = expectLater(
        repo.rawUserStream,
        emitsInOrder([isNull, isA<User>()]),
      );
      await repo.signUpWithEmail('u@example.com', 'pw-123456');
      await expectation;
    });
  });

  group('signUpWithEmail', () {
    test('should delegate to FirebaseAuth and produce currentUser', () async {
      await repo.signUpWithEmail('c@example.com', 'pw-123456');
      final current = mockAuth.currentUser;
      expect(current, isNotNull);
      expect(current!.email, 'c@example.com');
    });
  });

  group('signInWithCredential', () {
    test(
      'should sign in with EmailAuthProvider.credential and not swallow errors',
      () async {
        await repo.signUpWithEmail('e@example.com', 'pw-123456');
        await repo.signOut();
        final cred = EmailAuthProvider.credential(
          email: 'e@example.com',
          password: 'pw-123456',
        );
        await repo.signInWithCredential(cred);
        expect(mockAuth.currentUser, isNotNull);
        expect(mockAuth.currentUser!.email, 'e@example.com');
      },
    );
  });

  group('signInAnonymously', () {
    test('should create an anonymous currentUser', () async {
      await repo.signInAnonymously();
      final user = mockAuth.currentUser;
      expect(user, isNotNull);
      expect(user!.isAnonymous, isTrue);
    });
  });

  group('linkWithCredential', () {
    test(
      'should throw FirebaseAuthException with code=no-current-user when no currentUser',
      () async {
        expect(
          () => repo.linkWithCredential(
            EmailAuthProvider.credential(
              email: 'f@example.com',
              password: 'pw-123456',
            ),
          ),
          throwsA(
            isA<FirebaseAuthException>()
                .having((e) => e.code, 'code', 'no-current-user')
                .having(
                  (e) => e.message,
                  'message',
                  contains('User is not sign in'),
                ),
          ),
        );
      },
    );
  });

  group('signOut', () {
    test(
      'should delegate to FirebaseAuth.signOut and clear currentUser',
      () async {
        await repo.signInAnonymously();
        expect(mockAuth.currentUser, isNotNull);
        await repo.signOut();
        expect(mockAuth.currentUser, isNull);
      },
    );
  });
}
