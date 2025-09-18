import 'package:flashcards_v2/features/auth/domain/entities/auth_status.dart';

abstract class AuthRepository {
  Stream<Object?> get rawUserStream;

  Stream<AuthStatus> get status;

  Future<void> signInAnonymously();

  //TODO Выход ui(очистит гостя/обычного пользователя)
  Future<void> signOut();

  // TODO anonUser.linkWithCredential(credential) - cсылка анонимного аккаунта на «нормальный» логин (чтобы сохранить uid)

  Future<void> linkWithCredential(Object credential);
}
